select * from completedcards;

select distinct(type) 
from completedcards; 


--  Number of cards held by each client.
select 
ccs.client_id,
count(cc.card_id) as no_of_cards
from completedcards cc 
join completeddispositions cd on cd.disp_id = cc.disp_id
join completedclients ccs on ccs.client_id = cd.client_id
group by ccs.client_id ; 


---- Total number of cards issued to clients.
select 
count(*) 
from completedcards cc 
join completeddispositions cd on cd.disp_id = cc.disp_id
join completedclients ccs on ccs.client_id = cd.client_id ;


-- -- Number of cards held by each age group.
select 
case 
  WHEN ccs.age BETWEEN 10 AND 19 THEN  "Teens"
  WHEN ccs.age BETWEEN 20 AND 34 THEN  "Young_adults"
  WHEN ccs.age BETWEEN 35 AND 49 THEN  "Adults"
  WHEN ccs.age BETWEEN 50 AND 64 THEN  "Middle_ages"
 WHEN ccs.age >= 65 THEN "Seniors"
 End as age_group,
count(cc.card_id) as number_of_cards
from completedcards cc 
join completeddispositions cd on cd.disp_id = cc.disp_id
join completedclients ccs on ccs.client_id = cd.client_id 
group by age_group
order by number_of_cards desc;


-- -- Age group with the highest number of cardholders.
select 
case 
  WHEN ccs.age BETWEEN 10 AND 19 THEN  "Teens"
  WHEN ccs.age BETWEEN 20 AND 34 THEN  "Young_adults"
  WHEN ccs.age BETWEEN 35 AND 49 THEN  "Adults"
  WHEN ccs.age BETWEEN 50 AND 64 THEN  "Middle_ages"
 WHEN ccs.age >= 65 THEN "Seniors"
 End as age_group,
count(cc.card_id) as number_of_cards
from completedcards cc 
join completeddispositions cd on cd.disp_id = cc.disp_id
join completedclients ccs on ccs.client_id = cd.client_id 
group by age_group
order by number_of_cards desc
limit 1; 


-- Number of cards held by clients in each district.
select 
ccs.district_id,
count(cc.card_id) as number_of_cards
from completedcards cc 
join completeddispositions cd on cd.disp_id = cc.disp_id
join completedclients ccs on ccs.client_id = cd.client_id 
group by ccs.district_id
order by number_of_cards desc ;


-- District with highest cardholders
select 
ccs.district_id,
count(cc.card_id) as number_of_cards
from completedcards cc 
join completeddispositions cd on cd.disp_id = cc.disp_id
join completedclients ccs on ccs.client_id = cd.client_id 
group by ccs.district_id
order by number_of_cards desc
limit 1; 


-- Number of cards held by clients in each region.
select 
cds.region,
count(cc.card_id) as number_of_cards
from completedcards cc 
join completeddispositions cd on cd.disp_id = cc.disp_id
join completedclients ccs on ccs.client_id = cd.client_id 
join completeddistrict cds  on cds.district_id = ccs.district_id
group by cds.region
order by number_of_cards desc;


-- Region with the highest number of cardholders.
select 
cds.region,
count(cc.card_id) as number_of_cards
from completedcards cc 
join completeddispositions cd on cd.disp_id = cc.disp_id
join completedclients ccs on ccs.client_id = cd.client_id 
join completeddistrict cds  on cds.district_id = ccs.district_id
group by cds.region
order by number_of_cards desc
limit 1; 


-- number of clients and card holders per age group
with total_clients as(
select 
case 
  WHEN age BETWEEN 10 AND 19 THEN  "Teens"
  WHEN age BETWEEN 20 AND 34 THEN  "Young_adults"
  WHEN age BETWEEN 35 AND 49 THEN  "Adults"
  WHEN age BETWEEN 50 AND 64 THEN  "Middle_ages"
  WHEN age >= 65 THEN "Seniors"
 End as age_group,
 count(client_id) as number_clients
 from completedclients
 group by age_group),
