USE topezfarms;
#Positive tests
INSERT INTO orders (customer_id, shipping_address_id) VALUES (1,1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES (LAST_INSERT_ID(),33, 2, 8000.00);
SELECT * FROM orders;
SELECT * FROM order_items;
