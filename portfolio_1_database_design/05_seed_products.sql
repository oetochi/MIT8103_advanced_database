USE topezfarms;
INSERT INTO products (category_id, sku, name, unit_of_measure, price, stock_qty, min_order_qty, sales_mode) VALUES
(1, 'HOME-GARRI-5KG',       'Garri (5kg bag)',     'bag',     8000.00, 300, 1, 'IN_STOCK'),
(1, 'HOME-GARRI-10KG',      'Garri (10kg bag)',    'bag',     15000.00, 250, 1, 'IN_STOCK'),
(1, 'HOME-PALMOIL-5L',      'Palm Oil (5L)',    'container',    8000.00, 150, 1, 'IN_STOCK'),
(1, 'HOME-PALMOIL-10L',     'Palm Oil (10L)',    'container',    16000.00, 200, 1, 'IN_STOCK'),
(1, 'HOME-PALMOIL-25L',     'Palm Oil (25L)',    'container',    38000.00, 100, 1, 'IN_STOCK'),
(1, 'HOME-PLANTAIN-5KG',    'PLANTAIN (5kg CTN)',     'bag',     8000.00, 300, 1, 'IN_STOCK'),
(2, 'IND-CASSAVA-TON',  'Cassava (ton)',    'ton',  150000.00,  1000,   10, 'PRE_ORDER'),
(2, 'IND-FFB-TON',  'Palm Bunches (ton)',    'ton',  180000.00,  1500,   10, 'PRE_ORDER');