total_cards as 
(select 
case 
  WHEN ccs.age BETWEEN 10 AND 19 THEN  "Teens"
  WHEN ccs.age BETWEEN 20 AND 34 THEN  "Young_adults"
  WHEN ccs.age BETWEEN 35 AND 49 THEN  "Adults"
  WHEN ccs.age BETWEEN 50 AND 64 THEN  "Middle_ages"
 WHEN ccs.age >= 65 THEN "Seniors"
 End as age_group,
count(cc.card_id) as number_of_cards
from completedcards cc 
join completeddispositions cd on cd.disp_id = cc.disp_id
join completedclients ccs on ccs.client_id = cd.client_id 
group by age_group
order by number_of_cards desc) 
select 
tc.age_group,tc.number_clients,td.number_of_cards
from total_clients tc 
join total_cards  td on tc.age_group = td.age_group; 



-- number of clients and card holders per age group with percentage of card holders in each age group
with total_clients as (
  select 
    case 
      when age between 10 and 19 then 'Teens'
      when age between 20 and 34 then 'Young_adults'
      when age between 35 and 49 then 'Adults'
      when age between 50 and 64 then 'Middle_ages'
      when age >= 65 then 'Seniors'
    end as age_group,
    count(client_id) as number_clients
  from completedclients
  group by age_group
),
total_cards as (
  select 
    case 
      when ccs.age between 10 and 19 then 'Teens'
      when ccs.age between 20 and 34 then 'Young_adults'
      when ccs.age between 35 and 49 then 'Adults'
      when ccs.age between 50 and 64 then 'Middle_ages'
      when ccs.age >= 65 then 'Seniors'
    end as age_group,
    count(cc.card_id) as number_of_cards
  from completedcards cc 
  join completeddispositions cd on cd.disp_id = cc.disp_id
  join completedclients ccs on ccs.client_id = cd.client_id 
  group by age_group
  order by number_of_cards desc
)
select 
  tc.age_group,
  tc.number_clients,
  td.number_of_cards,
  round(td.number_of_cards * 100.0 / tc.number_clients, 2) as percentage_with_cards
from total_clients tc 
join total_cards td on tc.age_group = td.age_group;



-- Number of clients vs cards by region
with total_clients as(
	select 
    cd.region,
    count(cc.client_id) as number_of_clients
    from completedclients cc 
    join completeddistrict cd on cd.district_id = cc.district_id
    group by cd.region
    order by number_Of_clients desc),
total_cards as(
	select 
	cd.region,
    count(cc.card_id) as number_of_cards
    from completedcards cc 
    join completeddispositions cp on cp.disp_id = cc.disp_id
    join completedclients ccs on ccs.client_id = cp.client_id
    join completeddistrict cd on cd.district_id = ccs.district_id
    group by cd.region
    order by number_of_cards desc)
select 
tc.region,
tc.number_of_clients,
td.number_of_cards
from total_clients tc 
join total_cards td  on tc.region = td.region;


-- percentage of clients with cards per region
WITH total_clients AS (
	SELECT 
	    cd.region,
	    COUNT(cc.client_id) AS number_of_clients
	FROM completedclients cc 
	JOIN completeddistrict cd ON cd.district_id = cc.district_id
	GROUP BY cd.region
	ORDER BY number_of_clients DESC
),
total_cards AS (
	SELECT 
	    cd.region,
	    COUNT(cc.card_id) AS number_of_cards
	FROM completedcards cc 
	JOIN completeddispositions cp ON cp.disp_id = cc.disp_id
	JOIN completedclients ccs ON ccs.client_id = cp.client_id
	JOIN completeddistrict cd ON cd.district_id = ccs.district_id
	GROUP BY cd.region
	ORDER BY number_of_cards DESC
)
SELECT 
	tc.region,
	tc.number_of_clients,
	td.number_of_cards,
	ROUND(td.number_of_cards * 100.0 / tc.number_of_clients, 2) AS percentage_with_cards
FROM total_clients tc 
JOIN total_cards td ON tc.region = td.region;


-- 	Total per card type
select type, count(*) as no_of_cards
from completedcards
group by type 
order by no_of_cards desc ;

-- --Count of each card type per age group.
SELECT 
  CASE 
    WHEN ccs.age BETWEEN 10 AND 19 THEN 'Teens'
    WHEN ccs.age BETWEEN 20 AND 34 THEN 'Young_adults'
    WHEN ccs.age BETWEEN 35 AND 49 THEN 'Adults'
    WHEN ccs.age BETWEEN 50 AND 64 THEN 'Middle_ages'
    WHEN ccs.age >= 65 THEN 'Seniors'
  END AS age_group,
  COUNT(CASE WHEN cc.type = 'VISA Signature' THEN 1 END) AS visa_signature_card,
  COUNT(CASE WHEN cc.type = 'VISA Standard' THEN 1 END) AS visa_standard_card,
  COUNT(CASE WHEN cc.type = 'VISA Infinite' THEN 1 END) AS visa_infinite_card,
  COUNT(cc.card_id) AS total_cards
