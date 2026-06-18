Create Table customers (
customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INTEGER,
    customer_city VARCHAR(100),
    customer_state CHAR(2)
);
select * from customers;

select count(*) from customers;

-- counting null values -- 

SELECT
    COUNT(*) AS total_rows,
    COUNT(customer_id) AS customer_id_count,
    COUNT(customer_unique_id) AS customer_unique_id_count,
    COUNT(customer_zip_code_prefix) AS zip_count,
    COUNT(customer_city) AS city_count,
    COUNT(customer_state) AS state_count
FROM customers;

select customer_id , count(*)
from customers
group by customer_id 
having count(*) > 1;

SELECT COUNT(DISTINCT customer_unique_id)
FROM customers;

SELECT COUNT( customer_id)
FROM customers;

CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,

    CONSTRAINT fk_orders_customer
    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
);

select * from orders;

SELECT COUNT(*) AS total_orders
FROM orders;

SELECT
COUNT(*) AS total_rows,
COUNT(order_id) AS order_id_count,
COUNT(customer_id) AS customer_id_count,
COUNT(order_status) AS order_status_count,
COUNT(order_purchase_timestamp) AS purchase_count,
COUNT(order_approved_at) AS approved_count,
COUNT(order_delivered_carrier_date) AS carrier_count,
COUNT(order_delivered_customer_date) AS delivered_count,
COUNT(order_estimated_delivery_date) AS estimated_count
FROM orders;

SELECT
order_status,
COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

select * from orders;

select round(100*sum(case when order_status = 'delivered' then 1 else 0 end)/count(*),2) as delivery_percentage
FROM orders;

 
-- olist seller data -- 

CREATE TABLE sellers (
    seller_id              VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INTEGER,
    seller_city            VARCHAR(100),
    seller_state           CHAR(2)
);

select * from sellers;

SELECT COUNT(*) AS total_sellers FROM sellers; 

SELECT
    COUNT(*)                      AS total_rows,
    COUNT(seller_id)              AS seller_id_count,
    COUNT(seller_zip_code_prefix) AS zip_count,
    COUNT(seller_city)            AS city_count,
    COUNT(seller_state)           AS state_count
FROM sellers;

-- Duplicate check

SELECT seller_id, COUNT(*) as toal_seller_id
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;

-- Top 10 cities with most sellers

SELECT seller_city, COUNT(*) AS total_sellers
FROM sellers
GROUP BY seller_city
ORDER BY total_sellers DESC
LIMIT 10;


-- table of product_category --

CREATE TABLE product_category_name_translation (
    product_category_name         VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
);

SELECT COUNT(*) FROM product_category_name_translation;  
SELECT * FROM product_category_name_translation ORDER BY product_category_name;

-- tabele creation for product analysis -- 

CREATE TABLE products (
    product_id                 VARCHAR(50) PRIMARY KEY,
    product_category_name      VARCHAR(100),
    product_name_lenght        INTEGER,        
    product_description_lenght INTEGER,        
    product_photos_qty         INTEGER,
    product_weight_g           NUMERIC(10,2),
    product_length_cm          NUMERIC(10,2),
    product_height_cm          NUMERIC(10,2),
    product_width_cm           NUMERIC(10,2),
    CONSTRAINT fk_products_category
    FOREIGN KEY (product_category_name)
    REFERENCES product_category_name_translation(product_category_name)
);

-- Import: olist_products_dataset.csv as there was an error as there were some missing product name in product_category_name --

ALTER TABLE products
DROP CONSTRAINT fk_products_category;

-- checking the missing product_category_name in product_category_name_translation -- 
select count(*) from products;

select * from products;

select p.product_category_name from products p
left join product_category_name_translation t 
on p.product_category_name = t.product_category_name
where t.product_category_name is null
order by 1;

-- Step 1: Insert the 2 missing categories
INSERT INTO product_category_name_translation 
    (product_category_name, product_category_name_english)
VALUES
    ('pc_gamer','pc_gamer'),
    ('portateis_cozinha_e_preparadores_de_alimentos','portable_kitchen_and_food_preparers');

-- Step 2: Re-add the FK constraint
ALTER TABLE products
ADD CONSTRAINT fk_products_category
FOREIGN KEY (product_category_name)
REFERENCES product_category_name_translation(product_category_name);

-- Step 3: Verify constraint is back and data is clean

SELECT COUNT(*) AS total_products FROM products;         

SELECT COUNT(*) AS products_with_no_category
FROM products
WHERE product_category_name IS NULL;  

SELECT
    COUNT(*)                     AS total_rows,
    COUNT(product_id)            AS product_id_count,
    COUNT(product_category_name) AS category_count,
    COUNT(product_weight_g)      AS weight_count,
    COUNT(product_photos_qty)    AS photos_count
