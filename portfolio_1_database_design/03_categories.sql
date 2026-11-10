USE topezfarms;
CREATE TABLE categories (
    category_id         INT AUTO_INCREMENT PRIMARY KEY,
    name                VARCHAR(60) NOT NULL UNIQUE,
    description         VARCHAR(255),
    parent_category_id  INT NULL,
    FOREIGN KEY (parent_category_id) REFERENCES categories(category_id)
);

INSERT INTO categories (name, description) VALUES
('Home', 'Household food products sold in retail quantities'),
('Industry', 'Bulk agro inputs for industrial buyers, sold by pre-order');
