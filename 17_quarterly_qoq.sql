-- ============================================================
-- Brazilian E-Commerce Analytics (Olist)
-- 17_quarterly_qoq.sql
-- Quarter-over-Quarter (QoQ) Revenue Analytics
-- SQL Server
-- ============================================================

USE kaggle_data;
GO

---------------------------------------------------------------
-- Drop Existing Table
---------------------------------------------------------------

DROP TABLE IF EXISTS fact_quarterly_revenue_qoq;
GO

---------------------------------------------------------------
-- Create Quarterly Revenue Table
---------------------------------------------------------------

CREATE TABLE fact_quarterly_revenue_qoq
(
    calendar_year INT NOT NULL,
    calendar_quarter INT NOT NULL,
    total_orders INT NOT NULL,
    total_revenue DECIMAL(15,4) NOT NULL,
    prev_quarter_revenue DECIMAL(15,4),
    revenue_growth DECIMAL(15,4),
    revenue_growth_pct DECIMAL(15,7),

    PRIMARY KEY (calendar_year, calendar_quarter)
);
GO

---------------------------------------------------------------
-- Populate Quarterly Revenue Table
---------------------------------------------------------------

WITH quarterly_revenue AS
(
    SELECT

        YEAR(d.full_date) AS calendar_year,

        DATEPART(QUARTER, d.full_date) AS calendar_quarter,

        SUM(t.total_orders) AS total_orders,

        SUM(t.total_revenue) AS total_revenue

    FROM dim_date d

    INNER JOIN fact_time_revenue_daily t
        ON d.date_id = t.date_id

    GROUP BY

        YEAR(d.full_date),

        DATEPART(QUARTER, d.full_date)
)

INSERT INTO fact_quarterly_revenue_qoq
(
    calendar_year,
    calendar_quarter,
    total_orders,
    total_revenue,
    prev_quarter_revenue,
    revenue_growth,
    revenue_growth_pct
)

SELECT

    calendar_year,

    calendar_quarter,

    total_orders,

    total_revenue,

    LAG(total_revenue) OVER
    (
        ORDER BY calendar_year, calendar_quarter
    ) AS prev_quarter_revenue,

    total_revenue -
    LAG(total_revenue) OVER
    (
        ORDER BY calendar_year, calendar_quarter
    ) AS revenue_growth,

    (
        total_revenue -
        LAG(total_revenue) OVER
        (
            ORDER BY calendar_year, calendar_quarter
        )
    ) * 100.0
    /
    NULLIF
    (
        LAG(total_revenue) OVER
        (
            ORDER BY calendar_year, calendar_quarter
        ),
        0
    ) AS revenue_growth_pct

FROM quarterly_revenue;
GO

---------------------------------------------------------------
-- Validation
---------------------------------------------------------------

SELECT *
FROM fact_quarterly_revenue_qoq
ORDER BY calendar_year, calendar_quarter;
GO

---------------------------------------------------------------
-- End of Script
---------------------------------------------------------------
