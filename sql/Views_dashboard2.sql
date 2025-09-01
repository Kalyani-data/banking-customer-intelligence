-- AccountSummary View1(whole view )
WITH transaction_summary AS (
    SELECT 
        ct.account_id,
        SUM(CASE WHEN ct.type = 'credit' THEN ct.amount ELSE 0 END) AS total_inflow,
        SUM(CASE WHEN ct.type = 'debit' THEN ct.amount ELSE 0 END) AS total_outflow,
        MAX(ct.fulldatewithtime) AS last_transaction,
        DATEDIFF(
            (SELECT MAX(fulldatewithtime) FROM completedtrans), 
            MAX(ct.fulldatewithtime)
        ) AS days_since_last_transaction
    FROM completedtrans ct
    GROUP BY ct.account_id
),
current_balance AS (
    SELECT t1.account_id, t1.balance
    FROM completedtrans t1
    JOIN (
        SELECT account_id, MAX(fulldatewithtime) AS max_date
        FROM completedtrans
        GROUP BY account_id
    ) t2 
      ON t1.account_id = t2.account_id 
     AND t1.fulldatewithtime = t2.max_date
)
SELECT 
    ca.account_id,
    ca.frequency,
    cd.district_id,
    cd.city,
    cd.state_name AS state,
    cd.division,
    cd.region,
    ca.parseddate,
    DATEDIFF((SELECT MAX(fulldatewithtime) FROM completedtrans), ca.parseddate) AS account_age,
    cb.balance,
    ts.total_inflow,
    ts.total_outflow,
    (ts.total_inflow - ts.total_outflow) AS netflow,
    CASE WHEN cb.balance < 0 THEN 'Yes' ELSE 'No' END AS NegativeBalanceFlag,
    CASE 
        WHEN ts.days_since_last_transaction > 365 THEN 'Dormant > 12M'
        WHEN ts.days_since_last_transaction > 180 THEN 'Dormant > 6M'
        ELSE 'Active'
    END AS dormancy_status
FROM completedaccounts ca
LEFT JOIN completeddistrict cd ON ca.district_id = cd.district_id
LEFT JOIN current_balance cb ON ca.account_id = cb.account_id
LEFT JOIN transaction_summary ts ON ca.account_id = ts.account_id;


-- made to small views for fast execution 
-- 
create view view_1 as 
SELECT 
    ca.account_id,
    ca.frequency,
    cd.district_id,
    cd.city,
    cd.state_name AS state,
    cd.division,
    cd.region,
    ca.parseddate,
    TIMESTAMPDIFF(DAY, ca.parseddate, (SELECT MAX(fulldatewithtime) FROM completedtrans))   AS account_age_days,
	TIMESTAMPDIFF(MONTH, ca.parseddate, (SELECT MAX(fulldatewithtime) FROM completedtrans)) AS account_age_months,
	TIMESTAMPDIFF(YEAR, ca.parseddate, (SELECT MAX(fulldatewithtime) FROM completedtrans))  AS account_age_years
FROM completedaccounts ca
LEFT JOIN completeddistrict cd ON ca.district_id = cd.district_id
group by ca.account_id;

-- 
create view view_2 as 
WITH transaction_summary AS (
    SELECT 
        ct.account_id,
        SUM(CASE WHEN ct.type = 'credit' THEN ct.amount ELSE 0 END) AS total_inflow,
        SUM(CASE WHEN ct.type = 'debit' THEN ct.amount ELSE 0 END) AS total_outflow,
        MAX(ct.fulldatewithtime) AS last_transaction,
        DATEDIFF(
            (SELECT MAX(fulldatewithtime) FROM completedtrans), 
            MAX(ct.fulldatewithtime)
        ) AS days_since_last_transaction
    FROM completedtrans ct
    GROUP BY ct.account_id
)
select
 ca.account_id,
 ts.total_inflow,
 ts.total_outflow,
 (ts.total_inflow - ts.total_outflow) AS netflow,
 ts.last_transaction,
 ts.days_since_last_transaction,
		CASE 
			WHEN ts.days_since_last_transaction > 365 THEN 'Dormant > 12M'
			WHEN ts.days_since_last_transaction > 180 THEN 'Dormant > 6M'
			ELSE 'Active'
		END AS dormancy_status
FROM completedaccounts ca
LEFT JOIN transaction_summary ts ON ca.account_id = ts.account_id;

-- 
create view view_3 as 
 SELECT t1.account_id, t1.balance
    FROM completedtrans t1
    JOIN (
        SELECT account_id, MAX(fulldatewithtime) AS max_date
        FROM completedtrans
        GROUP BY account_id
    ) t2 
      ON t1.account_id = t2.account_id 
     AND t1.fulldatewithtime = t2.max_date;

