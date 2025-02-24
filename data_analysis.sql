
/* 1. Popular Time Slots
	  Identify 5 time slots during which the most orders are placed.
	  based on 2-hour intervals.*/

SELECT Top 5
    FLOOR(DATEPART(HOUR, order_time) / 2) * 2 AS start_time,
    FLOOR(DATEPART(HOUR, order_time) / 2) * 2 + 2 AS end_time,
    COUNT(*) AS total_orders
FROM orders
GROUP BY FLOOR(DATEPART(HOUR, order_time) / 2) * 2,
         FLOOR(DATEPART(HOUR, order_time) / 2) * 2 + 2
ORDER BY total_orders DESC
;

/* 2. Order Value Analysis (customer_name and aov)
      Find the average order value(aov) per customer who has placed
	  more than 750 orders.*/

SELECT
    c.customer_name,
    COUNT(o.order_id) AS orders,
    ROUND(AVG(o.total_amount), 2) AS aov
FROM orders AS o
LEFT JOIN customers AS c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_name
HAVING COUNT(o.order_id) >= 750;


/* 3. Orders Without Delivery
	  Write a query to find orders that were placed but not delivered. 
	  Return each restuarant name, city and number of not delivered
	  orders */

SELECT 
	r.restaurant_name,
	r.city,
	COUNT(d.delivery_status) AS not_delivered
FROM orders AS o
LEFT JOIN deliveries AS d
	ON o.order_id = d.order_id
LEFT JOIN restaurants AS r
	ON o.restaurant_id = r.restaurant_id
WHERE d.delivery_status = 'Not Delivered'
GROUP BY r.restaurant_name,
	     r.city
ORDER BY not_delivered DESC;


/* 4. Restaurant Revenue Ranking
	  Top 3 restaurants in each city by their total revenue   */

WITH RankTable AS (
    SELECT
        r.restaurant_name,
        r.city,
        SUM(o.total_amount) AS total_revenue,
        DENSE_RANK() OVER(PARTITION BY r.city ORDER BY SUM(o.total_amount) DESC) AS rank
    FROM orders AS o
    LEFT JOIN restaurants AS r
    ON o.restaurant_id = r.restaurant_id
    GROUP BY r.restaurant_name, r.city
)
SELECT *
FROM RankTable
WHERE rank <= 3
ORDER BY city DESC;


/* 5. Most Popular Dish by City
      Identifying the most popular dish in each city based on the number
	  of orders.*/

SELECT * 
FROM (
    SELECT
        r.city,
        o.order_item,
        COUNT(o.order_item) AS total,
        DENSE_RANK() OVER(PARTITION BY r.city ORDER BY COUNT(o.order_item) DESC) AS rank
    FROM orders AS o
    LEFT JOIN restaurants AS r
        ON o.restaurant_id = r.restaurant_id
    GROUP BY r.city, o.order_item
) AS sub_query
WHERE rank = 1
ORDER BY total DESC;


/* 6. Customer Churn: 
      Find customers who haven’t placed an order in 2024 but did in 2023.
	  - Find customers that placed an order in 2023
	  - Find "               -               " 2024
	  - In 2023 NOT IN 2024                                            */

SELECT DISTINCT o.customer_id,
c.customer_name
FROM orders AS o
JOIN customers AS c ON o.customer_id=c.customer_id
WHERE YEAR(o.order_date) = 2023
	  AND o.customer_id NOT IN (SELECT DISTINCT customer_id FROM orders
							  WHERE YEAR(order_date) = 2024)
ORDER BY o.customer_id;



/* 7. Cancellation Rate Comparison
      Calculate and compare the order cancellation rate for each restaurant between 
	  the current year and the previous year.
	    - Calc cancel ratio by year 
		- Join 2023 & 2024                                                      */

WITH cancel_ratio_2024 AS (
    SELECT
        r.restaurant_id,
        r.restaurant_name,
        ROUND(CAST(COUNT(CASE WHEN o.order_status = 'Not Fulfilled' THEN 1 END) AS DECIMAL(10,2)) 
              / CAST(COUNT(o.order_id) AS DECIMAL(10,2)) * 100, 2) AS cancellation
    FROM orders AS o
    JOIN restaurants AS r
        ON o.restaurant_id = r.restaurant_id
    WHERE YEAR(o.order_date) = 2024
    GROUP BY r.restaurant_id, r.restaurant_name
),
cancel_ratio_2023 AS (
    SELECT
        r.restaurant_id,
        r.restaurant_name,
        ROUND(CAST(COUNT(CASE WHEN o.order_status = 'Not Fulfilled' THEN 1 END) AS DECIMAL(10,2)) 
              /CAST(COUNT(o.order_id) AS DECIMAL(10,2)) * 100, 2) AS cancellation
    FROM orders AS o
    JOIN restaurants AS r
        ON o.restaurant_id = r.restaurant_id
    WHERE YEAR(o.order_date) = 2023
    GROUP BY r.restaurant_id, r.restaurant_name
)

