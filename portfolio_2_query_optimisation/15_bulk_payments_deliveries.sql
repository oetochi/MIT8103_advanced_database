USE topezfarms;
# payments for confirmed, delivered and partially delivered orders
INSERT INTO payments (order_id, amount, method, status, reference, paid_at)
SELECT o.order_id,
        SUM(oi.quantity * oi.unit_price),
        ELT(1 + o.order_id % 4, 'CARD', 'BANK_TRANSFER', 'USSD', 'WALLET', 'CRYPTO'),
        'SUCCESS',
        CONCAT('PAY-', LPAD(o.order_id, 8, '0')),
        o.order_date
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status NOT IN ('CANCELLED', 'PENDING')
GROUP BY o.order_id, o.order_date;

# one full delivery/ DELIVERED order
INSERT INTO deliveries (order_id, courier, tracking_no, status, shipped_at, delivered_at)
SELECT order_id, 'TF Logistics', CONCAT('TRK-', LPAD(order_id, 8, '0')),
        'DELIVERED', order_date + INTERVAL 1 DAY, order_date + INTERVAL 3 DAY
FROM orders
WHERE status = 'DELIVERED';

INSERT INTO delivery_items (delivery_id, product_id, quantity)
SELECT d.delivery_id, oi.product_id, oi.quantity
FROM deliveries d
JOIN order_items oi ON oi.order_id = d.order_id;





