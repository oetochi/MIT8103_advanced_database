USE topezfarms;
UPDATE products SET stock_qty = 10 WHERE sku = 'TXN-TEST-1';
SELECT stock_qty FROM products WHERE sku = 'TXN-TEST-1';
