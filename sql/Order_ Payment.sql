select * from completedorder; 

-- Most common k_symbol payments
select distinct(k_symbol)
from completedorder;


select 
k_symbol,
count(*) as no_of_orders
from completedorder 
group by k_symbol
order by no_of_orders desc; 

select 
k_symbol,
count(*) as no_of_orders,
round(count(*) * 100 / (select count(*) from completedorder),2) as percentage
from completedorder 
group by k_symbol
order by no_of_orders desc; 


-- Average transfer amount
select avg(amount) 
from completedorder ; 

-- Avergae transfer amount for each k_symbon 
select k_symbol,
avg(amount) as avg_amount
from completedorder 
group by k_symbol
order by avg_amount desc;


select 
k_symbol,
COUNT(*) AS total_orders,
avg(amount) as avg_amount
from completedorder 
group by k_symbol
order by avg_amount desc;


-- Account-to-account relationships
select 
account_id,
account_to,
count(*) as number_of_orders 
from completedorder
group by account_id,account_to 
having number_of_orders > 1; 


-- Top payers 
select
account_id,
count(*)  as  number_of_times_sent
from completedorder
group by account_id
order  by number_of_times_sent desc;


-- no of account having hightes orders 
SELECT COUNT(*) AS accounts_with_max_orders
FROM (
    SELECT account_id, COUNT(*) AS number_of_times_sent
    FROM CompletedOrder
    GROUP BY account_id
) AS sub
WHERE number_of_times_sent = (
    SELECT MAX(order_count)
    FROM (
        SELECT COUNT(*) AS order_count
        FROM CompletedOrder
        GROUP BY account_id
    ) AS inner_sub
);


-- -- no of account having hightes orders 
WITH order_counts AS (
    SELECT account_id, COUNT(*) AS number_of_times_sent
    FROM CompletedOrder
    GROUP BY account_id
),
max_orders AS (
    SELECT MAX(number_of_times_sent) AS max_order_count
    FROM order_counts
)
SELECT 
    m.max_order_count,
    COUNT(*) AS number_of_accounts
FROM order_counts o
JOIN max_orders m
  ON o.number_of_times_sent = m.max_order_count
GROUP BY m.max_order_count;


-- top receiver accounts 
select 
account_to , 
count(*) as no_of_order 
from completedorder 
group  by account_to 
having no_of_order > 1
order by no_of_order ; 


-- -- no of receiver account having hightes orders 
WITH order_counts AS (
    SELECT account_to, COUNT(*) AS number_of_times_sent
    FROM CompletedOrder
    GROUP BY account_to
),
max_orders AS (
    SELECT MAX(number_of_times_sent) AS max_order_count
    FROM order_counts
)
SELECT 
    m.max_order_count,
    COUNT(*) AS number_of_accounts
FROM order_counts o
JOIN max_orders m
  ON o.number_of_times_sent = m.max_order_count
GROUP BY m.max_order_count;

-- Region-wise transfer volume
select 
cd.region, 
sum(co.amount) as total_transaction,
count(*) as  no_of_orders
from completedorder co 
join completedaccounts ca on ca.account_id = co.account_id
join completeddistrict cd on cd.district_id = ca.district_id
group by region 
order by total_transaction desc; 

-- -- Region-wise transfer volume
select 
cd.region, 
sum(co.amount) as total_transaction,
count(*) as  no_of_orders,
ROUND(SUM(co.amount) / COUNT(*), 2) AS avg_transaction,
ROUND(SUM(co.amount) * 100 / (SELECT SUM(amount) FROM CompletedOrder), 2) AS percent_of_total
from completedorder co 
join completedaccounts ca on ca.account_id = co.account_id
join completeddistrict cd on cd.district_id = ca.district_id
group by region 
order by total_transaction desc; 

-- Self-payments or internal transfers
select * 
from completedorder
where account_id = account_to; 


-- Top Receiving Accounts (Most Money Received)
SELECT 
    account_to,
    SUM(amount) AS total_received,
    COUNT(*) AS num_transactions
FROM completedorder
GROUP BY account_to
ORDER BY total_received DESC
LIMIT 10;