FROM products;


SELECT product_category_name, COUNT(*) AS total_products
FROM products
GROUP BY product_category_name
ORDER BY total_products DESC
LIMIT 10;

SELECT COUNT(*) AS products_without_category
FROM products
WHERE product_category_name IS NULL;

CREATE TABLE geolocation (
    geolocation_zip_code_prefix INTEGER,
    geolocation_lat             NUMERIC(18,15),
    geolocation_lng             NUMERIC(18,15),
    geolocation_city            VARCHAR(100),
    geolocation_state           CHAR(2)
	);
	
SELECT COUNT(*) AS total_rows FROM geolocation;           
SELECT COUNT(DISTINCT geolocation_zip_code_prefix) AS unique_zips FROM geolocation;

-- States covered -- 
SELECT geolocation_state, COUNT(*) AS records
FROM geolocation
GROUP BY geolocation_state
ORDER BY records DESC;

--  ORDER PAYMENTS  (depends on orders) --

CREATE TABLE order_payments (
    order_id             VARCHAR(50),
    payment_sequential   INTEGER,
    payment_type         VARCHAR(30),
    payment_installments INTEGER,
    payment_value        NUMERIC(10,2),
	primary key(order_id,payment_sequential),
	constraint fk_payments_order
	foreign key (order_id)
	REFERENCES orders (order_id));

	select * from order_payments;

	select 
	count(*) as total_rows ,
	count(order_id) as total_id_count,
	COUNT(payment_type)         AS type_count,
    COUNT(payment_installments) AS installments_count,
    COUNT(payment_value)        AS value_count
FROM order_payments;

select * from order_payments;

-- Payment method breakdown

select payment_type, count(payment_type) as no_payment_type, ROUND(sum(payment_value),2) as total_revenue,
round(avg(payment_value),2) as avg_pay_by_different_pay_method
from order_payments
group by payment_type
order by no_payment_type desc;

-- Installment distribution (do most people pay in 1 shot?)
SELECT
    payment_installments,
    COUNT(*) AS total
FROM order_payments
GROUP BY payment_installments
ORDER BY payment_installments;


CREATE TABLE order_reviews (
    review_id               VARCHAR(50),
    order_id                VARCHAR(50),
    review_score            SMALLINT CHECK (review_score BETWEEN 1 AND 5),
    review_comment_title    VARCHAR(100),
    review_comment_message  TEXT,
    review_creation_date    TIMESTAMP,
    review_answer_timestamp TIMESTAMP,
	primary key (review_id,order_id),
	constraint fk_review_order
	foreign key (order_id) references orders(order_id)
	);

	select * from order_reviews;

	SELECT
    COUNT(*)                      AS total_rows,
    COUNT(review_id)              AS review_id_count,
    COUNT(order_id)               AS order_id_count,
    COUNT(review_score)           AS score_count,
    COUNT(review_comment_message) AS comment_count   -- many will be NULL
FROM order_reviews;

-- Score distribution with percentage
SELECT
    review_score,
    COUNT(*) AS total,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM order_reviews
GROUP BY review_score
ORDER BY review_score DESC;

-- Average review score
SELECT ROUND(AVG(review_score), 2) AS avg_review_score
FROM order_reviews;

-- How many reviews have a written comment?
SELECT COUNT(*) AS reviews_with_comment
FROM order_reviews
WHERE review_comment_message IS NOT NULL
  AND TRIM(review_comment_message) <> '';

-- 9. ORDER ITEMS  (depends on orders + products + sellers)

CREATE TABLE order_items (
    order_id            VARCHAR(50),
    order_item_id       INTEGER,
    product_id          VARCHAR(50),
    seller_id           VARCHAR(50),
    shipping_limit_date TIMESTAMP,
    price               NUMERIC(10,2),
    freight_value       NUMERIC(10,2),
    PRIMARY KEY (order_id, order_item_id),
    CONSTRAINT fk_items_order
        FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    CONSTRAINT fk_items_product
        FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT fk_items_seller
        FOREIGN KEY (seller_id)  REFERENCES sellers(seller_id)
);

-- Import: olist_order_items_dataset.csv

SELECT COUNT(*) AS total_order_items FROM order_items;  

SELECT
    COUNT(*)             AS total_rows,
    COUNT(order_id)      AS order_id_count,
    COUNT(product_id)    AS product_id_count,
    COUNT(seller_id)     AS seller_id_count,
    COUNT(price)         AS price_count,
    COUNT(freight_value) AS freight_count
FROM order_items;

-- Prove order_id alone cannot be PK
SELECT
    COUNT(*)                AS total_rows,
    COUNT(DISTINCT order_id) AS unique_orders