SELECT 
    c23.restaurant_id,
    c23.restaurant_name,
    CAST(c23.cancellation AS DECIMAL(10,2)) AS cancel_rate,
    CAST(COALESCE(c24.cancellation, 0) AS DECIMAL(10,2)) AS cancel_24
FROM cancel_ratio_2023 AS c23
FULL JOIN cancel_ratio_2024 AS c24
    ON c23.restaurant_id = c24.restaurant_id
ORDER BY c23.restaurant_id;



/* 8. Monthly Restaurant Growth Ratio
       Calculate each restaurant's growth ratio based on the total number of
	   delivered orders since its joining
	     - Break down by mm-yy
		 - Monthly orders and previous monthly orders
		 - Calc growth ration                                             */

WITH order_count AS (
    SELECT
        o.restaurant_id AS rest_id,
        FORMAT(o.order_date, 'MM-yy') AS mm_yy,
        COUNT(o.order_id) AS cr_count,
		SUM(o.total_amount) as total_revenue,
        LAG(COUNT(o.order_id), 1) OVER(PARTITION BY o.restaurant_id ORDER BY FORMAT(o.order_date, 'MM-yy')) AS prv_count,
		LAG(SUM(o.total_amount), 1) OVER(PARTITION BY o.restaurant_id ORDER BY FORMAT(o.order_date, 'MM-yy')) AS prv_revenue
    FROM deliveries AS d
    FULL JOIN orders AS o ON d.order_id = o.order_id
    WHERE d.delivery_status = 'Delivered'
    GROUP BY o.restaurant_id, FORMAT(o.order_date, 'MM-yy')
)
SELECT 
    rest_id,
    mm_yy,
    ISNULL(prv_count, 0) AS previous_count,  -- Replaces NULL with 0
    cr_count as current_count,
	total_revenue as cr_revenue,
	prv_revenue,
    ROUND(CAST((cr_count - prv_count) AS FLOAT) / NULLIF(prv_count,0)*100,2) AS growth_ratio
FROM order_count
ORDER BY rest_id, mm_yy;


/* 9. Customer Segmentation
       Segment customers into 'Gold' or 'Silver' groups based on their total spending
       compare to the average order value (AOV) . If customer's average spendings exceeds AOV
	   label them as Gold; otherwise Silver . Find total orders and revenue in each segment*/

SELECT
	customer_category,
	SUM(total_orders) AS total_orders,
	SUM(total_spent) AS total_revenue

FROM
	(SELECT customer_id,
	SUM(total_amount) AS total_spent,
	COUNT(order_id) AS total_orders,
	ROUND((SELECT SUM(total_amount)/COUNT(order_id) FROM orders), 2) AS customer_aov,
	CASE
		WHEN AVG(total_amount) > (SELECT AVG(total_amount) FROM orders) THEN 'GOLD'
		ELSE 'SILVER'
	END as customer_category
	FROM orders
	GROUP BY customer_id
	) as subquery
GROUP BY customer_category;


/* 10. Rider Monthly Earnings
 	   Rider's total monthly earnings, assuming they earn 8% of the order
	   amount                                                          */

SELECT d.rider_id,
	   FORMAT(o.order_date,'MM-yy') AS month_,
	   SUM(o.total_amount) AS total_revenue,
	   SUM(o.total_amount)*0.08 AS riders_monthly_earning
	   FROM orders AS o
	   JOIN deliveries AS d
	   ON o.order_id = d.order_id
GROUP BY d.rider_id, FORMAT(o.order_date,'MM-yy')
ORDER BY d.rider_id, month_ 


/* 11. Rider Ratings Analysis
       Based on delivery time give 5-star (if <15 mins), 4-star (if 15-20 mins),
	   and 3-star (if >20 mins) ratings
	     - Calc delivery time of each delivered order
		 - Rank each delivery (5/4/3 stars)
		 - Group by rider and star count                                   */

