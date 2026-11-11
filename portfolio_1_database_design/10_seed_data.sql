USE topezfarms;
INSERT INTO customers (full_name, customer_type, company_name, email, phone) VALUES 
('Miebi Wonders', 'HOME', NULL, 'm.wonders@xyz.com', '09100000001'),
('Vee Grace', 'HOME', NULL, 'vee.grace@yxz.com', '09100000002'),
('Abdul Shuabu', 'INDUSTRY', 'Subadu Industry', 'abdul_s@zyx.com', '09100000003'),
('Austin Belema', 'INDUSTRY', 'Bels Inc', 'belema.austin@belsinc.com', '09100000004');

INSERT INTO addresses (customer_id, street, landmark, city, state, is_default) VALUES
(1, '4 Grace Avenue', 'Opposite St Peter Cathedral', 'Port Harcourt', 'Rivers', TRUE),
(2, '15 Uniport Street', 'Beside Deeper Life Church', 'Port Harcourt', 'Rivers', TRUE),
(3, '7 Industrial Estate', 'Oregun Way', 'Ota', 'Ogun', TRUE),
(4, '1 Bels Factory Road', 'NEPA', 'Owerri', 'Imo', TRUE);