-- 
select count(distinct(account_id)) from view_1 ; 
select count(distinct(account_id)) from view_2;
select count(distinct(account_id)) from view_3; 

select * from view_1; 
select * from view_2; 
select * from view_3;

--
create view view_4 as 
select 
v1.*,
v2.total_inflow,v2.total_outflow,v2.netflow,v2.last_transaction,v2.days_since_last_transaction,
v2.dormancy_status
from view_1 v1 
left join view_2 v2 on v1.account_id = v2.account_id;

select * from view_4; 
select distinct(account_id) from view_4;

-- 
create view Dashboard2_AccountSummary as 
select 
v4.*,
v3.balance,
CASE WHEN v3.balance < 0 THEN 'Yes' ELSE 'No' END AS NegativeBalanceFlag
from  view_4 v4  join 
view_3  v3 on v4.account_id = v3.account_id;


select * from Dashboard2_AccountSummary;
select count(distinct(account_id)) from Dashboard2_AccountSummary;


-- TransactionTrends View(2) (whole view)

WITH monthly_txn AS (
    SELECT 
        ac.account_id,
        DATE_FORMAT(ct.fulldatewithtime, '%Y-%m') AS year_n_month,

        -- Monthly inflow
        SUM(CASE WHEN ct.type = 'Credit' THEN ct.amount ELSE 0 END) AS monthly_inflow,

        -- Monthly outflow
        SUM(CASE WHEN ct.type = 'Debit' THEN ct.amount ELSE 0 END) AS monthly_outflow,

        -- Net Flow
        SUM(CASE WHEN ct.type = 'Credit' THEN ct.amount ELSE 0 END) -
        SUM(CASE WHEN ct.type = 'Debit' THEN ct.amount ELSE 0 END) AS net_flow,

        -- Closing balance = latest balance in that month
        MAX(ct.fulldatewithtime) AS month_end_time
    FROM completedaccounts ac
    LEFT JOIN completedtrans ct 
           ON ac.account_id = ct.account_id
    GROUP BY ac.account_id, year_n_month
),
closing_balance AS (
    SELECT 
        t.account_id,
        DATE_FORMAT(t.fulldatewithtime, '%Y-%m') AS year_n_month,
        t.balance AS closing_balance
    FROM completedtrans t
    INNER JOIN (
        -- Get last transaction per account per month
        SELECT 
            account_id,
            DATE_FORMAT(fulldatewithtime, '%Y-%m') AS year_n_month,
            MAX(fulldatewithtime) AS last_txn_time
        FROM completedtrans
        GROUP BY account_id, year_n_month
    ) x
    ON t.account_id = x.account_id
    AND DATE_FORMAT(t.fulldatewithtime, '%Y-%m') = x.year_n_month
    AND t.fulldatewithtime = x.last_txn_time
)
SELECT 
    m.account_id,
    m.year_n_month,
    m.monthly_inflow,
    m.monthly_outflow,
    m.net_flow,
    m.month_end_time,
    c.closing_balance,

    -- Spike flag
    CASE 
        WHEN ( m.monthly_inflow >= 10 * LAG(m.monthly_inflow) OVER (PARTITION BY m.account_id ORDER BY m.year_n_month)
            OR  m.monthly_outflow >= 10 * LAG(m.monthly_outflow) OVER (PARTITION BY m.account_id ORDER BY m.year_n_month) )
        THEN 1 ELSE 0 
    END AS spike_flag,

    -- Low balance flag (closing balance < threshold = 1000)
    CASE 
        WHEN c.closing_balance < 1000 THEN 'Y' ELSE 'N' 
    END AS low_balance_flag
FROM monthly_txn m
LEFT JOIN closing_balance c
       ON m.account_id = c.account_id AND m.year_n_month = c.year_n_month;


-- 
create view Dashboard2_TransactionTrends1 as 
SELECT 
    ac.account_id,
    DATE_FORMAT(ct.fulldatewithtime, '%Y-%m') AS year_n_month,

    -- Monthly inflow
    SUM(CASE WHEN ct.type = 'Credit' THEN ct.amount ELSE 0 END) AS monthly_inflow,

    -- Monthly outflow
    SUM(CASE WHEN ct.type = 'Debit' THEN ct.amount ELSE 0 END) AS monthly_outflow,

    -- Net Flow
    SUM(CASE WHEN ct.type = 'Credit' THEN ct.amount ELSE 0 END) -
    SUM(CASE WHEN ct.type = 'Debit' THEN ct.amount ELSE 0 END) AS net_flow,

    -- Closing balance = just month-end timestamp (used later for join)
    MAX(ct.fulldatewithtime) AS month_end_time,

    -- Spike flag
    CASE 
        WHEN ( SUM(CASE WHEN ct.type = 'Credit' THEN ct.amount ELSE 0 END) >= 
                   10 * LAG(SUM(CASE WHEN ct.type = 'Credit' THEN ct.amount ELSE 0 END)) 
                      OVER (PARTITION BY ac.account_id ORDER BY DATE_FORMAT(ct.fulldatewithtime, '%Y-%m'))
            OR  SUM(CASE WHEN ct.type = 'Debit' THEN ct.amount ELSE 0 END) >= 
                   10 * LAG(SUM(CASE WHEN ct.type = 'Debit' THEN ct.amount ELSE 0 END)) 
                      OVER (PARTITION BY ac.account_id ORDER BY DATE_FORMAT(ct.fulldatewithtime, '%Y-%m')) )
        THEN 1 ELSE 0 
    END AS spike_flag

