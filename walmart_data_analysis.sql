
-- Create database
CREATE DATABASE IF NOT EXISTS walmartSales;

-- Create table with each column having "NOT NULL" Constraint .Hence null values are filtered out.
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

SELECT * 
FROM sales; 

-- --------- Data Cleaning -----------------
-- 1. Filter NULL VALUES from CSV file by using NOT NULL constraint with each column while creating the sales table.
-- 2. The data in the date column is not appropricate. Data is "2019-03-13 00:00:00" format.
-- To clean this column we use the below querries.
-- To remove the time portion (00:00:00) from the date column we use DATE()
SELECT DATE(`date`) AS date_without_time 
FROM sales;
 
SELECT date, DATE(date) as date_without_time
FROM sales ; 

UPDATE sales 
SET day_without_time = LEFT(DATE(`date`),10) 
where day_without_time IS NULL; 

ALTER TABLE sales DROP COLUMN date;
ALTER TABLE sales CHANGE day_without_time date VARCHAR(20);
SELECT * FROM sales;

-- ---------- Feature Engineering -----------------

-- 1. Add a new column named 'time_of_day' to give insights of sales during morning ,afternoon,evening.
-- This will help to answer the question in which part of the day sales are highest.
SELECT time  
FROM sales;

SELECT 
     time,
	  (CASE  
			WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"  -- `time` refers to column,back tick used to specify it.
			WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
			ELSE "Evening"
	  END ) AS time_of_day 
FROM sales;   

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);  

UPDATE sales 
SET time_of_day = (
             CASE 
             WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "MORNING"
			 WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "AFTERNOON"
			 ELSE "EVENING"
	    END
);  

-- 2. Add a new column named 'day_name' that contains extracted days of week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri). 
-- This will help answer the question on which week of the day each branch is busiest.
-- Add day_name column,First display day name
SELECT date, DAYNAME(date) 
FROM sales ; 

-- to get abbrevated week date use LEFT()
SELECT date,LEFT(DAYNAME(date), 3) AS day_name FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10); 

UPDATE sales 
SET day_name = LEFT(DAYNAME(date),3) 
where day_name IS NULL;  

-- 3.Add a new column named `month_name` that contains the extracted months of the year on which the given transaction took place 
-- (Jan, Feb,Mar).Help determine which month of the year has the most sales and profit.
SELECT date,LEFT(MONTHNAME(date),3) AS month_name FROM sales;
ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);
UPDATE sales 
SET month_name = LEFT(MONTHNAME(date),3) 
WHERE  month_name IS NULL;

-- ---------- Data Analysis -----------------

-- 1. List cities with respective branches 
SELECT DISTINCT city,branch
FROM sales; 

-- 2. What is the most common payment method?
SELECT payment, COUNT(*) AS count_of_payment_methods
FROM sales
GROUP BY payment 
ORDER BY count_of_payment_methods DESC LIMIT 1; 

-- 3. What is the most selling product category?
SELECT  product_line,
	SUM(quantity) as no_of_products_sold
FROM sales
GROUP BY product_line
ORDER BY no_of_products_sold DESC LIMIT 1; 

-- 4. What is the total revenue by month?
SELECT month_name,SUM(total) AS total_revenue 
From sales 
GROUP BY month_name
ORDER BY total_revenue DESC;  

-- 5. Fetch each product line and add a column to those product line showing "Good" or "Bad". 
-- 'Good' if its greater than average sales otherwise 'bad'.
SELECT AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;

-- 6 Which branch sold more products than average product sold? 
SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales); 

-- 7 Number of sales made in each time of the day per weekday 
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;
-- Evenings experience most sales, the stores are filled during the evening hours.

-- 8. Which day fo the week has the best avg ratings?
SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC;