FROM completedcards cc
JOIN completeddispositions cd ON cd.disp_id = cc.disp_id
JOIN completedclients ccs ON ccs.client_id = cd.client_id
GROUP BY age_group
ORDER BY total_cards DESC; 

-- % share of each card type within each age group.
SELECT 
  CASE 
    WHEN ccs.age BETWEEN 10 AND 19 THEN 'Teens'
    WHEN ccs.age BETWEEN 20 AND 34 THEN 'Young_adults'
    WHEN ccs.age BETWEEN 35 AND 49 THEN 'Adults'
    WHEN ccs.age BETWEEN 50 AND 64 THEN 'Middle_ages'
    WHEN ccs.age >= 65 THEN 'Seniors'
  END AS age_group,

  COUNT(cc.card_id) AS total_cards,

  COUNT(CASE WHEN cc.type = 'VISA Signature' THEN 1 END) AS visa_signature_card,
  ROUND(100.0 * COUNT(CASE WHEN cc.type = 'VISA Signature' THEN 1 END) / COUNT(cc.card_id), 2) AS visa_signature_pct,

  COUNT(CASE WHEN cc.type = 'VISA Standard' THEN 1 END) AS visa_standard_card,
  ROUND(100.0 * COUNT(CASE WHEN cc.type = 'VISA Standard' THEN 1 END) / COUNT(cc.card_id), 2) AS visa_standard_pct,

  COUNT(CASE WHEN cc.type = 'VISA Infinite' THEN 1 END) AS visa_infinite_card,
  ROUND(100.0 * COUNT(CASE WHEN cc.type = 'VISA Infinite' THEN 1 END) / COUNT(cc.card_id), 2) AS visa_infinite_pct

FROM completedcards cc
JOIN completeddispositions cd ON cd.disp_id = cc.disp_id
JOIN completedclients ccs ON ccs.client_id = cd.client_id
GROUP BY age_group
ORDER BY total_cards DESC;

-- Which card type is most common in each age group
WITH aggregated AS (
  SELECT 
    CASE 
      WHEN ccs.age BETWEEN 10 AND 19 THEN 'Teens'
      WHEN ccs.age BETWEEN 20 AND 34 THEN 'Young_adults'
      WHEN ccs.age BETWEEN 35 AND 49 THEN 'Adults'
      WHEN ccs.age BETWEEN 50 AND 64 THEN 'Middle_ages'
      WHEN ccs.age >= 65 THEN 'Seniors'
    END AS age_group,
    cc.type,
    COUNT(cc.card_id) AS total_cards
  FROM completedcards cc
  JOIN completeddispositions cd ON cd.disp_id = cc.disp_id
  JOIN completedclients ccs ON ccs.client_id = cd.client_id
  GROUP BY age_group, cc.type
),
ranked AS (
  SELECT *,
    ROW_NUMBER() OVER (
      PARTITION BY age_group
      ORDER BY total_cards DESC
    ) AS row_num
  FROM aggregated
)
SELECT age_group, type, total_cards
FROM ranked
WHERE row_num = 1
ORDER BY age_group;

-- Which card type is most common in each age group with totla cards in each group
WITH aggregated AS (
  SELECT 
    CASE 
      WHEN ccs.age BETWEEN 10 AND 19 THEN 'Teens'
      WHEN ccs.age BETWEEN 20 AND 34 THEN 'Young_adults'
      WHEN ccs.age BETWEEN 35 AND 49 THEN 'Adults'
      WHEN ccs.age BETWEEN 50 AND 64 THEN 'Middle_ages'
      WHEN ccs.age >= 65 THEN 'Seniors'
    END AS age_group,
    cc.type,
    COUNT(cc.card_id) AS total_cards
  FROM completedcards cc
  JOIN completeddispositions cd ON cd.disp_id = cc.disp_id
  JOIN completedclients ccs ON ccs.client_id = cd.client_id
  GROUP BY age_group, cc.type
),
total_cards_per_age_group AS (
  SELECT 
    age_group,
    SUM(total_cards) AS total_cards_in_age_group
  FROM aggregated
  GROUP BY age_group
),
ranked AS (
  SELECT 
    a.age_group,
    a.type,
    a.total_cards,
    t.total_cards_in_age_group,
    ROW_NUMBER() OVER (
      PARTITION BY a.age_group
      ORDER BY a.total_cards DESC
    ) AS row_num
  FROM aggregated a
  JOIN total_cards_per_age_group t ON a.age_group = t.age_group
)
SELECT 
  age_group,
  type,
  total_cards,
  total_cards_in_age_group
