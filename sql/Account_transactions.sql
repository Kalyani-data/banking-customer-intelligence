-- Transaction Count by Account
select account_id,count(trans_id) as number_of_transactions
from completedtrans
group by account_id; 

-- Transaction Count per Account (Using LEFT JOIN from CompletedAccounts)
select ca.account_id as account_id,count(ct.trans_id) as number_of_transactions
from completedaccounts ca left join completedtrans ct
on ca.account_id = ct.account_id
group by ca.account_id
order by number_of_transactions desc; 

-- Total Transaction Volume per Account
select ca.account_id as account_id,sum(ct.amount) as total_transaction_volume 
from completedaccounts ca left join completedtrans ct
on ca.account_id = ct.account_id
group by ca.account_id
order by total_transaction_volume  desc; 

-- Average Transaction Amount
select avg(amount) as avg_transaction_volume 
from completedtrans;


-- Total Balance Volume per Account
select ca.account_id as account_id,sum(ct.balance) as total_balance_volume 
from completedaccounts ca left join completedtrans ct
on ca.account_id = ct.account_id
group by account_id
order by total_balance_volume desc; 

-- Transaction Summary per Account (Count and Volume)
SELECT 
  ca.account_id,
  COUNT(ct.trans_id) AS num_transactions,
  SUM(ct.amount) AS total_transaction_volume
FROM completedaccounts ca 
LEFT JOIN completedtrans ct ON ca.account_id = ct.account_id
GROUP BY ca.account_id
ORDER BY total_transaction_volume DESC;

-- First and Last Transaction Dates (Entire Dataset)
SELECT 
    MIN(fulldatewithtime) AS first_transaction_date,
    MAX(fulldatewithtime) AS last_transaction_date
FROM CompletedTrans;



-- A. Last Transaction is Old
--  Dormancy Based on Last Transaction Date

-- Classifies accounts as 'Dormant > 12M', 'Dormant > 6M', or 'Active'
SELECT *,
  CASE 
    WHEN days_since_last_transaction > 365 THEN 'Dormant > 12M'
    WHEN days_since_last_transaction > 180 THEN 'Dormant > 6M'
    ELSE 'Active'
  END AS dormancy_status
FROM (
  SELECT 
    ca.account_id, 
    MAX(ct.fulldatewithtime) AS last_transaction,
    DATEDIFF((SELECT MAX(fulldatewithtime) FROM completedtrans), MAX(ct.fulldatewithtime)) AS days_since_last_transaction
  FROM Completedaccounts ca 
  LEFT JOIN completedtrans ct ON ca.account_id = ct.account_id
  GROUP BY ca.account_id
) AS sub
ORDER BY days_since_last_transaction DESC;


-- B. Very Few Transactions 
-- Likely Abandoned Accounts (Few Transactions, Long Age)
Select ca.account_id,ca.parseddate as open_date,max(ct.fulldatewithtime) as latest_transaction,
datediff(max(ct.fulldatewithtime),ca.parseddate) as account_age,
count(ct.trans_id) as no_of_transactions,
case 
	when count(ct.trans_id) <= 2 and 
    datediff(max(ct.fulldatewithtime),ca.parseddate) > 1000
    then "Likely Abandoned"
    else "Active"
end as account_status 
from completedaccounts ca left join 
completedtrans ct on ca.account_id = ct.account_id
group by ca.account_id
having account_age > 1000
order by no_of_transactions;


-- 
Select ca.account_id,ca.parseddate as open_date,max(ct.fulldatewithtime) as latest_transaction,
datediff(max(ct.fulldatewithtime),ca.parseddate) as account_age,
count(ct.trans_id) as no_of_transactions,
case 
	when count(ct.trans_id) <= 2 and 
    datediff(max(ct.fulldatewithtime),ca.parseddate) > 1000
    then "Likely Abandoned"
    else "Active"
end as account_status 
from completedaccounts ca left join 
completedtrans ct on ca.account_id = ct.account_id
group by ca.account_id
order by no_of_transactions;


