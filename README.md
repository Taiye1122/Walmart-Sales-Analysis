---

# Walmart Sales Analysis

## 📊 About the Project

This project explores Walmart sales data to gain insights into top-performing branches and products, sales trends, and customer behavior. The objective is to identify how sales strategies can be improved and optimized for better performance.

#### Dataset Source: [Kaggle Walmart Sales Forecasting Competition](https://www.kaggle.com/competitions/walmart-sales-forecasting)

---

## 🎯 Project Goals

* Understand sales performance across different Walmart branches.
* Analyze product line performance to identify high and low performers.
* Uncover customer behavior trends and segment profitability.
* Provide actionable recommendations to optimize sales strategies.

---

## 📂 Dataset Overview

* **Branches**: Mandalay, Yangon, Naypyitaw
* **Records**: 1,000 rows, 17 columns
* **Key Fields**: Invoice ID, Branch, City, Customer Type, Product Line, Unit Price, Quantity, Date, Time, COGS, Total, VAT, Gross Income, Rating

---

## 🔍 Analysis Performed

### 🏣 Product Analysis

* Identified best and worst-performing product lines.
* Categorized product lines based on performance (Good/Bad).

### 💰 Sales Analysis

* Tracked sales trends over time.
* Measured monthly revenue and cost of goods sold (COGS).
* Analyzed revenue contribution by customer type.

### 👥 Customer Analysis

* Segmented customers by gender, time of purchase, and rating behavior.
* Identified profitable customer types and peak engagement times.

---

## 🧰 Approach

### 1. **Data Wrangling**

* Cleaned and inspected data for missing/null values.

### 2. **Database Setup**

```sql
CREATE TABLE Sales (
  invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
  branch VARCHAR(5) NOT NULL,
  city VARCHAR(30) NOT NULL,
  customer_type VARCHAR(30) NOT NULL,
  gender VARCHAR(30) NOT NULL,
  product_line VARCHAR(50) NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  quantity INT NOT NULL,
  VAT DECIMAL(10,2) NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  date DATE NOT NULL,
  time TIME NOT NULL,
  payment VARCHAR(30) NOT NULL,
  cogs DECIMAL(10,2) NOT NULL,
  gross_margin_percentage DECIMAL(10,9) NOT NULL,
  gross_income DECIMAL(10,2) NOT NULL,
  rating DECIMAL(2,1) NOT NULL
);
```

### 3. **Feature Engineering**

```sql
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);
UPDATE sales SET time_of_day = (
  CASE
    WHEN time BETWEEN '00:00:00' AND '11:59:00' THEN 'Morning'
    WHEN time BETWEEN '12:00:00' AND '16:00:00' THEN 'Afternoon'
    WHEN time BETWEEN '16:01:00' AND '19:00:00' THEN 'Evening'
    ELSE 'Night'
  END
);

ALTER TABLE sales ADD COLUMN day_name VARCHAR(15);
UPDATE sales SET day_name = DAYNAME(date);

ALTER TABLE sales ADD COLUMN month_name VARCHAR(15);
UPDATE sales SET month_name = MONTHNAME(date);
```

### 4. **Exploratory Data Analysis (EDA)**

Used SQL to explore and analyze the data. Sample business questions answered:

---

## 📊 Sample Business Questions Answered

### Unique Cities in Dataset

```sql
SELECT DISTINCT city FROM sales;
```

### Most Selling Product Line

```sql
SELECT product_line, COUNT(*) AS qty
FROM sales
GROUP BY product_line
ORDER BY qty DESC;
```

### Total Revenue by Month

```sql
SELECT month_name AS month, SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;
```

### Time of Day with Most Ratings

```sql
SELECT time_of_day, COUNT(rating) AS rating
FROM sales
GROUP BY time_of_day
ORDER BY rating DESC;
```

---

## 📊 Recommendations

### ✅ Optimize High-Performing Product Lines

Focus marketing and stock allocation efforts on top-selling product lines. Consider bundling them with underperforming ones to boost their visibility and sales.

### ✅ Refine Sales Strategy by Time of Day

Since sales and ratings vary by time of day, schedule promotions and staff allocation accordingly — for instance, increasing staffing or offering discounts during peak hours.

### ✅ Leverage Customer Type Insights

If one customer type brings in more revenue, design loyalty programs, targeted ads, or upsell strategies tailored to them.

### ✅ Enhance Month-Based Campaigns

Identify the months with high revenue and replicate successful strategies during low-performing months to balance out seasonal dips.

### ✅ Product Line Performance Monitoring

Continue monitoring product line performance and flag lines consistently underperforming for review. Consider revising pricing, packaging, or positioning.

---

## 💾 For Full SQL Scripts

Check the [`SQL_queries`](Walmart.sql)  for complete queries used.




