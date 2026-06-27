-- Q1. Fetch all details of users who belong to the city 'Mumbai'.

SELECT *
FROM users
WHERE city = 'Mumbai';


-- Q2. List all products from the 'Electronics' category with a price greater than 5000.

SELECT *
FROM products
WHERE category = 'Electronics'
AND price > 5000;


-- Q3. Count the total number of orders present in the database.

SELECT COUNT(*) AS total_orders
FROM orders;


-- Q4. Find all unique categories of products available in the shop.

SELECT DISTINCT category
FROM products;


-- Q5. Show the top 5 costliest products available in the stock.

SELECT *
FROM products
ORDER BY price DESC
LIMIT 5;


-- Q6. Get all orders that have a status of 'Cancelled'.

SELECT *
FROM orders
WHERE status = 'Cancelled';


-- Q7. List all products whose stock quantity is less than 20.

SELECT *
FROM products
WHERE stock_quantity < 20;


-- Q8. Display the names and emails of users who joined in the year 2024.

SELECT full_name,
       email
FROM users
WHERE YEAR(join_date) = 2024;


-- Q9. Find the average price of all items listed in the products table.

SELECT AVG(price) AS average_price
FROM products;


-- Q10. List all successful payments made using the payment method 'UPI'.

SELECT *
FROM payments
WHERE payment_method = 'UPI'
AND payment_status = 'Success';


-- Q11. Find all products whose name starts with the letter 'Smart'.

SELECT *
FROM products
WHERE product_name LIKE 'Smart%';


-- Q12. Retrieve all shipments processed by the carrier 'BlueDart'.

SELECT *
FROM shipments
WHERE carrier = 'BlueDart';


-- Q13. List all reviews where the product rating is exactly 5 stars.

SELECT *
FROM reviews
WHERE rating = 5;


-- Q14. Show all logs from inventory where log_type is 'Return'.

SELECT *
FROM inventory_logs
WHERE log_type = 'Return';


-- Q15. Fetch the total product count inside each category.

SELECT category,
       COUNT(*) AS total_products
FROM products
GROUP BY category;



-- Q16. Display the user name along with their order IDs by joining users and orders tables.

SELECT u.name,
       o.order_id
FROM users u
INNER JOIN orders o
ON u.user_id = o.user_id;


-- Q17. Find the total amount spent on each order by summing up total_item_price from order_items.

SELECT order_id,
       SUM(total_item_price) AS total_order_value
FROM order_items
GROUP BY order_id;


-- Q18. Display product names and their associated user ratings and comments.

SELECT p.product_name,
       r.rating,
       r.comment
FROM products p
INNER JOIN reviews r
ON p.product_id = r.product_id;


-- Q19. Group the orders by status and show the count of orders for each status.

SELECT status,
       COUNT(*) AS status_count
FROM orders
GROUP BY status
ORDER BY status_count DESC;


-- Q20. List all categories that have an average product price greater than 1000.

SELECT category,
       AVG(price) AS avg_price
FROM products
GROUP BY category
HAVING avg_price > 1000;


-- Q21. Find the details of shipments that took more than 2 days to ship after the order date.

SELECT s.*,
       o.order_date
FROM shipments s
INNER JOIN orders o
ON s.order_id = o.order_id
WHERE DATEDIFF(s.shipment_date, o.order_date) > 2;


-- Q22. Show the top 3 cities that have the highest number of registered users.

SELECT city,
       COUNT(*) AS user_count
FROM users
GROUP BY city
ORDER BY user_count DESC
LIMIT 3;


-- Q23. Find the total quantity sold for each product_id.

SELECT product_id,
       SUM(quantity) AS total_units_sold
FROM order_items
GROUP BY product_id;


-- Q24. List all successful transactions where the amount paid was between 2000 and 10000.

SELECT *
FROM payments
WHERE payment_status = 'Success'
AND amount BETWEEN 2000 AND 10000;


-- Q25. Extract the month name and year from the order_date and count total orders per month.

SELECT YEAR(order_date) AS yr,
       MONTHNAME(order_date) AS mnth,
       COUNT(*) AS total_orders
FROM orders
GROUP BY YEAR(order_date),
         MONTHNAME(order_date);


-- Q26. Display the product details that have never been ordered yet.

SELECT p.*
FROM products p
LEFT JOIN order_items oi
ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;


-- Q27. Retrieve the total revenue collected grouped by each payment method.

SELECT payment_method,
       SUM(amount) AS total_collected
FROM payments
WHERE payment_status = 'Success'
GROUP BY payment_method;


-- Q28. Find the user details who has given the lowest rating (1 star) to any product.

SELECT DISTINCT u.*
FROM users u
INNER JOIN reviews r
ON u.user_id = r.user_id
WHERE r.rating = 1;


-- Q29. Calculate the total stock in and total stock out quantity for each product.

SELECT product_id,
       SUM(CASE
               WHEN log_type = 'Stock In'
               THEN change_quantity
               ELSE 0
           END) AS total_added,

       SUM(CASE
               WHEN log_type = 'Stock Out'
               THEN change_quantity
               ELSE 0
           END) AS total_removed
FROM inventory_logs
GROUP BY product_id;


-- Q30. List orders that contain more than 3 items inside a single order.

SELECT order_id,
       COUNT(item_id) AS items_count
FROM order_items
GROUP BY order_id
HAVING items_count > 3;


-- Q31. Write a query to find the customer who has placed the highest number of orders.

SELECT user_id,
       COUNT(*) AS order_count
FROM orders
GROUP BY user_id
ORDER BY order_count DESC
LIMIT 1;


