USE topezfarms;
CREATE TABLE addresses (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id     INT NOT NULL,
    street          VARCHAR(150) NOT NULL,
    landmark        VARCHAR(60),
    city            VARCHAR(60) NOT NULL,
    state           VARCHAR(60) NOT NULL,
    is_default      BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);