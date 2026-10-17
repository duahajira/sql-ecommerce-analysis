-- ==========================================
-- E-commerce Database Analysis
-- ==========================================

-- 1. CREATE TABLES
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status VARCHAR(20)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2)
);

-- 2. INSERT DATA
INSERT INTO customers VALUES 
(1, 'Ali Khan', 'Karachi', 'Pakistan'),
(2, 'Sara Ahmed', 'Lahore', 'Pakistan'),
(3, 'John Smith', 'New York', 'USA'),
(4, 'Ahmed Raza', 'Islamabad', 'Pakistan'),
(5, 'Mary Johnson', 'London', 'UK');

INSERT INTO products VALUES 
(101, 'Laptop', 'Electronics', 1200.00),
(102, 'Mouse', 'Electronics', 25.00),
(103, 'Chair', 'Furniture', 150.00),
(104, 'Notebook', 'Stationery', 5.00),
(105, 'Phone', 'Electronics', 800.00);

INSERT INTO orders VALUES 
(1001, 1, '2024-06-01', 'Delivered'),
(1002, 2, '2024-06-05', 'Delivered'),
(1003, 1, '2024-06-10', 'Pending'),
(1004, 3, '2024-06-15', 'Delivered'),
(1005, 4, '2024-06-20', 'Cancelled');

INSERT INTO order_items VALUES 
(1, 1001, 101, 1, 1200.00),
(2, 1001, 102, 2, 25.00),
(3, 1002, 103, 1, 150.00),
(4, 1003, 105, 1, 800.00),
(5, 1004, 104, 5, 5.00),
(6, 1004, 102, 1, 25.00),
(7, 1005, 101, 1, 1200.00);

-- 3. ANALYSIS QUERIES

-- Total Revenue (excluding cancelled orders)
SELECT SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status <> 'Cancelled';

-- Top 3 Customers (excluding cancelled orders)
SELECT c.customer_id, c.name,
       SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status <> 'Cancelled'
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC
LIMIT 3;

-- Category Wise Revenue (excluding cancelled orders)
SELECT p.category, SUM(oi.quantity * oi.unit_price) AS revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status <> 'Cancelled'
GROUP BY p.category
ORDER BY revenue DESC;