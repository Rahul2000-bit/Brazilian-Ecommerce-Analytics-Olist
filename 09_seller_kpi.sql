-- ============================================================
-- Brazilian E-Commerce Analytics (Olist)
-- 09_seller_kpi.sql
-- Seller KPI Analytics
-- SQL Server
-- ============================================================

USE kaggle_data;
GO

---------------------------------------------------------------
-- Drop Existing Table
---------------------------------------------------------------

DROP TABLE IF EXISTS fact_seller_kpi;
GO

---------------------------------------------------------------
-- Create Seller KPI Table
---------------------------------------------------------------

CREATE TABLE fact_seller_kpi
(
    seller_id VARCHAR(50) PRIMARY KEY,
    total_quantity_sold INT NOT NULL,
    total_seller_revenue DECIMAL(15,2) NOT NULL,
    order_coverage INT,
    avg_revenue_per_order DECIMAL(15,5),
    revenue_contribution DECIMAL(15,7),
    seller_rank VARCHAR(10),
    seller_lifecycle VARCHAR(20)
);
GO

---------------------------------------------------------------
-- Aggregate Seller Metrics
---------------------------------------------------------------

WITH seller_summary AS
(
    SELECT

        foi.seller_id,

        SUM(foi.quantity) AS total_quantity_sold,

        SUM(foi.item_total_value) AS total_seller_revenue,

        COUNT(DISTINCT foi.order_id) AS order_coverage,

        SUM(foi.item_total_value) * 1.0 /
        COUNT(DISTINCT foi.order_id)
            AS avg_revenue_per_order

    FROM fact_order_items foi

    INNER JOIN fact_orders fo
        ON foi.order_id = fo.order_id

    WHERE fo.order_lifecycle_status <> 'CANCELLED'

    GROUP BY foi.seller_id
),

seller_ranking AS
(
    SELECT
        *,
        NTILE(3) OVER
        (
            ORDER BY total_seller_revenue DESC
        ) AS revenue_bucket
    FROM seller_summary
)

---------------------------------------------------------------
-- Populate Seller KPI Table
---------------------------------------------------------------

INSERT INTO fact_seller_kpi
(
    seller_id,
    total_quantity_sold,
    total_seller_revenue,
    order_coverage,
    avg_revenue_per_order,
    revenue_contribution,
    seller_rank,
    seller_lifecycle
)

SELECT

    seller_id,

    total_quantity_sold,

    total_seller_revenue,

    order_coverage,

    avg_revenue_per_order,

    ROUND
    (
        total_seller_revenue * 100.0 /
        SUM(total_seller_revenue) OVER (),
        7
    ) AS revenue_contribution,

    CASE

        WHEN revenue_bucket = 1
            THEN 'TOP'

        WHEN revenue_bucket = 2
            THEN 'MID'

        ELSE 'LOW'

    END AS seller_rank,

    CASE

        WHEN total_quantity_sold >= 10
            THEN 'FAST_MOVING'

        ELSE 'SLOW_MOVING'

    END AS seller_lifecycle

FROM seller_ranking;
GO

---------------------------------------------------------------
-- Add Check Constraints
---------------------------------------------------------------

ALTER TABLE fact_seller_kpi
ADD CONSTRAINT CK_seller_rank
CHECK (seller_rank IN ('TOP','MID','LOW'));
GO

ALTER TABLE fact_seller_kpi
ADD CONSTRAINT CK_seller_lifecycle
CHECK (seller_lifecycle IN ('FAST_MOVING','SLOW_MOVING'));
GO

---------------------------------------------------------------
-- Validation
---------------------------------------------------------------

SELECT COUNT(*) AS total_sellers
FROM fact_seller_kpi;
GO

SELECT TOP (10) *
FROM fact_seller_kpi
ORDER BY total_seller_revenue DESC;
GO

---------------------------------------------------------------
-- End of Script
---------------------------------------------------------------
