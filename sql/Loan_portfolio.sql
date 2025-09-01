
-- What loan purposes are most common (car, debt consolidation, etc.)?
-- Most Common Loan Purposes by Volume
select purpose, Count(*) as num_loans
from Completedloan 
group  by purpose 
order by num_loans desc;

-- Most Common Loan Purposes by Total Amount Funded
SELECT purpose, 
       COUNT(*) AS num_loans,
       ROUND(SUM(amount), 2) AS total_funded
FROM CompletedLoan
GROUP BY purpose
ORDER BY total_funded DESC;


-- How does loan amount, duration, and status vary across regions or customer age groups?
-- across regions 

-- Total Loans by Region
Select 
cd.region as region,
count(cl.loan_id) as total_loans
from completedloan cl 
join completedaccounts ca on cl.account_id = ca.account_id 
join completeddistrict cd on ca.district_id = cd.district_id
group by region
order by total_loans desc;


-- Average Loan Amount by Region
Select 
cd.region as region,
avg(cl.amount) as avg_loan_amount
from completedloan cl 
join completedaccounts ca on cl.account_id = ca.account_id 
join completeddistrict cd on ca.district_id = cd.district_id
group by region
order by avg_loan_amount desc;

-- Average Loan Duration by Region
Select 
cd.region as region,
avg(cl.duration) as avg_loan_duration
from completedloan cl 
join completedaccounts ca on cl.account_id = ca.account_id 
join completeddistrict cd on ca.district_id = cd.district_id
group by region
order by avg_loan_duration desc;

-- Loan Status Counts by Region (A/B/C/D)
Select 
cd.region as region,
sum(case when status = "A" then 1 else 0 end) as  status_A,
sum(case when status = "B" then 1 else 0 end) as  status_B,
sum(case when status = "C" then 1 else 0 end) as  status_C,
sum(case when status = "D" then 1 else 0 end) as  status_D
from completedloan cl 
join completedaccounts ca on cl.account_id = ca.account_id 
join completeddistrict cd on ca.district_id = cd.district_id
group by region;

-- without joining accounts table 
-- Total Loans by Region (Using Location Field)
Select 
cd.region as region,
count(cl.loan_id) as total_loans
from completedloan cl 
right join completeddistrict cd on cl.location = cd.district_id
group by region
order by total_loans desc;


-- Distinct Locations Used in Loan Table
SELECT DISTINCT location 
FROM completedloan 
ORDER BY location ;


-- Locations in Loans That Don’t Match Any District
select location 
from completedloan 
where location is not null 
and location not in ( select district_id from completeddistrict);


-- Loan-to-District Join Coverage Check
SELECT 
  COUNT(*) AS total_loans,                         -- Total rows in CompletedLoan
  COUNT(cd.district_id) AS matched_districts       -- How many matched to a district
FROM completedloan cl
LEFT JOIN completeddistrict cd 
  ON cl.location = cd.district_id;
 
-- Location vs Account-District Mismatches
SELECT COUNT(*) AS mismatches
FROM completedloan cl
JOIN completedaccounts ca ON cl.account_id = ca.account_id
WHERE cl.location != ca.district_id;

-- across age groups 
--  Loan Count per Age Group
SELECT 
  COUNT(CASE WHEN clt.age BETWEEN 10 AND 19 THEN 1 END) AS Teens,
  COUNT(CASE WHEN clt.age BETWEEN 20 AND 34 THEN 1 END) AS Young_adults,
  COUNT(CASE WHEN clt.age BETWEEN 35 AND 49 THEN 1 END) AS Adults,
  COUNT(CASE WHEN clt.age BETWEEN 50 AND 64 THEN 1 END) AS Middle_ages,
  COUNT(CASE WHEN clt.age >= 65 THEN 1 END) AS Seniors
FROM completedloan cl 
JOIN completedaccounts ca ON cl.account_id = ca.account_id
JOIN CompletedDispositions cp ON cp.account_id = ca.account_id
JOIN completedclients clt ON clt.client_id = cp.client_id
WHERE cp.type = 'OWNER';


