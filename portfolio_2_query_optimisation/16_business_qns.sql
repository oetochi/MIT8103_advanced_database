explain analyze
# Q1: Find the top 10 products by total revenue (completed/valid orders)
SELECT p.product_id,
       p.sku,
       p.name AS product_name,
       p.sales_mode,
       SUM(oi.quantity) AS total_units_sold,
       SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status NOT IN ('CANCELLED', 'PENDING')
GROUP BY p.product_id, p.sku, p.name, p.sales_mode
ORDER BY total_revenue DESC
LIMIT 10;

# Q2: Total confirmed sales and other volume by states
SELECT a.state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(pay.amount) AS total_sales_amount,
    ROUND(AVG(pay.amount), 2) AS avg_order_value
FROM orders o
JOIN addresses a ON o.shipping_address_id = a.address_id
JOIN payments pay ON o.order_id = pay.order_id
WHERE pay.status = 'SUCCESS'
AND o.status IN ('CONFIRMED', 'PARTIALLY_DELIVERED', 'DELIVERED')
GROUP BY a.state
ORDER BY total_sales_amount DESC;


#Q3: Evaluate outstanding pre_order quantities for industry buyers.
SELECT
    o.order_id,
    c.company_name,
    o.order_date,
    o.expected_delivery_date,
    p.sku,
    p.name AS product_name,
    oi.quantity AS ordered_qty,
    COALESCE(SUM(di.quantity), 0) AS delivered_qty,
    (oi.quantity - COALESCE(sum(di.quantity), 0)) AS outstanding_qty
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_it = p.product_id
LEFT JOIN deliveries d ON o.order_id = d.order_id
LEFT join delivery_items di ON d.delivery_id = di.delivery_id AND di.product_id = oi.product_id
WHERE o.order_type = 'PRE_ORDER'
    AND c.customer_type = 'INDUSTRY'
    AND o.status IN ('CONFIRMED', 'PARTIALLY_DELIVERED')
GROUP BY 
    o.order_id, c.company_name, o.order_date, o.expected_delivery_date, p.sku, p.name, oi.quantity
HAVING outstanding_qty > 0
ORDER BY o.expected_delivery_date ASC;
