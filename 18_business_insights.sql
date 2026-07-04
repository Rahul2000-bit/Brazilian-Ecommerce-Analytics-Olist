-- ============================================================
-- Brazilian E-Commerce Analytics (Olist)
-- 18_business_insights.sql
-- Business Insight Queries
-- SQL Server
-- ============================================================

USE kaggle_data;
GO

/*==============================================================
1. Overall Business Revenue Summary
==============================================================*/

SELECT *
FROM fact_revenue_kpi;
GO

/*==============================================================
2. Delivery Performance Summary
==============================================================*/

SELECT *
FROM fact_delivery_performance;
GO

/*==============================================================
3. Top 10 Products by Revenue
==============================================================*/

SELECT TOP (10)

    product_id,
    total_product_revenue,
    total_quantity_sold,
    product_rank,
    product_lifecycle

FROM fact_product_kpi

ORDER BY total_product_revenue DESC;
GO

/*==============================================================
4. Top 10 Sellers by Revenue
==============================================================*/

SELECT TOP (10)

    seller_id,
    total_seller_revenue,
    total_quantity_sold,
    seller_rank,
    seller_lifecycle

FROM fact_seller_kpi

ORDER BY total_seller_revenue DESC;
GO

/*==============================================================
5. Top Customers by Revenue
==============================================================*/

SELECT TOP (10)

    customer_id,
    total_revenue_per_customer,
    total_orders_placed,
    avg_order_value_per_customer,
    customer_engagement

FROM fact_customer_kpi

ORDER BY total_revenue_per_customer DESC;
GO

/*==============================================================
6. Monthly Revenue Trend
==============================================================*/

SELECT

    calendar_year,
    month_name,
    total_revenue,
    total_orders,
    avg_order_value

FROM fact_time_revenue_monthly

ORDER BY calendar_year,
         month_number;
GO

/*==============================================================
7. Month-over-Month Revenue Growth
==============================================================*/

SELECT

    calendar_year,
    month_name,
    total_revenue,
    previous_month_revenue,
    revenue_growth,
    revenue_growth_pct

FROM fact_time_revenue_mom

ORDER BY calendar_year,
         month_number;
GO

/*==============================================================
8. Year-over-Year Revenue Growth
==============================================================*/

SELECT *

FROM fact_time_revenue_yoy

ORDER BY calendar_year;
GO

/*==============================================================
9. Quarter-over-Quarter Revenue Growth
==============================================================*/

SELECT *

FROM fact_quarterly_revenue_qoq

ORDER BY calendar_year,
         calendar_quarter;
GO

/*==============================================================
10. Best Revenue Month
==============================================================*/

SELECT TOP (1)

    calendar_year,
    month_name,
    total_revenue

FROM fact_time_revenue_monthly

ORDER BY total_revenue DESC;
GO

/*==============================================================
11. Lowest Revenue Month
==============================================================*/

SELECT TOP (1)

    calendar_year,
    month_name,
    total_revenue

FROM fact_time_revenue_monthly

ORDER BY total_revenue;
GO

/*==============================================================
12. Revenue Contribution by Seller Category
==============================================================*/

SELECT

    seller_rank,

    COUNT(*) AS seller_count,

    SUM(total_seller_revenue) AS total_revenue

FROM fact_seller_kpi

GROUP BY seller_rank

ORDER BY total_revenue DESC;
GO

/*==============================================================
13. Product Category Performance
==============================================================*/

SELECT

    product_rank,

    COUNT(*) AS product_count,

    SUM(total_product_revenue) AS total_revenue

FROM fact_product_kpi

GROUP BY product_rank

ORDER BY total_revenue DESC;
GO

/*==============================================================
14. Customer Segmentation
==============================================================*/

SELECT

    customer_engagement,

    COUNT(*) AS total_customers,

    SUM(total_revenue_per_customer) AS revenue_generated

FROM fact_customer_kpi

GROUP BY customer_engagement;
GO

/*==============================================================
15. Average Order Value Trend
==============================================================*/

SELECT

    calendar_year,

    month_name,

    avg_order_value

FROM fact_time_revenue_monthly

ORDER BY calendar_year,
         month_number;
GO

-- ============================================================
-- End of Business Insights
-- ============================================================
