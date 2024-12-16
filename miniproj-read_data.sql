LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/filtered_geolocation.csv'
INTO TABLE ecommercedb.olist_geolocation_dataset
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/filtered_olist_customers_dataset.csv'
INTO TABLE ecommercedb.olist_customers_dataset
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/filtered_olist_sellers_dataset.csv'
INTO TABLE ecommercedb.olist_sellers_dataset
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cleaned_olist_products_dataset.csv'
INTO TABLE ecommercedb.olist_products_dataset
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/filtered_olist_orders_dataset.csv'
INTO TABLE ecommercedb.olist_orders_dataset
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/filtered_olist_order_payments_dataset.csv'
INTO TABLE ecommercedb.olist_order_payments_dataset
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/filtered_olist_order_items_dataset.csv'
INTO TABLE ecommercedb.olist_order_items_dataset
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/filtered_olist_order_reviews_dataset.csv'
INTO TABLE ecommercedb.olist_order_reviews_dataset
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SHOW WARNINGS;

SHOW VARIABLES LIKE 'secure_file_priv';