FROM order_items;
-- total_rows > unique_orders proves one order can have multiple items

-- Revenue stats
SELECT
    ROUND(AVG(price), 2)          AS avg_item_price,
    ROUND(MIN(price), 2)          AS min_price,
    ROUND(MAX(price), 2)          AS max_price,
    ROUND(AVG(freight_value), 2)  AS avg_freight,
    ROUND(SUM(price), 2)          AS total_revenue
FROM order_items;

-- Top 10 sellers by revenue
SELECT
    seller_id,
    COUNT(*)                     AS items_sold,
    ROUND(SUM(price), 2)         AS total_revenue,
    ROUND(AVG(price), 2)         AS avg_price
FROM order_items
GROUP BY seller_id
ORDER BY total_revenue DESC
LIMIT 10;

--  now we are gong to solve the bussiness problems --  
  

SELECT 'customers'                    AS tbl, COUNT(*) AS rows FROM customers
UNION ALL
SELECT 'orders',                               COUNT(*) FROM orders
UNION ALL
SELECT 'order_items',                          COUNT(*) FROM order_items
UNION ALL
SELECT 'order_payments',                       COUNT(*) FROM order_payments
UNION ALL
SELECT 'order_reviews',                        COUNT(*) FROM order_reviews
UNION ALL
SELECT 'products',                             COUNT(*) FROM products
UNION ALL
SELECT 'sellers',                              COUNT(*) FROM sellers
UNION ALL
SELECT 'geolocation',                          COUNT(*) FROM geolocation
UNION ALL
SELECT 'product_category_name_translation',    COUNT(*) FROM product_category_name_translation
ORDER BY tbl;

-- A EXPLORATORY DATA ANALYSIS (EDA) --

--A1 Date range of the dataset --

select * from orders;
  
select min(order_purchase_timestamp):: date as first_order,
max(order_purchase_timestamp):: date as last_order,
max(order_purchase_timestamp):: date - min(order_purchase_timestamp):: date as days_covered
from orders ;

-- A2. Order status breakdown with %-- 


Select order_status,count(*) as total_orders,
round(100*count(*)/sum(count(*)) over(),2) as percentage
from orders
group by order_status
order by total_orders desc;

-- A3. Delivery success rate --

SELECT
    ROUND(
        100.0 * SUM(CASE WHEN order_status = 'delivered' THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS delivery_rate_pct
FROM orders;

-- A4. Null summary across orders table

select * from orders;

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(order_approved_at) AS null_approved_at,
    COUNT(*) - COUNT(order_delivered_carrier_date) AS null_carrier_date,
    COUNT(*) - COUNT(order_delivered_customer_date) AS null_delivered_date
FROM orders;


-- 	Revenue Analysis --

-- A5 Total revenue, total freight, grand total --

select * from order_items;

SELECT
    ROUND(SUM(price), 2)                        AS product_revenue,
    ROUND(SUM(freight_value), 2)                AS freight_revenue,
    ROUND(SUM(price + freight_value), 2)        AS grand_total,
    ROUND(AVG(price), 2)                        AS avg_item_price,
    ROUND(AVG(freight_value), 2)                AS avg_freight
FROM order_items;

-- A6 Monthly revenue trend  ← great for a line chart in Power BI --

select * from orders;
select * from order_items;

SELECT
    TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM')  AS month,
    COUNT(DISTINCT o.order_id)                       AS total_orders,
    ROUND(SUM(oi.price), 2)                          AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 1 desc; 

-- A7 Revenue by day of week (which day do customers buy most?) --

select to_char(order_purchase_timestamp,'DAY') AS Day_name,
extract(DOW FROM order_purchase_timestamp) AS day_num,
count(*) as total_orders
from orders
group by 1,2
order by 1 desc; -- wednesday max purchase --

-- A8
SELECT
EXTRACT(HOUR FROM order_purchase_timestamp) AS hour_of_day,
COUNT(*) AS total_orders
FROM orders
GROUP BY 1
ORDER BY 2 desc;

--.A9 Average order value (AOV) — a very common interview metric
SELECT
    ROUND(SUM(oi.price) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';

-- A10. Revenue by year and quarter

SELECT
EXTRACT(YEAR  FROM o.order_purchase_timestamp) AS yr,
EXTRACT(QUARTER FROM o.order_purchase_timestamp) AS qtr,
ROUND(SUM(oi.price), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1, 2
ORDER BY 1, 2;

 --  Average time (days) from purchase → approval → dispatch → delivery

 select * from orders;
 
SELECT
    ROUND(AVG(EXTRACT(EPOCH FROM (order_approved_at - order_purchase_timestamp))
              / 86400), 2) AS avg_days_to_approve,
    ROUND(AVG(EXTRACT(EPOCH FROM (order_delivered_carrier_date - order_approved_at))
              / 86400), 2) AS avg_days_to_dispatch,
    ROUND(AVG(EXTRACT(EPOCH FROM (order_delivered_customer_date - order_delivered_carrier_date))
              / 86400), 2) AS avg_days_in_transit,
    ROUND(AVG(EXTRACT(EPOCH FROM (order_delivered_customer_date - order_purchase_timestamp))
              / 86400), 2) AS avg_total_delivery_days
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;

 select distinct order_status from orders;


--  On-time vs late deliveries -- 

select count(*) as total_orders,
sum(case when order_delivered_customer_date <= order_estimated_delivery_date then 1 else 0 end) as on_time_delivry,
sum(case when order_delivered_customer_date > order_estimated_delivery_date then 1 else 0 end) as late_delivry,
round(100*sum(case when order_delivered_customer_date <= order_estimated_delivery_date then 1 else 0 end)/ count(*),2)
as avg_delivery_date
from orders
where order_status = 'delivered'
AND order_delivered_customer_date IS NOT NULL
AND order_estimated_delivery_date IS NOT NULL;




-- Average delay in days (for late orders only)--

SELECT
    ROUND(AVG(
        EXTRACT(EPOCH FROM (order_delivered_customer_date - order_estimated_delivery_date))
        / 86400
    ), 2) AS avg_delay_days
FROM orders
WHERE order_status = 'delivered'
AND order_delivered_customer_date > order_estimated_delivery_date;

--  monthly late delivery trend -- 

SELECT
    TO_CHAR(order_purchase_timestamp, 'YYYY-MM') AS month,
    COUNT(*) AS total_delivered,
    SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date
             THEN 1 ELSE 0 END) AS late_orders,
    ROUND(
        100.0 * SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date
                         THEN 1 ELSE 0 END) / COUNT(*), 2
    ) AS late_pct
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
GROUP BY 1
ORDER BY 1;

--. Delivery time by customer state (which states get fastest delivery?)
SELECT
    c.customer_state,
    COUNT(o.order_id) AS total_orders,
    ROUND(AVG(
        EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_purchase_timestamp))
        / 86400
    ), 2) AS avg_delivery_days
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY 1
ORDER BY avg_delivery_days;

