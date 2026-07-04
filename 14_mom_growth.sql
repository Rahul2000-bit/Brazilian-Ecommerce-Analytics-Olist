-- ============================================================
-- Brazilian E-Commerce Analytics (Olist)
-- 14_mom_growth.sql
-- Month-over-Month (MoM) Revenue & Order Growth
-- SQL Server
-- ============================================================

USE kaggle_data;
GO

---------------------------------------------------------------
-- Drop Existing Table
---------------------------------------------------------------

DROP TABLE IF EXISTS fact_time_revenue_mom;
GO

---------------------------------------------------------------
-- Create MoM Revenue Table
---------------------------------------------------------------

CREATE TABLE fact_time_revenue_mom
(
    calendar_year INT NOT NULL,
    month_name VARCHAR(10) NOT NULL,
    month_number INT NOT NULL,
    total_revenue DECIMAL(15,4) NOT NULL,
    previous_month_revenue DECIMAL(15,4),
    revenue_growth DECIMAL(15,4),
    revenue_growth_pct DECIMAL(15,7),
    total_orders INT NOT NULL,
    previous_month_orders INT,
    orders_growth INT,
    orders_growth_pct DECIMAL(15,7),

    PRIMARY KEY (calendar_year, month_number)
);
GO

---------------------------------------------------------------
-- Populate MoM Revenue Table
---------------------------------------------------------------

INSERT INTO fact_time_revenue_mom
(
    calendar_year,
    month_name,
    month_number,
    total_revenue,
    previous_month_revenue,
    revenue_growth,
    revenue_growth_pct,
    total_orders,
    previous_month_orders,
    orders_growth,
    orders_growth_pct
)

SELECT

    calendar_year,

    month_name,

    month_number,

    total_revenue,

    LAG(total_revenue) OVER
    (
        PARTITION BY calendar_year
        ORDER BY month_number
    ) AS previous_month_revenue,

    total_revenue -
    LAG(total_revenue) OVER
    (
        PARTITION BY calendar_year
        ORDER BY month_number
    ) AS revenue_growth,

    (
        total_revenue -
        LAG(total_revenue) OVER
        (
            PARTITION BY calendar_year
            ORDER BY month_number
        )
    ) * 100.0
    /
    NULLIF
    (
        LAG(total_revenue) OVER
        (
            PARTITION BY calendar_year
            ORDER BY month_number
        ),
        0
    ) AS revenue_growth_pct,

    total_orders,

    LAG(total_orders) OVER
    (
        PARTITION BY calendar_year
        ORDER BY month_number
    ) AS previous_month_orders,

    total_orders -
    LAG(total_orders) OVER
    (
        PARTITION BY calendar_year
        ORDER BY month_number
    ) AS orders_growth,

    (
        total_orders -
        LAG(total_orders) OVER
        (
            PARTITION BY calendar_year
            ORDER BY month_number
        )
    ) * 100.0
    /
    NULLIF
    (
        LAG(total_orders) OVER
        (
            PARTITION BY calendar_year
            ORDER BY month_number
        ),
        0
    ) AS orders_growth_pct

FROM fact_time_revenue_monthly

ORDER BY
    calendar_year,
    month_number;
GO

---------------------------------------------------------------
-- Validation
---------------------------------------------------------------

SELECT *
FROM fact_time_revenue_mom
ORDER BY calendar_year, month_number;
GO

---------------------------------------------------------------
-- End of Script
---------------------------------------------------------------
