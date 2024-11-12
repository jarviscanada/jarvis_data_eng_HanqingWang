-- Show table schema 
\d+ retail;

-- Show first 10 rows
SELECT * FROM retail limit 10;

-- Check # of records
SELECT COUNT(*) FROM retail;

-- number of clients (e.g. unique client ID)
SELECT COUNT(DISTINCT customer_id) AS unique_client_count
FROM retail;

-- invoice date range (e.g. max/min dates)
SELECT MIN(invoice_date) AS earliest_invoice_date, MAX(invoice_date) AS latest_invoice_date
FROM retail;

-- number of SKU/merchants (e.g. unique stock code)
SELECT COUNT(DISTINCT stock_code) AS SKU
FROM retail;

-- Calculate average invoice amount excluding invoices with a negative amount (e.g. canceled orders have negative amount)
--     - an invoice consists of one or more items where each item is a row in the df
--     - hint: you need to use GROUP BY and HAVING
SELECT 
    AVG(total_invoice_amount) AS average_invoice_amount
FROM (
    SELECT 
        invoice_no,
        SUM(quantity * unit_price) AS total_invoice_amount
    FROM 
        retail
    GROUP BY 
        invoice_no
    HAVING 
        SUM(quantity * unit_price) > 0
) AS subquery;

--  Calculate total revenue (e.g. sum of unit_price * quantity)
SELECT SUM(unit_price * quantity) AS total_revenue
FROM retail;

-- Calculate total revenue by YYYYMM 
SELECT 
    TO_CHAR(invoice_date, 'YYYYMM') AS year_month,
    SUM(unit_price * quantity) AS total_revenue
FROM 
    retail
GROUP BY 
    TO_CHAR(invoice_date, 'YYYYMM')
ORDER BY 
    year_month;
