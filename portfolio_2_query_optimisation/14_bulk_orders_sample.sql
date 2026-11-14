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

