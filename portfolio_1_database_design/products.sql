USE topezfarms;

CREATE TABLE products (
    product_id      INT AUTO_INCREMENT PRIMARY KEY,
    category_id     INT NOT NULL,
    sku             VARCHAR(30) NOT NULL UNIQUE,
    name            VARCHAR(120) NOT NULL,
    unit_of_measure VARCHAR(20) NOT NULL,
    price           DECIMAL(12,2) NOT NULL CHECK (price >= 0),
    stock_qty       DECIMAL(12,3) NOT NULL DEFAULT 0 CHECK (stock_qty >= 0),
    min_order_qty   DECIMAL(12,3) NOT NULL DEFAULT 1 CHECK (min_order_qty >0),
    sales_mode      ENUM('PRE_ORDER', 'IN_STOCK') NOT NULL DEFAULT 'IN_STOCK',
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);