-- -- C3.  CUSTOMER ANALYSIS --


-- C3-a. Total unique customers vs total customer records

select * from customers;

SELECT
    COUNT(customer_id)              AS total_records,
    COUNT(DISTINCT customer_unique_id) AS unique_customers,
	COUNT(customer_id) - COUNT(DISTINCT customer_unique_id) as diff
FROM customers;

-- C3-b. Repeat customers — how many placed more than 1 order?
select * from orders;
select * from customers;
SELECT
    order_count,
    COUNT(*) AS num_customers
FROM (
    SELECT c.customer_unique_id, COUNT(o.order_id) AS order_count
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
) t
GROUP BY order_count
ORDER BY order_count;

-- C3-c. Repeat purchase rate (one of the most asked metrics in interviews)
WITH customer_orders AS (
    SELECT c.customer_unique_id, COUNT(o.order_id) AS order_count
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS total_unique_customers,
    SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) AS repeat_customers,
    ROUND(
        100.0 * SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) / COUNT(*), 2
    ) AS repeat_rate_pct
FROM customer_orders;

-- C3-d. Top 10 cities by number of customers
SELECT
    customer_city,
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM customers
GROUP BY 1, 2
ORDER BY unique_customers DESC
LIMIT 10;

-- C3-e. Top 10 states by revenue  (combine with payments)
SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id)   AS total_orders,
    ROUND(SUM(oi.price), 2)      AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY total_revenue DESC
LIMIT 10;

-- C4.  SELLER ANALYSIS
-- ════════════════════════════════════════════════════════════
 
-- C4-a. Total active sellers (sellers who made at least 1 sale)
SELECT COUNT(DISTINCT seller_id) AS active_sellers
FROM order_items;
 
-- C4-b. Top 10 sellers by revenue
SELECT
    s.seller_id,
    s.seller_city,
    s.seller_state,
    COUNT(oi.order_id)           AS orders_handled,
    ROUND(SUM(oi.price), 2)      AS total_revenue,
    ROUND(AVG(oi.price), 2)      AS avg_item_price
FROM sellers s
JOIN order_items oi ON s.seller_id = oi.seller_id
GROUP BY 1, 2, 3
ORDER BY total_revenue DESC
LIMIT 10;
 