-- All Accounts Classified by Activity Level (Based on Transaction Frequency)
Select ca.account_id,ca.parseddate as open_date,max(ct.fulldatewithtime) as latest_transaction,
datediff(max(ct.fulldatewithtime),ca.parseddate) as account_age,
count(ct.trans_id) as no_of_transactions,
Round(count(trans_id) /(datediff(max(ct.fulldatewithtime),ca.parseddate)/365.0),2) AS transactions_per_year,
Case 
    when count(trans_id) /(datediff(max(ct.fulldatewithtime),ca.parseddate)/365.0) < 1 then 'Dormant'
    when count(trans_id) /(datediff(max(ct.fulldatewithtime),ca.parseddate)/365.0) < 5 then  'Low Activity'
    when count(trans_id) /(datediff(max(ct.fulldatewithtime),ca.parseddate)/365.0) < 15 then 'Moderate'
    else 'High Usage'
    end AS usage_category
from completedaccounts ca left join 
completedtrans ct on ca.account_id = ct.account_id
group by ca.account_id
order by no_of_transactions;


-- C. Opened Long Ago
-- Dormancy Classification for Old Accounts

-- If open > 3 years AND no transaction in last 1 year => Dormant
select 
ca.account_id as Account_id,
ca.parseddate as open_date,
max(ct.fulldatewithtime) as Latest_transaction,
datediff(max(ct.fulldatewithtime),ca.parseddate) as account_age,
datediff((select MAX(fulldatewithtime) FROM CompletedTrans),MAX(ct.fulldatewithtime)) as days_since_last_transaction,
case 
   when  datediff(max(ct.fulldatewithtime),ca.parseddate) >= 1095
   and datediff((select MAX(fulldatewithtime) FROM CompletedTrans),MAX(ct.fulldatewithtime)) >= 365
   then "Dormant"
   else "Active"
   end as account_status
from completedaccounts ca
left join completedtrans ct 
on ca.account_id = ct.account_id
group by account_id
order by days_since_last_transaction desc;


select 
ca.account_id as Account_id,
ca.parseddate as open_date,
max(ct.fulldatewithtime) as Latest_transaction,
datediff(max(ct.fulldatewithtime),ca.parseddate) as account_age,
datediff((select MAX(fulldatewithtime) FROM CompletedTrans),MAX(ct.fulldatewithtime)) as days_since_last_transaction,
case 
   when  datediff(max(ct.fulldatewithtime),ca.parseddate) >= 1095
   and datediff((select MAX(fulldatewithtime) FROM CompletedTrans),MAX(ct.fulldatewithtime)) >= 365
   then "Dormant"
   else "Active"
   end as account_status
from completedaccounts ca
left join completedtrans ct 
on ca.account_id = ct.account_id
group by account_id
order by days_since_last_transaction desc;


--  Classify Accounts as Dormant if Low Balance and No Recent Activity
select 
ca.account_id as Account_id,
ca.parseddate as open_date,
ct.balance as balance,
max(ct.fulldatewithtime) as Latest_transaction,
datediff((select MAX(fulldatewithtime) FROM CompletedTrans),MAX(ct.fulldatewithtime)) as days_since_last_transaction,
case 
   when  ct.balance <=100
   and datediff((select MAX(fulldatewithtime) FROM CompletedTrans),MAX(ct.fulldatewithtime)) >= 90
   then "Dormant"
   else "Active"
   end as account_status
from completedaccounts ca
left join completedtrans ct 
on ca.account_id = ct.account_id
group by account_id
order by days_since_last_transaction desc;

-- Latest Balance per Account
SELECT 
  ct1.account_id,
  ct1.fulldatewithtime AS latest_transaction,
  ct1.balance
FROM completedtrans ct1
JOIN (
    SELECT account_id, MAX(fulldatewithtime) AS max_time
    FROM completedtrans
    GROUP BY account_id
) ct2
ON ct1.account_id = ct2.account_id 
   AND ct1.fulldatewithtime = ct2.max_time;
   

