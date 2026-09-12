USE retail_analytics;

-- 1 Monthly revenue
SELECT DATE_FORMAT(transaction_date,'%Y-%m') AS month,
       ROUND(SUM(sales_amount),2) AS revenue
FROM transactions
GROUP BY DATE_FORMAT(transaction_date,'%Y-%m')
ORDER BY month;

-- 2 Revenue by region and category
SELECT c.region, cat.category_name,
       ROUND(SUM(t.sales_amount),2) AS revenue
FROM transactions t
JOIN customers c ON c.customer_id=t.customer_id
JOIN products p ON p.product_id=t.product_id
JOIN categories cat ON cat.category_id=p.category_id
GROUP BY c.region, cat.category_name
ORDER BY revenue DESC;

-- 3 Top products using a window function
WITH product_sales AS (
  SELECT p.product_name, SUM(t.sales_amount) revenue
  FROM transactions t JOIN products p ON p.product_id=t.product_id
  GROUP BY p.product_name
)
SELECT product_name, ROUND(revenue,2) revenue,
       DENSE_RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM product_sales;

-- 4 Month-over-month change
WITH monthly AS (
  SELECT DATE_FORMAT(transaction_date,'%Y-%m') month,
         SUM(sales_amount) revenue
  FROM transactions
  GROUP BY DATE_FORMAT(transaction_date,'%Y-%m')
)
SELECT month, ROUND(revenue,2) revenue,
       ROUND(revenue-LAG(revenue) OVER (ORDER BY month),2) AS mom_change
FROM monthly;

-- 5 Average order value
SELECT ROUND(SUM(sales_amount)/COUNT(*),2) AS avg_order_value
FROM transactions;

-- 6 Regional rank
WITH regional AS (
  SELECT c.region, SUM(t.sales_amount) revenue
  FROM transactions t JOIN customers c ON c.customer_id=t.customer_id
  GROUP BY c.region
)
SELECT region, ROUND(revenue,2) revenue,
       RANK() OVER (ORDER BY revenue DESC) AS region_rank
FROM regional;

-- 7 Category contribution
SELECT cat.category_name,
       ROUND(SUM(t.sales_amount),2) revenue,
       ROUND(100*SUM(t.sales_amount)/(SELECT SUM(sales_amount) FROM transactions),2) pct_total
FROM transactions t
JOIN products p ON p.product_id=t.product_id
JOIN categories cat ON cat.category_id=p.category_id
GROUP BY cat.category_name
ORDER BY revenue DESC;

-- 8 High-value customers
SELECT c.customer_id,c.customer_name,
       ROUND(SUM(t.sales_amount),2) lifetime_value
FROM customers c JOIN transactions t ON t.customer_id=c.customer_id
GROUP BY c.customer_id,c.customer_name
HAVING SUM(t.sales_amount)>5000
ORDER BY lifetime_value DESC;

-- 9 Quarterly revenue using CTE
WITH q AS (
 SELECT CONCAT(YEAR(transaction_date),'-Q',QUARTER(transaction_date)) quarter_name,
        SUM(sales_amount) revenue
 FROM transactions GROUP BY YEAR(transaction_date),QUARTER(transaction_date)
)
SELECT quarter_name, ROUND(revenue,2) revenue FROM q ORDER BY quarter_name;

-- 10 Payment status mix
SELECT payment_method,payment_status,COUNT(*) transaction_count
FROM payments GROUP BY payment_method,payment_status;

-- Additional query patterns for dashboard/reporting practice
SELECT DATE(transaction_date) day, COUNT(*) orders, SUM(quantity) units
FROM transactions GROUP BY DATE(transaction_date) ORDER BY day;
SELECT c.region, COUNT(DISTINCT c.customer_id) customers
FROM customers c GROUP BY c.region;
SELECT p.product_name, SUM(t.quantity) units_sold
FROM transactions t JOIN products p ON p.product_id=t.product_id
GROUP BY p.product_name ORDER BY units_sold DESC;
SELECT AVG(discount) avg_discount FROM transactions;
SELECT MAX(sales_amount) max_transaction FROM transactions;
SELECT MIN(sales_amount) min_transaction FROM transactions;
SELECT YEAR(transaction_date) year, MONTH(transaction_date) month, SUM(quantity) units
FROM transactions GROUP BY YEAR(transaction_date),MONTH(transaction_date);
SELECT c.region, AVG(t.sales_amount) avg_ticket
FROM transactions t JOIN customers c ON c.customer_id=t.customer_id
GROUP BY c.region;
SELECT cat.category_name, AVG(p.unit_price) avg_price
FROM products p JOIN categories cat ON cat.category_id=p.category_id
GROUP BY cat.category_name;
SELECT DATE_FORMAT(transaction_date,'%Y-%m') month, COUNT(*) orders
FROM transactions GROUP BY month ORDER BY month;