-- Q32. Find the second most expensive product inside the 'Electronics'
-- category using a subquery.

SELECT *
FROM products
WHERE category = 'Electronics'
  AND price < (
        SELECT MAX(price)
        FROM products
        WHERE category = 'Electronics'
    )
ORDER BY price DESC
LIMIT 1;


-- Q33. Rank all products within their respective categories
-- based on price using the DENSE_RANK() window function.

SELECT product_id,
       product_name,
       category,
       price,
       DENSE_RANK() OVER (
           PARTITION BY category
           ORDER BY price DESC
       ) AS price_rank
FROM products;


-- Q34. Use a Common Table Expression (CTE) to find users
-- who have spent more than 50,000 in total across all orders.

WITH UserSpend AS
(
    SELECT o.user_id,
           SUM(oi.total_item_price) AS total_spent
    FROM orders o
    INNER JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.user_id
)
SELECT u.name,
       us.total_spent
FROM UserSpend us
INNER JOIN users u
    ON us.user_id = u.user_id
WHERE us.total_spent > 50000;


-- Q35. Identify products whose current stock is below
-- the average stock quantity of all products in their category.

SELECT p.*
FROM products p
WHERE p.stock_quantity <
(
    SELECT AVG(sub.stock_quantity)
    FROM products sub
    WHERE sub.category = p.category
);


-- Q36. Determine the running total of revenue generated
-- day-by-day over the entire order history.

SELECT DATE(order_date) AS dte,
       SUM(total_item_price) AS daily_sales,
       SUM(SUM(total_item_price))
       OVER (ORDER BY DATE(order_date)) AS running_total
FROM orders o
INNER JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY DATE(order_date);


-- Q37. Find the percentage contribution of each product category
-- to the total overall sales revenue.

SELECT category,
       SUM(total_item_price) AS cat_sales,
       (
           SUM(total_item_price) /
           (
               SELECT SUM(total_item_price)
               FROM order_items
           ) * 100
       ) AS pct_contribution
FROM products p
INNER JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY category;


-- Q38. Retrieve the top 3 ordered products for each city.

WITH CityProd AS
(
    SELECT u.city,
           oi.product_id,
           COUNT(*) AS cnt,
           DENSE_RANK() OVER
           (
               PARTITION BY u.city
               ORDER BY COUNT(*) DESC
           ) AS rnk
    FROM users u
    INNER JOIN orders o
        ON u.user_id = o.user_id
    INNER JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY u.city,
             oi.product_id
)
SELECT *
FROM CityProd
WHERE rnk <= 3;


-- Q39. Find orders where the transaction status failed
-- but the shipment carrier was still assigned.

SELECT o.order_id,
       p.payment_status,
       s.carrier
FROM orders o
INNER JOIN payments p
    ON o.order_id = p.order_id
INNER JOIN shipments s
    ON o.order_id = s.order_id
WHERE p.payment_status IN ('Failed', 'Refunded')
AND s.carrier IS NOT NULL;


-- Q40. Find the most popular payment method in each city
-- based on transaction volume.

WITH CityPay AS
(
    SELECT u.city,
           p.payment_method,
           COUNT(*) AS vol,
           ROW_NUMBER() OVER
           (
               PARTITION BY u.city
               ORDER BY COUNT(*) DESC
           ) AS rnum
    FROM users u
    INNER JOIN orders o
        ON u.user_id = o.user_id
    INNER JOIN payments p
        ON o.order_id = p.order_id
    GROUP BY u.city,
             p.payment_method
)
SELECT city,
       payment_method,
       vol
FROM CityPay
WHERE rnum = 1;


-- Q41. Write a query to find users who made an order
-- within 7 days of their join date.

SELECT u.user_id,
       u.name,
       u.join_date,
       o.order_date
FROM users u
INNER JOIN orders o
    ON u.user_id = o.user_id
WHERE DATEDIFF(o.order_date, u.join_date) <= 7;


-- Q42. Categorize users into High Spender,
-- Medium Spender and Low Spender using CASE.

SELECT u.user_id,
       SUM(p.amount) AS total,
       CASE
           WHEN SUM(p.amount) > 40000
                THEN 'High Spender'
           WHEN SUM(p.amount) BETWEEN 15000 AND 40000
                THEN 'Medium Spender'
           ELSE 'Low Spender'
       END AS customer_segment
FROM users u
INNER JOIN orders o
    ON u.user_id = o.user_id
INNER JOIN payments p
    ON o.order_id = p.order_id
WHERE p.payment_status = 'Success'
GROUP BY u.user_id;


-- Q43. Identify products that have received
-- more than 5 bad reviews (rating <= 2).

SELECT product_id,
       COUNT(*) AS bad_reviews_count
FROM reviews
WHERE rating <= 2
GROUP BY product_id
HAVING bad_reviews_count > 5;


-- Q44. Find the order ID which has the maximum
-- variation in item prices inside it.

SELECT order_id,
       (
           MAX(total_item_price / quantity)
           -
           MIN(total_item_price / quantity)
       ) AS price_spread
FROM order_items
GROUP BY order_id
ORDER BY price_spread DESC
LIMIT 1;


-- Q45. Extract the list of products whose stock
-- has been replenished (Stock In) more than 3 times
-- in the last 60 days.

SELECT product_id,
       COUNT(*) AS incoming_logs_count
FROM inventory_logs
WHERE log_type = 'Stock In'
AND DATEDIFF('2026-06-01', log_date) <= 60
GROUP BY product_id
HAVING incoming_logs_count > 3;