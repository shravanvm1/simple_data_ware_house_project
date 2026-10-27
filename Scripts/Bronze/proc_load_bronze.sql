/*
===============================================================================
Stored Procedure: Bronze Layer Data Loading
===============================================================================
Purpose:
    This stored procedure loads raw data from CSV source files into the
    Bronze Layer tables of the data warehouse.

Process:
    1. Uses SET NOCOUNT ON to suppress row-count messages.
    2. Records the start time of the overall ETL batch.
    3. Loads CRM source data into the following tables:
       - bronze.crm_cust_info
       - bronze.crm_product_details
       - bronze.crm_sales_details
    4. Loads ERP source data into the following tables:
       - bronze.erp_cust_az12
       - bronze.erp_loc_a101
       - bronze.erp_px_cat_g1v2
    5. Truncates each target table before loading to prevent duplicate
       records during repeated full-load executions.
    6. Uses BULK INSERT to import data from CSV files, skipping the header
       row and using a comma as the field delimiter.
    7. Records and displays the execution duration for each table load.
    8. Records and displays the total duration of the ETL batch.
    9. Uses TRY...CATCH for error handling. If an error occurs, the procedure
       displays the error message and error number, then rethrows the error
       using THROW.

Notes:
    - This procedure performs a full refresh of the Bronze tables.
    - Source file paths must be accessible to the SQL Server service account.
    - If a load fails, previously truncated or loaded tables may be left in
      a partially refreshed state because the procedure does not use a
      transaction to make the entire batch atomic.
    - Execution durations are measured in seconds.

===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @start_time DATETIME,@end_time DATETIME,@batch_start DATETIME,@batch_end DATETIME;
	BEGIN TRY
	SET @batch_start = GETDATE();
		print'===================================================================';
		PRINT'Loading the BRONZE LAYER'
		print'===================================================================';

		print'------------------------------------------------------------------------';
		print'loading CRM Tables'
		print'------------------------------------------------------------------------';

		SET @start_time = GETDATE();

		TRUNCATE TABLE bronze.crm_cust_info; -- or it will create duplicates of data
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\shrav\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)

		SET @end_time = GETDATE();
		print '>>>>> DURATION:' + CAST (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + '  seconds';
		print'>>>>.......................................................'

		
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_product_details; -- or it will create duplicates of data
		BULK INSERT bronze.crm_product_details
		FROM 'C:\Users\shrav\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_time = GETDATE();
		print '>>>>> DURATION:' + CAST (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + '  seconds';
		print'>>>>.......................................................'

		

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_sales_details; -- or it will create duplicates of data
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\shrav\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_time = GETDATE();
		print '>>>>> DURATION:' + CAST (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + '  seconds';
		print'>>>>.......................................................'

		
			print'------------------------------------------------------------------------';
			print'loading ERP Tables'
			print'--------------------------------------------------------------------------';

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_cust_az12; -- or it will create duplicates of data
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\shrav\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_time = GETDATE();
		print '>>>>> DURATION:' + CAST (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + '  seconds';
		print'>>>>.......................................................'


		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_loc_a101; -- or it will create duplicates of data
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\shrav\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_time = GETDATE();
		print '>>>>> DURATION:' + CAST (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + '  seconds';
		print'>>>>.......................................................'

		


		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_px_cat_g1v2; -- or it will create duplicates of data
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\shrav\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_time = GETDATE();
		print '>>>>> DURATION:' + CAST (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + '  seconds';
		print'>>>>.......................................................'

		
		SET @batch_end = GETDATE();
		print 'ETL PROCESS COMPLETED!';
		print '>>>>>TOTAL LOAD DURATION:' + CAST (DATEDIFF(second,@batch_start,@batch_end) AS NVARCHAR) + '  seconds';
		print'>>>>.......................................................'

	END TRY
	BEGIN CATCH
			print'------------------------------------------------------------------------';
			print'DATA not loaded due to error';
			print'ERROR message: ' + ERROR_MESSAGE();
			print'ERROR message: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
			print'------------------------------------------------------------------------';
	THROW;
	END CATCH;
	
END 