-- Final Account Status (Latest Balance + Dormancy Check)
WITH LatestTrans AS (
    SELECT 
        account_id,
        MAX(fulldatewithtime) AS latest_transaction
    FROM completedtrans
    GROUP BY account_id
), 
LatestBalance AS (
    SELECT 
        ct.account_id,
        ct.fulldatewithtime,
        ct.balance
    FROM completedtrans ct
    JOIN LatestTrans lt
      ON ct.account_id = lt.account_id
     AND ct.fulldatewithtime = lt.latest_transaction
), 
FinalStatus AS (
    SELECT 
        ca.account_id,
        ca.parseddate AS open_date,
        lb.balance,
        lb.fulldatewithtime AS latest_transaction,
        DATEDIFF(
            (SELECT MAX(fulldatewithtime) FROM completedtrans),
            lb.fulldatewithtime
        ) AS days_since_last_transaction,
        CASE 
            WHEN lb.balance <= 100 
             AND DATEDIFF(
                 (SELECT MAX(fulldatewithtime) FROM completedtrans),
                 lb.fulldatewithtime
             ) > 90
            THEN 'Dormant'
            ELSE 'Active'
        END AS account_status
    FROM completedaccounts ca
    LEFT JOIN LatestBalance lb
      ON ca.account_id = lb.account_id
)
SELECT *
FROM FinalStatus
ORDER BY days_since_last_transaction DESC;


-- Account Status Classification Using Latest Balance and Transaction Date (Refined with CTEs
WITH MaxDate AS (
    SELECT MAX(fulldatewithtime) AS max_date FROM completedtrans
),
LatestTrans AS (
    SELECT account_id, MAX(fulldatewithtime) AS latest_transaction
    FROM completedtrans
    GROUP BY account_id
),
LatestBalance AS (
    SELECT ct.account_id, ct.fulldatewithtime, ct.balance
    FROM completedtrans ct
    JOIN LatestTrans lt
      ON ct.account_id = lt.account_id
     AND ct.fulldatewithtime = lt.latest_transaction
),
FinalStatus AS (
    SELECT 
        ca.account_id,
        ca.parseddate AS open_date,
        lb.balance,
        lb.fulldatewithtime AS latest_transaction,
        DATEDIFF(md.max_date, lb.fulldatewithtime) AS days_since_last_transaction,
        CASE 
            WHEN lb.balance <= 100 AND DATEDIFF(md.max_date, lb.fulldatewithtime) > 90
            THEN 'Dormant'
            ELSE 'Active'
        END AS account_status
    FROM completedaccounts ca
    LEFT JOIN LatestBalance lb ON ca.account_id = lb.account_id
    CROSS JOIN MaxDate md
)
SELECT *
FROM FinalStatus
ORDER BY days_since_last_transaction DESC;


-- A. High Frequency in Short Time
-- Account Status Using Latest Transaction and Balance (Simpler Variant)
SELECT 
  ca.account_id,
  ca.parseddate AS open_date,
  latest_tx.latest_transaction,
  latest_tx.balance,
  latest_tx.days_since_last_transaction,
  CASE 
    WHEN latest_tx.balance <= 100
         AND latest_tx.days_since_last_transaction >= 90
    THEN 'Dormant'
    ELSE 'Active'
  END AS account_status
FROM completedaccounts ca
LEFT JOIN (
    SELECT 
      ct1.account_id,
      ct1.fulldatewithtime AS latest_transaction,
      ct1.balance,
      DATEDIFF((SELECT MAX(fulldatewithtime) FROM completedtrans), ct1.fulldatewithtime) AS days_since_last_transaction
    FROM completedtrans ct1
    JOIN (
        SELECT account_id, MAX(fulldatewithtime) AS max_time
        FROM completedtrans
        GROUP BY account_id
    ) ct2
    ON ct1.account_id = ct2.account_id AND ct1.fulldatewithtime = ct2.max_time
) latest_tx
ON ca.account_id = latest_tx.account_id
ORDER BY latest_tx.balance ;

-- Accounts with More Than 5 Transactions in a Single Day
select 
ca.account_id,
ct.fulldate,
count(ct.trans_id) as total_no_transactions
from completedaccounts ca 
left join completedtrans ct 
on ca.account_id = ct.account_id 
group by ca.account_id,ct.fulldate
having total_no_transactions > 5; 


--  Maximum Number of Transactions Done in a Day per Account
SELECT 
  MAX(tx_count) AS max_txn_per_day
FROM (
  SELECT 
    ca.account_id,
    ct.fulldate,
    COUNT(ct.trans_id) AS tx_count
  FROM completedaccounts ca 
  LEFT JOIN completedtrans ct 
    ON ca.account_id = ct.account_id 
  GROUP BY ca.account_id, ct.fulldate
) sub;

-- Large Inflows & Outflows Without Balance Buildup
-- Count of Transactions with Undefined or Unexpected Types (Not 'Credit' or 'Debit')
select count(*) 
from completedtrans
where type not in ("Credit","Debit");
 

-- High Inflows and Outflows But Low Latest Balance (Likely Flow-Through Accounts)
SELECT 
    ca.account_id,
    SUM(CASE WHEN ct.type = 'credit' THEN ct.amount ELSE 0 END) AS total_inflow,
    SUM(CASE WHEN ct.type = 'debit' THEN ct.amount ELSE 0 END) AS total_outflow,
    lb.balance AS latest_balance
FROM CompletedAccounts ca
LEFT JOIN CompletedTrans ct 
    ON ca.account_id = ct.account_id
LEFT JOIN (
    SELECT account_id, balance
    FROM (
        SELECT 
            account_id,
            balance,
            ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY fulldatewithtime DESC) AS rn
        FROM CompletedTrans
    ) sub
    WHERE rn = 1
) lb 
    ON ca.account_id = lb.account_id
