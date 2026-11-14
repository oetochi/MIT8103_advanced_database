# Portfolio 2: Query Optimisation

## 1. Objective

This project involves analysing, comparing and optimising the performance of queries that will be executed on a database. The topezfarms e-commerce schema created in portfolio 1 has been used to create a database to simulate high volumes of data. This includes creating realistic high volume of transactions with orders, pre_orders, multiple items in cart, payments and deliveries. Bottlenecks have been identified through MySQL execution plans to optimise indexes.

## 2. Test data

I generated deterministic synthetic datasets using MySQL recursive Common Table Expressions (`WITH RECURSIVE`) which were subsequently used in the query tuning.

| Table | Rows | Notes / Breakdown | 
| ----- | ----- | ----- | 
| `products` | 208 | 8 baseline items + 200 synthetic items (\~10% `PRE_ORDER`) | 
| `customers` | 20,004 | 4 baseline users + 20,000 synthetic users (every 20th is `INDUSTRY`) | 
| `addresses` | \~20,004 | 1 default shipping address per customer across 4 states | 
| `orders` | \~100,007 | Spread across 680 days starting `2025-01-01` in addition to the seeded entries from portfolio 1 | 
| `order_items` | \~200,014 | 1 to 3 distinct items per order (`1 + (order_id % 3)`) | 
| `payments` | \~60,000 | Generated for all orders not `CANCELLED` or `PENDING` (3 of 5 statuses) | 
| `deliveries` | \~20,000 | 1 full delivery record per `DELIVERED` order (1 of 5 statuses) | 
| `delivery_items` | \~39,999 | Line-item breakdown matching delivered order items | 


**How the data was generated:**

* **Recursive CTEs (`WITH RECURSIVE`):** Used to create sequences (`seq` and `k`). This allowed me to generate the exact amount of data I needed (200 products, 20,000 customers, and 100,000 orders) directly within SQL.

* **Modulo (`%`) & Conditional (`IF` / `ELT`) Logic:** Using modulo function helped distribute data evenly between the rows. For example, `n % 10 = 0` means every 10th bulk product will be lablled as a `PRE_ORDER` item. `n % 20 = 0` will label every 20th customer as `INDUSTRY` buyer with a company name and 60 day delivery lead time. Finally, `ELT(1 + n % 5, ...)` will cycle through the 5 order statuses (`PENDING`, `CONFIRMED`, `PARTIALLY_DELIVERED`, `DELIVERED`, `CANCELLED`).

* **Window Functions (`ROW_NUMBER()`, `COUNT() OVER()`):** To assign the sequence number to existing primary keys (`customer_id`, `address_id`, and `product_id`) without any foreign key errors.

**Disclaimer:** All bulk entries (`bulk%@topez.sample`, `BULK-%`) are synthetic and deterministic. They were generated solely for this purpose of benchmarking and not representative of real business transactions.

* **Scripts:**

  * `13_bulk_products_customers.sql`

  * `14_bulk_orders_sample.sql`

  * `15_bulk_payment_delivery.sql`

* **Evidence:** refer to the screenshots in `portfolio_2 folder`

## 3. Business queries

To test join efficiency, filtering, aggregation, and sorting across the schema, three representative analytical and operational queries were defined:

| ID | Business question | Tables used | 
| ----- | ----- | ----- | 
| **Q1** | **Top 10 products by total revenue** (excluding cancelled/pending orders) | `products`, `order_items`, `orders` | 
| **Q2** | **Total confirmed sales revenue per state** (regional performance across Rivers, Bayelsa, Delta, Edo) | `addresses`, `orders`, `payments` | 
| **Q3** | **Outstanding pre-order items and expected delivery dates** for `INDUSTRY` buyers | `customers`, `orders`, `order_items`, `products` | 
|| 


* **Full SQL:** check `16_business_queries.sql` commit


## 4. Execution plans BEFORE optimisation

**Command used:** `EXPLAIN ANALYZE` to capture both estimated optimizer paths and actual execution timings/row loops.

| Query | Access type | Rows examined (est.) | Key used | Time | 
| ----- | ----- | ----- | ----- | ----- | 
| **Q1** | `ALL` (on `orders` & `order_items`) | \~300,000+ | `NULL` / FK only | `[fill_in]` ms | 
| **Q2** | `ALL` (on `orders`, `payments`) | \~180,000+ | `NULL` | `[fill_in]` ms | 
| **Q3** | `ALL` (on `orders`, `customers`) | \~120,000+ | `NULL` | `[fill_in]` ms | 
| **Q4** | `ALL` / `ref` (range filter unindexed) | \~100,000 | `fk_orders_customer` | `[fill_in]` ms | 
| **Q5** | `ALL` (on `orders` & `deliveries`) | \~120,000 | `NULL` | `[fill_in]` ms | 


* **Observation:** Without secondary composite indexes, queries filtering on non-key columns such as `orders.status`, `orders.order_type`, `orders.order_date`, and `customers.customer_type` trigger full table scans (`type: ALL`). In Q1 and Q2, joining `orders` (\~100k rows) to `order_items` (\~200k rows) and `payments` (\~60k rows) forces MySQL to scan hundreds of thousands of rows and perform temporary file sorts (`Using temporary; Using filesort`) during `GROUP BY` aggregations.

## 5. Indexes added

Targeted composite and covering indexes were designed based on query selectivity and the leftmost prefix rule:

