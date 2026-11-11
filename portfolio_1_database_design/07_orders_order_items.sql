USE topezfarms;

CREATE TABLE orders (
    order_id                INT AUTO_INCREMENT PRIMARY KEY,
    customer_id             INT NOT NULL,
    shipping_address_id     INT NOT NULL,
    order_type              ENUM('PRE_ORDER', 'STANDARD') NOT NULL DEFAULT 'STANDARD',
    order_date              TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expected_delivery_date  DATE NULL,
    status ENUM('PENDING', 'CONFIRMED', 'PARTIALLY_DELIVERED', 'DELIVERED', 'CANCELLED') NOT NULL DEFAULT 'PENDING',
    FOREIGN KEY (customer_id)       REFERENCES customers(customer_id),
    FOREIGN KEY (shipping_address_id) REFERENCES addresses(address_id),
    #chk_preorder_date compares two columns, hence it's written as a separate table-level constraint after the column list
    CONSTRAINT chk_preorder_date
        CHECK (order_type = 'PRE_ORDER' OR expected_delivery_date IS NULL)
);

CREATE TABLE order_items (
    order_id        INT NOT NULL,
    product_id      INT NOT NULL,
    quantity        DECIMAL(12,3) NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(12,3) NOT NULL CHECK (unit_price >=0),
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id)  REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
