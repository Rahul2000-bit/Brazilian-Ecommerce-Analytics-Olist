-- ============================================================
-- Brazilian E-Commerce Analytics (Olist)
-- 15_yearly_revenue.sql
-- Yearly Revenue Analytics
-- SQL Server
-- ============================================================

USE kaggle_data;
GO

---------------------------------------------------------------
-- Drop Existing Table
---------------------------------------------------------------

DROP TABLE IF EXISTS fact_time_revenue_yearly;
GO

---------------------------------------------------------------
-- Create Yearly Revenue Table
---------------------------------------------------------------

CREATE TABLE fact_time_revenue_yearly
(
    calendar_year INT PRIMARY KEY,
    total_revenue DECIMAL(15,4) NOT NULL,
    total_orders INT NOT NULL,
    total_item_sold INT NOT NULL,
    avg_order_value DECIMAL(15,7)
);
GO

---------------------------------------------------------------
-- Populate Yearly Revenue Table
---------------------------------------------------------------

INSERT INTO fact_time_revenue_yearly
(
    calendar_year,
    total_revenue,
    total_orders,
    total_item_sold,
    avg_order_value
)

SELECT

    YEAR(d.full_date) AS calendar_year,

    SUM(t.total_revenue) AS total_revenue,

    SUM(t.total_orders) AS total_orders,

    SUM(t.total_items_sold) AS total_item_sold,

    SUM(t.total_revenue) * 1.0 /
    SUM(t.total_orders) AS avg_order_value

FROM dim_date d

INNER JOIN fact_time_revenue_daily t
    ON d.date_id = t.date_id

GROUP BY YEAR(d.full_date);
GO

---------------------------------------------------------------
-- Validation
---------------------------------------------------------------

SELECT *
FROM fact_time_revenue_yearly
ORDER BY calendar_year;
GO

---------------------------------------------------------------
-- End of Script
---------------------------------------------------------------