-- Loan Count Grouped by Age Category
SELECT 
 CASE 
  WHEN clt.age BETWEEN 10 AND 19 THEN  "Teens"
  WHEN clt.age BETWEEN 20 AND 34 THEN  "Young_adults"
  WHEN clt.age BETWEEN 35 AND 49 THEN  "Adults"
  WHEN clt.age BETWEEN 50 AND 64 THEN  "Middle_ages"
 WHEN clt.age >= 65 THEN "Seniors"
 End as age_group,
 count(cl.loan_id) as Total_Loan
FROM completedloan cl 
JOIN completedaccounts ca ON cl.account_id = ca.account_id
JOIN CompletedDispositions cp ON cp.account_id = ca.account_id
JOIN completedclients clt ON clt.client_id = cp.client_id
WHERE cp.type = 'OWNER'
group by age_group 
order by Total_Loan desc ; 

-- Average Loan Duration by Age Group
SELECT 
 CASE 
  WHEN clt.age BETWEEN 10 AND 19 THEN  "Teens"
  WHEN clt.age BETWEEN 20 AND 34 THEN  "Young_adults"
  WHEN clt.age BETWEEN 35 AND 49 THEN  "Adults"
  WHEN clt.age BETWEEN 50 AND 64 THEN  "Middle_ages"
 WHEN clt.age >= 65 THEN "Seniors"
 End as age_group,
 avg(cl.duration) as avg_loan_duration
FROM completedloan cl 
JOIN completedaccounts ca ON cl.account_id = ca.account_id
JOIN CompletedDispositions cp ON cp.account_id = ca.account_id
JOIN completedclients clt ON clt.client_id = cp.client_id
WHERE cp.type = 'OWNER'
group by age_group 
order by avg_loan_duration desc ; 

-- Loan Status Distribution by Age Group
SELECT 
 CASE 
  WHEN clt.age BETWEEN 10 AND 19 THEN  "Teens"
  WHEN clt.age BETWEEN 20 AND 34 THEN  "Young_adults"
  WHEN clt.age BETWEEN 35 AND 49 THEN  "Adults"
  WHEN clt.age BETWEEN 50 AND 64 THEN  "Middle_ages"
 WHEN clt.age >= 65 THEN "Seniors"
 End as age_group,
count(case when status = "A" then 1  end) as  status_A,
count(case when status = "B" then 1  end) as  status_B,
count(case when status = "C" then 1  end) as  status_C,
count(case when status = "D" then 1  end) as  status_D
FROM completedloan cl 
JOIN completedaccounts ca ON cl.account_id = ca.account_id
JOIN CompletedDispositions cp ON cp.account_id = ca.account_id
JOIN completedclients clt ON clt.client_id = cp.client_id
WHERE cp.type = 'OWNER'
group by age_group ; 



-- All Disposition Types Available
select distinct(type) 
from completeddispositions;


-- Customer-Loan Repayment Behavior
-- Find clients with more than one loan.
select 
cp.client_id,
count(cl.loan_id) as number_of_loans
from completedLoan cl 
join completedaccounts ca on cl.account_id = ca.account_id
join  completeddispositions cp on cp.account_id = ca.account_id
where cp.type = "owner"
group by client_id 
having number_of_loans > 1;

-- Checking what payment column indicate
select * 
from completedloan 
where amount != duration * payments ; 


SELECT 
  cl.loan_id,
  cl.account_id,
  cl.fulldate AS loan_date,
  MIN(ct.fulldate) AS first_debit_date
FROM completedloan cl
JOIN completedtrans ct ON cl.account_id = ct.account_id
WHERE ct.type = 'debit'
GROUP BY cl.loan_id, cl.account_id, cl.fulldate
ORDER BY cl.loan_id
LIMIT 10;


SELECT 
  ROUND(AVG(amount), 2) AS avg_approved_amount,
  ROUND(AVG(duration * payments), 2) AS avg_total_repayment
FROM completedloan;


























