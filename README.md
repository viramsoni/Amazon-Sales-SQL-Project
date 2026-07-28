# Amazon USA SQL Sales Analysis Project

### Project Overview

I have worked on analyzing a dataset of over 20,000 sales records from an Amazon-like e-commerce platform. This project involves extensive querying of customer behavior, product performance, and sales trends using PostgreSQL. Through this project, I have tackled various SQL problems, including revenue analysis, customer segmentation, and inventory management.

The project also focuses on data cleaning, handling null values, and solving real-world business problems using structured queries.

An ERD diagram is included to visually represent the database schema and relationships between tables.

<img width="1430" height="778" alt="Amazon ERD" src="https://github.com/user-attachments/assets/77e5a02e-5462-47ef-a0a9-da4f44fa4db1" />

## Database Setup & Design

Schema Structure
```sql
CREATE TABLE category
(
  category_id	INT PRIMARY KEY,
  category_name VARCHAR(20)
);

-- customers TABLE
CREATE TABLE customers
(
  customer_id INT PRIMARY KEY,	
  first_name	VARCHAR(20),
  last_name	VARCHAR(20),
  state VARCHAR(20),
  address VARCHAR(5) DEFAULT ('xxxx')
);

-- sellers TABLE
CREATE TABLE sellers
(
  seller_id INT PRIMARY KEY,
  seller_name	VARCHAR(25),
  origin VARCHAR(15)
);

-- products table
  CREATE TABLE products
  (
  product_id INT PRIMARY KEY,	
  product_name VARCHAR(50),	
  price	FLOAT,
  cogs	FLOAT,
  category_id INT, -- FK 
  CONSTRAINT product_fk_category FOREIGN KEY(category_id) REFERENCES category(category_id)
);

-- orders
CREATE TABLE orders
(
  order_id INT PRIMARY KEY, 	
  order_date	DATE,
  customer_id	INT, -- FK
  seller_id INT, -- FK 
  order_status VARCHAR(15),
  CONSTRAINT orders_fk_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  CONSTRAINT orders_fk_sellers FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
);

CREATE TABLE order_items
(
  order_item_id INT PRIMARY KEY,
  order_id INT,	-- FK 
  product_id INT, -- FK
  quantity INT,	
  price_per_unit FLOAT,
  CONSTRAINT order_items_fk_orders FOREIGN KEY (order_id) REFERENCES orders(order_id),
  CONSTRAINT order_items_fk_products FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- payment TABLE
CREATE TABLE payments
(
  payment_id	
  INT PRIMARY KEY,
  order_id INT, -- FK 	
  payment_date DATE,
  payment_status VARCHAR(20),
  CONSTRAINT payments_fk_orders FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE shippings
(
  shipping_id	INT PRIMARY KEY,
  order_id	INT, -- FK
  shipping_date DATE,	
  return_date	 DATE,
  shipping_providers	VARCHAR(15),
  delivery_status VARCHAR(15),
  CONSTRAINT shippings_fk_orders FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE inventory
(
  inventory_id INT PRIMARY KEY,
  product_id INT, -- FK
  stock INT,
  warehouse_id INT,
  last_stock_date DATE,
  CONSTRAINT inventory_fk_products FOREIGN KEY (product_id) REFERENCES products(product_id)
  );
```
## Task: Data Cleaning

I checked whether dataset is cleaned or not by performing following and then cleaned:

- Handling missing values: Null values in critical fields (e.g., customer address, payment status) were either filled with default values or handled using appropriate methods.

- Removing duplicates: Duplicates in the customer and order tables were identified and removed.

