-- ===========================================================
-- Brazilian E-Commerce Analytics (Olist)
-- Database Setup
-- SQL Server
-- ===========================================================

USE master;
GO

IF DB_ID('kaggle_data') IS NOT NULL
BEGIN
    ALTER DATABASE kaggle_data SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE kaggle_data;
END
GO

CREATE DATABASE kaggle_data;
GO

USE kaggle_data;
GO
