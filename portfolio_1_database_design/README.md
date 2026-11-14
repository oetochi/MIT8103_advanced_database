# MIT8103 - Advanced Database Coursework

## Name: TOCHI OPARA-EZE
## Student ID: 301923057

## Portfolio 1 DB Design README
Company Name: Topez Farms Ltd
Topez Farms (TF) is an agritech company connecting rural smallholder farmers directly to urban customers and industrial markets (addressing produce wastage and middleman markups). It uses e-commerce technology to set up a digital storefront to take in orders from its customers, which include both individual and industrial buyers.
Users: customers, farmhub admins, finance, staff, operations team
Major Data: customers, addresses, products, categories, orders, order items, payments, deliveries
Key Operations: Place orders, process payments, track delivery, add products, update stock

### MySQL Version Used: 9.7.4
<img width="379" height="139" alt="image" src="https://github.com/user-attachments/assets/aaebcbef-b094-4679-8b9b-6ce98945767e" />


### AI USE
Claude AI was useful in suggesting the structure of the database. It also played a role in debugging some of my SQL code, especially when I struggled to identify flagged errors. I ran every script, fixed typos and errors, deliberately tested constraints and adjusted it to suit the business case being presented here.
It was also useful in generating the script behind the large sample datasets used in building portfolio 2.


### Database Normalisation
 
1. All attributes have atomic data. Address information is stored in a separate table rather than address1 and address2. Products ordered are stored in order_items.

2. The primary key for the order_items table is order_id and product_id. There is no product_name or category as this can be identified purely from product_id. Quantity and unit_price are dependent on the full primary key.

3. The category details are stored only once in the categories table. Customer details are stored only once in the customers table. There are no transitive dependencies.

4. Trade-offs: `Unit_price` has been included in `order_items` even though `unit_price` also appears in `products.price`. This was done deliberately so that the price at the time of ordering is recorded. This will prevent any changes to history if the price changes.

5. Orders can be delivered in parts, so outstanding pre-order quantity is calculated from Order_items - delivery_items


### DB Design Decisions
|Business Fact| Design Response|
|-------------|----------------|
|Two categories (at the moment)|A category table created instead of hardcoding ENUM, giving room for additions as the business grows|
|Differing Units (l, kg, tons, bunches)| unit_of_measure column on each product|
|Industry goods are sold in tons|Quantities are in decimal |
|Industry products are pre-ordered before harvest|PRE_ORDER in sales_mode column|
|Industry are bulk buyers | min_order_qty|


### Constraint Tests & Error Returned
|S/N  |Constraint Test     | Error Returned       | Error Expected?|
|-----|--------------------|----------------------|-------------------|
|T1|UNIQUE value violation test - email duplicate| MySQL Error (1062): Duplicate entry 'abdul_s@zyx.com' for key 'customers.email'|Yes|
|T2|CHECK violation test - negative price| MySQL Error (3819): Check constraint 'products_chk_1' is violated|Yes|
|T3|UNIQUE value violation test - SKU duplicate| MySQL Error (1062): Duplicate entry 'IND-CASSAVA-TON' for key 'products.sku'|Yes|
|T4|FOREIGN KEY violation: category_id 89 doesn't exist|MySQL Error (1452): Cannot add or update a child row: a foreign key constraint fails (`topezfarms`.`products`, CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`))|Yes|
|T5|STANDARD order cannot have an expected_delivery_date like INDUSTRIAL|MySQL Error (3819): Check constraint 'chk_preorder_date' is violated.|Yes|
|T6|zero quantity violates CHECK|MySQL Error (3819): Check constraint 'order_items_chk_1' is violated.|Yes|

* Delivery.order_id is not unique because delivery of orders can be staggered based on the volume.

### Positive tests entries
<img width="960" height="440" alt="postive test" src="https://github.com/user-attachments/assets/baeff6f6-0628-426d-ba50-94b42c0f13f7" />

### Project Scope Limit/Known Limitation
Although Topez Farms connects smallholder farmers to indivisual/industrial buyers, this database design is limited to the sales side only. At the moment, nothing stops over-delivery of orders, but this will be addressed in portfolio 3 (check it out [here](url)).

### Challenges
In the process of building this portfolio, I hit brick walls with typos in CHECK, ENUM mismatches, hardcoded IDs vs AUTO-INCREMENT). These were subsequently resolved after painstaking review of the scripts.