use magist;
/*Explore the tables:*/

/* 1-How many orders are there in the dataset?*/
SELECT 
    COUNT(order_id) AS number_orders
FROM
    orders;
/* there is 99441 orders in the dataset*/

/*2-Are orders actually delivered?*/
SELECT 
    order_status, COUNT(order_status) AS order_count
FROM
    orders
GROUP BY order_status;
/*there is 96478 delivered order*/

/*3-Is Magist having user growth?*/
SELECT 
    YEAR(order_purchase_timestamp) AS year_y,
    MONTH(order_purchase_timestamp) AS month_m,
    COUNT(customer_id)
FROM
    orders
GROUP BY year_y , month_m
ORDER BY year_y , month_m;
/* since 2017, the number of Magist customers is increasing significantly but since august 2018 it shows a descrease*/

/*4-How many products are there on the products table?*/
SELECT 
    COUNT(DISTINCT product_id) AS products_num
FROM
    products;
/* there are 32951 products*/

/*5-Which are the categories with the most products?*/
SELECT 
    COUNT(DISTINCT product_id) AS product_numb,
    product_category_name
FROM
    products
GROUP BY product_category_name
ORDER BY product_numb DESC limit 5;
/*cama_mesa_banho ,esporte_lazer,moveis_decoracao are the categories with the most number of products.*/

/*6-How many of those products were present in actual transactions?*/
SELECT 
    COUNT(DISTINCT product_id)
FROM
    order_items;
/*all the 32951 products were present in actual transactions.*/

/*7-What’s the price for the most expensive and cheapest products?*/
select 
max(price) as max_price, min(price) as min_price 
from order_items;
/* the most expensive product costs 6735, and the cheapest product costs 0,85.*/

/*8-What are the highest and lowest payment values?*/
select
max(payment_value) , min(payment_value)
from order_payments;
/* the highest payment value is 13664,1 and the lowest payment value is 0.*/


/*Answer business questions:*/
/*1-In relation to the products:*/
/*1.1-What categories of tech products does Magist have?*/
SELECT DISTINCT
    product_category_name AS tech_category
FROM
    product_category_name_translation
WHERE
    product_category_name_english IN (
'air_conditioning',
'audio',
'cds_dvds_musicals',
'cine_photo',
'computers',
'computers_accessories',
'consoles_games',
'dvds_blu_ray',
'electronics',
'fixed_telephony',
'home_appliances',
'home_appliances_2',
'music',
'musical_instruments',
'portable_kitchen_food_processors',
'pc_gamer',
'security_and_services',
'signaling_and_security',
'small_appliances',
'small_appliances_home_oven_and_coffee',
'tablets_printing_image',
'telephony',
'watches_gifts');

/*1-2-How many products of these tech categories have been sold (within the time window of the database snapshot)? What percentage does that represent from the overall number of products sold?*/
select
count( oi.product_id ) as sold_tech_products
FROM
   order_items oi
join products p
using (product_id)
join orders
using (order_id)

WHERE
    product_category_name IN (
'audio',
'cds_dvds_musicais',
'cine_foto',
'climatizacao',
'consoles_games',
'dvds_blu_ray',
'eletrodomesticos',
'eletrodomesticos_2',
'eletronicos',
'eletroportateis',
'informatica_acessorios',
'instrumentos_musicais',
'musica',
'pc_gamer',
'pcs',
'portateis_casa_forno_e_cafe',
'portateis_cozinha_e_preparadores_de_alimentos',
'relogios_presentes',
'seguros_e_servicos',
'sinalizacao_e_seguranca',
'tablets_impressao_imagem',
'telefonia',
'telefonia_fixa') and order_status in ('delivered','shipped','approved');
SELECT 
    COUNT( product_id)
FROM
    order_items;
/*25985 products from the tech categories have been sold . and we have already found out that there is 112.650 solded product.*/
select 
(25985/112650)*100;
/* so the tech products solded are 23% from the overall solded products.*/

/*1.3-What’s the average price of the products being sold?*/
select round(avg(price)) as avg_price_sold_product
from order_items;
/* the average price of the products being sold is 121.*/

/*1.4-Are expensive tech products popular?*/
select
count(oi.product_id) as exp_tech_product,
case when count(oi.product_id) >10000 then "expensive tech products are popular"
	else "expensive tech products are not popular"
 end as exp_tech_products_sale_rating
 from order_items oi
 join products p
 using (product_id)

WHERE     product_category_name IN (
'audio',
'cds_dvds_musicais',
'cine_foto',
'climatizacao',
'consoles_games',
'dvds_blu_ray',
'eletrodomesticos',
'eletrodomesticos_2',
'eletronicos',
'eletroportateis',
'informatica_acessorios',
'instrumentos_musicais',
'musica',
'pc_gamer',
'pcs',
'portateis_casa_forno_e_cafe',
'portateis_cozinha_e_preparadores_de_alimentos',
'relogios_presentes',
'seguros_e_servicos',
'sinalizacao_e_seguranca',
'tablets_impressao_imagem',
'telefonia',
'telefonia_fixa') and price> 300;
/* 8671 tech product with price more then 120 were been sold. we can definitely say that the expensive tech products are popular.*/
/*2-In relation to the sellers:*/

/*2.1-How many months of data are included in the magist database?*/
select 
TIMESTAMPDIFF(month, min(order_purchase_timestamp),max(order_purchase_timestamp)) as number_mounth
from orders; 
/* the number of months of data included in the magist database are 25 mounths.*/

