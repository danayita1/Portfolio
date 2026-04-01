SELECT 
    SUM(oi.quantity * oi.price) AS total_revenue
FROM order_items oi;
SELECT 
    AVG(order_total) AS avg_order_value
FROM (
    SELECT 
        o.order_id,
        SUM(oi.quantity * oi.price) AS order_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.order_id
) AS order_totals;
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(oi.quantity * oi.price) AS lifetime_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id
ORDER BY lifetime_value DESC;
SELECT 
    p.product_name,
    SUM(oi.quantity) AS total_units_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_units_sold DESC;
SELECT 
    p.category,
    SUM(oi.quantity * oi.price) AS category_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY category_revenue DESC;
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    SUM(oi.quantity * oi.price) AS monthly_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;