-- C4-c. Seller performance tier  (great for segmentation questions)
WITH seller_revenue AS (
    SELECT
        seller_id,
        ROUND(SUM(price), 2) AS total_revenue
    FROM order_items
    GROUP BY seller_id
)
SELECT
    CASE
        WHEN total_revenue >= 100000 THEN 'Platinum'
        WHEN total_revenue >= 50000  THEN 'Gold'
        WHEN total_revenue >= 10000  THEN 'Silver'
        ELSE                              'Bronze'
    END AS tier,
    COUNT(*) AS num_sellers,
    ROUND(AVG(total_revenue), 2) AS avg_revenue
FROM seller_revenue
GROUP BY 1
ORDER BY avg_revenue DESC;
 
-- C4-d. Average delivery days by seller (identify slow sellers)
SELECT
    oi.seller_id,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(AVG(
        EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_purchase_timestamp))
        / 86400
    ), 2) AS avg_delivery_days
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY 1
HAVING COUNT(DISTINCT o.order_id) >= 50     -- sellers with meaningful volume
ORDER BY avg_delivery_days DESC
LIMIT 15;
 
-- C4-e. Sellers by state
SELECT
    seller_state,
    COUNT(DISTINCT seller_id) AS num_sellers
FROM sellers
GROUP BY 1
ORDER BY num_sellers DESC;

-- C5.  PRODUCT & CATEGORY ANALYSIS
-- ════════════════════════════════════════════════════════════
 
-- C5-a. Top 10 categories by revenue (using English names)
SELECT
    COALESCE(t.product_category_name_english, p.product_category_name, 'Unknown') AS category,
    COUNT(oi.order_item_id)         AS items_sold,
    ROUND(SUM(oi.price), 2)         AS total_revenue,
    ROUND(AVG(oi.price), 2)         AS avg_price
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t
       ON p.product_category_name = t.product_category_name
GROUP BY 1
ORDER BY total_revenue DESC
LIMIT 10;
 
-- C5-b. Top 10 categories by number of orders
SELECT
    COALESCE(t.product_category_name_english, p.product_category_name, 'Unknown') AS category,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t
       ON p.product_category_name = t.product_category_name
GROUP BY 1
ORDER BY total_orders DESC
LIMIT 10;
 
-- C5-c. Top 10 individual products by revenue
SELECT
    oi.product_id,
    COALESCE(t.product_category_name_english, p.product_category_name) AS category,
    COUNT(oi.order_item_id)     AS times_sold,
    ROUND(SUM(oi.price), 2)     AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t
       ON p.product_category_name = t.product_category_name
GROUP BY 1, 2
ORDER BY total_revenue DESC
LIMIT 10;
 
-- C5-d. Average product weight vs average freight (heavier = costlier freight?)
SELECT
    COALESCE(t.product_category_name_english, p.product_category_name) AS category,
    ROUND(AVG(p.product_weight_g), 2)   AS avg_weight_g,
    ROUND(AVG(oi.freight_value), 2)     AS avg_freight
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t
       ON p.product_category_name = t.product_category_name
WHERE p.product_weight_g IS NOT NULL
GROUP BY 1
ORDER BY avg_weight_g DESC
LIMIT 15;

-- C6.  PAYMENT ANALYSIS
-- ════════════════════════════════════════════════════════════
 
-- C6-a. Revenue and transaction count by payment type
SELECT
    payment_type,
    COUNT(*)                        AS transactions,
    ROUND(SUM(payment_value), 2)    AS total_paid,
    ROUND(AVG(payment_value), 2)    AS avg_payment,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_transactions
FROM order_payments
GROUP BY 1
ORDER BY transactions DESC;
 
-- C6-b. Installment behaviour (do high-value orders use more installments?)
SELECT
    payment_installments,
    COUNT(*)                        AS orders,
    ROUND(AVG(payment_value), 2)    AS avg_order_value,
    ROUND(SUM(payment_value), 2)    AS total_value
FROM order_payments
WHERE payment_type = 'credit_card'
GROUP BY 1
ORDER BY 1;
 
-- C6-c. Orders paid with multiple payment methods
SELECT
    order_id,
    COUNT(*) AS payment_methods_used
FROM order_payments
GROUP BY 1
HAVING COUNT(*) > 1
ORDER BY payment_methods_used DESC
LIMIT 10;
 
-- C6-d. Average payment value by customer state
SELECT
    c.customer_state,
    ROUND(AVG(op.payment_value), 2) AS avg_payment
FROM order_payments op
JOIN orders o ON op.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY 1
ORDER BY avg_payment DESC;
 
 
-- ════════════════════════════════════════════════════════════
-- C7.  REVIEW & CUSTOMER SATISFACTION ANALYSIS
-- ════════════════════════════════════════════════════════════
 
-- C7-a. Score distribution with %
SELECT
    review_score,
    COUNT(*) AS total,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct
FROM order_reviews
GROUP BY 1
ORDER BY 1 DESC;
 
