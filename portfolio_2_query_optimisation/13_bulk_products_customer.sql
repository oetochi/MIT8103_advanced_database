USE topezfarms;
# recursion_depth_cte 
SET SESSION cte_max_recursion_depth= 1000000;
#200 extra products (industry pre-order items about 10%)
INSERT INTO products (category_id, sku, name, unit_of_measure, price, stock_qty, min_order_qty, sales_mode)
WITH RECURSIVE seq AS (
    SELECT 1 AS n UNION ALL SELECT n +1
    FROM seq
    WHERE n < 200
)
SELECT IF(n % 10 = 0,2,1),
        CONCAT('BULK-', LPAD(n, 4, '0')),
        CONCAT('Bulk Product', n), 'unit ',
        500 + (n * 137 % 5000),
        100 + (n % 400),
        IF(n % 10 = 0, 5, 1),
        IF(n % 10 = 0, 'PRE_ORDER', 'IN_STOCK')
FROM seq;

# Adds 20,000 customers where each 20th is an industry buyer
INSERT INTO customers (full_name, customer_type, company_name, email, phone)
WITH RECURSIVE seq AS (
    SELECT 1 AS n UNION ALL SELECT n + 1
    FROM seq WHERE n <20000
)
SELECT CONCAT('Bulk Customer', n),
        IF(n % 20 = 0, 'INDUSTRY', 'HOME'),
        IF(n % 20 = 0, CONCAT('Bulk Company', n), NULL),
        CONCAT('bulk', n, '@topez.sample'),
        CONCAT('080', LPAD(n, 8, '0'))
FROM seq;

# Used a default address for bulk customers
INSERT INTO addresses (customer_id, street, landmark, city, state, is_default)
SELECT customer_id,
        CONCAT(customer_id, ' Factory Road'),
        'By IBM juction',
        ELT(1 + customer_id % 4, 'Port Harcourt', 'Yenegoa', 'Asaba', 'Benin'),
        ELT(1 + customer_id % 4, 'Rivers', 'Bayelsa', 'Delta', 'Edo'),
        TRUE
FROM customers
WHERE email LIKE 'bulk%@topez.sample';

