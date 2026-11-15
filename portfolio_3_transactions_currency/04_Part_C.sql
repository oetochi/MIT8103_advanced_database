USE topezfarms;
UPDATE products SET stock_qty = 10 WHERE sku = 'TXN-TEST-1';
SET @prod = (SELECT product_id FROM products WHERE sku='TXN-TEST-1');
INSERT INTO orders (customer_id, shipping_address_id)
VALUES ((SELECT MIN(customer_id) FROM customers), (SELECT MIN(address_id) FROM addresses));
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES (LAST_INSERT_ID(), @prod, 6, 5000.00);
SELECT stock_qty FROM products WHERE sku = 'TXN-TEST-1';

