USE topezfarms;

#T1: UNIQUE value violation test - email duplicate
INSERT INTO customers (full_name, email) VALUES ('Agent 1', 'abdul_s@zyx.com');

#T2: CHECK violation test - negative price
INSERT INTO products (category_id, sku, name, unit_of_measure, price) 
VALUES (1, 'TEST_1', 'Test Product', 'bag', -5);

#T3: duplicate SKU violates UNIQUE
INSERT INTO products (category_id, sku, name, unit_of_measure, price) 
VALUES (1, 'IND-CASSAVA-TON', 'Duplicate Test', 'bag', 150000);

#T4: FOREIGN KEY violation’s has 
INSERT INTO products (category_id, sku, name, unit_of_measure, price) 
VALUES (89, 'TEST_2', 'DT', 'bag', 50);

#T5: FOREIGN KEY violation’s has 
INSERT INTO orders (customer_id, shipping_address_id, order_type, expected_delivery_date) 
VALUES (1, 1, 'STANDARD', '2027-05-04');

#T6: zero quantity violates CHECK
INSERT INTO order_items (order_id, product_id, quantity, unit_price) 
VALUES (1, 1, 0, 8000);

#T6.1: Correct CHECK
INSERT INTO order_items (order_id, product_id, quantity, unit_price) 
VALUES (1, 1, 3, 8000.00);