FROM ranked
WHERE row_num = 1
ORDER BY age_group;


-- Count of card types per region
select 
   cd.region,
  COUNT(CASE WHEN cc.type = 'VISA Signature' THEN 1 END) AS visa_signature_card,
  COUNT(CASE WHEN cc.type = 'VISA Standard' THEN 1 END) AS visa_standard_card,
  COUNT(CASE WHEN cc.type = 'VISA Infinite' THEN 1 END) AS visa_infinite_card,
  count(cc.card_id) as total_cards
from completedcards cc  
join completeddispositions cp on cp.disp_id = cc.disp_id
join completedclients ccs on ccs.client_id = cp.client_id
join completeddistrict cd on cd.district_id = ccs.district_id
group by cd.region 
order by total_cards desc;

-- % of each card type in each region.
select 
cd.region,
count(cc.card_id) as total_cards,
  COUNT(CASE WHEN cc.type = 'VISA Signature' THEN 1 END) AS visa_signature_card,
  ROUND(100.0 * COUNT(CASE WHEN cc.type = 'VISA Signature' THEN 1 END) / COUNT(cc.card_id), 2) AS visa_signature_pct,
  COUNT(CASE WHEN cc.type = 'VISA Standard' THEN 1 END) AS visa_standard_card,
  ROUND(100.0 * COUNT(CASE WHEN cc.type = 'VISA Standard' THEN 1 END) / COUNT(cc.card_id), 2) AS visa_standard_pct,
  COUNT(CASE WHEN cc.type = 'VISA Infinite' THEN 1 END) AS visa_infinite_card,
  ROUND(100.0 * COUNT(CASE WHEN cc.type = 'VISA Infinite' THEN 1 END) / COUNT(cc.card_id), 2) AS visa_infinite_pct
from completedcards cc  
join completeddispositions cp on cp.disp_id = cc.disp_id
join completedclients ccs on ccs.client_id = cp.client_id
join completeddistrict cd on cd.district_id = ccs.district_id
group by cd.region 
order by total_cards desc;

-- Region-wise preference: which region favors which card type
with aggregated as(
select 
cd.region,
cc.type,
count(cc.card_id) as no_of_cards
from completedcards cc  
join completeddispositions cp on cp.disp_id = cc.disp_id
join completedclients ccs on ccs.client_id = cp.client_id
join completeddistrict cd on cd.district_id = ccs.district_id
group by cd.region,cc.type),
ranked as (
select 
* ,
row_number() over (partition by region order by no_of_cards desc) as row_num
from aggregated)
select * 
from ranked 
where row_num = 1
order by no_of_cards; 


-- Region-wise preference: which region favors which card type with totla cards 
with aggregated as(
select 
cd.region,
cc.type,
count(cc.card_id) as no_of_cards
from completedcards cc  
join completeddispositions cp on cp.disp_id = cc.disp_id
join completedclients ccs on ccs.client_id = cp.client_id
join completeddistrict cd on cd.district_id = ccs.district_id
group by cd.region,cc.type),
total_no_cards as (
select 
      region ,
      sum(no_of_cards) as total_no_cards
from aggregated
group by region),
ranked as (
select 
a.region,
a.type,
a.no_of_cards,
t.total_no_cards,
row_number() over (partition by a.region order by no_of_cards desc) as row_num
from aggregated a
join total_no_cards t on a.region = t.region)
select 
region,
type,
no_of_cards,
total_no_cards
from ranked 
where row_num = 1
order by no_of_cards; 


--  Number of cards held by gender.
SELECT 
  CASE 
    WHEN ccs.sex = "Female" then "Female"
    WHEN ccs.sex = "Male" then "Male"
    end as gender,
  COUNT(cc.card_id) AS total_cards
FROM completedcards cc
JOIN completeddispositions cd ON cd.disp_id = cc.disp_id
JOIN completedclients ccs ON ccs.client_id = cd.client_id
GROUP BY gender
ORDER BY total_cards DESC; 


