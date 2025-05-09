create database Walmart_sales;

Create table Sales (invoice_id varchar(30) not null primary key,
branch varchar(5) not null,
city varchar(30) not null,
customer_type varchar(30) not null,
Gender varchar(30) not null,
product_line varchar(50) not null,
unit_price decimal(10,2) not null,
quantity int not null,
VAT decimal(10,2) not null,
total decimal(10,2) not null,
date date not null,
time time not null,
payment varchar(30) not null,
cogs decimal (10,2) not null,
gross_margin_percentage decimal(10,9) not null,
gross_income decimal (10,2) not null,
rating decimal(2,1) not null);

alter table sales
change payment payment_method varchar(30) not null;

select * 
from sales;

-- Adding a time of the day column
select `time` ,
case
   when `time` between '00:00:00' and '11:59:00' then 'Morning'
   when `time` between '12:00:00' and '16:00:00' then 'Afternoon'
   when `time` between '16:01:00' and '19:00:00' then 'Evening'
   else 'Night'
   end as time_of_day
   from Sales;
 
 alter table sales
 add column time_of_day varchar(20);
 
 update sales
 set time_of_day = (case
   when `time` between '00:00:00' and '11:59:00' then 'Morning'
   when `time` between '12:00:00' and '16:00:00' then 'Afternoon'
   when `time` between '16:01:00' and '19:00:00' then 'Evening'
   else 'Night'
   end );
   
-- Adding a day name column
select `date`, dayname(`date`) as day_name
from sales;

alter table sales add column day_name varchar(15);

update sales
set day_name = dayname(`date`);

-- Adding a month name column
select `date`, monthname(`date`) as month_name
from sales;

alter table sales add column month_name varchar(15);

update sales
set month_name = monthname(`date`);

-- Generic --------------------------------------------------------------------------------------------------------------------------------------------
-- How many unique cities does the data have?
select distinct city
from sales;

-- In which city is each branch?
select distinct city, branch
from sales;

-- Product -------------------------------------------------------------------------------------------------------------------------------------------
-- How many unique product lines does the data have?
Select count(distinct product_line)
from sales;

select distinct product_line
from sales;

-- What is the most common payment method?
select payment_method, count(payment_method) as Count
from sales
group by payment_method
order by Count desc;

-- What is the most selling product line?
select product_line, sum(quantity) as sum_of_qty
from sales
group by product_line
order by sum_of_qty desc;

select product_line, count(product_line) as qty
from sales
group by product_line
order by qty desc;

-- What is the total revenue by month?
select month_name as month, sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;

-- What month had the largest COGS?
select month_name as month, sum(cogs) as COGS
from sales
group by month_name
order by COGS desc
limit 1;

-- What product line had the largest revenue?
select product_line, sum(total) total_revenue
from sales
group by product_line
order by total_revenue desc
limit 1;

-- What is the city with the largest revenue?
select city, sum(total) total_revenue
from sales
group by city
order by total_revenue desc
limit 1;

-- What product line had the largest VAT?
select product_line, avg(VAT) VAT
from sales
group by product_line
order by VAT desc
limit 1;


-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
select avg(total) from sales;

Select product_line, total,
case
when total > (select avg(total) from sales) then "Good"
else "bad"
end as remark
from sales
group by product_line, total;

-- Which branch sold more products than average product sold?
select branch, sum(quantity) as qty
from sales
group by branch
having qty > (select avg(quantity) from sales);

-- What is the most common product line by gender?
select gender, product_line
from (SELECT gender, product_line, COUNT(product_line) AS count,
        ROW_NUMBER() OVER (PARTITION BY gender ORDER BY COUNT(product_line) DESC) AS rn
    FROM sales
    GROUP BY gender, product_line) as ranked
where rn = 1;

-- What is the average rating of each product line?
select product_line, round(avg(rating),2) as avg_rating
from sales
group by product_line
order by avg_rating desc;

-- Sales ---------------------------------------------------------------------------------------------------------------------------------------------
-- Number of sales made in each time of the day per weekday
select time_of_day, count(invoice_id) as No_of_Sales
from sales
group by time_of_day
order by No_of_Sales desc;

-- Which of the customer types brings the most revenue?
select customer_type, sum(total) as revenue
from sales
group by customer_type
order by revenue desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
select city, avg(VAT) AS VAT
from sales
group by city
order by VAT desc;

-- Which customer type pays the most in VAT?
select customer_type, avg(VAT) as VAT
from sales
group by customer_type
order by VAT desc;

-- Customer ------------------------------------------------------------------------------------------------------------------------------------------
-- How many unique customer types does the data have?
select customer_type, count(customer_type) as count
from sales
group by customer_type
order by count desc;

-- How many unique payment methods does the data have?
select payment_method, count(payment_method) as count
from sales
group by payment_method
order by count desc;

-- What is the most common customer type?
select customer_type, count(customer_type) as count
from sales
group by customer_type
order by count desc
limit 1;

-- Which customer type buys the most?
select customer_type, sum(quantity) as Quantity
from sales
group by customer_type
order by Quantity desc;

-- What is the gender of most of the customers?
select gender, count(gender) as count
from sales
group by gender
order by count desc;

-- What is the gender distribution per branch?
select branch, gender
from (SELECT branch, gender, COUNT(gender) AS count,
        ROW_NUMBER() OVER (PARTITION BY branch ORDER BY COUNT(gender) DESC) AS rn
    FROM sales
    GROUP BY branch, gender) as ranked
where rn = 1;

-- Which time of the day do customers give most ratings?
select time_of_day, count(rating) as rating
from sales
group by time_of_day
order by rating desc;

-- Which time of the day do customers give most ratings per branch?
select branch, time_of_day
from (SELECT branch, time_of_day, COUNT(rating) AS count,
        ROW_NUMBER() OVER (PARTITION BY branch ORDER BY COUNT(rating) DESC) AS rn
    FROM sales
    GROUP BY branch, time_of_day) as ranked
where rn = 1;

-- Which day of the week has the best avg ratings?
select day_name, avg(rating) as rating
from sales
group by day_name
order by rating desc;

-- Which day of the week has the best average ratings per branch?
select branch, day_name
from (SELECT branch, day_name, avg(rating) AS rating,
        ROW_NUMBER() OVER (PARTITION BY branch ORDER BY avg(rating) DESC) AS rn
    FROM sales
    GROUP BY branch, day_name) as ranked
where rn = 1;


