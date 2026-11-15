USE topezfarms;

SET @cust = (SELECT customer_id FROM customers WHERE email = 'bulk1@topez.sample');
SET @addr = (SELECT address_id FROM addresses WHERE customer_id = @cust LIMIT 1);
SET @prod = (SELECT product_id FROM products WHERE sku = 'TXN-TEST-1');

START TRANSACTION;
INSERT INTO orders (customer_id, shipping_address_id) VALUES (@cust, @addr);
SET @oid = LAST_INSERT_ID();

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES (@oid, @prod, 50, 5000.00);

UPDATE products SET stock_qty = stock_qty - 50 WHERE product_id = @prod; #expect this line to fail

#check that the order and order_item rows are still pending
SELECT COUNT(*) FROM orders WHERE order_id = @oid;

ROLLBACK;

SELECT COUNT(*) FROM orders WHERE order_id = @oid;
SELECT stock_qty FROM products WHERE product_id = @prod;