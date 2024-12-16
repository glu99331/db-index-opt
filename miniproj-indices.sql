USE ECommerceDB;

EXPLAIN ANALYZE
SELECT
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp,
    p.product_id,
    p.product_category_name,
    oi.price,
    oi.freight_value
FROM
    olist_orders_dataset o
JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
JOIN olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
WHERE
    c.customer_unique_id = '8d50f5eadf50201ccdcedfb9e2ac8455'
ORDER BY o.order_purchase_timestamp DESC;

-- Sort: o.order_purchase_timestamp DESC  (actual time=141..141 rows=16 loops=1)
--    -> Stream results  (cost=22161 rows=11327) (actual time=8.99..141 rows=16 loops=1)
--        -> Nested loop inner join  (cost=22161 rows=11327) (actual time=8.98..141 rows=16 loops=1)
--            -> Nested loop inner join  (cost=18196 rows=11327) (actual time=8.97..141 rows=16 loops=1)
--                -> Nested loop inner join  (cost=14573 rows=9962) (actual time=8.95..141 rows=17 loops=1)
--                    -> Filter: (c.customer_unique_id = \'8d50f5eadf50201ccdcedfb9e2ac8455\')  (cost=11086 rows=9962) (actual time=8.44..138 rows=17 loops=1)
--                        -> Table scan on c  (cost=11086 rows=99622) (actual time=0.809..133 rows=99163 loops=1)
--                   -> Index lookup on o using customer_id (customer_id=c.customer_id)  (cost=0.25 rows=1) (actual time=0.146..0.147 rows=1 loops=17)
--                -> Index lookup on oi using PRIMARY (order_id=o.order_id)  (cost=0.25 rows=1.14) (actual time=0.00937..0.0103 rows=0.941 loops=17)
--            -> Single-row index lookup on p using PRIMARY (product_id=oi.product_id)  (cost=0.25 rows=1) (actual time=0.00486..0.00487 rows=1 loops=16)

-- This query relies heavily on nested loops, in particular lots of nested loop inner joins. 
-- The filter on c.customer_unique_id triggers a full table scan on the olist_customers_dataset table resulting in scanning 99,622 rows

-- We can create indices on the join condition variables: order_id, product_id, customer_id
-- We also create one on customer_unique_id to avoid the full table scan:
CREATE INDEX idx_customer_unique_id ON olist_customers_dataset (customer_unique_id);
CREATE INDEX idx_orders_customer_id ON olist_orders_dataset (customer_id);
CREATE INDEX idx_order_items_order_id ON olist_order_items_dataset (order_id);
CREATE INDEX idx_products_product_id ON olist_products_dataset (product_id);

-- We can also apply Push Down Filters to filter the data as much as possible before the joins to reduce the number of processed records. 
-- So, rather than filtering on customer_unique_id, filter on customers first, but necessary for this task.
EXPLAIN ANALYZE
SELECT
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp,
    p.product_id,
    p.product_category_name,
    oi.price,
    oi.freight_value
FROM
    olist_orders_dataset o
JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
JOIN olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
WHERE
    c.customer_unique_id = '8d50f5eadf50201ccdcedfb9e2ac8455'
ORDER BY o.order_purchase_timestamp DESC;
-- Sort: o.order_purchase_timestamp DESC  (actual time=3.04..3.05 rows=16 loops=1)
--    -> Stream results  (cost=23.8 rows=19.3) (actual time=0.396..2.99 rows=16 loops=1)
--       -> Nested loop inner join  (cost=23.8 rows=19.3) (actual time=0.387..2.96 rows=16 loops=1)
--            -> Nested loop inner join  (cost=17.1 rows=19.3) (actual time=0.369..2.84 rows=16 loops=1)
--                -> Nested loop inner join  (cost=9.13 rows=17) (actual time=0.337..2.64 rows=17 loops=1)
--                    -> Filter: (c.customer_unique_id = \'8d50f5eadf50201ccdcedfb9e2ac8455\')  (cost=3.18 rows=17) (actual time=0.0233..0.0478 rows=17 loops=1)
--                        -> Covering index lookup on c using idx_customer_unique_id (customer_unique_id=\'8d50f5eadf50201ccdcedfb9e2ac8455\')  (cost=3.18 rows=17) (actual time=0.0202..0.0307 rows=17 loops=1)
--                    -> Index lookup on o using idx_orders_customer_id (customer_id=c.customer_id)  (cost=0.256 rows=1) (actual time=0.152..0.152 rows=1 loops=17)
--                -> Index lookup on oi using PRIMARY (order_id=o.order_id)  (cost=0.36 rows=1.14) (actual time=0.0102..0.011 rows=0.941 loops=17)
--            -> Single-row index lookup on p using PRIMARY (product_id=oi.product_id)  (cost=0.255 rows=1) (actual time=0.00729..0.00732 rows=1 loops=16)