GROUP BY ca.account_id, lb.balance
HAVING 
    SUM(CASE WHEN ct.type = 'credit' THEN ct.amount ELSE 0 END) > 50000 AND
    SUM(CASE WHEN ct.type = 'debit' THEN ct.amount ELSE 0 END) > 50000 AND
    lb.balance < 5000;
    

-- High Inflow/Outflow Accounts with Low Balance Using Percentile Ranking
-- Step 1: Get inflow/outflow per account
WITH inflow_outflow AS (
    SELECT 
        ca.account_id,
        SUM(CASE WHEN ct.type = 'credit' THEN ct.amount ELSE 0 END) AS total_inflow,
        SUM(CASE WHEN ct.type = 'debit' THEN ct.amount ELSE 0 END) AS total_outflow
    FROM CompletedAccounts ca
    LEFT JOIN CompletedTrans ct 
        ON ca.account_id = ct.account_id
    GROUP BY ca.account_id
),
-- Step 2: Assign percentile ranks (approximate)
inflow_ranked AS (
    SELECT *,
        NTILE(100) OVER (ORDER BY total_inflow) AS inflow_percentile,
        NTILE(100) OVER (ORDER BY total_outflow) AS outflow_percentile
    FROM inflow_outflow
),
-- Step 3: Get latest balance per account
latest_balance AS (
    SELECT account_id, balance
    FROM (
        SELECT 
            account_id,
            balance,
            ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY fulldatewithtime DESC) AS rn
        FROM CompletedTrans
    ) sub
    WHERE rn = 1
)
-- Step 4: Final selection using 75th percentile and low balance
SELECT 
    r.account_id,
    r.total_inflow,
    r.total_outflow,
    lb.balance AS latest_balance
FROM inflow_ranked r
LEFT JOIN latest_balance lb ON r.account_id = lb.account_id
WHERE 
    r.inflow_percentile >= 75 AND
    r.outflow_percentile >= 75 AND
    lb.balance < 5000;
    

