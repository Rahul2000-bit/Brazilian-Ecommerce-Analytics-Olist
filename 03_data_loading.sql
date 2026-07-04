-- ==========================================================
-- Brazilian E-Commerce Analytics (Olist)
-- Data Loading
-- SQL Server
-- ==========================================================

USE kaggle_data;
GO

-- ==========================================================
-- LOAD CUSTOMERS
-- ==========================================================

BULK INSERT customers
FROM 'C:\Olist Dataset\olist_customers_dataset.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- ==========================================================
-- LOAD ORDERS
-- ==========================================================

BULK INSERT orders
FROM 'C:\Olist Dataset\olist_orders_dataset.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- ==========================================================
-- LOAD ORDER ITEMS
-- ==========================================================

BULK INSERT order_items
FROM 'C:\Olist Dataset\olist_order_items_dataset.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- ==========================================================
-- LOAD PAYMENTS
-- ==========================================================

BULK INSERT order_payments
FROM 'C:\Olist Dataset\olist_order_payments_dataset.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- ==========================================================
-- LOAD REVIEWS
-- ==========================================================

BULK INSERT order_reviews
FROM 'C:\Olist Dataset\olist_order_reviews_dataset.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- ==========================================================
-- LOAD PRODUCTS
-- ==========================================================

BULK INSERT products
FROM 'C:\Olist Dataset\olist_products_dataset.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- ==========================================================
-- LOAD SELLERS
-- ==========================================================

BULK INSERT sellers
FROM 'C:\Olist Dataset\olist_sellers_dataset.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- ==========================================================
-- LOAD GEOLOCATION
-- ==========================================================

BULK INSERT geolocation
FROM 'C:\Olist Dataset\olist_geolocation_dataset.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- ==========================================================
-- VALIDATION
-- ==========================================================

SELECT COUNT(*) AS customers_count FROM customers;
SELECT COUNT(*) AS orders_count FROM orders;
SELECT COUNT(*) AS order_items_count FROM order_items;
SELECT COUNT(*) AS payments_count FROM order_payments;
SELECT COUNT(*) AS reviews_count FROM order_reviews;
SELECT COUNT(*) AS products_count FROM products;
SELECT COUNT(*) AS sellers_count FROM sellers;
SELECT COUNT(*) AS geolocation_count FROM geolocation;
