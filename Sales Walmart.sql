-- CREATE NEW DATABASE
CREATE database IF NOT EXISTS SalesDataWalmart;


-- CREATE NEW TABLE
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT,
    gross_income DECIMAL(12, 4),
    rating FLOAT
);


-- Feature Engineer 
-- time_of_day
SELECT 
	time,
    (CASE 
		WHEN time between "00:00:00" and "12:00:00" then 'Morning'
        WHEN time between "12:00:01" and "16:00:00" then 'Afternoon'
        ELSE 'Evening' 
	END) as time_of_day
From sales; 
-- CREATE A NEW COLUMN 
ALTER TABLE sales ADD COLUMN time_of_date varchar (20);

-- CHANGE A NAME COLUMN
ALTER TABLE sales RENAME COLUMN time_of_date TO time_of_day;

-- INSERT DATA INTO A NEW COLUMN 
UPDATE sales 
SET time_of_day = (
    CASE 
		WHEN time between "00:00:00" and "12:00:00" then 'Morning'
        WHEN time between "12:00:01" and "16:00:00" then 'Afternoon'
        ELSE 'Evening' 
	END
    );
    
-- day_name
SELECT 
	date,
    date_format(date,'%a') as day_name,
    date_format(date,'%b') as month_name
from sales;

-- CREATE NEW COLUMN DAY_NAME & MONTH_NAME
ALTER TABLE sales 
	ADD COLUMN 	day_name varchar(20),
    ADD COLUMN month_name varchar(20);
    
-- INSERT DATA TO NEW COLUMNS
UPDATE sales
SET 
	day_name = date_format(date,'%a'),
    month_name = date_format(date,'%b');
-- -------------------------------------------------------------------------------------------------------------------------------------------
-- BUSINESS QUESTIONS TO ANSWER
-- Generic Question
-- How many unique cities does the data have?
SELECT 
	count(distinct city)
FROM sales; 
-- In which city is each branch?
SELECT 
	distinct branch,
    city
FROM sales;

-- PRODUCT
-- How many unique product lines does the data have?
SELECT 
	distinct product_line
from sales;

-- What is the most common payment method? 
SELECT 
	payment,
	COUNT(payment) as nb_payment
FROM sales
GROUP BY payment
ORDER BY nb_payment desc
LIMIT 1;

-- What is the most selling product line?
SELECT
	product_line,
    count(invoice_id) as nb_sold
FROM sales
GROUP BY product_line
ORDER BY nb_sold desc
LIMIT 1;

-- What is the total revenue by month?
SELECT
	month_name,
    sum(total) as total_revenue
FROM sales
GROUP BY month_name;

-- What month had the largest COGS?
SELECT 
	month_name,
	sum(cogs) total_cogs
FROM sales
group by month_name
order by total_cogs desc
limit 1;

-- What product line had the largest revenue?
SELECT
	product_line,
    sum(total) as total_revenue
FROM sales
GROUP BY product_line
order by total_revenue desc
limit 1;

-- What is the city with the largest revenue?
SELECT
	city,
    sum(total) as total_revenue
FROM sales
GROUP BY city
order by total_revenue desc
limit 1;
-- What product line had the largest VAT?
SELECT
	product_line,
    sum(tax_pct) as total_VAT
FROM sales
GROUP BY product_line
order by total_VAT desc
limit 1;
-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
-- Average_sales
SELECT 
	product_line
    total,
	CASE 
		WHEN total > avg(total) over (partition by product_line) THEN 'Good' ELSE 'Bad'
	END as 'Remark'
FROM sales
GROUP BY product_line, total;

-- Which branch sold more products than average product sold?
SELECT
	branch,
    sum(quantity) as total_qty
FROM sales
GROUP BY branch
HAVING sum(quantity) > (SELECT avg(quantity) FROM sales);

-- What is the most common product line by gender?
SELECT
	branch,
    count(gender) as nb_gender
from sales
group by branch
order by nb_gender desc
Limit 1;

-- What is the average rating of each product line?
SELECT
		product_line,
        avg(rating) as average_rating
FROM sales
GROUP BY product_line
ORDER BY average_rating;

-- ------------------------------------SALES --------------------------------
-- Number of sales made in each time of the day per weekday
SELECT
	day_name,
    time_of_day,
    round(sum(total),2) as nb_sales
FROM sales
WHERE day_name NOT IN ('Sat','Sun')
GROUP BY time_of_day, day_name
order by day_name;

-- Which of the customer types brings the most revenue?
SELECT 
	customer_type,
    sum(total) as total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT 
	city,
    sum(tax_pct) as total_VAT
FROM sales
GROUP BY city
ORDER BY total_VAT desc;
-- Which customer type pays the most in VAT?
SELECT 
	customer_type,
    sum(tax_pct) as total_customer_tax
FROM sales
GROUP BY customer_type
ORDER BY total_customer_tax desc;
-- -----------------------------------Customer-------------------------------
-- How many unique customer types does the data have?
SELECT 
	DISTINCT customer_type
FROM sales;
-- How many unique payment methods does the data have?
SELECT
	DISTINCT payment
FROM sales;
-- What is the most common customer type?
SELECT 
	customer_type,
    count(invoice_id) as nb_trans
FROM sales
group by customer_type
order by nb_trans desc
limit 1;
-- Which customer type buys the most?
SELECT 
	customer_type,
	sum(total)
FROM sales
GROUP BY customer_type
order by sum(total) desc
LIMIT 1;
-- What is the gender of most of the customers?
SELECT
	gender,
    count(*)
FROM sales
GROUP BY gender
ORDER BY count(*) desc 
LIMIT 1;
-- What is the gender distribution per branch?
SELECT
	branch,
    gender,
    count(gender) as nb_distri
FROM sales
GROUP BY branch, gender
ORDER BY branch;
-- Which time of the day do customers give most ratings?
SELECT
	time_of_day,
    count(*)
FROM sales
GROUP BY time_of_day
ORDER BY count(*) desc
LIMIT 1;
-- Which time of the day do customers give most ratings per branch?
SELECT
	branch,
    time_of_day,
    count(*)
FROM sales
GROUP BY branch, time_of_day
ORDER BY branch;
-- Which day fo the week has the best avg ratings?
SELECT 
	time_of_day,
    avg(rating) as avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating desc
LIMIT 1;
-- Which day of the week has the best average ratings per branch?
SELECT 
	branch,
    day_name,
    avg(rating) as avg_rating
FROM sales
GROUP BY branch, day_name
ORDER BY branch, avg_rating desc;