# 🇧🇷 Brazilian E-Commerce Analytics | Olist SQL Data Warehouse

![SQL Server](https://img.shields.io/badge/SQL%20Server-TSQL-red)
![Project](https://img.shields.io/badge/Project-Data%20Warehouse-blue)
![Dataset](https://img.shields.io/badge/Dataset-Olist-success)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

## 📌 Project Overview

This project demonstrates the design and implementation of a SQL Server-based analytical data warehouse using the Brazilian E-Commerce Public Dataset (Olist).

The objective was to transform raw transactional e-commerce data into an analytics-ready data warehouse capable of answering business questions through KPI tables, time-series analytics, and reporting queries.

The project follows a structured ETL approach involving data validation, dimensional modeling, KPI generation, and business analytics.

---

# Dataset

**Source**

Brazilian E-Commerce Public Dataset by Olist

The dataset contains information about:

- Customers
- Orders
- Products
- Sellers
- Payments
- Delivery
- Reviews
- Geolocation

---

# Project Objectives

- Build a SQL Server analytical database
- Design fact and dimension tables
- Create reusable KPI tables
- Perform customer, seller and product analytics
- Build daily, monthly, quarterly and yearly revenue summaries
- Calculate MoM, QoQ and YoY growth metrics
- Generate business insight queries for reporting

---

# Tech Stack

- SQL Server
- T-SQL
- SSMS
- Star Schema Modeling
- Window Functions
- Common Table Expressions (CTEs)
- Aggregate Functions
- Date Dimension Modeling

---

# Project Structure

```
Brazilian-Ecommerce-Analytics/

│
├── 01_database_setup/
├── 02_source_tables/
├── 03_data_loading/
├── 04_data_validation/
├── 05_fact_tables/
├── 06_dimension_tables/
├── 07_kpi_tables/
├── 08_time_analytics/
├── 09_business_insights/
│
├── README.md
└── LICENSE
```

---

# Database Architecture

The project follows a dimensional model.

```
                    dim_date
                       │
                       │
               fact_orders
                    │
                    │
      ┌─────────────┴─────────────┐
      │                           │
fact_order_items          fact_order_payments
      │
      │
 ┌────┴────┐
 │         │
 │         │
Product   Seller

↓

Customer KPI
Product KPI
Seller KPI
Revenue KPI
Delivery KPI

↓

Time Analytics

↓

Business Insights
```

---

# Fact Tables

The project includes the following analytical fact tables.

| Table | Description |
|--------|-------------|
| fact_orders | Order level analytics |
| fact_order_items | Item level sales |
| fact_order_payments | Payment analytics |
| fact_customer_kpi | Customer KPIs |
| fact_product_kpi | Product KPIs |
| fact_seller_kpi | Seller KPIs |
| fact_delivery_performance | Delivery metrics |
| fact_revenue_kpi | Overall business KPIs |
| fact_time_revenue_daily | Daily sales summary |
| fact_time_revenue_monthly | Monthly sales summary |
| fact_time_revenue_mom | Month-over-Month growth |
| fact_time_revenue_yearly | Yearly sales summary |
| fact_time_revenue_yoy | Year-over-Year growth |
| fact_quarterly_revenue_qoq | Quarter-over-Quarter growth |

---

# Dimension Table

## dim_date

A reusable calendar dimension containing

- Date ID
- Calendar Year
- Quarter
- Month
- Week
- Day
- Weekend Indicator
- Month End Flag
- Quarter End Flag
- Year End Flag

---

# KPIs Generated

### Customer KPIs

- Total Orders
- Customer Revenue
- Average Order Value
- Customer Engagement

---

### Product KPIs

- Total Quantity Sold
- Product Revenue
- Revenue Contribution
- Product Rank
- Product Lifecycle

---

### Seller KPIs

- Total Revenue
- Revenue Contribution
- Average Revenue per Order
- Seller Rank
- Seller Lifecycle

---

### Delivery KPIs

- Delivered Orders
- Average Delivery Days
- Delayed Orders
- Delayed Percentage

---

### Revenue KPIs

- Total Revenue
- Total Orders
- Total Items Sold
- Average Order Value

---

# Time-Series Analytics

Implemented analytical tables for

- Daily Revenue
- Monthly Revenue
- Yearly Revenue
- Month-over-Month Growth
- Quarter-over-Quarter Growth
- Year-over-Year Growth

---

# Business Insights

The project includes SQL queries answering business questions such as:

- Overall business performance
- Monthly revenue trends
- Top customers
- Top sellers
- Top products
- Delivery performance
- Revenue growth analysis
- Customer segmentation
- Product performance
- Seller performance

---

# SQL Concepts Used

- DDL
- DML
- Constraints
- Primary Keys
- Check Constraints
- Aggregate Functions
- CASE Expressions
- CTEs
- Window Functions
- LAG()
- DATE Functions
- GROUP BY
- HAVING
- JOINs
- ORDER BY
- Data Validation Queries

---

# Key Highlights

✔ Designed an analytical SQL data warehouse

✔ Built reusable KPI fact tables

✔ Created a reusable Date Dimension

✔ Implemented MoM, QoQ and YoY revenue analysis

✔ Performed customer, seller and product analytics

✔ Generated business reporting queries

---

# Repository Structure

```
01_database_setup
02_source_tables
03_data_loading
04_data_validation
05_fact_tables
06_dimension_tables
07_kpi_tables
08_time_analytics
09_business_insights
```

---

# Future Enhancements

- Power BI Dashboard
- Azure Data Factory Pipeline
- Azure Data Lake Integration
- Incremental ETL Pipeline
- Stored Procedures
- SQL Agent Scheduling

---

# Author

**Rahul K Ranjith**

Data Engineering Portfolio Project

Built using SQL Server and the Olist Brazilian E-Commerce Dataset.
