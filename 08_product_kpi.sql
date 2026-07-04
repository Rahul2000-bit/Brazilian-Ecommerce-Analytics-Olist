-- ============================================================
-- Brazilian E-Commerce Analytics (Olist)
-- 08_product_kpi.sql
-- Product KPI Analytics
-- SQL Server
-- ============================================================

USE kaggle_data;
GO

---------------------------------------------------------------
-- Drop Existing Table
---------------------------------------------------------------

DROP TABLE IF EXISTS fact_product_kpi;
GO

---------------------------------------------------------------
-- Create Product KPI Table
---------------------------------------------------------------

CREATE TABLE fact_product_kpi
(
    product_id VARCHAR(50) PRIMARY KEY,
    total_quantity_sold INT NOT NULL,
    total_product_revenue DECIMAL(10,2) NOT NULL,
    order_coverage INT,
    avg_selling_price_per_unit DECIMAL(15,5),
    revenue_contribution_percentage DECIMAL(15,5),
    product_rank VARCHAR(10),
    product_lifecycle VARCHAR(20)
);
GO

---------------------------------------------------------------
-- Aggregate Product Metrics
---------------------------------------------------------------

WITH product_summary AS
(
    SELECT
        foi.product_id,
        SUM(foi.quantity) AS total_quantity_sold,
        SUM(foi.item_total_value) AS total_product_revenue,
        COUNT(DISTINCT foi.order_id) AS order_coverage,
        AVG(foi.item_price) AS avg_selling_price_per_unit

    FROM fact_order_items foi

    INNER JOIN fact_orders fo
        ON foi.order_id = fo.order_id

    WHERE fo.order_lifecycle_status <> 'CANCELLED'

    GROUP BY foi.product_id
),

product_ranking AS
(
    SELECT
        *,
        NTILE(3) OVER
        (
            ORDER BY total_product_revenue DESC
        ) AS revenue_bucket
    FROM product_summary
)

---------------------------------------------------------------
-- Populate Product KPI Table
---------------------------------------------------------------

INSERT INTO fact_product_kpi
(
    product_id,
    total_quantity_sold,
    total_product_revenue,
    order_coverage,
    avg_selling_price_per_unit,
    revenue_contribution_percentage,
    product_rank,
    product_lifecycle
)

SELECT

    product_id,

    total_quantity_sold,

    total_product_revenue,

    order_coverage,

    avg_selling_price_per_unit,

    ROUND
    (
        total_product_revenue * 100.0 /
        SUM(total_product_revenue) OVER (),
        5
    ) AS revenue_contribution_percentage,

    CASE

        WHEN revenue_bucket = 1
            THEN 'TOP'

        WHEN revenue_bucket = 2
            THEN 'MID'

        ELSE 'LOW'

    END AS product_rank,

    CASE

        WHEN total_quantity_sold >= 10
            THEN 'FAST_MOVING'

        ELSE 'SLOW_MOVING'

    END AS product_lifecycle

FROM product_ranking;
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

SELECT COUNT(*) AS total_products
FROM fact_product_kpi;
GO

SELECT TOP (10) *
FROM fact_product_kpi
ORDER BY total_product_revenue DESC;
GO

---------------------------------------------------------------
-- End of Script
---------------------------------------------------------------
