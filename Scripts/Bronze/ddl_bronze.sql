/*
===============================================================================
Script Purpose:
    This script creates the Bronze Layer tables for the SQL Data Warehouse
    project. These tables are designed to store raw data ingested from CRM
    and ERP source systems before further cleaning and transformation.

Tables Created:
    CRM Tables:
        - Bronze.crm_cust_info
        - Bronze.crm_sales_details
        - Bronze.crm_product_details

    ERP Tables:
        - Bronze.erp_loc_a101
        - Bronze.erp_cust_az12
        - Bronze.erp_px_cat_g1v2

Usage Notes:
    - Run this script before executing the Bronze loading stored procedure.
    - The tables are created with column definitions corresponding to the
      source datasets.
    - Data cleaning, standardization, and transformation will be handled
      in subsequent layers of the Medallion Architecture.

WARNING:
    Running this script again without dropping or otherwise handling existing
    tables will result in errors because the tables already exist.
===============================================================================
*/




CREATE TABLE Bronze.crm_cust_info (
cst_id INT,
cst_key NVARCHAR(50),
cst_firstname NVARCHAR(50),
cst_lastname NVARCHAR(50),
cst_marital_status Nvarchar(50),
cst_gndr Nvarchar(50),
cst_create_date DATE);

CREATE TABLE Bronze.crm_sales_details(
sls_ord_num Nvarchar(50) ,
sls_prd_key Nvarchar(50),
sls_cust_id INT,
sls_order_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT
);

CREATE TABLE Bronze.crm_product_details(
prd_id INT,
prd_key Nvarchar(50),
prd_nm Nvarchar(50),
prd_cost INT,
prd_line Nvarchar(50),
prd_start_dt DATETIME,
prd_end_dt DATETIME);


CREATE TABLE Bronze.erp_loc_a101 (
Cid Nvarchar(50),
Cntry Nvarchar(50)
);

CREATE TABLE Bronze.erp_cust_az12(
Cid NVARCHAR(50),
bdgate DATE,
gen NVARCHAR(50)
);

CREATE TABLE Bronze.erp_px_cat_g1v2(
id NVARCHAR(50),
cat NVARCHAR(50),
subcat NVARCHAR(50),
maintenance NVARCHAR(50)
);
