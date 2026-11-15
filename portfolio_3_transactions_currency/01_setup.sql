USE topezfarms;

INSERT INTO products (category_id, sku, name, unit_of_measure, price, stock_qty, min_order_qty, sales_mode)
VALUES (1, 'TXN-TEST-1', 'Transaction Test Product', 'bag', 5000.00, 10, 1, 'IN_STOCK');

SELECT product_id, stock_qty FROM products WHERE sku = 'TXN-TEST-1';
COMMIT;