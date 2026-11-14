USE topezfarms;
# SET SESSION recursion_depth_cte = 1000000;
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