-- number of clients and card holders per gender
with total_clients as(
select 
CASE 
    WHEN sex = "Female" then "Female"
    WHEN sex = "Male" then "Male"
    end as gender,
 count(client_id) as number_clients
 from completedclients
 group by gender),
total_cards as 
(select 
CASE 
    WHEN ccs.sex = "Female" then "Female"
    WHEN ccs.sex = "Male" then "Male"
    end as gender,
count(cc.card_id) as number_of_cards
from completedcards cc 
join completeddispositions cd on cd.disp_id = cc.disp_id
join completedclients ccs on ccs.client_id = cd.client_id 
group by gender
order by number_of_cards desc) 
select 
tc.gender,tc.number_clients,td.number_of_cards
from total_clients tc 
join total_cards  td on tc.gender = td.gender; 


-- number of clients and card holders per gender with percentage of card holders in each gender
with total_clients as(
select 
CASE 
    WHEN sex = "Female" then "Female"
    WHEN sex = "Male" then "Male"
    end as gender,
 count(client_id) as number_clients
 from completedclients
 group by gender),
total_cards as 
(select 
CASE 
    WHEN ccs.sex = "Female" then "Female"
    WHEN ccs.sex = "Male" then "Male"
    end as gender,
count(cc.card_id) as number_of_cards
from completedcards cc 
join completeddispositions cd on cd.disp_id = cc.disp_id
join completedclients ccs on ccs.client_id = cd.client_id 
group by gender
order by number_of_cards desc) 
select 
tc.gender,tc.number_clients,td.number_of_cards,
round(td.number_of_cards * 100.0 / tc.number_clients, 2) as percentage_with_cards
from total_clients tc 
join total_cards  td on tc.gender = td.gender; 



-- --Count of each card type per gender 
SELECT 
CASE 
    WHEN ccs.sex = "Female" then "Female"
    WHEN ccs.sex = "Male" then "Male"
    end as gender,
  COUNT(CASE WHEN cc.type = 'VISA Signature' THEN 1 END) AS visa_signature_card,
  COUNT(CASE WHEN cc.type = 'VISA Standard' THEN 1 END) AS visa_standard_card,
  COUNT(CASE WHEN cc.type = 'VISA Infinite' THEN 1 END) AS visa_infinite_card,
  COUNT(cc.card_id) AS total_cards
FROM completedcards cc
JOIN completeddispositions cd ON cd.disp_id = cc.disp_id
JOIN completedclients ccs ON ccs.client_id = cd.client_id
GROUP BY gender
ORDER BY total_cards DESC; 

-- % share of each card type within each gender.
SELECT 
 CASE 
    WHEN ccs.sex = "Female" then "Female"
    WHEN ccs.sex = "Male" then "Male"
    end as gender,
  COUNT(cc.card_id) AS total_cards,

  COUNT(CASE WHEN cc.type = 'VISA Signature' THEN 1 END) AS visa_signature_card,
  ROUND(100.0 * COUNT(CASE WHEN cc.type = 'VISA Signature' THEN 1 END) / COUNT(cc.card_id), 2) AS visa_signature_pct,

  COUNT(CASE WHEN cc.type = 'VISA Standard' THEN 1 END) AS visa_standard_card,
  ROUND(100.0 * COUNT(CASE WHEN cc.type = 'VISA Standard' THEN 1 END) / COUNT(cc.card_id), 2) AS visa_standard_pct,

  COUNT(CASE WHEN cc.type = 'VISA Infinite' THEN 1 END) AS visa_infinite_card,
  ROUND(100.0 * COUNT(CASE WHEN cc.type = 'VISA Infinite' THEN 1 END) / COUNT(cc.card_id), 2) AS visa_infinite_pct

FROM completedcards cc
JOIN completeddispositions cd ON cd.disp_id = cc.disp_id
JOIN completedclients ccs ON ccs.client_id = cd.client_id
GROUP BY gender
ORDER BY total_cards DESC;

-- Which card type is most common in each gender
WITH aggregated AS (
select 
CASE 
    WHEN ccs.sex = "Female" then "Female"
    WHEN ccs.sex = "Male" then "Male"
    end as gender,
    cc.type,
    COUNT(cc.card_id) AS total_cards
  FROM completedcards cc
  JOIN completeddispositions cd ON cd.disp_id = cc.disp_id
  JOIN completedclients ccs ON ccs.client_id = cd.client_id
  GROUP BY gender, cc.type
),
ranked AS (
  SELECT *,
    ROW_NUMBER() OVER (
      PARTITION BY gender
      ORDER BY total_cards DESC
    ) AS row_num
  FROM aggregated
)
SELECT gender, type, total_cards
FROM ranked
WHERE row_num = 1
ORDER BY gender;

