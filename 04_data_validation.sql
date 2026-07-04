-- ==========================================================
-- Brazilian E-Commerce Analytics (Olist)
-- Data Validation
-- SQL Server
-- ==========================================================

USE kaggle_data;
GO

-- ==========================================================
-- CUSTOMERS
-- ==========================================================

-- Total Records
SELECT COUNT(*) AS total_customers
FROM customers;

-- Duplicate Customer IDs
SELECT customer_id,
       COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- NULL Customer IDs
SELECT *
FROM customers
WHERE customer_id IS NULL;

-- ==========================================================
-- ORDERS
-- ==========================================================

-- Total Records
SELECT COUNT(*) AS total_orders
FROM orders;

-- Duplicate Order IDs
SELECT order_id,
       COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Missing Customers
SELECT o.order_id,
       o.customer_id
FROM orders o
LEFT JOIN customers c
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Invalid Order Dates
SELECT *
FROM orders
WHERE order_purchase_timestamp IS NULL;

-- ==========================================================
-- ORDER ITEMS
-- ==========================================================

-- Duplicate Order Item Keys
SELECT order_id,
       order_item_id,
       COUNT(*) AS duplicate_count
FROM order_items
GROUP BY order_id,
         order_item_id
HAVING COUNT(*) > 1;

-- Invalid Prices
SELECT *
FROM order_items
WHERE price < 0;

-- Invalid Freight
SELECT *
FROM order_items
WHERE freight_value < 0;

-- ==========================================================
-- PAYMENTS
-- ==========================================================

-- Invalid Payment Amount
SELECT *
FROM order_payments
WHERE payment_value <= 0;

-- Invalid Installments
SELECT *
FROM order_payments
WHERE payment_installments < 0;

-- ==========================================================
-- PRODUCTS
-- ==========================================================

-- Missing Product IDs
SELECT *
FROM products
WHERE product_id IS NULL;

-- Missing Categories
SELECT *
FROM products
WHERE product_category_name IS NULL;

-- ==========================================================
-- SELLERS
-- ==========================================================

-- Duplicate Sellers
SELECT seller_id,
       COUNT(*) AS duplicate_count
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;

-- ==========================================================
-- REVIEWS
-- ==========================================================

-- Invalid Review Scores
SELECT *
FROM order_reviews
WHERE review_score NOT BETWEEN 1 AND 5;

-- ==========================================================
-- REFERENTIAL INTEGRITY
-- ==========================================================

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
-- SUMMARY
-- ==========================================================

SELECT 'Customers' AS table_name, COUNT(*) AS total_rows FROM customers
UNION ALL
SELECT 'Orders', COUNT(*) FROM orders
UNION ALL
SELECT 'Order Items', COUNT(*) FROM order_items
UNION ALL
SELECT 'Payments', COUNT(*) FROM order_payments
UNION ALL
SELECT 'Products', COUNT(*) FROM products
UNION ALL
SELECT 'Sellers', COUNT(*) FROM sellers
UNION ALL
SELECT 'Reviews', COUNT(*) FROM order_reviews
UNION ALL
SELECT 'Geolocation', COUNT(*) FROM geolocation;