-- immediate credit and debit(it could be added to above to get time based activity) 
SELECT 
    c.account_id,
    c.trans_id AS credit_txn_id,
    c.fulldatewithtime AS credit_time,
    c.amount AS credit_amount,
    
    d.trans_id AS debit_txn_id,
    d.fulldatewithtime AS debit_time,
    d.amount AS debit_amount,
    
    TIMESTAMPDIFF(HOUR, c.fulldatewithtime, d.fulldatewithtime) AS hours_between
FROM CompletedTrans c
JOIN CompletedTrans d
  ON c.account_id = d.account_id
  AND c.type = 'credit'
  AND d.type = 'debit'
  AND d.fulldatewithtime > c.fulldatewithtime
  AND TIMESTAMPDIFF(HOUR, c.fulldatewithtime, d.fulldatewithtime) <= 24
WHERE c.amount >= 10000
ORDER BY c.account_id, c.fulldatewithtime;


--  Count of Rapid Credit-Debit Pairs Within 24 Hours by Account
WITH RapidFlow AS (
    SELECT 
        c.account_id,
        c.trans_id AS credit_txn_id,
        c.fulldatewithtime AS credit_time,
        c.amount AS credit_amount,
        d.trans_id AS debit_txn_id,
        d.fulldatewithtime AS debit_time,
        d.amount AS debit_amount,
        TIMESTAMPDIFF(HOUR, c.fulldatewithtime, d.fulldatewithtime) AS hours_between
    FROM CompletedTrans c
    JOIN CompletedTrans d
      ON c.account_id = d.account_id
      AND c.type = 'credit'
      AND d.type = 'debit'
      AND d.fulldatewithtime > c.fulldatewithtime
      AND TIMESTAMPDIFF(HOUR, c.fulldatewithtime, d.fulldatewithtime) <= 24
    WHERE c.amount >= 10000
)
SELECT 
    account_id,
    COUNT(*) AS rapid_flow_count
FROM RapidFlow
GROUP BY account_id
ORDER BY rapid_flow_count DESC;



-- C. Same Amount Repeating
--  Repeated Same Amount Transactions by Account (Frequency ≥ 10)
SELECT 
    account_id,
    amount,
    COUNT(*) AS frequency
FROM CompletedTrans
GROUP BY account_id, amount
HAVING COUNT(*) >= 10
ORDER BY frequency DESC;


--  Distinct Transaction Amounts Used Across All Accounts
select distinct(amount) from completedtrans; 


-- Most Frequently Used Transaction Amount per Account (Frequency ≥ 75)
SELECT account_id, amount, frequency
FROM (
    SELECT 
        account_id,
        amount,
        COUNT(*) AS frequency,
        Row_number() OVER (PARTITION BY account_id ORDER BY COUNT(*) DESC) AS rnk
    FROM CompletedTrans
    GROUP BY account_id, amount
) sub
WHERE rnk = 1 AND frequency >= 75
ORDER BY frequency DESC;


SELECT account_id, amount, frequency
FROM (
    SELECT 
        account_id,
        amount,
        COUNT(*) AS frequency,
        Row_number() OVER (PARTITION BY account_id ORDER BY COUNT(*) DESC) AS rnk
    FROM CompletedTrans
    GROUP BY account_id, amount
) sub
WHERE rnk = 1 AND frequency >= 75
ORDER BY frequency DESC;



-- Transactions at Odd Hours
--  Accounts with 10+ Transactions at Odd Hours (Outside 6 AM – 6 PM)
SELECT account_id, COUNT(*) AS odd_hour_txn_count
FROM CompletedTrans
WHERE HOUR(fulldatewithtime) not BETWEEN 6 AND 18
GROUP BY account_id
HAVING COUNT(*) >= 10
ORDER BY odd_hour_txn_count DESC;