FROM completedaccounts ac
LEFT JOIN completedtrans ct 
       ON ac.account_id = ct.account_id
GROUP BY ac.account_id, year_n_month;

--
create view Dashboard2_TransactionTrends2 as 
SELECT 
    ac.account_id,
    DATE_FORMAT(t.fulldatewithtime, '%Y-%m') AS year_n_month,
    t.balance AS closing_balance,
    CASE 
        WHEN t.balance < 1000 THEN 'Y' 
        ELSE 'N' 
    END AS low_balance_flag
FROM completedaccounts ac 
LEFT JOIN completedtrans t 
    ON t.account_id = ac.account_id 
INNER JOIN (
    SELECT 
        account_id,
        DATE_FORMAT(fulldatewithtime, '%Y-%m') AS year_n_month,
        MAX(fulldatewithtime) AS last_txn_time
    FROM completedtrans
    GROUP BY account_id, year_n_month
) x
ON t.account_id = x.account_id
AND DATE_FORMAT(t.fulldatewithtime, '%Y-%m') = x.year_n_month
AND t.fulldatewithtime = x.last_txn_time;


select * from Dashboard2_TransactionTrends1;

select * from Dashboard2_TransactionTrends2;



-- view3-TransactionPatterns View
CREATE OR REPLACE VIEW Dashboard2_TransactionPatterns_final AS
WITH base AS (
    SELECT 
        t.account_id,
        t.trans_id,
        DATE(t.fulldatewithtime) AS transaction_date,
        TIME(t.fulldatewithtime) AS transaction_time,
        t.amount,
        t.type,
        t.fulldatewithtime,

        -- Odd hour flag
        CASE 
            WHEN HOUR(t.fulldatewithtime) < 6 OR HOUR(t.fulldatewithtime) >= 18 
            THEN 1 ELSE 0 
        END AS odd_hour_flag
    FROM completedtrans t
),

-- Repeated amount count per account
repeated AS (
    SELECT account_id, amount, COUNT(*) AS repeated_amount_count
    FROM completedtrans
    GROUP BY account_id, amount
),

-- Daily transaction count per account
daily AS (
    SELECT account_id, DATE(fulldatewithtime) AS transaction_date, COUNT(*) AS daily_transaction_count
    FROM completedtrans
    GROUP BY account_id, DATE(fulldatewithtime)
),

-- Rapid credit/debit detection (self join within 24 hours)
rapid AS (
    SELECT DISTINCT t1.trans_id, 1 AS rapid_credit_debit_flag
    FROM completedtrans t1
    JOIN completedtrans t2 
      ON t1.account_id = t2.account_id
     AND t1.trans_id <> t2.trans_id
     AND ABS(TIMESTAMPDIFF(HOUR, t1.fulldatewithtime, t2.fulldatewithtime)) <= 24
     AND (
           (t1.type = 'Credit' AND t2.type = 'Debit')
        OR (t1.type = 'Debit'  AND t2.type = 'Credit')
     )
)

SELECT 
    b.account_id,
    b.trans_id,
    b.transaction_date,
    b.transaction_time,
    b.amount,
    b.type,
    b.odd_hour_flag,
    COALESCE(r.rapid_credit_debit_flag, 0) AS rapid_credit_debit_flag,
    ra.repeated_amount_count,
    d.daily_transaction_count
FROM base b
LEFT JOIN repeated ra 
       ON b.account_id = ra.account_id AND b.amount = ra.amount
LEFT JOIN daily d 
       ON b.account_id = d.account_id AND b.transaction_date = d.transaction_date
LEFT JOIN rapid r 
       ON b.trans_id = r.trans_id;



-- view4- DormancyBehavior View
CREATE OR REPLACE VIEW Dashboard2_DormancyBehavior AS
WITH
-- Parse once to a real DATETIME
Parsed AS (
  SELECT
    account_id,
    trans_id,
    amount,
    STR_TO_DATE(fulldatewithtime, '%Y-%m-%d %H:%i:%s') AS ts
  FROM CompletedTrans
),

