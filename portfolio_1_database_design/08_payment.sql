USE topezfarms;

CREATE TABLE payments (
    payment_id      INT AUTO_INCREMENT PRIMARY KEY,
    order_id        INT NOT NULL,
    amount          DECIMAL(14,2) NOT NULL CHECK (amount > 0),
    method          ENUM('CARD', 'BANK_TRANSFER','USSD', 'WALLET', 'CRYPTO') NOT NULL,
    status          ENUM('PENDING', 'SUCCESS', 'FAILED') NOT NULL DEFAULT 'PENDING',
    reference       VARCHAR(60) UNIQUE,
    paid_at         TIMESTAMP NULL,
    FOREIGN KEY     (order_id) REFERENCES orders(order_id)
);