-- Which card type is most common in each age group with totla cards in each group
WITH aggregated AS (
  SELECT 
CASE 
    WHEN ccs.sex = "Female" then "Female"
    WHEN ccs.sex = "Male" then "Male"
    end as gender,
    cc.type,
    COUNT(cc.card_id) AS total_cards
  FROM completedcards cc
  JOIN completeddispositions cd ON cd.disp_id = cc.disp_id
  JOIN completedclients ccs ON ccs.client_id = cd.client_id
  GROUP BY gender, cc.type
),
total_cards AS (
  SELECT 
    gender,
    SUM(total_cards) AS total_cards_gender
  FROM aggregated
  GROUP BY gender
),
ranked AS (
  SELECT 
    a.gender,
    a.type,
    a.total_cards,
    t.total_cards_gender,
    ROW_NUMBER() OVER (
      PARTITION BY a.gender
      ORDER BY a.total_cards DESC
    ) AS row_num
  FROM aggregated a
  JOIN total_cards t ON a.gender= t.gender
)
SELECT 
  gender,
  type,
  total_cards,
  total_cards_gender
FROM ranked
where row_num = 1 
ORDER BY gender;


select 
cc.client_id,
count(cd.account_id) as no_of_accounts
from completedclients cc
left join completeddispositions cd on 
cc.client_id = cd.client_id 
group by cc.client_id
having no_of_accounts > 1; 

select 
client_id,
count(account_id) as number_accounts
from completeddispositions
group by client_id
having number_accounts > 1; 


-- Card adoption rate by type
WITH card_holders AS (
  SELECT 
    cc.type,
    COUNT(DISTINCT cd.client_id) AS clients_with_card
  FROM completedcards cc
  JOIN completeddispositions cd ON cd.disp_id = cc.disp_id
  GROUP BY cc.type
),
total_clients AS (
  SELECT COUNT(DISTINCT client_id) AS total_clients FROM completedclients
)
SELECT 
  ch.type,
  ch.clients_with_card,
  tc.total_clients,
  ROUND(ch.clients_with_card * 100.0 / tc.total_clients, 2) AS adoption_rate_pct
FROM card_holders ch
 JOIN total_clients tc
 order by adoption_rate_pct desc;
 
 
-- Card type usage trends over time
select 
type ,
year,
count(card_id) as no_of_cards
from completedcards
group by type,year
order by type , year;


-- monthly trends 
select 
type ,
year,
month,
count(card_id) as no_of_cards
from completedcards
group by type,year,month
order by type , year,month;

-- year-over-year (YoY) growth calculation
SELECT 
    type,
    year,
    COUNT(card_id) AS total_cards,
    
    LAG(COUNT(card_id)) OVER (PARTITION BY type ORDER BY year) AS prev_year_cards,
    
    ROUND(
        (COUNT(card_id) - LAG(COUNT(card_id)) OVER (PARTITION BY type ORDER BY year)) * 100.0 /
        NULLIF(LAG(COUNT(card_id)) OVER (PARTITION BY type ORDER BY year), 0), 
    2) AS yoy_growth_pct
FROM CompletedCards
GROUP BY type, year
ORDER BY type, year;


-- Card owners vs non-card clients
select 
case 
  when cc.card_id is not null then "withcard"
  else "withoutcard"
  end as card_ownership_status,
count(distinct cd.client_id) as number_of_clients
from completeddispositions cd 
left join completedcards cc 
on cd.disp_id = cc.disp_id 
group by card_ownership_status;


-- Card owners vs non-card clients percentage
SELECT 
  CASE 
    WHEN cc.card_id IS NOT NULL THEN 'With Card'
    ELSE 'Without Card'
  END AS card_ownership_status,
  COUNT(DISTINCT cd.client_id) AS number_of_clients,
  ROUND(
    COUNT(DISTINCT cd.client_id) * 100.0 / 
    (SELECT COUNT(DISTINCT client_id) FROM completeddispositions), 2
  ) AS percentage_of_total
FROM completeddispositions cd
LEFT JOIN completedcards cc 
  ON cd.disp_id = cc.disp_id
GROUP BY card_ownership_status;















