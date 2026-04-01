-- Create Database
CREATE DATABASE ecommerce_analytics;
USE ecommerce_analytics;

-- Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    signup_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    location VARCHAR(100),
    CHECK (email LIKE '%@%')
);

-- Products Table
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0)
);

-- Orders Table
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    status VARCHAR(50) DEFAULT 'Completed',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE CASCADE
);

-- Order Items Table
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
        ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Indexes for performance optimization
CREATE INDEX idx_customer_id ON orders(customer_id);
CREATE INDEX idx_product_id ON order_items(product_id);
CREATE INDEX idx_order_id ON order_items(order_id);