-- 1.1 NULL VALUES ANALYSIS for Inventory Table 
```sql
SELECT 
    COUNT(*) FILTER (WHERE inventory_id IS NULL) AS null_inventory_id,
    COUNT(*) FILTER (WHERE product_id IS NULL) AS null_product_id,
    COUNT(*) FILTER (WHERE stock IS NULL) AS null_stock,
    COUNT(*) FILTER (WHERE warehouse_id IS NULL) AS null_warehouse_id,
    COUNT(*) FILTER (WHERE last_stock_date IS NULL) AS null_last_stock_date
FROM inventory;
```
-- 1.2 DUPLICATE ROWS CHECK (Based on Primary Key)
```sql
select inventory_id, count(*) from inventory group by inventory_id HAVING count(*)>1 ;
```
-- 2.1 NULL VALUES ANALYSIS FOR SELLERS TABLE
```sql
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE seller_id IS NULL) AS null_seller_id,
    COUNT(*) FILTER (WHERE seller_name IS NULL) AS null_seller_name,
    COUNT(*) FILTER (WHERE origin IS NULL) AS null_origin
FROM sellers;
```
-- 2.2 DUPLICATE ROWS CHECK FOR SELLERS TABLE
```sql
SELECT seller_id, COUNT(*) 
FROM sellers 
GROUP BY seller_id 
HAVING COUNT(*) > 1;
```
-- 3.1 NULL VALUES ANALYSIS FOR CATEGORY TABLE
```sql
select * FROM CATEGORY;

select 
	count(*) as total_rows,
	count(*) FILTER(where category_id is null ) as null_category_id,
	count(*) FILTER(where category_name is null ) as null_category_name
from category
```
-- 3.2 DUPLICATE ROWS CHECK FOR CATEGORY TABLE
```sql
SELECT seller_id, COUNT(*) 
FROM sellers 
GROUP BY seller_id 
HAVING COUNT(*) > 1;
```
-- 4.1 NULL VALUES ANALYSIS FOR PRODUCT TABLE
```sql
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE product_id IS NULL) AS null_product_id,
    COUNT(*) FILTER (WHERE product_name IS NULL) AS null_product_name,
    COUNT(*) FILTER (WHERE price IS NULL) AS null_price,
    COUNT(*) FILTER (WHERE category_id IS NULL) AS null_category_id
FROM products;
```
-- 4.2. DUPLICATE ROWS CHECK
```sql
SELECT product_id, COUNT(*) 
FROM products 
GROUP BY product_id 
HAVING COUNT(*) > 1;
```
-- 5.1 NULL VALUES ANALYSIS
```sql
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS null_customer_id,
    COUNT(*) FILTER (WHERE first_name IS NULL) AS null_first_name,
    COUNT(*) FILTER (WHERE last_name IS NULL) AS null_last_name,
    COUNT(*) FILTER (WHERE state IS NULL) AS null_state
FROM customers;
```
-- 5.2 DUPLICATE ROWS CHECK
```sql
SELECT customer_id, COUNT(*) 
FROM customers 
GROUP BY customer_id 
HAVING COUNT(*) > 1;
```
-- 6.1 NULL VALUES ANALYSIS
```sql
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE order_id IS NULL) AS null_order_id,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS null_customer_id,
    COUNT(*) FILTER (WHERE order_date IS NULL) AS null_order_date,
    COUNT(*) FILTER (WHERE order_status IS NULL) AS null_order_status
FROM orders;
```
-- 6.2 DUPLICATE ROWS CHECK
```sql
SELECT order_id, COUNT(*) 
FROM orders 
GROUP BY order_id 
HAVING COUNT(*) > 1;
```
-- 7.1 NULL VALUES ANALYSIS
```sql
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE order_item_id IS NULL) AS null_order_item_id,
    COUNT(*) FILTER (WHERE order_id IS NULL) AS null_order_id,
    COUNT(*) FILTER (WHERE product_id IS NULL) AS null_product_id,
    COUNT(*) FILTER (WHERE quantity IS NULL) AS null_quantity,
    COUNT(*) FILTER (WHERE price_per_unit IS NULL) AS null_price_per_unit
FROM order_items;
```
## Objective

The primary objective of this project is to showcase SQL proficiency through complex queries that address real-world e-commerce business challenges. The analysis covers various aspects of e-commerce operations, including:

- Customer behavior
- Sales trends
- Inventory management
- Payment and shipping analysis
- Product performance

## Identifying Business Problems

* Key business problems identified:

- Low product availability due to inconsistent restocking.
- High return rates for specific product categories.
- Significant delays in shipments and inconsistencies in delivery times.
- High customer acquisition costs with a low customer retention rate.

