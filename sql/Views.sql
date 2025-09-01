
-- Dashboard 1: Client-Level View 
-- Dashboard 1: Client-Level View
CREATE VIEW Dashboard1_ClientView AS
-- Step 1: Get the latest balance per account
WITH  LatestBalance AS (
    SELECT t1.account_id, t1.balance
    FROM CompletedTrans t1
    JOIN (
        SELECT account_id, MAX(fulldatewithtime) AS max_date
        FROM CompletedTrans
        GROUP BY account_id
    ) t2 ON t1.account_id = t2.account_id AND t1.fulldatewithtime = t2.max_date
),
-- Step 2: Count loans only for OWNER type
LoanOwner AS (
    SELECT 
        cd.client_id,
        COUNT(cl.loan_id) AS no_of_loans,
        SUM(CASE WHEN cd.type = 'OWNER' THEN cl.amount ELSE 0 END) AS total_loan_amount
    FROM CompletedDispositions cd
    LEFT JOIN CompletedLoan cl ON cl.account_id = cd.account_id
    GROUP BY cd.client_id
),
-- Step 3: Aggregate accounts, cards, transactions per client
ClientAggregates AS (
    SELECT
        cc.client_id,
        COUNT(DISTINCT ca.account_id) AS no_of_accounts,
        COUNT(DISTINCT ccs.card_id) AS no_of_cards,
        COUNT(ct.trans_id) AS no_of_transactions,
        SUM(lb.balance) AS latest_balance
    FROM CompletedClients cc
    LEFT JOIN CompletedDispositions cdsp ON cc.client_id = cdsp.client_id
    LEFT JOIN CompletedAccounts ca ON ca.account_id = cdsp.account_id
    LEFT JOIN CompletedCards ccs ON ccs.disp_id = cdsp.disp_id
    LEFT JOIN CompletedTrans ct ON ct.account_id = ca.account_id
    LEFT JOIN LatestBalance lb ON lb.account_id = ca.account_id
    GROUP BY cc.client_id
)
-- Step 4: Final client-level SELECT for Dashboard 1
SELECT
    cc.client_id,
    cc.fullname,
    cc.age,
    cc.sex,
    CASE 
        WHEN cc.age BETWEEN 10 AND 19 THEN 'Teens'
        WHEN cc.age BETWEEN 20 AND 34 THEN 'Young Adults'
        WHEN cc.age BETWEEN 35 AND 49 THEN 'Adults'
        WHEN cc.age BETWEEN 50 AND 64 THEN 'Middle-aged'
        WHEN cc.age >= 65 THEN 'Seniors'
        ELSE 'Unknown'
    END AS age_group,
    cd.district_id,
    cd.region,
    cd.state_name AS state,
    cd.city,
    cd.division,
    agg.no_of_accounts,
    agg.no_of_cards,
    lo.no_of_loans,
    lo.total_loan_amount,
    agg.latest_balance,
    agg.no_of_transactions
FROM CompletedClients cc
LEFT JOIN CompletedDistrict cd ON cc.district_id = cd.district_id
LEFT JOIN LoanOwner lo ON lo.client_id = cc.client_id
LEFT JOIN ClientAggregates agg ON agg.client_id = cc.client_id;








-- client details 1 
CREATE VIEW ClientInfoView AS
-- Loan info (only OWNER dispositions)
WITH LoanOwner AS (
    SELECT 
        cd.client_id,
        COUNT(cl.loan_id) AS no_of_loans,
        SUM(CASE WHEN cd.type = 'OWNER' THEN cl.amount ELSE 0 END) AS total_loan_amount
    FROM CompletedDispositions cd
    LEFT JOIN CompletedLoan cl ON cl.account_id = cd.account_id
    GROUP BY cd.client_id
),
-- Aggregates per client
ClientAggregates AS (
    SELECT
        cc.client_id,
        COUNT(DISTINCT ca.account_id) AS no_of_accounts,
        COUNT(DISTINCT ccs.card_id) AS no_of_cards
    FROM CompletedClients cc
    LEFT JOIN CompletedDispositions cdsp ON cc.client_id = cdsp.client_id
    LEFT JOIN CompletedAccounts ca ON ca.account_id = cdsp.account_id
    LEFT JOIN CompletedCards ccs ON ccs.disp_id = cdsp.disp_id
    GROUP BY cc.client_id
)
SELECT
    cc.client_id,
    cc.fullname,
    cc.age,
    cc.sex,
    CASE 
        WHEN cc.age BETWEEN 10 AND 19 THEN 'Teens'
        WHEN cc.age BETWEEN 20 AND 34 THEN 'Young Adults'
        WHEN cc.age BETWEEN 35 AND 49 THEN 'Adults'
        WHEN cc.age BETWEEN 50 AND 64 THEN 'Middle-aged'
        WHEN cc.age >= 65 THEN 'Seniors'
        ELSE 'Unknown'
    END AS age_group,
    cd.district_id,
    cd.region,
    cd.state_name AS state,
    cd.city,
    cd.division,
    agg.no_of_accounts,
    agg.no_of_cards,
    lo.no_of_loans,
    lo.total_loan_amount
FROM CompletedClients cc
LEFT JOIN CompletedDistrict cd ON cc.district_id = cd.district_id
LEFT JOIN LoanOwner lo ON lo.client_id = cc.client_id
LEFT JOIN ClientAggregates agg ON agg.client_id = cc.client_id;


-- -- client details 2
CREATE VIEW TransactionView1 AS
WITH  LatestBalance AS (
    SELECT t1.account_id, t1.balance
    FROM CompletedTrans t1
    JOIN (
        SELECT account_id, MAX(fulldatewithtime) AS max_date
        FROM CompletedTrans
        GROUP BY account_id
    ) t2 ON t1.account_id = t2.account_id AND t1.fulldatewithtime = t2.max_date),