-- All Accounts Ranked by Odd Hour Transactions Count
SELECT account_id, COUNT(*) AS odd_hour_txn_count
FROM CompletedTrans
WHERE HOUR(fulldatewithtime) not BETWEEN 6 AND 18
GROUP BY account_id
ORDER BY odd_hour_txn_count DESC;



-- Spikes After Long Dormancy For each account
-- Transactions Spiking After 90+ Days of Inactivity (Method 1 - CTE)
WITH lagged AS (
  SELECT 
    account_id,
    fulldatewithtime,
    LAG(fulldatewithtime) OVER (PARTITION BY account_id ORDER BY fulldatewithtime) AS prev_txn
  FROM completedtrans
),
dormant_breakers AS ( 
select
  account_id,
  fulldatewithtime as breaker_time,
  prev_txn,
  DATEDIFF(fulldatewithtime, prev_txn) AS gap_days
FROM lagged 
where  DATEDIFF(fulldatewithtime, prev_txn) > 90
)
SELECT 
  db.account_id,
  db.breaker_time,
  COUNT(ct.fulldatewithtime) AS txns_in_next_7_days
FROM dormant_breakers db
JOIN completedtrans ct 
  ON db.account_id = ct.account_id
  AND ct.fulldatewithtime > db.breaker_time
  AND ct.fulldatewithtime <= DATE_ADD(db.breaker_time, INTERVAL 7 DAY)
GROUP BY db.account_id, db.breaker_time
HAVING COUNT(ct.fulldatewithtime) >= 3; 


-- Spikes After Long Dormancy For each account
-- Transactions Spiking After 90+ Days of Inactivity (Method 2 - Inline Subquery)
WITH lagged AS (
  SELECT 
    account_id,
    fulldatewithtime,
    LAG(fulldatewithtime) OVER (PARTITION BY account_id ORDER BY fulldatewithtime) AS prev_txn
  FROM completedtrans
)
SELECT 
  db.account_id,
  db.breaker_time,
  COUNT(ct.fulldatewithtime) AS txns_in_next_7_days
FROM (select
  account_id,
  fulldatewithtime as breaker_time,
  prev_txn,
  DATEDIFF(fulldatewithtime, prev_txn) AS gap_days
FROM lagged 
where  DATEDIFF(fulldatewithtime, prev_txn) > 90) db
JOIN completedtrans ct 
  ON db.account_id = ct.account_id
  AND ct.fulldatewithtime > db.breaker_time
  AND ct.fulldatewithtime <= DATE_ADD(db.breaker_time, INTERVAL 7 DAY)
GROUP BY db.account_id, db.breaker_time
HAVING COUNT(ct.fulldatewithtime) >= 3; 


-- Spikes After Long Dormancy For each account
-- Transactions Spiking After Dormancy with Gap Info Included (Method 3 - Simplified)
SELECT 
  db.account_id,
  db.breaker_time,
  db.prev_txn,
  db.gap_days,
  COUNT(ct.fulldatewithtime) AS txns_in_next_7_days
FROM (
  SELECT 
    account_id,
    fulldatewithtime AS breaker_time,
    LAG(fulldatewithtime) OVER (PARTITION BY account_id ORDER BY fulldatewithtime) AS prev_txn,
    DATEDIFF(fulldatewithtime, LAG(fulldatewithtime) OVER (PARTITION BY account_id ORDER BY fulldatewithtime)) AS gap_days
  FROM completedtrans
) db
JOIN completedtrans ct 
  ON db.account_id = ct.account_id
  AND ct.fulldatewithtime > db.breaker_time
  AND ct.fulldatewithtime <= DATE_ADD(db.breaker_time, INTERVAL 7 DAY)
WHERE db.gap_days > 90
GROUP BY db.account_id, db.breaker_time, db.prev_txn, db.gap_days
HAVING COUNT(ct.fulldatewithtime) >= 3;


-- Frequent Overdrafts or Negative Balance
-- Accounts with Frequent Negative Balances (Count ≥ 5)
SELECT 
  account_id,
  COUNT(*) AS negative_balance_count,
  MAX(fulldatewithtime) AS last_negative_balance_date