-- C7-b. Average review score
SELECT ROUND(AVG(review_score), 2) AS avg_score
FROM order_reviews;
 
-- C7-c. Average score by product category  (which categories satisfy most?)
SELECT
    COALESCE(t.product_category_name_english, p.product_category_name) AS category,
    ROUND(AVG(r.review_score), 2)   AS avg_score,
    COUNT(r.review_id)              AS review_count
FROM order_reviews r
JOIN orders o        ON r.order_id   = o.order_id
JOIN order_items oi  ON o.order_id   = oi.order_id
JOIN products p      ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t
       ON p.product_category_name  = t.product_category_name
GROUP BY 1
HAVING COUNT(r.review_id) >= 100
ORDER BY avg_score DESC
LIMIT 15;
 
-- C7-c. Average score by seller (hold sellers accountable)
SELECT
    oi.seller_id,
    ROUND(AVG(r.review_score), 2) AS avg_score,
    COUNT(r.review_id)            AS total_reviews
FROM order_reviews r
JOIN orders o       ON r.order_id    = o.order_id
JOIN order_items oi ON o.order_id    = oi.order_id
GROUP BY 1
HAVING COUNT(r.review_id) >= 30
ORDER BY avg_score DESC
LIMIT 15;
 
-- C7-d. Response time: how fast does Olist answer reviews?
SELECT
    ROUND(AVG(
        EXTRACT(EPOCH FROM (review_answer_timestamp - review_creation_date))
        / 3600
    ), 2) AS avg_response_hours
FROM order_reviews
WHERE review_answer_timestamp IS NOT NULL;
 
 
-- ════════════════════════════════════════════════════════════
-- C8.  DELIVERY DELAY vs REVIEW SCORE
--      (Shows correlation — very strong interview talking point)
-- ════════════════════════════════════════════════════════════
 
-- C8-a. Average review score: on-time vs late deliveries
SELECT
    CASE
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
        THEN 'On Time'
        ELSE 'Late'
    END AS delivery_status,
    COUNT(*)                          AS total_orders,
    ROUND(AVG(r.review_score), 2)     AS avg_review_score
FROM orders o
JOIN order_reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY 1;
 
-- C8-b. Review score by delay bucket  (deeper dive)
SELECT
    CASE
        WHEN delay_days <= 0           THEN '1. On Time / Early'
        WHEN delay_days BETWEEN 1 AND 3  THEN '2. 1–3 days late'
        WHEN delay_days BETWEEN 4 AND 7  THEN '3. 4–7 days late'
        WHEN delay_days BETWEEN 8 AND 14 THEN '4. 8–14 days late'
        ELSE                                  '5. 15+ days late'
    END AS delay_bucket,
    COUNT(*)                        AS total_orders,
    ROUND(AVG(r.review_score), 2)   AS avg_review_score
FROM (
    SELECT
        o.order_id,
        ROUND(
            EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_estimated_delivery_date))
            / 86400
        ) AS delay_days
    FROM orders o
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
) delays
JOIN order_reviews r ON delays.order_id = r.order_id
GROUP BY 1
ORDER BY 1;
 
 
-- ════════════════════════════════════════════════════════════
-- C9.  RFM ANALYSIS
--      Recency · Frequency · Monetary
--      (Most asked segmentation in DA interviews)
-- ════════════════════════════════════════════════════════════
 
