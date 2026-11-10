USE topezfarms;

ALTER TABLE customers
    ADD COLUMN customer_type    ENUM('HOME', 'INDUSTRY') NOT NULL DEFAULT 'HOME' AFTER full_name,
    ADD COLUMN company_name VARCHAR(120) NULL AFTER customer_type;