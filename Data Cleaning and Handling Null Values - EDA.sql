-- EDA and Data Cleaning and Handling Null Values
select * from inventory; -- dimension or attribute 
select * from sellers; -- dimension or attribute 
select * from category; -- dimension or attribute 
select * from products; -- dimension or attribute 
select * from customers; -- dimension or attribute 
select * from orders; -- fact
select * from order_items; -- fact
select * from payments; --fact
select * from shipping; -- fact


select distinct payment_status
from payments

select * from shipping
where return_date is not null

--6747
select * from orders
where order_id = 6747

select * from payments 
where order_id = 6747

select * from shipping 
where return_date is null

-- 1.1 NULL VALUES ANALYSIS for Inventory Table 
SELECT 
    COUNT(*) FILTER (WHERE inventory_id IS NULL) AS null_inventory_id,
    COUNT(*) FILTER (WHERE product_id IS NULL) AS null_product_id,
    COUNT(*) FILTER (WHERE stock IS NULL) AS null_stock,
    COUNT(*) FILTER (WHERE warehouse_id IS NULL) AS null_warehouse_id,
    COUNT(*) FILTER (WHERE last_stock_date IS NULL) AS null_last_stock_date
FROM inventory;

-- 1.2 DUPLICATE ROWS CHECK (Based on Primary Key)

select inventory_id, count(*) from inventory group by inventory_id HAVING count(*)>1 ;

-- 2.1 NULL VALUES ANALYSIS FOR SELLERS TABLE
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE seller_id IS NULL) AS null_seller_id,
    COUNT(*) FILTER (WHERE seller_name IS NULL) AS null_seller_name,
    COUNT(*) FILTER (WHERE origin IS NULL) AS null_origin
FROM sellers;

-- 2.2 DUPLICATE ROWS CHECK FOR SELLERS TABLE
SELECT seller_id, COUNT(*) 
FROM sellers 
GROUP BY seller_id 
HAVING COUNT(*) > 1;


-- 3.1 NULL VALUES ANALYSIS FOR CATEGORY TABLE

select * FROM CATEGORY;

select 
	count(*) as total_rows,
	count(*) FILTER(where category_id is null ) as null_category_id,
	count(*) FILTER(where category_name is null ) as null_category_name
from category

-- 3.2 DUPLICATE ROWS CHECK FOR CATEGORY TABLE
SELECT seller_id, COUNT(*) 
FROM sellers 
GROUP BY seller_id 
HAVING COUNT(*) > 1;


-- 4.1 NULL VALUES ANALYSIS FOR PRODUCT TABLE
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE product_id IS NULL) AS null_product_id,
    COUNT(*) FILTER (WHERE product_name IS NULL) AS null_product_name,
    COUNT(*) FILTER (WHERE price IS NULL) AS null_price,
    COUNT(*) FILTER (WHERE category_id IS NULL) AS null_category_id
FROM products;

-- 4.2. DUPLICATE ROWS CHECK
SELECT product_id, COUNT(*) 
FROM products 
GROUP BY product_id 
HAVING COUNT(*) > 1;

-- 5.1 NULL VALUES ANALYSIS
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS null_customer_id,
    COUNT(*) FILTER (WHERE first_name IS NULL) AS null_first_name,
    COUNT(*) FILTER (WHERE last_name IS NULL) AS null_last_name,
    COUNT(*) FILTER (WHERE state IS NULL) AS null_state
FROM customers;

-- 5.2 DUPLICATE ROWS CHECK
SELECT customer_id, COUNT(*) 
FROM customers 
GROUP BY customer_id 
HAVING COUNT(*) > 1;



-- 6.1 NULL VALUES ANALYSIS
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE order_id IS NULL) AS null_order_id,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS null_customer_id,
    COUNT(*) FILTER (WHERE order_date IS NULL) AS null_order_date,
    COUNT(*) FILTER (WHERE order_status IS NULL) AS null_order_status
FROM orders;

-- 6.2 DUPLICATE ROWS CHECK
SELECT order_id, COUNT(*) 
FROM orders 
GROUP BY order_id 
HAVING COUNT(*) > 1;

-- 7.1 NULL VALUES ANALYSIS
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE order_item_id IS NULL) AS null_order_item_id,
    COUNT(*) FILTER (WHERE order_id IS NULL) AS null_order_id,
    COUNT(*) FILTER (WHERE product_id IS NULL) AS null_product_id,
    COUNT(*) FILTER (WHERE quantity IS NULL) AS null_quantity,
    COUNT(*) FILTER (WHERE price_per_unit IS NULL) AS null_price_per_unit
FROM order_items;

/* Other techinique to remove check null

SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) - count(order_item_id) AS null_order_item_id,
    COUNT(*) count(order_id) AS null_order_id,
    COUNT(*) - count(product_id),
    COUNT(*) - count(quantity),
    COUNT(*)- count(price_per_unit)
FROM order_items;
*/

-- 7.2 DUPLICATE ROWS CHECK
SELECT order_item_id, COUNT(*) 
FROM order_items 
GROUP BY order_item_id 
HAVING COUNT(*) > 1;


-- 8.1 NULL VALUES ANALYSIS
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE payment_id IS NULL) AS null_payment_id,
    COUNT(*) FILTER (WHERE order_id IS NULL) AS null_order_id,
    COUNT(*) FILTER (WHERE payment_date IS NULL) AS null_payment_date,
    COUNT(*) FILTER (WHERE payment_status IS NULL) AS null_payment_status,
    COUNT(*) FILTER (WHERE amount IS NULL) AS null_amount
FROM payments;

-- 8.2 DUPLICATE ROWS CHECK
SELECT payment_id, COUNT(*) 
FROM payments 
GROUP BY payment_id 
HAVING COUNT(*) > 1;

-- 9.1 NULL VALUES ANALYSIS
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE shipping_id IS NULL) AS null_shipping_id,
    COUNT(*) FILTER (WHERE order_id IS NULL) AS null_order_id,
    COUNT(*) FILTER (WHERE shipping_date IS NULL) AS null_shipping_date,
    COUNT(*) FILTER (WHERE delivery_status IS NULL) AS null_delivery_status
FROM shipping;

-- 9.2 DUPLICATE ROWS CHECK
SELECT shipping_id, COUNT(*) 
FROM shipping 
GROUP BY shipping_id 
HAVING COUNT(*) > 1;


