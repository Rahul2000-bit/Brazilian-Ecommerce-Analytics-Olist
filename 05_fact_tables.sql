-- ============================================================
-- Brazilian E-Commerce Analytics (Olist)
-- 05_fact_tables.sql
-- Create and Populate Fact Tables
-- SQL Server
-- ============================================================

USE kaggle_data;
GO

---------------------------------------------------------------
-- Drop Existing Fact Tables
---------------------------------------------------------------

DROP TABLE IF EXISTS fact_order_payments;
DROP TABLE IF EXISTS fact_order_items;
DROP TABLE IF EXISTS fact_orders;
GO

---------------------------------------------------------------
-- FACT TABLE : FACT_ORDERS
---------------------------------------------------------------

CREATE TABLE fact_orders
(
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    delivery_flag BIT,
    delivery_days INT,
    order_lifecycle_status VARCHAR(20),
    order_date_id INT
);
GO

INSERT INTO fact_orders
(
    order_id,
    customer_id,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    delivery_flag,
    delivery_days,
    order_lifecycle_status,
    order_date_id
)
SELECT
    order_id,
    customer_id,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,

    CASE
        WHEN order_status = 'delivered' THEN 1
        ELSE 0
    END AS delivery_flag,

    DATEDIFF
    (
        DAY,
        order_purchase_timestamp,
        order_delivered_customer_date
    ) AS delivery_days,

    CASE
        WHEN order_status = 'delivered' THEN 'DELIVERED'
        WHEN order_status = 'canceled' THEN 'CANCELLED'
        ELSE 'ACTIVE'
    END AS order_lifecycle_status,

    CONVERT(INT,
        CONVERT(VARCHAR(8), order_purchase_timestamp, 112)
    ) AS order_date_id

FROM orders;
GO

---------------------------------------------------------------
-- Validation
---------------------------------------------------------------

SELECT COUNT(*) AS fact_orders_count
FROM fact_orders;
GO

---------------------------------------------------------------
-- FACT TABLE : FACT_ORDER_ITEMS
---------------------------------------------------------------

CREATE TABLE fact_order_items
(
    order_id VARCHAR(50) NOT NULL,
    order_item_id INT NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    seller_id VARCHAR(50) NOT NULL,
    item_price DECIMAL(10,2) NOT NULL,
    freight_value DECIMAL(10,2),
    quantity INT,
    item_total_value DECIMAL(10,2),
    is_freight_free BIT,
    high_value_item_flag BIT,

    PRIMARY KEY (order_id, order_item_id)
);
GO

INSERT INTO fact_order_items
(
    order_id,
    order_item_id,
    product_id,
    seller_id,
    item_price,
    freight_value,
    quantity,
    item_total_value,
    is_freight_free,
    high_value_item_flag
)

SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    price,
    freight_value,

    1 AS quantity,

    (price + freight_value) AS item_total_value,

    CASE
        WHEN freight_value = 0 THEN 1
        ELSE 0
    END AS is_freight_free,

    CASE
        WHEN price >= 500 THEN 1
        ELSE 0
    END AS high_value_item_flag

FROM order_items;
GO

---------------------------------------------------------------
-- Validation
---------------------------------------------------------------

SELECT COUNT(*) AS fact_order_items_count
FROM fact_order_items;
GO

---------------------------------------------------------------
-- FACT TABLE : FACT_ORDER_PAYMENTS
---------------------------------------------------------------

CREATE TABLE fact_order_payments
(
    order_id VARCHAR(50) NOT NULL,
    payment_sequential INT NOT NULL,
    payment_type VARCHAR(20),
    payment_installments INT,
    payment_value DECIMAL(10,2) NOT NULL,
    order_lifecycle_status VARCHAR(20) NOT NULL,

    PRIMARY KEY (order_id, payment_sequential)
);
GO

INSERT INTO fact_order_payments
(
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value,
    order_lifecycle_status
)

SELECT
    p.order_id,
    p.payment_sequential,
    p.payment_type,
    p.payment_installments,
    p.payment_value,

    CASE
        WHEN o.order_status = 'delivered' THEN 'DELIVERED'
        WHEN o.order_status = 'canceled' THEN 'CANCELLED'
        ELSE 'ACTIVE'
    END AS order_lifecycle_status

FROM order_payments p
INNER JOIN orders o
    ON p.order_id = o.order_id;
GO

---------------------------------------------------------------
-- Validation
---------------------------------------------------------------

SELECT COUNT(*) AS fact_order_payments_count
FROM fact_order_payments;
GO

---------------------------------------------------------------
-- End of Script
---------------------------------------------------------------