-- Step 1: Calculate raw RFM values per customer
WITH rfm_base AS (
    SELECT
        c.customer_unique_id,
        MAX(o.order_purchase_timestamp)::DATE          AS last_purchase_date,
        COUNT(DISTINCT o.order_id)                     AS frequency,
        ROUND(SUM(oi.price), 2)                        AS monetary,
        (SELECT MAX(order_purchase_timestamp)::DATE FROM orders) AS max_date
    FROM customers c
    JOIN orders o     ON c.customer_id  = o.customer_id
    JOIN order_items oi ON o.order_id   = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
 
-- Step 2: Score R, F, M from 1 to 4 using NTILE
rfm_scores AS (
    SELECT
        customer_unique_id,
        last_purchase_date,
        frequency,
        monetary,
        max_date - last_purchase_date                  AS recency_days,
        NTILE(4) OVER (ORDER BY max_date - last_purchase_date DESC) AS r_score, -- lower recency = higher score
        NTILE(4) OVER (ORDER BY frequency ASC)          AS f_score,
        NTILE(4) OVER (ORDER BY monetary  ASC)          AS m_score
    FROM rfm_base
),
 
-- Step 3: Combine scores into a segment
rfm_segments AS (
    SELECT *,
        CONCAT(r_score, f_score, m_score) AS rfm_code,
        r_score + f_score + m_score       AS rfm_total
    FROM rfm_scores
)
 
-- Step 4: Label segments
SELECT
    CASE
        WHEN rfm_total >= 11 THEN 'Champions'
        WHEN rfm_total >= 9  THEN 'Loyal Customers'
        WHEN rfm_total >= 7  THEN 'Potential Loyalists'
        WHEN r_score >= 3 AND f_score <= 2 THEN 'New Customers'
        WHEN r_score <= 2 AND f_score >= 3 THEN 'At Risk'
        WHEN r_score = 1 AND f_score = 1   THEN 'Lost Customers'
        ELSE 'Need Attention'
    END AS segment,
    COUNT(*)                        AS num_customers,
    ROUND(AVG(recency_days), 0)     AS avg_recency_days,
    ROUND(AVG(frequency), 2)        AS avg_frequency,
    ROUND(AVG(monetary), 2)         AS avg_monetary
FROM rfm_segments
GROUP BY 1
ORDER BY avg_monetary DESC;
 
 
-- ════════════════════════════════════════════════════════════
-- C10. MONTHLY COHORT SNAPSHOT
--      Which month did a customer place their FIRST order?
--      How much did each cohort spend?
-- ════════════════════════════════════════════════════════════
 
WITH first_order AS (
    SELECT
        c.customer_unique_id,
        MIN(TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM')) AS cohort_month
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
),
cohort_revenue AS (
    SELECT
        f.cohort_month,
        COUNT(DISTINCT f.customer_unique_id)    AS cohort_size,
        ROUND(SUM(oi.price), 2)                 AS total_revenue,
        ROUND(AVG(oi.price), 2)                 AS avg_revenue_per_item
    FROM first_order f
    JOIN customers c   ON f.customer_unique_id = c.customer_unique_id
    JOIN orders o      ON c.customer_id         = o.customer_id
    JOIN order_items oi ON o.order_id           = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY f.cohort_month
)
SELECT *
FROM cohort_revenue
ORDER BY cohort_month;
 
 
-- ════════════════════════════════════════════════════════════
-- BONUS: CROSS-TABLE BUSINESS SUMMARY
-- A single query to show the full picture — great for README
-- ════════════════════════════════════════════════════════════
SELECT
    COUNT(DISTINCT c.customer_unique_id)            AS unique_customers,
    COUNT(DISTINCT o.order_id)                      AS total_orders,
    COUNT(DISTINCT oi.seller_id)                    AS active_sellers,
    COUNT(DISTINCT p.product_id)                    AS unique_products,
    ROUND(SUM(oi.price), 2)                         AS total_product_revenue,
    ROUND(SUM(oi.freight_value), 2)                 AS total_freight,
    ROUND(SUM(oi.price + oi.freight_value), 2)      AS grand_total_revenue,
    ROUND(AVG(r.review_score), 2)                   AS avg_review_score,
    ROUND(
        100.0 * SUM(CASE WHEN o.order_status = 'delivered' THEN 1 ELSE 0 END)
        / COUNT(DISTINCT o.order_id), 2
    )                                               AS delivery_rate_pct
FROM orders o
JOIN customers c    ON o.customer_id   = c.customer_id
JOIN order_items oi ON o.order_id      = oi.order_id
JOIN products p     ON oi.product_id   = p.product_id
LEFT JOIN order_reviews r ON o.order_id = r.order_id;

-- ════════════════════════════════════════════════════════════
-- C11. MONTH-OVER-MONTH REVENUE GROWTH
-- ════════════════════════════════════════════════════════════

WITH monthly_revenue AS (
    SELECT
        TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS month,
        ROUND(SUM(oi.price), 2)                        AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1
)
SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month)        AS prev_month_revenue,
    ROUND(
        100.0 * (revenue - LAG(revenue) OVER (ORDER BY month))
        / LAG(revenue) OVER (ORDER BY month), 2
    )                                          AS mom_growth_pct
FROM monthly_revenue
ORDER BY month;


 -- ════════════════════════════════════════════════════════════
-- C12. CUSTOMER LIFETIME VALUE (CLV)
-- ════════════════════════════════════════════════════════════

-- C12-a. CLV per customer (full detail)
WITH clv_base AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id)              AS total_orders,
        ROUND(SUM(oi.price), 2)                 AS total_spent,
        ROUND(AVG(oi.price), 2)                 AS avg_item_value,
        MIN(o.order_purchase_timestamp)::DATE   AS first_order_date,
        MAX(o.order_purchase_timestamp)::DATE   AS last_order_date,
        MAX(o.order_purchase_timestamp)::DATE -
        MIN(o.order_purchase_timestamp)::DATE   AS customer_lifespan_days
    FROM customers c
    JOIN orders o      ON c.customer_id  = o.customer_id
    JOIN order_items oi ON o.order_id    = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    customer_unique_id,
    total_orders,
    total_spent,
    avg_item_value,
    first_order_date,
    last_order_date,
    customer_lifespan_days