## Solving Business Problems

### Solutions Implemented:

1. Top Selling Products
Query the top 10 products by total sales value.
Challenge: Include product name, total quantity sold, and total sales value.

-- SALE VALUE = QUANTITY * PRICE_PER_UNIT
-- add total_price column name in Ordder_items table
```sql
alter table order_items
add column total_price float;
update order_items set total_price = price_per_unit * quantity;
select * from order_items
```
-- Solving the challenge
```sql
SELECT p.product_id, p.product_name, sum(oi.quantity) as total_quantity,  sum(oi.total_price) as Total_revenue 
FROM PRODUCTS P 
JOIN ORDER_ITEMS OI ON OI.PRODUCT_ID = P.PRODUCT_ID 
group by 1,2
order by 3 DESC
limit 10
``

2. Revenue by Category
Calculate total revenue generated by each product category.
Challenge: Include the percentage contribution of each category to total revenue.
```sql
select * from orders
select * from order_items
select * from products
select * from category
```
--perentage of category contribution: category_name / sum (total_revenue) * 100
```sql
SELECT 
p.category_id, c.category_name, sum(oi.total_price) as total_revenue,
sum(oi.total_price)::numeric / (select  sum (total_price) from order_items)::numeric * 100 as Contribution
FROM order_items oi 
left join products p on oi.product_id = p.product_id
left join category c on c.category_id = p.category_id
group by 1,2
```

3. Average Order Value (AOV)
Compute the average order value for each customer.
Challenge: Include only order with more than 10 orders

-- aov :  total orders value or amount /  number of orders
```sql
select * from customers
select * from order_items 
select * from orders

with t1 as (
select o.customer_id, concat(c.first_name, ' ',c.last_name) as Full_name, count(o.order_id) as Total_orders,
sum(oi.total_price) as Order_amount , sum(oi.total_price) / count(o.order_id) as AOV
from order_items oi
join orders  o on o.order_id = oi.order_id
left join customers c on c.customer_id = o.customer_id
group by 1,2
)
select * 
from t1
where total_orders>10
```

4. Monthly Sales Trend
Query monthly total sales over the past year.
Challenge: Display the sales trend, grouping by month, return current_month sale, last month sale!
 
-- Tables order, order_items, group by , 
-- master-table
```sql
select * from order_items oi
join orders o on o.order_id = oi.order_id
```
----------
```sql
with t1 as(
select  
	extract(month from o.order_date) as month, 
	extract(year from order_date) as year, 
	sum(oi.total_price) as total_revenue 
from order_items oi
join orders o on o.order_id = oi.order_id
where o.order_date >= current_date - interval '3 year'
group by 1,2 order by 1,2
)
select year, month, total_revenue as current_month_sale,lag(total_revenue,1) over(order by year, month) as last_month_sale from t1
```

5. Customers with No Purchases
Find customers who have registered but never placed an order.
Challenge: List customer details and the time since their registration.
```sql
select * from customers 
select * from orders
```
-- The list of customers who have not placed any order
```sql
select c.customer_id, concat(c.first_name, ' ' ,c.last_name) as Full_name, 
from customers c
left join orders o  on c.customer_id = o.customer_id
where o.customer_id is null
```
-- Time of fist order for each customer
```sql
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    AGE(CURRENT_DATE, MIN(o.order_date)) AS time_since_registration
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY 1, 2;
```

6. Least-Selling Categories by State
Identify the least-selling product category for each state.
Challenge: Include the total sales for that category within each state.
```sql
select * from category
select * from products
select * from order_items
select * from customers

