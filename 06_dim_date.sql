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
    day_number INT,
    day_name VARCHAR(15),
    week_number INT,
    month_number INT,
    month_name VARCHAR(15),
    quarter_number INT,
    calendar_year INT,
    is_weekend BIT
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
        day_number,
        day_name,
        week_number,
        month_number,
        month_name,
        quarter_number,
        calendar_year,
        is_weekend
    )

    VALUES
    (
        CONVERT(INT, CONVERT(VARCHAR(8), @StartDate, 112)),
        @StartDate,
        DAY(@StartDate),
        DATENAME(WEEKDAY, @StartDate),
        DATEPART(WEEK, @StartDate),
        MONTH(@StartDate),
        DATENAME(MONTH, @StartDate),
        DATEPART(QUARTER, @StartDate),
        YEAR(@StartDate),

        CASE
            WHEN DATENAME(WEEKDAY, @StartDate) IN ('Saturday','Sunday')
            THEN 1
            ELSE 0
        END
    );

    SET @StartDate = DATEADD(DAY,1,@StartDate);

END
GO

---------------------------------------------------------------
-- Validation
---------------------------------------------------------------

SELECT COUNT(*) AS total_dates
FROM dim_date;
GO

SELECT TOP 10 *
FROM dim_date;
GO

---------------------------------------------------------------
-- End of Script
---------------------------------------------------------------
