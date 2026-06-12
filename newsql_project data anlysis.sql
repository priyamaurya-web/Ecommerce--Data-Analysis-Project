--  E-COMMERCE SALES DATA ANALYSIS PROJECT
--  Dataset: 31,047 orders | India | Jan–Dec 2022
--  Columns: cust_id, gender, age, date, status, channel,
--           category, size, qty, currency, amount,
--           ship_city, ship_state, ship_country, b2b

-- SCHEMA SETUP
CREATE TABLE orders (
    cust_id      BIGINT,
    gender       VARCHAR(10),
    age          INT,
    date         DATE,
    status       VARCHAR(20),
    channel      VARCHAR(20),
    category     VARCHAR(30),
    size         VARCHAR(10),
    qty          INT,
    currency     VARCHAR(5),
    amount       INT,
    ship_city    VARCHAR(100),
    ship_state   VARCHAR(100),
    ship_country VARCHAR(50),
    b2b          BOOLEAN
);

-- "Amazon and Flipkart together account for the majority
--  of total revenue compared to other channels."

select 
     channel,
	 count(*) as total_orders, 
	 sum(amount) as total_revenue,
	 ROUND(SUM(amount) * 100.0 / SUM(SUM(amount)) OVER (),2) as revenue_share_pct
from  dataset
group by channel
ORDER BY total_revenue DESC;


-- Women generate significantly more revenue than Men.

select gender,
     count(*) as total_orders,
     sum(amount) as total_revenue ,
	 ROUND(avg(amount) , 2) as avg_order_value
from dataset
group by gender
order by total_revenue DESC ;


 ---The 26–35 age group (young adults) places the most orders.

 select 
     case
	    when age between 18 and 25 then '18-25'
		when age between  26 and 35 then '26-35'
		when age between 36 and 45 then '36-45'
		when age between 46 and 55 then '46-55'
		when age between 56 and 65 then '56-65'
		else '66+'
	end as age_group,
	count(*) as total_orders,
	sum(amount ) as total_revenue,
	round(avg(amount), 2) as avg_order_value
from dataset
group by age_group
order by total_orders DESC;



-- Find  the top-performing state by revenue.
select 
    ship_state,
	count(*) as total_orders,
	sum(amount) as total_revenue
from dataset
group by ship_state
order by total_revenue DESC;
	

--- Find the best-selling category by volume and revenue.

select 
    category,
	count(*) as total_orders,
	sum(qty) as total_units_sold,
	sum(amount) as total_revenue,
	round(avg(amount) , 2) as avg_selling_price
from dataset
group by category
order by total_revenue DESC;


--- Find the cancellation and return rate by channel.
select
    channel,
	count(*) as total_orders,
	sum(case when status ='Cancelled' then 1 else 0 end) as cancelled,
	sum(case when status ='Returned' then 1 else 0 end) as returned,
	round((sum(case when status in ('Cancelled' ,'Returned') then 1 else 0 end)
	*100.0) / count(*), 2) as cancel_return_rate_pct
from dataset
group by channel
order by cancel_return_rate_pct DESC ;

		
-- Find top sales month by revenue and volume .
select
    extract (month from date) as month_num,
	to_char(date, 'Mon YYYY') as month,
	count(*) as total_orders,
	sum(amount) as total_revenue
from dataset
group by month_num , month
order by month_num;


---Find higher order_type by volume and revenue .

select 
  case when b2b then 'B2B' else 'B2C' end as order_type,
  count(*) as total_orders,
  sum(amount) as total_revenue,
  round(avg(amount) , 2) as avg_order_value,
  max(amount) as max_order_value
from dataset
group by b2b;


-- Find  the most ordered sizes.
select 
    size,count(*) as total_orders,
	sum(amount) as total_revenue
from dataset
group by size
order by  total_orders DESC ;


-- Find Older customers preferences category-wise and volume .
select
    case 
	   when age < 35 then 'Under 35'
	   when age between 35 and 54 then '35-54'
	   else '55+'
	 end as age_group,
	 category,
	 count(*)  as total_orders
from dataset
group by age_group , category
order by age_group , total_orders DESC;


----Delivered orders make up more than 80% of all orders.
select
    status,
	count(*) as total_orders,
	round(count(*) * 100.0 / sum(count(*)) over() , 2) as pct_of_total
from dataset
group by status
order by total_orders DESC ;

---- Find  the highest-spending customer segment (gender × age group).
select 
     gender ,
	 case
	   when age between 18 and 25 then '18-25'
	   when age between 26 and 35 then '26-35'
	   when age between 36 and 45 then '36-45'
	   when age between 46 and 55 then '46-55'
	   else '56+'
	 end as age_group,
	 count(*) as total_orders,
	 sum(amount) as total_revenue,
	 round(avg(amount) ,2) as avg_order_value
from dataset
group by gender, age_group
order by total_revenue DESC
LIMIT 5 ;

--- Channels differ significantly in average order value —
select 
    channel,
	round(avg(amount) , 2) as avg_order_value,
	round(avg(amount) - avg(avg(amount)) over() ,2) as diff_from_overall_avg
from dataset
group by channel
order by avg_order_value DESC;

--Find top performing  states in order volume.
select
    case
        when ship_state in  ('KARNATAKA','TAMIL NADU','TELANGANA','ANDHRA PRADESH','KERALA')
            then 'South India'
        when ship_state in ('UTTAR PRADESH','RAJASTHAN','PUNJAB','HARYANA','DELHI',
                            'MADHYA PRADESH','UTTARAKHAND','HIMACHAL PRADESH','BIHAR')
            then 'North India'
        when ship_state in  ('MAHARASHTRA','GOA','GUJARAT')
            then'West India'
        when ship_state in ('WEST BENGAL','ODISHA','JHARKHAND','CHHATTISGARH','ASSAM')
            then 'East/NE India'
        else 'Other'
    end  as region,
    count (*) as total_orders,
    sum(amount)as total_revenue
from dataset
group by region
order by  total_orders DESC;

 ----BONUS: EXECUTIVE SUMMARY VIEW
-- Overall KPIs in one shot
select
    count(*)   as total_orders,                                                           
    count(distinct cust_id) as unique_customers,
    sum(amount) as gross_revenue_inr,
    round (avg(amount), 2)as avg_order_value,
    sum(case when status = 'Delivered'  then 1 else 0 end) as delivered,
    sum(case when status = 'Cancelled'  THEN 1 else 0 end) as cancelled,
    sum(case when  status = 'Returned'   THEN 1 else 0 end) as returned,
    sum(case when status = 'Refunded'   THEN 1 else 0 end) as refunded,
    round(
        sum(case when status in('Cancelled','Returned') then 1 else 0 end)
        * 100.0 / count(*), 2
    )as cancel_return_rate_pct  
from dataset;



 


	
	

 






	 






















