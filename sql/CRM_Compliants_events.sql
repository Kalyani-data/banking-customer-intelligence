select * from CRM_CallLogs; 

select * from CRM_Events; 

select * from CRM_Reviews ; 

select * from completedclients; 


select count(*) from crm_calllogs; 



select count(*) from crm_calllogs 
where complaint_id = '' ; 

select * from crm_events
where company_response = ' ';

select distinct(complaint_id) from crm_events; 

select distinct(company_response) from crm_events;


select * from crm_events
where timely_response is null;

select * from crm_events
where consumer_disputed = ''; 

select distinct(consumer_disputed) from crm_events; 

-- Complaints Resolved vs Escalated
SELECT 
  CASE 
    WHEN company_response IN ('Untimely response', 'In Progress') 
         OR timely_response = 'No' 
      THEN 'Escalated'
    WHEN company_response IN (
         'Closed with explanation', 'Closed with relief', 'Closed without relief', 
         'Closed with non-monetary relief', 'Closed with monetary relief', 'Closed'
         ) 
         AND consumer_disputed = 'Yes'
      THEN 'Resolved but Disputed'
    ELSE 'Resolved' 
  END AS category,
  COUNT(*) AS number_of_complaints 
FROM crm_events 
GROUP BY category;


SELECT 
     * ,
    CASE 
        WHEN company_response IN ('Untimely response', 'In Progress') 
             OR timely_response = 'No' 
        THEN 'Escalated'
        
        WHEN company_response IN (
                'Closed with explanation', 'Closed with relief', 'Closed without relief', 
                'Closed with non-monetary relief', 'Closed with monetary relief', 'Closed'
             ) 
             AND consumer_disputed = 'Yes' 
        THEN 'Resolved but Disputed'
        
        ELSE 'Resolved'
    END AS category
FROM crm_events;


-- Average Call Resolution Time by Agent 
SELECT 
    agent_name,
    SEC_TO_TIME(Round(AVG(TIME_TO_SEC(ser_time)))) AS avg_call_resolution_time
FROM crm_calllogs 
GROUP BY agent_name
order by avg_call_resolution_time desc;  


-- Frequent Support Contacts (Possible Churn Risk)
SELECT
    client_id,
    COUNT(*) AS no_of_calls
FROM crm_calllogs
WHERE client_id IS NOT NULL 
  AND client_id <> ''
GROUP BY client_id
ORDER BY no_of_calls DESC;


-- more than 3 calls with client detials 
SELECT
    ccl.client_id,
    cc.fullname,
    cc.sex,
    cc.age,
    COUNT(*) AS no_of_calls
FROM crm_calllogs ccl 
join completedclients cc on ccl.client_id = cc.client_id 
WHERE ccl.client_id IS NOT NULL 
  AND ccl.client_id <> ''
GROUP BY ccl.client_id
Having count(*) >= 3 
ORDER BY no_of_calls DESC;

-- with client detials 
SELECT
    ccl.client_id,
    cc.fullname,
    cc.sex,
    cc.age,
    COUNT(*) AS no_of_calls
FROM crm_calllogs ccl 
join completedclients cc on ccl.client_id = cc.client_id 
WHERE ccl.client_id IS NOT NULL 
  AND ccl.client_id <> ''
GROUP BY ccl.client_id
ORDER BY no_of_calls DESC;


-- Complaint Type Trends Over Time — Most common issue/sub_issue per month/year.
select distinct(issue) from crm_events; 
select * from crm_events where issue is null; 
select * from crm_events where date_received is null;  


-- Complaint Type Trends Over Time — Most common issues per month/year.
SELECT 
    DATE_FORMAT(date_received, '%Y-%m') AS yearmonth,
    issue, 
    COUNT(*) AS complaint_count
FROM crm_events
WHERE issue IS NOT NULL AND issue <> ''
GROUP BY yearmonth, issue
ORDER BY yearmonth ASC, complaint_count DESC;


SELECT 
    DATE_FORMAT(date_received, '%Y-%m') AS yearmonth,
    issue, 
    COUNT(*) AS complaint_count
FROM crm_events
WHERE issue IS NOT NULL AND issue <> ''
GROUP BY yearmonth, issue
ORDER BY yearmonth ASC, complaint_count DESC;


SELECT 
    year(date_received) AS years,
    issue, 
    COUNT(*) AS complaint_count
FROM crm_events
WHERE issue IS NOT NULL AND issue <> ''
GROUP BY years, issue
ORDER BY years ASC, complaint_count DESC;