FROM clv_base
ORDER BY total_spent DESC
LIMIT 20;


-- C12-b. CLV tier segmentation
WITH clv_base AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id)   AS total_orders,
        ROUND(SUM(oi.price), 2)      AS total_spent
    FROM customers c
    JOIN orders o       ON c.customer_id  = o.customer_id
    JOIN order_items oi ON o.order_id     = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    CASE
        WHEN total_spent >= 5000 THEN 'Platinum — Top Spender'
        WHEN total_spent >= 1000 THEN 'Gold — High Value'
        WHEN total_spent >= 500  THEN 'Silver — Mid Value'
        ELSE                          'Bronze — Low Value'
    END                          AS clv_tier,
    COUNT(*)                     AS num_customers,
    ROUND(AVG(total_spent), 2)   AS avg_lifetime_value,
    ROUND(SUM(total_spent), 2)   AS total_revenue_from_tier
FROM clv_base
GROUP BY 1
ORDER BY avg_lifetime_value DESC;


-- C12-c. Average CLV across all customers (the headline number)
WITH clv_base AS (
    SELECT
        c.customer_unique_id,
        ROUND(SUM(oi.price), 2) AS total_spent
    FROM customers c
    JOIN orders o       ON c.customer_id  = o.customer_id
    JOIN order_items oi ON o.order_id     = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*)                     AS total_customers,
    ROUND(AVG(total_spent), 2)   AS avg_clv,
    ROUND(MIN(total_spent), 2)   AS min_clv,
    ROUND(MAX(total_spent), 2)   AS max_clv,
    ROUND(SUM(total_spent), 2)   AS total_revenue
FROM clv_base;

-- ════════════════════════════════════════════════════════════
-- C13. CHURN RISK ANALYSIS
-- ════════════════════════════════════════════════════════════

-- C13-a. Days since last order per customer
WITH last_purchase AS (
    SELECT
        c.customer_unique_id,
        MAX(o.order_purchase_timestamp)::DATE   AS last_order_date,
        COUNT(DISTINCT o.order_id)              AS total_orders,
        ROUND(SUM(oi.price), 2)                 AS total_spent,
        (SELECT MAX(order_purchase_timestamp)::DATE
         FROM orders)                           AS snapshot_date
    FROM customers c
    JOIN orders o       ON c.customer_id  = o.customer_id
    JOIN order_items oi ON o.order_id     = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    customer_unique_id,
    last_order_date,
    snapshot_date - last_order_date      AS days_inactive,
    total_orders,
    total_spent,
    CASE
        WHEN snapshot_date - last_order_date >= 365 THEN 'Lost'
        WHEN snapshot_date - last_order_date >= 180 THEN 'High Risk'
        WHEN snapshot_date - last_order_date >= 90  THEN 'Medium Risk'
        ELSE                                              'Active'
    END                                  AS churn_risk
FROM last_purchase
ORDER BY days_inactive DESC;


-- C13-b. Churn risk summary (how many customers in each bucket?)
WITH last_purchase AS (
    SELECT
        c.customer_unique_id,
        MAX(o.order_purchase_timestamp)::DATE AS last_order_date,
        ROUND(SUM(oi.price), 2)               AS total_spent,
        (SELECT MAX(order_purchase_timestamp)::DATE FROM orders) AS snapshot_date
    FROM customers c
    JOIN orders o       ON c.customer_id  = o.customer_id
    JOIN order_items oi ON o.order_id     = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
churn_classified AS (
    SELECT
        customer_unique_id,
        total_spent,
        snapshot_date - last_order_date AS days_inactive
    FROM last_purchase
),
churn_labelled AS (
    SELECT
        customer_unique_id,
        total_spent,
        days_inactive,
        CASE
            WHEN days_inactive >= 365 THEN 'Lost'
            WHEN days_inactive >= 180 THEN 'High Risk'
            WHEN days_inactive >= 90  THEN 'Medium Risk'
            ELSE                           'Active'
        END AS churn_risk,
        CASE
            WHEN days_inactive >= 365 THEN 1
            WHEN days_inactive >= 180 THEN 2
            WHEN days_inactive >= 90  THEN 3
            ELSE 4
        END AS sort_order
    FROM churn_classified
)
SELECT
    churn_risk,
    COUNT(*)                        AS num_customers,
    ROUND(AVG(total_spent), 2)      AS avg_lifetime_value,
    ROUND(SUM(total_spent), 2)      AS total_revenue_at_risk
FROM churn_labelled
GROUP BY churn_risk, sort_order
ORDER BY sort_order;