select * from order_items as oi
join orders o on o.order_id = oi.order_id 
join products p on p.product_id = oi.product_id
join category c on c.category_id = p.category_id
join customers cu on cu.customer_id = o.customer_id
```
--Identify the least-selling product category for each state, alongwith total sales:
```sql
with t1 as(
select cu.state, c.category_id, c.category_name, sum(oi.quantity) as Quantity_sold,
round(sum(oi.total_price)::numeric,2) as Total_Revenue,
rank() over(partition by cu.state order by sum(oi.quantity)) as rank
from order_items as oi
join orders o on o.order_id = oi.order_id 
join products p on p.product_id = oi.product_id
join category c on c.category_id = p.category_id
join customers cu on cu.customer_id = o.customer_id
group by 1,2,3 ) select state, category_name, Total_Revenue from t1 where rank = 1
```
7. Customer Lifetime Value (CLTV)
Calculate the total value of orders placed by each customer over their lifetime.
Challenge: Rank customers based on their CLTV.
```sql
select * from customers
select * from order_items
select * from orders
```
-------
```sql
select * from customers c
join orders o on o.customer_id = c.customer_id
join order_items oi on oi.order_id = o.order_id
```
-------
```sql
with t1 as(
select concat(first_name, ' ', last_name) as Full_name, round(sum(total_price)::numeric,2) as total_revenue
from customers c
join orders o on o.customer_id = c.customer_id
join order_items oi on oi.order_id = o.order_id 
group by 1 order by 2 desc
)
select Full_name, Total_revenue, dense_rank() over(order by total_revenue ) as rank
from t1
```
8. Inventory Stock Alerts
Query products with stock levels below a certain threshold (e.g., less than 10 units).
Challenge: Include last restock date and warehouse information.
```sql
select * from inventory
select * from products
```
-----
```sql
select * from inventory i
join products p on i.product_id = p.product_id 
```
-----
```sql
select warehouse_id, p.product_name, i.stock, i.last_stock_date from inventory i
join products p on i.product_id = p.product_id 
where i.stock <= 10
```
9. Shipping Delays
Identify orders where the shipping date is later than 3 days after the order date.
Challenge: Include customer, order details, and delivery provider.
```sql
select * from shipping
select * from orders
select * from customers
select * from order_items
```
----
```sql
select * from shipping s
join orders o on o.order_id = s.order_id
join order_items oi on o.order_id = oi.order_id
join customers c on c.customer_id = o.customer_id
```
----
```sql
select concat(first_name, ' ' , last_name) as full_name, order_date, shipping_providers, delivery_status, order_status, quantity, price_per_unit, total_price
from shipping s
join orders o on o.order_id = s.order_id
join order_items oi on o.order_id = oi.order_id
join customers c on c.customer_id = o.customer_id
where shipping_date > order_date +  interval '3 days'
```

10. Payment Success Rate 
Calculate the percentage of successful payments across all orders.
Challenge: Include breakdowns by payment status (e.g., failed, pending).
```sql
select * from payments
select * from orders
```
---
```sql
select * from payments p
join orders o on p.order_id = o.order_id
```
---
```sql
select p.payment_status, count(*) as count, 
round(count(*)::numeric / (select count(*) from payments)::numeric * 100, 2) as percentage
from payments p
join orders o on p.order_id = o.order_id
group by 1
```
11. Top Performing Sellers
Find the top 5 sellers based on total sales value.
Challenge: Include both successful and failed orders, and display their percentage of successful orders.
```sql
select * from sellers
select * from order_items
select * from orders
```
--to check types of order status
```sql
select order_status, count(*) from orders
group by 1
```
----
--Main Join Table
```sql
select * from sellers s
join orders o on s.seller_id = o.seller_id
join order_items oi on oi.order_id = o.order_id
```
----
---- Find the top 5 sellers based on total sales value:
```sql
select seller_name, round(sum(total_price)::numeric,2) as total_revenue from sellers s
join orders o on s.seller_id = o.seller_id
join order_items oi on oi.order_id = o.order_id 
group by 1 order by 2 desc limit 5
```
---Include both successful and failed orders, and 
---display their percentage of successful orders.
```sql
with t1 as (
select seller_name, round(sum(total_price)::numeric,2) as total_revenue from sellers s
join orders o on s.seller_id = o.seller_id
join order_items oi on oi.order_id = o.order_id 
group by 1 order by 2 desc limit 5
),
seller_report as(
select s.seller_name, o.order_status, count(*) as total_orders 
from sellers s
join orders o on s.seller_id = o.seller_id
join order_items oi on oi.order_id = o.order_id 
join t1 t1 on t1.seller_name = s.seller_name
where order_status in ('Completed', 'Returned' , 'Cancelled')
group by 1,2 order by 1,2,3  desc
)
select 
seller_name,
sum(case when order_status = 'Completed' then total_orders else 0 end) as Completed_orders,
sum(case when order_status = 'Cancelled' then total_orders else 0 end ) as Cancelled_orders,
sum(total_orders) as Total_orders,
round(sum(case when order_status = 'Completed' then total_orders else 0 end)::numeric /
sum(total_orders)::numeric * 100, 2)
as percentage_successful_orders
from seller_report
group by 1 order by 5
```

12. Product Profit Margin
Calculate the profit margin for each product (difference between price and cost of goods sold).
```sql
SELECT * from products
select * from order_items
```
---
```sql
SELECT 
    p.product_id,
    p.product_name,
    ROUND(
        (SUM(total_price - (p.cogs * oi.quantity))::numeric / SUM(total_price)::numeric) * 100,
        2
    ) AS profit_margin
