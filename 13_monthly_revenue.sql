-- ============================================================
-- Brazilian E-Commerce Analytics (Olist)
-- 13_monthly_revenue.sql
-- Monthly Revenue Analytics
-- SQL Server
-- ============================================================

USE kaggle_data;
GO

---------------------------------------------------------------
-- Drop Existing Table
---------------------------------------------------------------

DROP TABLE IF EXISTS fact_time_revenue_monthly;
GO

---------------------------------------------------------------
-- Create Monthly Revenue Table
---------------------------------------------------------------

CREATE TABLE fact_time_revenue_monthly
(
    calendar_year INT NOT NULL,
    month_name VARCHAR(10) NOT NULL,
    month_number INT NOT NULL,
    total_revenue DECIMAL(10,2) NOT NULL,
    total_orders INT NOT NULL,
    total_item_sold INT NOT NULL,
    avg_order_value DECIMAL(15,7),

    PRIMARY KEY (calendar_year, month_number)
);
GO

---------------------------------------------------------------
-- Populate Monthly Revenue Table
---------------------------------------------------------------

INSERT INTO fact_time_revenue_monthly
(
    calendar_year,
    month_name,
    month_number,
    total_revenue,
    total_orders,
    total_item_sold,
    avg_order_value
)

SELECT

    YEAR(d.full_date) AS calendar_year,

    d.month_name,

    d.month_number,

    SUM(t.total_revenue) AS total_revenue,

    SUM(t.total_orders) AS total_orders,

    SUM(t.total_items_sold) AS total_item_sold,

    SUM(t.total_revenue) * 1.0 /
    SUM(t.total_orders) AS avg_order_value

FROM dim_date d

INNER JOIN fact_time_revenue_daily t
    ON d.date_id = t.date_id

GROUP BY

    YEAR(d.full_date),
    d.month_name,
    d.month_number;
GO

---------------------------------------------------------------
-- Validation
---------------------------------------------------------------

SELECT COUNT(*) AS total_months
FROM fact_time_revenue_monthly;
GO

SELECT *
FROM fact_time_revenue_monthly
ORDER BY calendar_year, month_number;
GO

---------------------------------------------------------------
-- End of Script
---------------------------------------------------------------