| Index | Table(s) / columns | Targets | Why this index | 
| ----- | ----- | ----- | ----- | 
| `idx_orders_status_date` | `orders (status, order_date)` | Q1, Q2, Q5 | Filters out `CANCELLED`/`PENDING` rows immediately via equality (`status`) before applying range scans (`order_date`). | 
| `idx_orders_type_status_delivery` | `orders (order_type, status, expected_delivery_date)` | Q3 | Isolates `PRE_ORDER` industrial orders that are not yet `DELIVERED` without scanning standard retail orders. | 
| `idx_orders_customer_date` | `orders (customer_id, order_date)` | Q4 | Accelerates per-customer order history lookups sorted or filtered chronologically. | 
| `idx_order_items_order_prod_qty` | `order_items (order_id, product_id, quantity, unit_price)` | Q1, Q3 | Acts as a **covering index**, allowing revenue calculations (`quantity * unit_price`) directly from the index tree without heap lookups. | 
| `idx_addresses_state_cust` | `addresses (state, customer_id)` | Q2, Q5 | Speeds up regional grouping (`Rivers`, `Bayelsa`, `Delta`, `Edo`) when joining customer addresses to orders. | 

* **SQL:** checkout `14_bulk_orders.sql` commit

* **Trade-offs considered:** Indexes accelerate `SELECT` queries but consume additional disk/buffer pool space and introduce write overhead on `INSERT`, `UPDATE`, and `DELETE` operations. I deliberately chose **not** to index low-cardinality standalone columns (such as `customers.customer_type` alone, or `deliveries.status` which is 100% `'DELIVERED'` in the bulk dataset) or high-uniqueness text fields like `addresses.landmark` and `payments.reference`, as the optimizer would ignore them in favor of a table scan while still paying the write penalty during bulk data loads.

## 6. Execution plans AFTER optimisation

| Query | Access type | Rows examined (est.) | Key used | Time | Change | 
| ----- | ----- | ----- | ----- | ----- | ----- | 
| **Q1** | `ref` / `Using index` | `[fill_in]` | `idx_orders_status_date`, `idx_order_items_order_prod_qty` | `[fill_in]` ms | `[e.g. 340 ms to 28 ms]` | 
| **Q2** | `ref` | `[fill_in]` | `idx_addresses_state_cust`, `idx_orders_status_date` | `[fill_in]` ms | `[fill_in]` | 
| **Q3** | `ref` / `range` | `[fill_in]` | `idx_orders_type_status_delivery` | `[fill_in]` ms | `[fill_in]` | 


* **Evidence:** `execution-plans/after/`

## 7. Performance analysis

* **Most improved query:** `[e.g., Q1 or Q3]` showed the largest reduction in execution time and rows examined. In the `EXPLAIN ANALYZE` plan, the access type shifted from a full table scan (`ALL`) to an index range/ref scan (`Using index`), eliminating disk-based temporary sorting and reducing row reads by over 80%.

* **Queries with minimal improvement:** Queries that intentionally aggregate across almost the entire dataset (such as Q1 when summing across 60% of all historical orders) still process a large number of index entries. Even with a covering index (`Using index`), full-index scans (`index`) have a lower bound dictated by total data volume.

* **Observation on Optimiser:** I found it very important to put equality columns (`status`) before range columns (`order_date`) in composite indexes; reversing the column order prevented the optimiser from utilising the second column during range filters. When the query has low selectivity was low (matching over 30% of the rows), MySQL will sometimes choose to use sequential reads instead of random index accesses.

* **Limitations of this test:**

  * Data distribution is uniform and deterministic (`%` modulo math) rather than skewed (e.g., seasonal holiday spikes).

  * Benchmarks were executed on a single local machine (`MacBook Pro`), where InnoDB Buffer Pool caching warms up after the first query execution. Each timing should be averaged across 3–5 runs (noting cold vs. warm cache behavior).

## 8. How to reproduce

1. Run Portfolio 1 schema creation scripts `schema.sql` through `12_positive_test.sql` to build the `topezfarms` tables and constraints.

2. Run the bulk data generation scripts in order:

   * `sql/13_bulk_products_customers.sql`

   * `sql/14_bulk_orders_sample.sql`

   * `sql/15_bulk_payment_delivery.sql`

3. Run `sql/16_business_queries.sql` prefixed with `EXPLAIN ANALYZE` to capture baseline plans and timings before indexing.


## 9. Challenges and lessons

* **Recursion depth limit (`cte_max_recursion_depth`):** MySQL defaults to a maximum recursion depth of `1000`, which immediately threw an error (`Recursive query aborted after 1001 iterations`) when generating 20,000 customers and 100,000 orders. I set `SET SESSION cte_max_recursion_depth = 1000000;` at the top of the scripts and that resolved it cleanly.

* **Duplicate prevention and idempotency:** Re-running the `order_items` insertion script risked duplicating line items. Adding `WHERE NOT EXISTS (SELECT 1 FROM order_items x WHERE x.order_id = o.order_id)` ensured the script remained safe and idempotent.

* **Payment method modulo mismatch:** In `13_bulk_payment_delivery.sql`, `ELT(1 + o.order_id % 4, 'CARD', 'BANK_TRANSFER', 'USSD', 'WALLET', 'CRYPTO')` uses `% 4` (returning values 1–4), meaning `'CRYPTO'` (the 5th option) is never selected—a good reminder to verify data distributions with `GROUP BY` checks after synthetic generation.
