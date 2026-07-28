/*Table List 

inventory, sellers, products, category, customers, orders, order_items, payments, shipping
function to find lendth to decide varchar length in MS excel 2010 ::: MAX(INDEX(LEN(A:A),0))

*/
drop table if exists inventory;
create table inventory
(
	inventory_id INT PRIMARY KEY, 
	product_id	INT, -- FK FROM PRODUCT TABLE
	stock INT,
	warehouse_id INT, 
	last_stock_date Date,
	CONSTRAINT INVENTORY_FK_PRODUCTS FOREIGN KEY (product_id) REFERENCES PRODUCTS(product_id)
)

drop table if exists sellers;
create table sellers
(
	seller_id INT PRIMARY KEY, 	seller_name VARCHAR(25)	, origin VARCHAR(15)
)
drop table if exists products;
create table products
(
	product_id	INT PRIMARY KEY, product_name VARCHAR(60),	price FLOAT,	cogs int,
	category_id INT, --FK  FROM CATEGORY TABLE,
	CONSTRAINT PRODUCTS_FK_CATEGORY FOREIGN KEY (category_id) REFERENCES CATEGORY(category_id)
)
alter table products
alter column cogs type float;

	drop table if exists CATEGORY;
	create table CATEGORY
(
	category_id int PRIMARY KEY, 	category_name VARCHAR(30)
)

drop table if exists customers;
create table customers
(
	Customer_ID	INT PRIMARY KEY, first_name VARCHAR(25), 	last_name VARCHAR(25), 	state VARCHAR(30)
)

drop table if exists orders;
create table  orders
( 
	order_id INT PRIMARY KEY,	
	order_date	DATE, 
	customer_id	INT, -- FK FROM CUSTOMERS TABLE 
	seller_id INT,	-- FK FROM SELLERS TABLE
	order_status VARCHAR(25),
	CONSTRAINT ORDERS_FK_CUSTOMERS FOREIGN KEY (customer_id) REFERENCES CUSTOMERS(customer_id),
	CONSTRAINT ORDERS_FK_SELLERS FOREIGN KEY (seller_id) REFERENCES SELLERS(seller_id)
)

drop table if exists order_items;
create table order_items
( 	order_item_id	INT PRIMARY KEY, 
	order_id	INT, -- FK FROM ORDER TABLE
	product_id INT, -- FK FROM PRODUCTS TABLE
	quantity INT,	
	price_per_unit FLOAT,
	CONSTRAINT ORDER_ITEMS_FK_ORDERS FOREIGN KEY (order_id)  REFERENCES ORDERS(order_id) ,
	CONSTRAINT ORDER_ITEMS_FK_PRODUCTS FOREIGN KEY (product_id) REFERENCES PRODUCTS(product_id) 
)

drop table if exists payments;
create table payments
( 	payment_id	INT PRIMARY KEY, 
	order_id	INT , -- FK FROM ORDERS TABLE 
	payment_date	DATE, 
	payment_status VARCHAR(25),
	CONSTRAINT PAYMENTS_FK_ORDERS FOREIGN KEY (order_id) REFERENCES ORDERS(order_id )
)
drop table if exists shipping;
create table shipping
(	shipping_id	INT PRIMARY KEY, 
	order_id	INT, -- FK FROM ORDERS  TABLE
	shipping_date	DATE, 
	return_date	DATE, 
	shipping_providers VARCHAR(25),	
	delivery_status VARCHAR(25),
	CONSTRAINT SHIPPING_FK_ORDERS FOREIGN KEY (order_id) REFERENCES ORDERS(order_id)
)
