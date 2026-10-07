-- Drop existing tables to avoid conflicts during execution
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;

-- 1. Customers Table (Includes state for regional analysis)
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50), 
    signup_date DATE
);

-- 2. Products Table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);

-- 3. Orders Table (Tracks order status)
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_status VARCHAR(20) -- e.g., 'Delivered', 'Cancelled', 'Returned'
);

-- 4. Order_Items Table (Tracks products and quantities per order)
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    item_price DECIMAL(10, 2)
);

-- ==========================================
-- INSERTING DATA INTO TABLES
-- ==========================================

-- Insert Customers Data
INSERT INTO customers VALUES 
(1, 'Rahul Sharma', 'Delhi', 'Delhi', '2023-01-15'),
(2, 'Priya Singh', 'Mumbai', 'Maharashtra', '2023-02-20'),
(3, 'Amit Patel', 'Ahmedabad', 'Gujarat', '2023-03-10'),
(4, 'Neha Gupta', 'Pune', 'Maharashtra', '2023-04-05');

-- Insert Products Data
INSERT INTO products VALUES 
(101, 'Wireless Mouse', 'Electronics', 500.00),
(102, 'Mechanical Keyboard', 'Electronics', 2500.00),
(103, 'Cotton T-Shirt', 'Clothing', 600.00),
(104, 'Running Shoes', 'Footwear', 1200.00);

-- Insert Orders Data
INSERT INTO orders VALUES 
(1001, 1, '2023-05-10', 'Delivered'),
(1002, 2, '2023-05-12', 'Cancelled'),
(1003, 1, '2023-05-15', 'Delivered'),
(1004, 3, '2023-05-20', 'Returned'),
(1005, 4, '2023-05-22', 'Delivered');

-- Insert Order Items Data
INSERT INTO order_items VALUES 
(11, 1001, 101, 2, 500.00),
(12, 1001, 102, 1, 2500.00),
(13, 1002, 104, 1, 1200.00),
(14, 1003, 103, 3, 600.00),
(15, 1004, 101, 1, 500.00),
(16, 1005, 102, 1, 2500.00);

-- ==========================================
-- DATA ANALYSIS QUERIES
-- ==========================================

-- Q1. Get the names and states of all customers from the customers table.
SELECT customer_name, city
FROM customers;

-- Q2. Show the names and prices of products that cost more than 1000.
SELECT product_name, price
FROM products
WHERE price > 1000;

-- Q3. List all orders from the orders table that have a 'Delivered' status.
SELECT order_id
FROM orders
WHERE order_status = 'Delivered';

-- Q4. Find the entries in the order_items table where the quantity is 2 or more.
SELECT order_item_id
FROM order_items
WHERE quantity >= 2;

-- Q5. Using the order_items table, find the total quantity of all items sold combined.
SELECT SUM(quantity)
FROM order_items;

-- Q6. Show each product_id and its total sold quantity from the order_items table.
SELECT product_id, SUM(quantity)
FROM order_items
GROUP BY product_id
ORDER BY product_id ASC;

-- Q7. Find out how many different products exist in each category inside the products table.
SELECT category, COUNT(product_id) 
FROM products 
GROUP BY category;

-- Q8. Join the customers and orders tables to show the customer's name and their order status.
SELECT customer_name, order_status
FROM customers
INNER JOIN orders
ON customers.customer_id = orders.customer_id;

-- Q9. Show each product's name and its total sold quantity.
SELECT products.product_name, SUM(order_items.quantity)
FROM order_items
INNER JOIN products
ON products.product_id = order_items.product_id
GROUP BY products.product_name;

-- Q10. Get the names and cities of customers whose orders were successfully 'Delivered'.
SELECT customer_name, city
FROM customers
INNER JOIN orders
ON customers.customer_id = orders.customer_id
WHERE orders.order_status = 'Delivered';