FROM completedtrans
WHERE balance < 0
GROUP BY account_id
HAVING COUNT(*) >= 5  -- You can adjust this threshold
ORDER BY negative_balance_count DESC;


-- Negative Balance Summary Over 6 Months and Lifetime
SELECT 
    account_id,
    COUNT(*) AS total_negative_days,
    SUM(
        CASE 
            WHEN fulldatewithtime >= (
                SELECT MAX(fulldatewithtime) - INTERVAL 6 MONTH 
                FROM completedtrans
            )
            THEN 1 
            ELSE 0 
        END
    ) AS recent_negative_days
FROM completedtrans
WHERE balance < 0
GROUP BY account_id
HAVING recent_negative_days >= 5 OR total_negative_days >= 15;



--  Sudden Transaction Spikes
--  Sudden Monthly Transaction Spikes (≥ 10x Previous Month)
WITH monthly_txns AS (
  SELECT 
    account_id,
    DATE_FORMAT(fulldatewithtime, '%Y-%m') AS year_n_month,
    COUNT(*) AS monthly_txn_count
  FROM completedtrans
  GROUP BY account_id, year_n_month
),
ranked_months AS (
  SELECT *,
    ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY year_n_month) AS month_rank
  FROM monthly_txns
  ),
monthly_with_prev AS (
  SELECT 
    account_id,
    year_n_month,
    monthly_txn_count,
    LAG(monthly_txn_count) OVER (PARTITION BY account_id ORDER BY month_rank) AS prev_month_txn
  FROM ranked_months
)
SELECT 
  account_id,
  year_n_month,
  monthly_txn_count,
  prev_month_txn,
  ROUND(monthly_txn_count / NULLIF(prev_month_txn, 0), 2) AS growth_ratio
FROM monthly_with_prev
WHERE prev_month_txn IS NOT NULL
  AND monthly_txn_count >= 10 * prev_month_txn  -- spike condition
ORDER BY account_id, year_n_month;



-- Monthly and Yearly Inflow/Outflow Trends
-- Monthly Inflow and Outflow by Transaction Type
SELECT 
  DATE_FORMAT(STR_TO_DATE(fulldatewithtime, '%Y-%m-%d %H:%i:%s'), '%Y-%m') AS year_n_month,
  type,
  SUM(amount) AS total_amount
FROM CompletedTrans
GROUP BY year_n_month, type
ORDER BY year_n_month;


-- Yearly Inflow, Outflow, and Net Flow Summary
SELECT 
  YEAR(STR_TO_DATE(fulldatewithtime, '%Y-%m-%d %H:%i:%s')) AS Years,
  SUM(CASE WHEN type = 'Credit' THEN amount ELSE 0 END) AS total_inflow,
  SUM(CASE WHEN type = 'Debit' THEN amount ELSE 0 END) AS total_outflow,
  SUM(CASE WHEN type = 'Credit' THEN amount ELSE 0 END) -
  SUM(CASE WHEN type = 'Debit' THEN amount ELSE 0 END) AS net_flow
FROM CompletedTrans
WHERE amount > 0
GROUP BY years
ORDER BY years;

-- . Monthly Inflow, Outflow, and Net Flow Summary
SELECT 
  DATE_FORMAT(STR_TO_DATE(fulldatewithtime, '%Y-%m-%d %H:%i:%s'), '%Y-%m') AS year_n_month,
  SUM(CASE WHEN type = 'Credit' THEN amount ELSE 0 END) AS total_inflow,
  SUM(CASE WHEN type = 'Debit' THEN amount ELSE 0 END) AS total_outflow,
  SUM(CASE WHEN type = 'Credit' THEN amount ELSE 0 END) -
  SUM(CASE WHEN type = 'Debit' THEN amount ELSE 0 END) AS net_flow
FROM CompletedTrans
WHERE amount > 0
GROUP BY year_n_month
ORDER BY year_n_month;









































