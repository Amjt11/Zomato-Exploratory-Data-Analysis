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

![](https://github.com/Amjt11/Zomato-Exploratory-Data-Analysis/blob/main/Output%20screenshots/1.jpg)

The data highlights the peak ordering hours between 14:00 and 16:00, with 1,188 orders, followed by 18:00 and 20:00 (1,136 orders) and 22:00 and 24:00 (1,123 orders). These time slots indicate high customer engagement during **late afternoons and evenings**, suggesting opportunities to optimize staffing, launch targeted promotions, and boost revenue during these high-demand slots.

### 2. Order Value Analysis (AOV of customer with more than 750 orders)

![](https://github.com/Amjt11/Zomato-Exploratory-Data-Analysis/blob/main/Output%20screenshots/2.jpg)

The data reveals **Sneha Desai** as the top customer with **807** orders and a strong **₹333.58 AOV**. Targeting high-value customers like her with **exclusive offers** can boost **loyalty** and **repeat sales**.

### 3. Orders Without Delivery(Return each restuarant name, city and number of not delivered orders)

![](https://github.com/Amjt11/Zomato-Exploratory-Data-Analysis/blob/main/Output%20screenshots/3.jpg)

The data highlights **Mumbai** as the city with the highest undelivered orders, led by Gajalee (32 orders) and Mahesh Lunch Home (31 orders). This signals potential **operational bottlenecks** in Mumbai's delivery network. **Targeted process improvements** at top-affected restaurants could significantly **reduce non-deliveries** and enhance customer satisfaction.

### 4. Top 3 restaurants in each city by their total revenue, including their name and total revenue.

![](https://github.com/Amjt11/Zomato-Exploratory-Data-Analysis/blob/main/Output%20screenshots/4.jpg)

The data reveals top-performing restaurants by city, with **Bademiya (Mumbai)** leading overall with **₹157,583** in revenue. **Mumbai** dominates the revenue charts, followed by strong performers like **The Oberoi (Bengaluru)** and **Annalakshmi (Chennai)**. Focusing promotional efforts on these **high-revenue hotspots** and replicating their strategies in lower-performing cities could drive **revenue growth** across regions.

### 5. Most popular Dish in each city.

![](https://github.com/Amjt11/Zomato-Exploratory-Data-Analysis/blob/main/Output%20screenshots/5.jpg)

### 6. Customers who haven’t placed an order in 2024 but did in 2023.

![](https://github.com/Amjt11/Zomato-Exploratory-Data-Analysis/blob/main/Output%20screenshots/6.jpg)

### 7. Calculate and compare the order cancellation rate for each restaurant between the current year and the previous year.

![](https://github.com/Amjt11/Zomato-Exploratory-Data-Analysis/blob/main/Output%20screenshots/7.jpg)

### 8. Monthly Restaurant Growth Ratio based on the total number of delivered orders since its joining and comparing monthly sales trend. 

![](https://github.com/Amjt11/Zomato-Exploratory-Data-Analysis/blob/main/Output%20screenshots/8.jpg)

### 9. Segment customers into 'Gold' or 'Silver' groups based on their total spending(comparing AOV) and find total revenue and total orders in each segment.

![](https://github.com/Amjt11/Zomato-Exploratory-Data-Analysis/blob/main/Output%20screenshots/9.jpg)

### 10. Rider's monthly earnings, assuming they earn 8% of the order amount

![](https://github.com/Amjt11/Zomato-Exploratory-Data-Analysis/blob/main/Output%20screenshots/10.jpg)

### 11. Based on delivery time give 5-star (if <15 mins), 4-star (if 15-20 mins),and 3-star (if >20 mins) ratings and count number of every stars for each rider.

![](https://github.com/Amjt11/Zomato-Exploratory-Data-Analysis/blob/main/Output%20screenshots/11.jpg)

### 12.  Order frequency per day of the week and identifiction of the peak day for each restaurant.

![](https://github.com/Amjt11/Zomato-Exploratory-Data-Analysis/blob/main/Output%20screenshots/12.jpg)

### 13. Rider efficiency evaluation by determining average delivery times and identifying those with the lowest and highest averages.

![](https://github.com/Amjt11/Zomato-Exploratory-Data-Analysis/blob/main/Output%20screenshots/13a.jpg)


![](https://github.com/Amjt11/Zomato-Exploratory-Data-Analysis/blob/main/Output%20screenshots/13b.jpg)

### 14. Tracking the popularity of specific order items over time and identify seasonal demand spikes.

![](https://github.com/Amjt11/Zomato-Exploratory-Data-Analysis/blob/main/Output%20screenshots/14.jpg)

### 15. The rank of each city based on the total revenue for last year.

![](https://github.com/Amjt11/Zomato-Exploratory-Data-Analysis/blob/main/Output%20screenshots/15.jpg)