number_or_transactions as (
	select 
	account_id,
	count(trans_id) as number_of_transactions
	from completedtrans
group by account_id)
select 
lb.account_id,
lb.balance,
nt.number_of_transactions
from  LatestBalance lb 
join number_or_transactions nt on lb.account_id = nt.account_id ;


create view TransactionView2 as 
select 
ct.client_id,
ca.account_id
from completedclients ct 
left join CompletedDispositions cd on cd.client_id = ct.client_id
left join completedaccounts ca on ca.account_id = cd.account_id;

select * from Transactionview1;
select * from Transactionview2;

create view Transactionview as 
select 
tv2.client_id,
tv2.account_id,
tv1.balance,
tv1.number_of_transactions
from transactionview2 tv2 
join  transactionview1 tv1 on tv1.account_id = tv2.account_id;

select * from ClientInfoView ; 

select * from  Transactionview ; 

select count(distinct(client_id)) from Transactionview; 


CREATE VIEW Dashboard1_ClientView AS
select 
cv.* , tv.balance, tv.number_of_transactions
from ClientInfoView cv 
join Transactionview tv on cv.client_id = tv.client_id;

select distinct(client_id) from Dashboard1_ClientView;

select count(distinct(client_id)) from Dashboard1_ClientView;

describe Dashboard1_ClientView;

select * from completeddispositions;


create view client_type as 
select 
cc.client_id,
cd.type
from CompletedClients cc 
left join Completeddispositions cd on cc.client_id = cd.client_id; 

select * from client_type; 


select 
cv.*, 
ct.type
from Dashboard1_ClientView cv 
left join client_type ct on  cv.client_id = ct.client_id ;

select distinct(sex) from Dashboard1_ClientView;

select * from Dashboard1_ClientView;

describe Dashboard1_ClientView;

select * from dashboard1_clientview where no_of_loans > 0 and total_loan_amount = 0; 

select * from dashboard1_clientview where no_of_loans = 0 and total_loan_amount > 0; 

select * from CompletedLoan; 

select * from completedloan where amount = 0;


select 
cc.client_id,
count(cl.loan_id),
sum(cl.amount)
from completedclients cc 
left join completeddispositions cd on cc.client_id = cd.client_id 
left join completedaccounts ca on ca.account_id = cd.account_id 
left join completedloan cl on cl.account_id = ca.account_id 
group by client_id ;




-- Fixing errors 
-- client details 1 
CREATE OR REPLACE view ClientInfoView AS
-- Loan info (only OWNER dispositions)
WITH LoanOwner AS (
    SELECT 
        cd.client_id,
        COUNT(CASE WHEN cd.type = 'OWNER' THEN cl.loan_id END) AS no_of_loans,
        SUM(CASE WHEN cd.type = 'OWNER' THEN cl.amount ELSE 0 END) AS total_loan_amount
    FROM CompletedDispositions cd
    LEFT JOIN CompletedLoan cl ON cl.account_id = cd.account_id
    GROUP BY cd.client_id
),
-- Aggregates per client
ClientAggregates AS (
    SELECT
        cc.client_id,
        COUNT(DISTINCT ca.account_id) AS no_of_accounts,
        COUNT(DISTINCT ccs.card_id) AS no_of_cards
    FROM CompletedClients cc
    LEFT JOIN CompletedDispositions cdsp ON cc.client_id = cdsp.client_id
    LEFT JOIN CompletedAccounts ca ON ca.account_id = cdsp.account_id
    LEFT JOIN CompletedCards ccs ON ccs.disp_id = cdsp.disp_id
    GROUP BY cc.client_id
)
SELECT
    cc.client_id,
    cc.fullname,
    cc.age,
    cc.sex,
    CASE 
        WHEN cc.age BETWEEN 10 AND 19 THEN 'Teens'
        WHEN cc.age BETWEEN 20 AND 34 THEN 'Young Adults'
        WHEN cc.age BETWEEN 35 AND 49 THEN 'Adults'
        WHEN cc.age BETWEEN 50 AND 64 THEN 'Middle-aged'
        WHEN cc.age >= 65 THEN 'Seniors'
        ELSE 'Unknown'
    END AS age_group,
    cd.district_id,
    cd.region,
    cd.state_name AS state,
    cd.city,
    cd.division,
    agg.no_of_accounts,
    agg.no_of_cards,
    lo.no_of_loans,
    lo.total_loan_amount
FROM CompletedClients cc
LEFT JOIN CompletedDistrict cd ON cc.district_id = cd.district_id
LEFT JOIN LoanOwner lo ON lo.client_id = cc.client_id
LEFT JOIN ClientAggregates agg ON agg.client_id = cc.client_id;



select * from ClientInfoView ; 

select * from  Transactionview ; 

select count(distinct(client_id)) from Transactionview; 

CREATE or replace VIEW Dashboard1_ClientView AS
select 
cv.* , tv.balance, tv.number_of_transactions
from ClientInfoView cv 
join Transactionview tv on cv.client_id = tv.client_id;

select distinct(client_id) from Dashboard1_ClientView;

select count(distinct(client_id)) from Dashboard1_ClientView;

describe Dashboard1_ClientView;

select * from dashboard1_clientview where no_of_loans > 0 and total_loan_amount = 0; 

select * from dashboard1_clientview where no_of_loans = 0 and total_loan_amount > 0; 

select count(*) from dashboard1_clientview where age_group = 'Young Adults'; 


select distinct(no_of_accounts) from  Dashboard1_ClientView;















