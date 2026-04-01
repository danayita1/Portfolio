-- Insert Customers
INSERT INTO customers (first_name, last_name, email, signup_date, location) VALUES
('John', 'Smith', 'john@example.com', '2023-01-10', 'California'),
('Sarah', 'Lee', 'sarah@example.com', '2023-03-15', 'Texas'),
('David', 'Brown', 'david@example.com', '2023-06-20', 'New York'),
('Emma', 'Wilson', 'emma@example.com', '2023-08-01', 'Florida');

-- Insert Products
INSERT INTO products (product_name, category, price, stock_quantity) VALUES
('Laptop', 'Electronics', 1200.00, 50),
('Headphones', 'Electronics', 150.00, 200),
('Office Chair', 'Furniture', 300.00, 80),
('Water Bottle', 'Accessories', 25.00, 500),
('Monitor', 'Electronics', 400.00, 100);

-- Insert Orders
INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2024-01-05', 'Completed'),
(2, '2024-01-10', 'Completed'),
(3, '2024-02-01', 'Completed'),
(1, '2024-02-15', 'Completed');

-- Insert Order Items
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 1200.00),
(1, 2, 1, 150.00),
(2, 3, 1, 300.00),
(3, 2, 2, 150.00),
(4, 5, 1, 400.00);