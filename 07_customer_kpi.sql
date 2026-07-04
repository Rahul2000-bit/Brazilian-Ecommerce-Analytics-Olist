-- ============================================================
-- Brazilian E-Commerce Analytics (Olist)
-- 07_customer_kpi.sql
-- Customer KPI Analytics
-- SQL Server
-- ============================================================

USE kaggle_data;
GO

---------------------------------------------------------------
-- Drop Existing Table
---------------------------------------------------------------

DROP TABLE IF EXISTS fact_customer_kpi;
GO

---------------------------------------------------------------
-- Create Customer KPI Table
---------------------------------------------------------------

CREATE TABLE fact_customer_kpi
(
    customer_id VARCHAR(50) PRIMARY KEY,
    total_orders_placed INT NOT NULL,
    first_order_date DATE,
    last_order_date DATE,
    total_revenue_per_customer DECIMAL(10,2) NOT NULL,
    avg_order_value_per_customer DECIMAL(10,2),
    customer_engagement VARCHAR(20)
);
GO

---------------------------------------------------------------
-- Populate Customer KPI Table
---------------------------------------------------------------

WITH customer_orders AS
(
    SELECT
        fo.customer_id,
        fo.order_id,
        fo.order_purchase_timestamp,
        foi.item_total_value
    FROM fact_orders fo
    INNER JOIN fact_order_items foi
        ON fo.order_id = foi.order_id
    WHERE fo.order_lifecycle_status <> 'CANCELLED'
)

INSERT INTO fact_customer_kpi
(
    customer_id,
    total_orders_placed,
    first_order_date,
    last_order_date,
    total_revenue_per_customer,
    avg_order_value_per_customer,
    customer_engagement
)

SELECT

    customer_id,

    COUNT(DISTINCT order_id) AS total_orders_placed,

    CAST(MIN(order_purchase_timestamp) AS DATE) AS first_order_date,

    CAST(MAX(order_purchase_timestamp) AS DATE) AS last_order_date,

    SUM(item_total_value) AS total_revenue_per_customer,

    SUM(item_total_value) * 1.0 /
    COUNT(DISTINCT order_id) AS avg_order_value_per_customer,

    CASE
        WHEN COUNT(DISTINCT order_id) = 1
            THEN 'One-time customer'
        ELSE 'Repeat customer'
    END AS customer_engagement

FROM customer_orders

GROUP BY customer_id;
GO

---------------------------------------------------------------
-- Validation
---------------------------------------------------------------

SELECT COUNT(*) AS total_customers
FROM fact_customer_kpi;
GO

SELECT TOP (10) *
FROM fact_customer_kpi
ORDER BY total_revenue_per_customer DESC;
GO

---------------------------------------------------------------
-- End of Script
---------------------------------------------------------------
