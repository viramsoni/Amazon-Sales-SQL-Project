# amazon_sql_project

Project Overview
I have worked on analyzing a dataset of over 20,000 sales records from an Amazon-like e-commerce platform. This project involves extensive querying of customer behavior, product performance, and sales trends using PostgreSQL. Through this project, I have tackled various SQL problems, including revenue analysis, customer segmentation, and inventory management.

The project also focuses on data cleaning, handling null values, and solving real-world business problems using structured queries.

An ERD diagram is included to visually represent the database schema and relationships between tables.

<img width="1430" height="778" alt="Amazon ERD" src="https://github.com/user-attachments/assets/77e5a02e-5462-47ef-a0a9-da4f44fa4db1" />

# Database Setup & Design

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
# Task: Data Cleaning

I checked whether dataset is cleaned or not by performing following and then cleaned:


Handling missing values: Null values in critical fields (e.g., customer address, payment status) were either filled with default values or handled using appropriate methods.


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

Removing duplicates: Duplicates in the customer and order tables were identified and removed.



