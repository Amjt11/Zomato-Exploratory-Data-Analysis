# Zomato-Exploratory-Data-Analysis

![](https://github.com/Amjt11/Zomato-Exploratory-Data-Analysis/blob/main/brand_logo.png)

---

## Project Overview
This repository contains a SQL-based data analysis project focused on key business metrics for Zomato, a food delivery company. The project involves exploratory data analysis (EDA) using Transact-SQL to answer 15 unique business questions related to customer behavior, restaurant performance, rider efficiency, and operational insights.

---

## Objective
The goal of this project is to:
1. **Customer Behavior and Insights**: Understanding customer order patterns, preferences and churn rates.
2. **Order and Sales Analysis**: Evaluating order volumes, peak times, and revenue generation.
3. **Restaurant Performance**: Analysis of restaurant revenue ranking, cancellation rate comparison and monthly growth ratio.
4. **Rider Efficiency and Performance**: Metrics on delivery time, ratings, monthly earning and efficiency.

---

### Topics Covered
The project explores various SQL topics, including:

 **Data Retrieval and Filtering**: SQL queries to retrieve and filter data.
- **Aggregations and Grouping**: Use of `COUNT()`, `SUM()`, and `AVG()` to aggregate data.
- **Joining Tables**: Combining data from multiple tables using `LEFT JOIN`.
- **Window Functions**: Utilization of `ROW_NUMBER()`, `DENSE_RANK()`, and `LAG()` to analyze ranked data.
- **Date and Time Functions**: Manipulating timestamps for business insights.
- **Conditional Logic**: Use of `CASE` statements for data segmentation.
- **Subqueries**: Nested queries to derive complex metrics.
- **Ranking and Ordering**: Applying various ranking techniques to categorize data based on performance.
- **Data Segmentation**: Use of conditional logic (`CASE STATEMENT`) for dividing data into meaningful categories.

---

## Entity Relationship Diagram

![](https://github.com/Amjt11/Zomato-Exploratory-Data-Analysis/blob/main/ERD.jpg)

---

## Project Structure
- **Database Setup**: Creation of the database and the required tables.
- **Data Import**: Inserting sample data into the tables.
- **Data Cleaning**: Handling null values and ensuring data integrity.
- **Business Problems**: Solving 15 specific business problems using T-SQL queries. 

---

**T-SQL Files**:
  - `table_creation.sql`: SQL script for creating the database tables and defining relationships.
  - `data_analysis.sql`: SQL queries for exploratory data analysis (EDA), including data extraction, manipulation, and insights generation.

---

## Data Cleaning and Null values

Before performing analysis, I ensured that the data was clean and free from null values where necessary.
```sql
SELECT
	COUNT(*)
FROM customers
WHERE customer_name IS NULL
	OR reg_date IS NULL;

SELECT
	COUNT(*)
FROM restaurants
WHERE restaurant_name IS NULL
	OR city IS NULL
	OR opening_hours IS NULL;

SELECT
	*
FROM orders
WHERE order_item IS NULL
	OR order_date IS NULL
	OR order_time IS NULL
	OR order_status IS NULL
	OR total_amount IS NULL;
```
---

## Business Problems and Solutions

### 1. Popular Time Slots during which the most orders are placed (based on 2-hour intervals)

```sql
SELECT Top 5
    FLOOR(DATEPART(HOUR, order_time) / 2) * 2 AS start_time,
    FLOOR(DATEPART(HOUR, order_time) / 2) * 2 + 2 AS end_time,
    COUNT(*) AS total_orders
FROM orders
GROUP BY FLOOR(DATEPART(HOUR, order_time) / 2) * 2,
         FLOOR(DATEPART(HOUR, order_time) / 2) * 2 + 2
ORDER BY total_orders DESC
;
```
### 2. Order Value Analysis (AOV of customer with more than 750 orders)


### 3. Orders Without Delivery(Return each restuarant name, city and number of not delivered orders)


### 4. Top 3 restaurants in each city by their total revenue, including their name and total revenue.


### 5. Most popular Dish in each city.


### 6. Customers who haven’t placed an order in 2024 but did in 2023.


### 7. Calculate and compare the order cancellation rate for each restaurant between the current year and the previous year.


### 8. Monthly Restaurant Growth Ratio based on the total number of delivered orders since its joining and comparing monthly sales trend. 


### 9. Segment customers into 'Gold' or 'Silver' groups based on their total spending(comparing AOV) and find total revenue and total orders in each segment.


### 10. Rider's monthly earnings, assuming they earn 8% of the order amount


### 11. Based on delivery time give 5-star (if <15 mins), 4-star (if 15-20 mins),and 3-star (if >20 mins) ratings and count number of every stars for each rider.


### 12.  Order frequency per day of the week and identifiction of the peak day for each restaurant.


### 13. Rider efficiency evaluation by determining average delivery times and identifying those with the lowest and highest averages.


### 14. Tracking the popularity of specific order items over time and identify seasonal demand spikes.


### 15. The rank of each city based on the total revenue for last year.
