FROM order_items AS oi
JOIN products AS p ON oi.product_id = p.product_id
GROUP BY 1, 2
ORDER BY 3 DESC;
```
13. Most Returned Products
Query the top 10 products by the number of returns.
Challenge: Display the return rate as a percentage of total units sold for each product.
```sql
select * from orders
select * from order_items
select * from products
select * from shipping
```
-----
--Join Tables
```sql
select * from orders o
join order_items oi on oi.order_id = o.order_id
join products p on p.product_id = oi.product_id
```
-----
-- Query: the top 10 products by the number of returns.
```sql
select p.product_id, p.product_name, o.order_status, count(o.order_status) as returned_order from orders o
join order_items oi on oi.order_id = o.order_id
join products p on p.product_id = oi.product_id
where order_status = 'Returned'
group by 1,2,3 order by 4 desc limit 10
```
-----
--Challenge: Display the return rate as a percentage of total units sold for each product.
```sql
select 
p.product_id, 
p.product_name, 
count(o.order_status) as total_units_sold,
sum(case when order_status = 'Returned' then 1 else 0 end) as total_returned_units,
round(sum(case when order_status = 'Returned' then 1 else 0 end)::numeric  / count(o.order_status) * 100, 2) as perc
from orders o
join order_items oi on oi.order_id = o.order_id
join products p on p.product_id = oi.product_id
group by 1,2 order by 3 desc limit 10
```
14. Inactive Sellers
Identify sellers who haven’t made any sales in the last 15 months.
Challenge: Show the last sale date and total sales from those sellers.
```sql
select * from sellers
select  * from orders
select * from order_items
```
----Join Tables ----
```sql
select * from sellers s
join orders o on s.seller_id = o.seller_id
```
----Identify sellers who haven’t made any sales in the last 2 years.
```sql
select s.seller_id, s.seller_name
from sellers s
where not exists(
select 1 from orders o 
where s.seller_id = o.seller_id and order_date >= current_date - interval '2 years')
```
----Challenge: Show the last sale date and total sales from those sellers.
/*with t1 as(
select s.seller_id, s.seller_name
from sellers s
where not exists(
select 1 from orders o 
where s.seller_id = o.seller_id and order_date >= current_date - interval '10 month')
)
select t1.seller_id, t1.seller_name, max(order_date) as last_sale, coalesce(round(sum(oi.total_price)::numeric, 0),0) as total_sales 
from t1 t1
left join orders o on o.seller_id = t1.seller_id
left join order_items oi on o.order_id = oi.order_id
group by 1,2 order by 3 desc
*/
```sql
WITH cte1 AS (
    SELECT 
        s.seller_id,
        s.seller_name
    FROM sellers AS s
    WHERE NOT EXISTS (
            SELECT 1 
            FROM orders AS o
            WHERE o.seller_id = s.seller_id 
            AND o.order_date >= CURRENT_DATE - INTERVAL '6 month'
        )
)

SELECT 
    cte1.seller_id,
    cte1.seller_name,
    MAX(o.order_date) AS last_sale_date,
    ROUND(SUM(oi.total_price)::numeric,2) AS total_sales
