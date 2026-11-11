USE topezfarms;

CREATE TABLE deliveries (
    delivery_id         INT AUTO_INCREMENT PRIMARY KEY,
    order_id            INT NOT NULL,
    courier             VARCHAR(60),
    tracking_no         VARCHAR(40) UNIQUE,
    status              ENUM('PROCESSING', 'IN_TRANSIT', 'DELIVERED', 'RETURNED') NOT NULL DEFAULT 'PROCESSING',
    shipped_at          TIMESTAMP NULL,
    delivered_at        TIMESTAMP NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE delivery_items(
    delivery_id     INT NOT NULL,
    product_id      INT NOT NULL,
    quantity        DECIMAL(12,3) NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (delivery_id, product_id),
    FOREIGN KEY (delivery_id) REFERENCES deliveries(delivery_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);