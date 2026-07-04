-- ==========================================================
-- Brazilian E-Commerce Analytics (Olist)
-- Data Validation
-- SQL Server
-- ==========================================================

USE kaggle_data;
GO

-- ==========================================================
-- RECORD COUNT VALIDATION
-- ==========================================================

SELECT COUNT(*) AS total_customers
FROM customers;

SELECT COUNT(*) AS total_orders
FROM orders;

SELECT COUNT(*) AS total_order_items
FROM order_items;

SELECT COUNT(*) AS total_payments
FROM order_payments;

SELECT COUNT(*) AS total_products
FROM products;

SELECT COUNT(*) AS total_sellers
FROM sellers;

SELECT COUNT(*) AS total_reviews
FROM order_reviews;

SELECT COUNT(*) AS total_geolocations
FROM geolocation;

-- ==========================================================
-- DUPLICATE VALIDATION
-- ==========================================================

-- Customers
SELECT customer_id, COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Orders
SELECT order_id, COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Products
SELECT product_id, COUNT(*) AS duplicate_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

-- Sellers
SELECT seller_id, COUNT(*) AS duplicate_count
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;

-- ==========================================================
-- NULL VALIDATION
-- ==========================================================

SELECT *
FROM customers
WHERE customer_id IS NULL;

SELECT *
FROM orders
WHERE order_id IS NULL
   OR customer_id IS NULL;

SELECT *
FROM products
WHERE product_id IS NULL;

SELECT *
FROM sellers
WHERE seller_id IS NULL;

-- ==========================================================
-- REFERENTIAL INTEGRITY VALIDATION
-- ==========================================================

-- Orders without Customers
SELECT o.order_id
FROM orders o
LEFT JOIN customers c
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Order Items without Orders
SELECT oi.order_id
FROM order_items oi
LEFT JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Order Items without Products
SELECT oi.product_id
FROM order_items oi
LEFT JOIN products p
ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

-- Order Items without Sellers
SELECT oi.seller_id
FROM order_items oi
LEFT JOIN sellers s
ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;

-- Payments without Orders
SELECT op.order_id
FROM order_payments op
LEFT JOIN orders o
ON op.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Reviews without Orders
SELECT r.order_id
FROM order_reviews r
LEFT JOIN orders o
ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

-- ==========================================================
-- MONETARY VALIDATION
-- ==========================================================

SELECT *
FROM order_items
WHERE price < 0
   OR freight_value < 0;

SELECT *
FROM order_payments
WHERE payment_value < 0;

-- ==========================================================
-- DATE VALIDATION
-- ==========================================================

SELECT *
FROM orders
WHERE order_purchase_timestamp IS NULL;

-- ==========================================================
-- REVIEW SCORE VALIDATION
-- ==========================================================

SELECT *
FROM order_reviews
WHERE review_score NOT BETWEEN 1 AND 5;