/*2.2-How many sellers are there? How many Tech sellers are there? What percentage of overall sellers are Tech sellers?*/
select count(distinct seller_id) as number_sellers from sellers;
/* there are 3095 sellers.*/
SELECT 
    COUNT(DISTINCT s.seller_id) AS tech_sellers
FROM
    sellers s
        LEFT JOIN
    order_items oi USING (seller_id)
        LEFT JOIN
    products USING (product_id)
WHERE
    product_category_name IN (
'audio',
'cds_dvds_musicais',
'cine_foto',
'climatizacao',
'consoles_games',
'dvds_blu_ray',
'eletrodomesticos',
'eletrodomesticos_2',
'eletronicos',
'eletroportateis',
'informatica_acessorios',
'instrumentos_musicais',
'musica',
'pc_gamer',
'pcs',
'portateis_casa_forno_e_cafe',
'portateis_cozinha_e_preparadores_de_alimentos',
'relogios_presentes',
'seguros_e_servicos',
'sinalizacao_e_seguranca',
'tablets_impressao_imagem',
'telefonia',
'telefonia_fixa');
/* there is 790 tech_sellers.*/
select (790/3095)*100;
/* the tch sellers are 25,52% from the sellers.*/
/*2.3-What is the total amount earned by all sellers? What is the total amount earned by all Tech sellers?*/
select sum(price)-sum(freight_value) as total_earned
from order_items; 
/* the total earned by all the sellers  is 11.339.734 .*/
select sum(price)-sum(freight_value) as tech_seller_earn
from order_items 
 JOIN
    products USING (product_id)
WHERE
    product_category_name IN (
'audio',
'cds_dvds_musicais',
'cine_foto',
'climatizacao',
'consoles_games',
'dvds_blu_ray',
'eletrodomesticos',
'eletrodomesticos_2',
'eletronicos',
'eletroportateis',
'informatica_acessorios',
'instrumentos_musicais',
'musica',
'pc_gamer',
'pcs',
'portateis_casa_forno_e_cafe',
'portateis_cozinha_e_preparadores_de_alimentos',
'relogios_presentes',
'seguros_e_servicos',
'sinalizacao_e_seguranca',
'tablets_impressao_imagem',
'telefonia',
'telefonia_fixa');
	/* total earned by tech sellers is 3.337.299.*/
    select (3337299/11339734)*100;
/* the tech sellers earn 29.4% from the total earned .*/

/*4.2-Can you work out the average monthly income of all sellers? Can you work out the average monthly income of Tech sellers?*/
SELECT 
    (SUM(price) - SUM(freight_value)) / (TIMESTAMPDIFF(MONTH,
        MIN(order_purchase_timestamp),
        MAX(order_purchase_timestamp))) AS avg_monthly_earnings
FROM
    order_items
        LEFT JOIN
    orders USING (order_id);
/*the average monthly income of all sellers is 493.031 .*/
SELECT 
    (SUM(price) - SUM(freight_value)) / (TIMESTAMPDIFF(MONTH,
        MIN(order_purchase_timestamp),
        MAX(order_purchase_timestamp))) AS avg_monthly_earnings_tech
FROM
    order_items
        LEFT JOIN
    orders USING (order_id)
    join  products USING (product_id)
WHERE
    product_category_name IN (
'audio',
'cds_dvds_musicais',
'cine_foto',
'climatizacao',
'consoles_games',
'dvds_blu_ray',
'eletrodomesticos',
'eletrodomesticos_2',
'eletronicos',
'eletroportateis',
'informatica_acessorios',
'instrumentos_musicais',
'musica',
'pc_gamer',
'pcs',
'portateis_casa_forno_e_cafe',
'portateis_cozinha_e_preparadores_de_alimentos',
'relogios_presentes',
'seguros_e_servicos',
'sinalizacao_e_seguranca',
'tablets_impressao_imagem',
'telefonia',
'telefonia_fixa');
/* the average monthly income of Tech sellers is 145.099
.*/

/*3-In relation to the delivery time*/
/*3.1-What’s the average time between the order being placed and the product being delivered?*/
select avg(datediff(order_delivered_customer_date,order_purchase_timestamp)) as avg_time_delivery
from orders;
/*the average time between the order being placed and the product being delivered is 12.5 days.*/

/*3.2-How many orders are delivered on time vs orders delivered with a delay?*/
select count(order_id),
case when date(order_delivered_customer_date)< date(order_estimated_delivery_date) then "delivered before estimated time"
when date(order_delivered_customer_date)= date(order_estimated_delivery_date) then "delivered on time"
else "delayed"
end as "delivery_time"
from orders
where order_status="delivered"
group by delivery_time;
/* we can see that most of the orders are delivered even before the estimated time 88471 order.*/


/*3.3-Is there any pattern for delayed orders, e.g. big products being delayed more often?*/

select
case when (product_weight_g) < 500 then "very light weight" 
when (product_weight_g) < 1000 then  "light weight"
when (product_weight_g) < 5000 then "medium weight"
when (product_weight_g) < 10000 then  "heavy weight"
else  "very heavy weight" 
end as group_per_weight , count(o.order_id)
from products
join order_items
using (product_id)
join orders o
using (order_id)
where date(order_delivered_customer_date)> date(order_estimated_delivery_date)
group by group_per_weight
;