-- First-Contact Resolution Rate — % resolved on first call.
select count(*)  from crm_calllogs where complaint_id is null or complaint_id ='' ; 

select * from crm_events where  complaint_id is null or complaint_id ='' ; 

select distinct(complaint_id) from crm_events; 

select * 
from crm_calllogs cl 
join crm_events ce on cl.complaint_id = ce.complaint_id; 


-- sql query
SELECT 
    COUNT(CASE WHEN outcome = 'AGENT' THEN 1 END) * 100.0 / COUNT(*) AS fcr_percentage
FROM crm_calllogs;

-- Call Volume by Time of Day/Week — From ser_start in CRM_CallLogs.
select 
hour(ser_start) as time,
count(*) number_of_calls
from crm_calllogs
group by time  
order by number_of_calls desc; 


select 
dayname(date_received) as day,
count(*) number_of_calls
from crm_calllogs
group by day  
order by number_of_calls desc; 

select 
dayname(date_received) as day,
hour(ser_start) as time,
count(*) number_of_calls
from crm_calllogs
group by day,time
ORDER BY DAYOFWEEK(min(date_received)), time;

-- 
WITH ranked_calls AS (
    SELECT 
        DAYNAME(date_received) AS day,
        HOUR(ser_start) AS time,
        COUNT(*) AS number_of_calls,
        ROW_NUMBER() OVER (
            PARTITION BY DAYOFWEEK(date_received)
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM crm_calllogs
    GROUP BY DAYOFWEEK(date_received), day, time
)
SELECT 
    day,
    time,
    number_of_calls
FROM ranked_calls
WHERE rn = 1
ORDER BY FIELD(day, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');



-- Cross-Link Complaints to Financial Products — e.g., card complaints → card closures.
select distinct(product) from crm_events; 

select distinct(issue)  from crm_events; 

select distinct(company_response) from crm_events; 

select * from crm_events where sub_product is null or sub_product = ''; 


-- Credit Card Closure Counts
SELECT 
    issue,
    company_response,
    COUNT(*) AS num_complaints
FROM crm_events
WHERE product = 'Credit card'
  AND (
      issue LIKE '%close%'
      OR company_response LIKE '%Closed%'
  )
GROUP BY issue, company_response
ORDER BY num_complaints DESC;

-- Cross-link complaints with financial products (base summary)
SELECT 
    product,
    sub_product,
    issue,
    company_response,
    COUNT(*) AS complaint_count
FROM crm_events
WHERE product IN ('Bank account or service', 'Credit card')
GROUP BY product, sub_product, issue, company_response
ORDER BY product, complaint_count DESC;


--  Finding “credit card closure” patterns
SELECT 
    product,
    issue,
    company_response,
    COUNT(*) AS closure_related_complaints
FROM crm_events
WHERE product = 'Credit card'
  AND (
       LOWER(issue) LIKE '%account closed%' 
    OR LOWER(issue) LIKE '%card closed%'
    OR LOWER(issue) LIKE '%cancellation%'
  )
GROUP BY product, issue, company_response
ORDER BY closure_related_complaints DESC;


-- See which products are linked to each issue
SELECT 
    issue,
    product,
    COUNT(*) AS complaint_count
FROM crm_events
GROUP BY issue, product
ORDER BY issue, complaint_count DESC;

-- Finding top product for each issue
WITH issue_rank AS (
    SELECT
        issue,
        product,
        COUNT(*) AS complaint_count,
        ROW_NUMBER() OVER (PARTITION BY issue ORDER BY COUNT(*) DESC) AS rn
    FROM crm_events
    GROUP BY issue, product
)
SELECT issue, product, complaint_count
FROM issue_rank
WHERE rn = 1
ORDER BY complaint_count DESC;

-- Identifying  issues that are highly concentrated on one product
WITH issue_product AS (
    SELECT
        issue,
        product,
        COUNT(*) AS cnt
    FROM crm_events
    GROUP BY issue, product
),
issue_totals AS (
    SELECT
        issue,
        SUM(cnt) AS total_cnt
    FROM issue_product
    GROUP BY issue
)
SELECT 
    ip.issue,
    ip.product,
    ip.cnt,
    ROUND((ip.cnt * 100.0) / it.total_cnt, 2) AS pct_of_issue
FROM issue_product ip
JOIN issue_totals it 
    ON ip.issue = it.issue
ORDER BY pct_of_issue DESC;











