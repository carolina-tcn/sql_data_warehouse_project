/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the 'silver' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking 'silver.crm_cust_info'
-- ====================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT * FROM silver.crm_cust_info;

SELECT cst_id, COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- First SELECT an example where we have duplicates to see the issue
SELECT * FROM silver.crm_cust_info WHERE cst_id = 29466;

-- We pick the most recent and highest value
SELECT * FROM (
SELECT *, 
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
FROM silver.crm_cust_info
)t
WHERE flag_last = 1;

-- Check for unwanted spaces in string values
-- Expectation: No Results
SELECT  cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

-- Data Standarization & Consistency
SELECT  DISTINCT cst_gndr
FROM silver.crm_cust_info;

SELECT  DISTINCT cst_marital_status
FROM silver.crm_cust_info;
