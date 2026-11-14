USE topezfarms;

#T1: UNIQUE value violation test - email duplicate
INSERT INTO customers (full_name, email) VALUES ('Agent 1', 'abdul_s@zyx.com');

#T2: CHECK violation test - negative price
INSERT INTO products (category_id, sku, name, unit_of_measure, price) 
VALUES (1, 'TEST_1', 'Test Product', 'bag', -5);

#T3: duplicate SKU violates UNIQUE
INSERT INTO products (category_id, sku, name, unit_of_measure, price) 
VALUES (1, 'IND-CASSAVA-TON', 'Duplicate Test', 'bag', 150000);

#T4: FOREIGN KEY violation’s category_id 89 doesn't exist
INSERT INTO products (category_id, sku, name, unit_of_measure, price) 
VALUES (89, 'TEST_2', 'DT', 'bag', 50);

# T4 Error Output -> MySQL Error (1452): Cannot add or update a child row: a foreign key constraint fails (`topezfarms`.`products`, CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`))

#T5: STANDARD order cannot have an expected_delivery_date like INDUSTRIAL
INSERT INTO orders (customer_id, shipping_address_id, order_type, expected_delivery_date) 
VALUES (1, 1, 'STANDARD', '2027-05-04');
# T5 Error Output -> MySQL Error (3819): Check constraint 'chk_preorder_date' is violated.

#T6: zero quantity violates CHECK
INSERT INTO order_items (order_id, product_id, quantity, unit_price) 
VALUES (1, 1, 0, 8000);
#T6 Error Output -> MySQL Error (3819): Check constraint 'order_items_chk_1' is violated.

