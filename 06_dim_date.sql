-- ============================================================
-- Brazilian E-Commerce Analytics (Olist)
-- 06_dim_date.sql
-- Create and Populate Date Dimension
-- SQL Server
-- ============================================================

USE kaggle_data;
GO

---------------------------------------------------------------
-- Drop Existing Table
---------------------------------------------------------------

DROP TABLE IF EXISTS dim_date;
GO

---------------------------------------------------------------
-- Create Date Dimension
---------------------------------------------------------------

CREATE TABLE dim_date
(
    date_id INT PRIMARY KEY,
    full_date DATE NOT NULL,
    calendar_year INT,
    quarter_number INT,
    month_number INT,
    month_name VARCHAR(20),
    week_of_year INT,
    day_of_month INT,
    day_of_week INT,
    day_name VARCHAR(20),
    is_weekend BIT,
    is_month_end BIT,
    is_quarter_end BIT,
    is_year_end BIT
);
GO

---------------------------------------------------------------
-- Populate Date Dimension
---------------------------------------------------------------

DECLARE @StartDate DATE = '2016-01-01';
DECLARE @EndDate DATE = '2019-12-31';

WHILE @StartDate <= @EndDate
BEGIN

    INSERT INTO dim_date
    (
        date_id,
        full_date,
        calendar_year,
        quarter_number,
        month_number,
        month_name,
        week_of_year,
        day_of_month,
        day_of_week,
        day_name,
        is_weekend,
        is_month_end,
        is_quarter_end,
        is_year_end
    )

    VALUES
    (
        CONVERT(INT, CONVERT(VARCHAR(8), @StartDate, 112)),

        @StartDate,

        YEAR(@StartDate),

        DATEPART(QUARTER, @StartDate),

        MONTH(@StartDate),

        DATENAME(MONTH, @StartDate),

        DATEPART(WEEK, @StartDate),

        DAY(@StartDate),

        DATEPART(WEEKDAY, @StartDate),

        DATENAME(WEEKDAY, @StartDate),

        CASE
            WHEN DATENAME(WEEKDAY, @StartDate) IN ('Saturday', 'Sunday')
            THEN 1
            ELSE 0
        END,

        CASE
            WHEN @StartDate = EOMONTH(@StartDate)
            THEN 1
            ELSE 0
        END,

        CASE
            WHEN MONTH(DATEADD(DAY, 1, @StartDate)) IN (1,4,7,10)
                 AND DAY(DATEADD(DAY, 1, @StartDate)) = 1
            THEN 1
            ELSE 0
        END,

        CASE
            WHEN MONTH(@StartDate) = 12
                 AND DAY(@StartDate) = 31
            THEN 1
            ELSE 0
        END
    );

    SET @StartDate = DATEADD(DAY, 1, @StartDate);

END
GO

---------------------------------------------------------------
-- Validation
---------------------------------------------------------------

SELECT COUNT(*) AS total_dates
FROM dim_date;
GO

SELECT TOP (20) *
FROM dim_date
ORDER BY full_date;
GO

---------------------------------------------------------------
-- End of Script
---------------------------------------------------------------
