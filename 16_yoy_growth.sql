-- ============================================================
-- Brazilian E-Commerce Analytics (Olist)
-- 16_yoy_growth.sql
-- Year-over-Year (YoY) Revenue Growth Analytics
-- SQL Server
-- ============================================================

USE kaggle_data;
GO

---------------------------------------------------------------
-- Drop Existing Table
---------------------------------------------------------------

DROP TABLE IF EXISTS fact_time_revenue_yoy;
GO

---------------------------------------------------------------
-- Create YoY Revenue Growth Table
---------------------------------------------------------------

CREATE TABLE fact_time_revenue_yoy
(
    calendar_year INT PRIMARY KEY,
    total_revenue DECIMAL(15,4) NOT NULL,
    previous_year_revenue DECIMAL(15,4),
    revenue_growth DECIMAL(15,4),
    revenue_growth_pct DECIMAL(15,7)
);
GO

---------------------------------------------------------------
-- Populate YoY Revenue Growth Table
---------------------------------------------------------------

INSERT INTO fact_time_revenue_yoy
(
    calendar_year,
    total_revenue,
    previous_year_revenue,
    revenue_growth,
    revenue_growth_pct
)

SELECT

    calendar_year,

    total_revenue,

    LAG(total_revenue) OVER
    (
        ORDER BY calendar_year
    ) AS previous_year_revenue,

    total_revenue -
    LAG(total_revenue) OVER
    (
        ORDER BY calendar_year
    ) AS revenue_growth,

    (
        total_revenue -
        LAG(total_revenue) OVER
        (
            ORDER BY calendar_year
        )
    ) * 100.0
    /
    NULLIF
    (
        LAG(total_revenue) OVER
        (
            ORDER BY calendar_year
        ),
        0
    ) AS revenue_growth_pct

FROM fact_time_revenue_yearly;
GO

---------------------------------------------------------------
-- Validation
---------------------------------------------------------------

SELECT *
FROM fact_time_revenue_yoy
ORDER BY calendar_year;
GO

---------------------------------------------------------------
-- End of Script
---------------------------------------------------------------
