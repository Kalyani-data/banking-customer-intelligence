-- Minimum Client Age
select min(age)
from CompletedClients;

-- Maximum Client Age
Select max(age) 
from completedclients;

-- Age Group Distribution
Select 
     count(case when age >= 10 and age <=19 then 1 end) as Teens,
     count(case when age >=20 and age <= 34 then 1 end) as Young_adults,
     count(case when age >=35 and age <= 49 then 1 end) as Adults,
     count(case when age >= 50 and age <= 64 then 1 end) as Middle_ages,
     count(case when age >= 65 then 1 end ) as Seniors
from completedclients; 


 -- Gender Distribution    
select 
	count(case when sex = "Female" then 1 end) as Female,
    count(case when sex = "Male" then 1 end) as Male
from CompletedClients; 

-- Clients by State
select cd.state_name as State_name,count(cc.client_id) as number_clients
from CompletedClients cc left join completeddistrict cd
on cc.district_id = cd.district_id
group by State_name;


-- Clients by District ID
select district_id,count(*) as number_clients
from CompletedClients 
group by district_id;


-- Clients by Region
select cd.region as Region, count(cc.Client_id) as number_of_clients
from completedclients cc left join CompletedDistrict cd 
on cc.district_id = cd.district_id 
group by Region 
order by number_of_clients desc; 


-- Clients by Division
select cd.division as Division, count(cc.Client_id) as number_of_clients
from completedclients cc left join CompletedDistrict cd 
on cc.district_id = cd.district_id 
group by Division
order by number_of_clients desc; 

-- Top 10 Districts by Client Count
select district_id ,count(client_id) as number_clients
from CompletedClients 
group by district_id
order by number_clients desc 
limit 10;

-- Top 10 Districts with Details (Join with District Table)
With DistrictClientCount as (
		select district_id ,count(client_id) as number_clients
		from CompletedClients 
		group by district_id)
select cd.* ,dcc.number_clients
from DistrictClientcount dcc join completeddistrict cd
on dcc.district_id = cd.district_id 
order by number_clients desc
limit 10; 

-- Age & Gender Breakdown by Region
SELECT
  cd.region,
  count(cc.client_id) as total,
  COUNT(CASE WHEN age BETWEEN 10 AND 19 THEN 1 END) AS Teens,
  COUNT(CASE WHEN age BETWEEN 20 AND 34 THEN 1 END) AS Young_Adults,
  COUNT(CASE WHEN age BETWEEN 35 AND 49 THEN 1 END) AS Adults,
  COUNT(CASE WHEN age BETWEEN 50 AND 64 THEN 1 END) AS Middle_Aged,
  COUNT(CASE WHEN age >= 65 THEN 1 END) AS Seniors,
  COUNT(CASE WHEN sex = 'Male' THEN 1 END) AS Males,
  COUNT(CASE WHEN sex = 'Female' THEN 1 END) AS Females
FROM CompletedClients cc
LEFT JOIN CompletedDistrict cd ON cc.district_id = cd.district_id
GROUP BY cd.region
ORDER BY total desc;

-- Age & Gender Breakdown by District
SELECT
  district_id,
  count(client_id) as total ,
  COUNT(CASE WHEN age BETWEEN 10 AND 19 THEN 1 END) AS Teens,
  COUNT(CASE WHEN age BETWEEN 20 AND 34 THEN 1 END) AS Young_Adults,
  COUNT(CASE WHEN age BETWEEN 35 AND 49 THEN 1 END) AS Adults,
  COUNT(CASE WHEN age BETWEEN 50 AND 64 THEN 1 END) AS Middle_Aged,
  COUNT(CASE WHEN age >= 65 THEN 1 END) AS Seniors,
  COUNT(CASE WHEN sex = 'Male' THEN 1 END) AS Males,
  COUNT(CASE WHEN sex = 'Female' THEN 1 END) AS Females
FROM CompletedClients
GROUP BY district_id
ORDER BY total desc;


-- Age & Gender Breakdown by State (Top 10)
SELECT
  cd.state_name,
  count(cc.client_id) as total,
  COUNT(CASE WHEN age BETWEEN 10 AND 19 THEN 1 END) AS Teens,
  COUNT(CASE WHEN age BETWEEN 20 AND 34 THEN 1 END) AS Young_Adults,
  COUNT(CASE WHEN age BETWEEN 35 AND 49 THEN 1 END) AS Adults,
  COUNT(CASE WHEN age BETWEEN 50 AND 64 THEN 1 END) AS Middle_Aged,
  COUNT(CASE WHEN age >= 65 THEN 1 END) AS Seniors,
  COUNT(CASE WHEN sex = 'Male' THEN 1 END) AS Males,
  COUNT(CASE WHEN sex = 'Female' THEN 1 END) AS Females
FROM CompletedClients cc
LEFT JOIN CompletedDistrict cd ON cc.district_id = cd.district_id
GROUP BY cd.state_name
ORDER BY total desc
limit 10;











		





