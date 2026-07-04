-- ============================================================
-- Brazilian E-Commerce Analytics (Olist)
-- 11_revenue_kpi.sql
-- Revenue KPI Analytics
-- SQL Server
-- ============================================================

USE kaggle_data;
GO

---------------------------------------------------------------
-- Drop Existing Table
---------------------------------------------------------------

DROP TABLE IF EXISTS fact_revenue_kpi;
GO

---------------------------------------------------------------
-- Create Revenue KPI Table
---------------------------------------------------------------

CREATE TABLE fact_revenue_kpi
(
    total_revenue DECIMAL(15,2) NOT NULL,
    total_items_sold INT,
    total_order INT,
    avg_order_value DECIMAL(10,2)
);
GO

---------------------------------------------------------------
-- Populate Revenue KPI Table
---------------------------------------------------------------

INSERT INTO fact_revenue_kpi
(
    total_revenue,
    total_items_sold,
    total_order,
    avg_order_value
)

SELECT

    SUM(foi.item_total_value) AS total_revenue,

    SUM(foi.quantity) AS total_items_sold,

    COUNT(DISTINCT fo.order_id) AS total_order,

    ROUND
    (
        SUM(foi.item_total_value) * 1.0
        /
        COUNT(DISTINCT fo.order_id),
        2
    ) AS avg_order_value

FROM fact_order_items foi

INNER JOIN fact_orders fo
    ON foi.order_id = fo.order_id

WHERE fo.order_lifecycle_status <> 'CANCELLED';
GO

---------------------------------------------------------------
-- Validation
---------------------------------------------------------------

SELECT *
FROM fact_revenue_kpi;
GO

---------------------------------------------------------------
-- End of Script
---------------------------------------------------------------