FROM cte1
LEFT JOIN orders AS o 
    ON cte1.seller_id = o.seller_id
    AND o.order_date < CURRENT_DATE - INTERVAL '6 month'  -- Only historical sales
LEFT JOIN order_items AS oi 
    ON o.order_id = oi.order_id
GROUP BY cte1.seller_id, cte1.seller_name
ORDER BY last_sale_date DESC;
```

15. IDENTITY customers into returning or new
if the customer has done more than 5 times product returns then categorize them as returning otherwise good
Challenge: List customers id, name, total orders, total returns
```sql
select * from customers
select * from orders
select * from shipping
select delivery_status , count(*) from shipping
group by delivery_status

select order_status , count(*) from orders
group by order_status
```
----Join Table
```sql
select * from customers c 
join orders o on o.customer_id = c.customer_id  
join shipping s on s.order_id = o.order_id
```
----
```sql
with t1 as( 
select 
concat(c.first_name, ' ', c.last_name ) as full_name, 
count(o.order_id) as total_orders,
sum(case when o.order_status = 'Returned' then 1 else 0 end ) as total_return
from customers c
join orders o on o.customer_id = c.customer_id  
join shipping s on s.order_id = o.order_id  
group by 1 order by 3  desc
) 
select * ,  CASE WHEN total_return > 5 THEN 'Returning customer' ELSE 'NEW' END AS customer_category
from t1
```
-----

16. Top 5 Customers by Orders in Each State
Identify the top 5 customers with the highest number of orders for each state.
Challenge: Include the number of orders and total sales for each customer.
```sql
select * from customers
select * from orders
select * from order_items
```
-----
```sql
select * from customers c 
join orders o on o.customer_id = c.customer_id
join order_items oi on oi.order_id = o.order_id
```
----Top 5 Customers by Orders in Each State
```sql
select concat(c.first_name, ' ' ,c.last_name), count(o.order_id) from customers c 
join orders o on o.customer_id = c.customer_id
join order_items oi on oi.order_id = o.order_id
group by 1 order by 2 desc limit 5
```
----Identify the top 5 customers with the highest number of orders for each state.
```sql
with t1 as (
select  
state , 
concat(c.first_name, ' ' ,c.last_name) as full_name, 
count(o.order_id) as total_orders,
rank() over(partition by state  order by count(o.order_id) desc) as rank
from customers c 
join orders o on o.customer_id = c.customer_id
join order_items oi on oi.order_id = o.order_id
group by 1,2 order by 1,3 desc
)
select * from t1 where rank <=5 
----Challenge: Include the number of orders and total sales for each customer.
with t1 as (
select  
state , 
concat(c.first_name, ' ' ,c.last_name) as full_name, 
count(o.order_id) as total_orders,
round(sum(total_price)::numeric, 2) as total_sales,
dense_rank() over(partition by state  order by count(o.order_id) desc) as rank
from customers c 
join orders o on o.customer_id = c.customer_id
join order_items oi on oi.order_id = o.order_id
group by 1,2 order by 1,3 desc
)
select * from t1 where rank <=5
```

17. Revenue by Shipping Provider
Calculate the total revenue handled by each shipping provider.
Challenge: Include the total number of orders handled and the average return delivery time for each provider.
```sql
select * from shipping
select * from orders
select * from order_items
```
----Join Tables
```sql
select * from shipping s
join orders o on s.order_id = o.order_id
join order_items oi on oi.order_id = o.order_id
```
----Calculate the total revenue handled by each shipping provider:
```sql
select shipping_providers, round(sum(total_price)::numeric, 2) as shipping_provider_revenue from shipping s
join orders o on s.order_id = o.order_id
join order_items oi on oi.order_id = o.order_id
group by 1 order by 2 desc
```
----Include the total number of orders handled and the average delivery time for each provider for rerurn orders.
```sql
select 
shipping_providers, 
count(o.order_id) as shipping_provider_orders,
round(sum(oi.total_price)::numeric, 2) as shipping_provider_revenue ,
coalesce (round(avg(return_date- shipping_date)::numeric, 2),0) as avg_days
from shipping s
join orders o on s.order_id = o.order_id
join order_items oi on oi.order_id = o.order_id
where order_status = 'Returned'
group by 1 order by 2 desc
```
18. Top 10 product with highest decreasing revenue ratio compare to year 2022 and year 2023
Challenge: Return product_id, product_name, category_name, 2022 revenue and 2023 revenue decrease ratio at end Round the result
Note: Decrease ratio = y23-y22/y22* 100
```sql
select * from products
select * from categories
select * from orders
select * from order_items
```
-----Join tables
```sql
select * from category c
left join products p on c.category_id = p.category_id
join order_items oi on oi.product_id = p.product_id
join orders o on oi.order_id = o.order_id
```
---- product_id, product_name, category_name, 2022 revenue
```sql
select 
c.category_name,
p.product_id,
p.product_name,
round(sum(oi.total_price)::numeric,2) as total_revenue
from category c
left join products p on c.category_id = p.category_id
join order_items oi on oi.product_id = p.product_id
join orders o on oi.order_id = o.order_id
where extract(year from order_date) = '2022'
group by 1,2,3 order by 4 desc
```
---- product_id, product_name, category_name, 2023 revenue
```sql
select 
c.category_name,
p.product_id,
p.product_name,
round(sum(oi.total_price)::numeric,2) as total_revenue
from category c
left join products p on c.category_id = p.category_id
join order_items oi on oi.product_id = p.product_id
join orders o on oi.order_id = o.order_id
where extract(year from order_date) = '2023'
group by 1,2,3 order by 4 desc
```
----Top 10 product with highest decreasing revenue ratio compare to year 2022 and year 2023
----Note: Decrease ratio = y23-y22/y22* 100
```sql
with t1 as (
select 
c.category_name,
p.product_id,
p.product_name,
round(sum(oi.total_price)::numeric,2) as total_revenue_2022
from category c
left join products p on c.category_id = p.category_id
join order_items oi on oi.product_id = p.product_id
join orders o on oi.order_id = o.order_id
where extract(year from order_date) = '2022'
group by 1,2,3 order by 4 desc
), 
t2 as (
select 
c.category_name,
p.product_id,
p.product_name,
round(sum(oi.total_price)::numeric,2) as total_revenue_2023
from category c
left join products p on c.category_id = p.category_id
join order_items oi on oi.product_id = p.product_id
join orders o on oi.order_id = o.order_id
where extract(year from order_date) = '2023'
group by 1,2,3 order by 4 desc
)
select 
t1.category_name,
t1.product_id,
t1.product_name,
t1.total_revenue_2022,
t2.total_revenue_2023 ,
round((t2.total_revenue_2023 - t1.total_revenue_2022) / t1.total_revenue_2022 * 100, 2) as decrease_ratio
from t1
join t2 on t1.product_id = t2.product_id
order by decrease_ratio
limit 10
```

## Key Learning Outcomes

Through this project, I have successfully developed the technical expertise to:

- Architect Scalable Models: Designed and deployed a highly structured, fully normalized relational database schema.
- Refine Raw Datasets: Executed complex data cleaning and preprocessing pipelines to ensure data integrity for analysis.
- Write Advanced Queries: Leveraged high-performance SQL techniques, including window functions, subqueries, and multi-table joins.
- Drive Business Intelligence: Translated raw transaction data into actionable operational insights and key business metrics.
- Optimize Database Execution: Enhanced query runtimes, optimized execution plans, and managed data workloads efficiently.

## Conclusion

This advanced SQL portfolio project bridges the gap between raw transaction data and strategic e-commerce execution. By translating complex, multi-layered data challenges into structured database solutions, the analysis addresses critical core dependencies across inventory management, supply chain logistics, and long-term customer retention.

Ultimately, this project showcases a comprehensive understanding of relational databases as modern engines for business intelligence. The resulting data structures and query pipelines serve as a reliable blueprint for navigating data-heavy operational ecosystems and driving scalable, data-backed corporate decision-making.

# Entity Relationship Diagram (ERD)
<img width="1309" height="822" alt="ERD - Amazon" src="https://github.com/user-attachments/assets/0160cb77-7f4d-46b2-9d86-bb7940c1a399" />
