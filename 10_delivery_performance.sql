-- ============================================================
-- Brazilian E-Commerce Analytics (Olist)
-- 10_delivery_performance.sql
-- Delivery Performance KPI
-- SQL Server
-- ============================================================

USE kaggle_data;
GO

---------------------------------------------------------------
-- Drop Existing Table
---------------------------------------------------------------

DROP TABLE IF EXISTS fact_delivery_performance;
GO

---------------------------------------------------------------
-- Create Delivery Performance Table
---------------------------------------------------------------

CREATE TABLE fact_delivery_performance
(
    total_delivered_orders INT NOT NULL,
    avg_delivery_days DECIMAL(10,2),
    delayed_order_count INT,
    delayed_percentage DECIMAL(10,2)
);
GO

---------------------------------------------------------------
-- Populate Delivery Performance KPI
---------------------------------------------------------------

INSERT INTO fact_delivery_performance
(
    total_delivered_orders,
    avg_delivery_days,
    delayed_order_count,
    delayed_percentage
)

SELECT

    COUNT(*) AS total_delivered_orders,

    AVG(CAST(delivery_days AS DECIMAL(10,2))) AS avg_delivery_days,

    SUM
    (
        CASE
            WHEN delivery_days > 7 THEN 1
            ELSE 0
        END
    ) AS delayed_order_count,

    ROUND
    (
        SUM
        (
            CASE
                WHEN delivery_days > 7 THEN 1
                ELSE 0
            END
        ) * 100.0
        /
        COUNT(*),
        2
    ) AS delayed_percentage

FROM fact_orders

WHERE order_lifecycle_status = 'DELIVERED';
GO

---------------------------------------------------------------
-- Validation
---------------------------------------------------------------

SELECT *
FROM fact_delivery_performance;
GO

---------------------------------------------------------------
-- End of Script
---------------------------------------------------------------