-- Global reference point = last timestamp present in the data
MaxDate AS (
  SELECT MAX(ts) AS max_ts FROM Parsed
),

-- Latest transaction per account
LastTx AS (
  SELECT account_id, MAX(ts) AS last_tx
  FROM Parsed
  GROUP BY account_id
),

-- Dormancy vs dataset's max timestamp
DormantCalc AS (
  SELECT
    l.account_id,
    DATE(l.last_tx) AS LastTransactionDate,
    DATEDIFF(DATE(m.max_ts), DATE(l.last_tx)) AS DormantDays,
    CASE WHEN DATEDIFF(DATE(m.max_ts), DATE(l.last_tx)) > 90 THEN 1 ELSE 0 END AS DormantFlag
  FROM LastTx l
  CROSS JOIN MaxDate m
),

-- Find gaps between consecutive txns
Lagged AS (
  SELECT
    p.account_id,
    p.ts,
    p.amount,
    LAG(p.ts)  OVER (PARTITION BY p.account_id ORDER BY p.ts) AS prev_ts,
    TIMESTAMPDIFF(DAY,
      LAG(p.ts) OVER (PARTITION BY p.account_id ORDER BY p.ts),
      p.ts
    ) AS gap_days
  FROM Parsed p
),

-- First txn that follows a gap > 90 days (the dormancy breaker)
Breaker AS (
  SELECT account_id, MIN(ts) AS DormancyBreakerDate
  FROM Lagged
  WHERE gap_days > 90
  GROUP BY account_id
),

-- Attach the breaker amount
BreakerWithAmount AS (
  SELECT
    b.account_id,
    b.DormancyBreakerDate,
    p.amount AS DormancyBreakerAmount
  FROM Breaker b
  JOIN Parsed p
    ON p.account_id = b.account_id
   AND p.ts = b.DormancyBreakerDate
),

-- Baseline: average absolute amount BEFORE the breaker
PreBreakerAvg AS (
  SELECT
    b.account_id,
    AVG(ABS(p.amount)) AS AvgBeforeDormancy
  FROM Breaker b
  JOIN Parsed p
    ON p.account_id = b.account_id
   AND p.ts < b.DormancyBreakerDate
  GROUP BY b.account_id
)

-- Final projection
SELECT
  d.account_id AS AccountID,
  d.LastTransactionDate,
  d.DormantDays,
  d.DormantFlag,
  b.DormancyBreakerDate,
  b.DormancyBreakerAmount,
  CASE
    WHEN b.DormancyBreakerAmount IS NOT NULL
     AND pb.AvgBeforeDormancy IS NOT NULL
     AND ABS(b.DormancyBreakerAmount) >= 3 * pb.AvgBeforeDormancy
      THEN 1 ELSE 0
  END AS PostDormancySpikeFlag
FROM DormantCalc d
LEFT JOIN BreakerWithAmount b ON b.account_id = d.account_id
LEFT JOIN PreBreakerAvg   pb ON pb.account_id = d.account_id;

select max(fulldatewithtime) from completedtrans; 

select * from Dashboard2_DormancyBehavior;


-- view-5 PaymentBehavior View
CREATE VIEW Dashboard2_PaymentBehavior  AS
SELECT 
    t.Trans_iD,
    t.Account_id,
    t.fulldatewithtime AS TransactionDate,
    t.type,
    t.Operation AS PaymentType,      -- using operation instead of k_symbol
    d.Region,
    t.Amount,
    
    -- Payer (if transaction is debit → sender)
    CASE WHEN t.Type = 'debit' THEN t.Account_id END AS PayerID,
    
    -- Receiver (if transaction is credit → receiver)
    CASE WHEN t.Type = 'credit' THEN t.Account_id END AS ReceiverID,
    
    -- Aggregated total # of payments per account
    COUNT(t.Trans_id) OVER (PARTITION BY t.Account_id) AS TotalPaymentsByAccount,
    
    -- Aggregated total amount per account
    SUM(t.Amount) OVER (PARTITION BY t.Account_id) AS TotalAmountByAccount

FROM CompletedTrans t
JOIN CompletedAccounts a 
    ON t.Account_id = a.Account_id
JOIN CompletedDistrict d 
    ON a.District_id = d.District_id;
    


select * from dashboard2_accountsummary;
select * from dashboard2_transactiontrends1;
select * from dashboard2_transactiontrends2;
select * from dashboard2_transactionpatterns_final;
select * from dashboard2_dormancybehavior;
select * from dashboard2_paymentbehavior;

select sum(amount) from completedtrans;

