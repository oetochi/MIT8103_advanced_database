USE topezfarms;
SET SESSION cte_max_recursion_depth = 1000000;

# create 100,000 orders spread across 680 days; industrial customers do PRE_ORDERs only
INSERT INTO orders (customer_id, shipping_address_id, order_type, order_date, expected_delivery_date, status)
WITH RECURSIVE seq AS (
    SELECT 1 AS n UNION ALL SELECT n + 1
    FROM seq WHERE n <100000
),
cust AS (
    SELECT a.customer_id, a.address_id,
            ROW_NUMBER() OVER (ORDER BY a.customer_id) AS rn
    FROM addresses a
    JOIN customers c ON c.customer_id = a.customer_id
    WHERE c.email LIKE 'bulk%@topez.sample'
),
src AS (
    SELECT seq.n, cust.rn, cust.customer_id, cust.address_id,
        TIMESTAMP('2025-01-01 06:00:00') + INTERVAL (seq.n * 37 % 680) DAY AS od
    FROM seq
    JOIN cust ON cust.rn = 1 + (seq.n % 20000)
)
SELECT customer_id, address_id,
        IF(rn % 20 = 0, 'PRE_ORDER', 'STANDARD'),
        od,
        IF(rn % 20 = 0, DATE(od + INTERVAL 60 DAY), NULL),
        ELT(1 + N % 5, 'PENDING', 'CONFIRMED', 'PARTIALLY_DELIVERED', 'DELIVERED', 'CANCELLED')
FROM src;

# Add 1-3 items/order, picking different products
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
WITH RECURSIVE k AS (
    SELECT 0 AS j UNION ALL SELECT j + 1
    FROM k WHERE j < 2
),
plist AS (
    SELECT product_id, price,
            ROW_NUMBER() OVER (ORDER BY product_id) - 1 AS idx,
            COUNT(*) OVER () AS total
    FROM products
)
SELECT o.order_id, p.product_id, 1 + (o.order_id % 5), p.price
FROM orders o
JOIN k  ON k.j < 1 + (o.order_id % 3)
JOIN plist p ON p.idx = (o.order_id * 7 + k.j * 11) % p.total
WHERE NOT EXISTS (SELECT 1 FROM order_items x WHERE x.order_id = o.order_id);




