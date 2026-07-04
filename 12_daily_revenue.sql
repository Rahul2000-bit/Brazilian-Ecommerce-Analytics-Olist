-- ============================================================
-- Brazilian E-Commerce Analytics (Olist)
-- 12_daily_revenue.sql
-- Daily Revenue Analytics
-- SQL Server
-- ============================================================

USE kaggle_data;
GO

---------------------------------------------------------------
-- Drop Existing Table
---------------------------------------------------------------

DROP TABLE IF EXISTS fact_time_revenue_daily;
GO

---------------------------------------------------------------
-- Create Daily Revenue Table
---------------------------------------------------------------

CREATE TABLE fact_time_revenue_daily
(
    date_id INT PRIMARY KEY,
    total_revenue DECIMAL(10,2) NOT NULL,
    total_orders INT NOT NULL,
    total_items_sold INT NOT NULL,
    avg_order_value DECIMAL(15,7)
);
GO

---------------------------------------------------------------
-- Populate Daily Revenue Table
---------------------------------------------------------------

WITH base_day_data AS
(
    SELECT
        foi.order_id,
        foi.quantity,
        foi.item_total_value,
        fo.order_date_id

    FROM fact_order_items foi

    INNER JOIN fact_orders fo
        ON foi.order_id = fo.order_id

    WHERE fo.order_lifecycle_status <> 'CANCELLED'
)

INSERT INTO fact_time_revenue_daily
(
    date_id,
    total_revenue,
    total_orders,
    total_items_sold,
    avg_order_value
)

SELECT

    b.order_date_id AS date_id,

    SUM(b.item_total_value) AS total_revenue,

    COUNT(DISTINCT b.order_id) AS total_orders,

    SUM(b.quantity) AS total_items_sold,

    SUM(b.item_total_value) * 1.0 /
    COUNT(DISTINCT b.order_id) AS avg_order_value

FROM base_day_data b

INNER JOIN dim_date d
    ON b.order_date_id = d.date_id

GROUP BY b.order_date_id;
GO

---------------------------------------------------------------
-- Validation
---------------------------------------------------------------

SELECT COUNT(*) AS total_days
FROM fact_time_revenue_daily;
GO

SELECT TOP (20) *
FROM fact_time_revenue_daily
ORDER BY date_id;
GO

---------------------------------------------------------------
-- End of Script
---------------------------------------------------------------