SELECT rider_id,
rider_ratings,
COUNT(*) AS total_stars
FROM
	(SELECT 
	rider_id,
	delivery_time_taken,
	CASE
		WHEN delivery_time_taken<15 THEN '5 star'
		WHEN delivery_time_taken>=15 AND delivery_time_taken<=20 THEN '4 star'
		ELSE '3 star'
	END as rider_ratings

	FROM
		(SELECT d.rider_id,
		o.order_time,
		d.delivery_time,
		(CASE 
			WHEN d.delivery_time < o.order_time THEN 
				DATEDIFF(SECOND, o.order_time, '23:59:59') + DATEDIFF(SECOND, 
				'00:00:00', d.delivery_time) + 1
			ELSE 
				DATEDIFF(SECOND, o.order_time, d.delivery_time)
		END)/60 AS delivery_time_taken
		FROM orders AS o
		LEFT JOIN deliveries AS d ON o.order_id = d.order_id
		LEFT JOIN riders AS r ON d.rider_id = r.rider_id
		WHERE d.delivery_status = 'Delivered'
		) as rating_table
	) as table2
GROUP BY rider_id,rider_ratings
ORDER BY rider_id, rider_ratings DESC;


/* 12. Order Frequency by Day
       Order frequency per day of the week + identifiction of the peak day for
	   each restaurant.                                                     */

SELECT restaurant_name,
	   day_of_week AS peak_day,
	   total_orders
FROM
	(SELECT
		r.restaurant_name,
		FORMAT(o.order_date, 'dddd') AS day_of_week,
		COUNT(o.order_id) AS total_orders,
		DENSE_RANK() OVER(PARTITION BY r.restaurant_name ORDER BY COUNT(o.order_id) DESC) AS peak_rank
	FROM orders AS o
	JOIN restaurants AS r 
	ON o.restaurant_id = r.restaurant_id
	GROUP BY r.restaurant_name, FORMAT(o.order_date, 'dddd')
	) AS subquery 
WHERE peak_rank=1;


/* 13. Rider Efficiency
       Rider efficiency evaluation by determining average delivery times and
	   identifying those with the lowest and highest averages.             */

SELECT MIN(avg_delivery_time) AS minimum_avg_delivery_time , MAX (avg_delivery_time) 
  AS  maximum_avg_delivery_time 
FROM
  ( SELECT rider_id,
	AVG(delivery_time_taken) AS avg_delivery_time
	FROM
			(SELECT d.rider_id,
			o.order_time,
			d.delivery_time,
			(CASE 
				WHEN d.delivery_time < o.order_time THEN 
					DATEDIFF(SECOND, o.order_time, '23:59:59') + DATEDIFF(SECOND, '00:00:00', d.delivery_time) + 1
				ELSE 
					DATEDIFF(SECOND, o.order_time, d.delivery_time)
			END)/60 AS delivery_time_taken
			FROM orders AS o
			LEFT JOIN deliveries AS d ON o.order_id = d.order_id
			LEFT JOIN riders AS r ON d.rider_id = r.rider_id
			WHERE d.delivery_status = 'Delivered'
			) as subquery
	GROUP BY rider_id
	--ORDER BY avg_delivery_time DESC
  ) as subquery2


/* 14. Order Item Popularity
       Tracking the popularity of specific order items over time and identify
	   seasonal demand spikes.                                             */

SELECT order_item,
	COUNT(order_item) AS total_orders,
	season
FROM (SELECT
		order_item,
		CASE 
			WHEN FORMAT(order_date, 'MM') IN ('12', '01', '02') THEN 'winter'
			WHEN FORMAT(order_date, 'MM') BETWEEN '03' AND '04' THEN 'spring'
			WHEN FORMAT(order_date, 'MM') BETWEEN '05' AND '07' THEN 'summer'
			WHEN FORMAT(order_date, 'MM') BETWEEN '08' AND '09' THEN 'monsoon'
			WHEN FORMAT(order_date, 'MM') BETWEEN '10' AND '11' THEN 'autumn'
		END AS season
	FROM orders
) as t1
GROUP BY order_item,season
ORDER BY order_item,total_orders DESC;


/* 15. The rank of each city based on the total revenue for last year 2023 */

SELECT
r.city,
SUM(o.total_amount) AS total_revenue,
RANK() OVER( ORDER BY SUM(o.total_amount) DESC ) AS rank
FROM orders AS o
JOIN restaurants AS r
ON r.restaurant_id=o.restaurant_id
GROUP BY r.city 


/* ------------------------------------------------------------------------------------------------------------------------ */
