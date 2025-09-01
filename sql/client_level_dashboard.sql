select * from completedclients; 

alter table completedclients add column fullname varchar(200);

UPDATE CompletedClients
SET fullname = CONCAT_WS(' ', first, middle, last);

select fullname from completedclients ; 


-- Full Profile of a Client
WITH latest_balances AS (
    SELECT 
        ca.account_id,
        ct.balance
    FROM completedaccounts ca
    JOIN (
        SELECT account_id, MAX(fulldatewithtime) AS latest_date
        FROM completedtrans
        GROUP BY account_id
    ) latest ON latest.account_id = ca.account_id
    JOIN completedtrans ct 
        ON ct.account_id = latest.account_id AND ct.fulldatewithtime = latest.latest_date
),
inflow_outflow AS (
    SELECT 
        cc.client_id,
        SUM(CASE WHEN ct.type = 'credit' THEN ct.amount ELSE 0 END) AS inflow,
        SUM(CASE WHEN ct.type = 'debit' THEN ct.amount ELSE 0 END) AS outflow,
        SUM(lb.balance) AS balance_amount
    FROM completedclients cc
    LEFT JOIN completeddispositions cd ON cd.client_id = cc.client_id
    left JOIN completedaccounts ca ON ca.account_id = cd.account_id
    left JOIN completedtrans ct ON ct.account_id = ca.account_id
    LEFT JOIN latest_balances lb ON lb.account_id = ca.account_id
    GROUP BY cc.client_id
)
select 
cc.client_id,cc.fullname,cc.age,cc.phone,cc.address_1,ca.district_id,
ca.account_id,cd.type,ca.frequency,ca.parseddate,
ccs.type as card_type,
CASE WHEN cd.type = 'OWNER' THEN cl.amount ELSE NULL END AS loan_amount,
CASE WHEN cd.type = 'OWNER' THEN cl.duration ELSE NULL END AS loan_duration,
CASE WHEN cd.type = 'OWNER' THEN cl.purpose ELSE NULL END AS loan_purpose,
io.inflow,io.outflow,io.balance_amount
from completedclients cc 
left join completeddispositions cd on cc.client_id = cd.client_id 
left join completedaccounts ca on ca.account_id = cd.account_id 
left join completedloan cl on cl.account_id = ca.account_id 
left join completedcards ccs on ccs.disp_id = cd.disp_id
left join inflow_outflow io ON cc.client_id = io.client_id; 





-- Full Profile of a Client
with inflow_outflow as 
(select 
cc.client_id,
sum(case when ct.type = 'credit' then amount else 0 end) as "inflow",
sum(case when ct.type = 'debit' then amount else 0 end) as "outflow"
from completedclients cc 
left join completeddispositions cd on cd.client_id = cc.client_id 
left join completedaccounts ca on ca.account_id = cd.account_id 
left join completedtrans ct on ct.account_id = ca.account_id
group by client_id)
select 
cc.client_id,cc.fullname,cc.age,cc.phone,cc.address_1,ca.district_id,
ca.account_id,cd.type,ca.frequency,ca.parseddate,
ccs.type as card_type,
CASE WHEN cd.type = 'OWNER' THEN cl.amount ELSE NULL END AS loan_amount,
CASE WHEN cd.type = 'OWNER' THEN cl.duration ELSE NULL END AS loan_duration,
CASE WHEN cd.type = 'OWNER' THEN cl.purpose ELSE NULL END AS loan_purpose,
io.inflow,io.outflow
from completedclients cc 
left join completeddispositions cd on cc.client_id = cd.client_id 
left join completedaccounts ca on ca.account_id = cd.account_id 
left join completedloan cl on cl.account_id = ca.account_id 
left join completedcards ccs on ccs.disp_id = cd.disp_id
left join inflow_outflow io ON cc.client_id = io.client_id;  


-- Life cycle segmentation 
-- Client Age Segmentation — Based on Account Opening Date
WITH date_boundary AS ( 
    SELECT 
        MAX(fulldatewithtime) AS maxdate
    FROM completedtrans
)
SELECT 
    cc.client_id,
    ca.account_id,
    ca.parseddate,
    DATEDIFF(db.maxdate, ca.parseddate) AS account_age_days,
    CASE
        WHEN DATEDIFF(db.maxdate, ca.parseddate) <= 180 THEN 'New Client'
        WHEN DATEDIFF(db.maxdate, ca.parseddate) BETWEEN 181 AND 730 THEN 'Mid-term Client'
        ELSE 'Long-term Client'
    END AS client_category
FROM completedclients cc
LEFT JOIN completeddispositions cd 
    ON cd.client_id = cc.client_id
LEFT JOIN completedaccounts ca 
    ON ca.account_id = cd.account_id
CROSS JOIN date_boundary db
WHERE ca.parseddate IS NOT NULL;

-- using months instead of dates 
WITH date_boundary AS ( 
    SELECT 
        MAX(fulldatewithtime) AS maxdate
    FROM completedtrans
)
SELECT 
    cc.client_id,
    ca.account_id,
    ca.parseddate,
    TIMESTAMPDIFF(MONTH, ca.parseddate, db.maxdate) AS account_age_months,
    CASE
        WHEN TIMESTAMPDIFF(MONTH, ca.parseddate, db.maxdate) < 6 THEN 'New Client'
        WHEN TIMESTAMPDIFF(MONTH, ca.parseddate, db.maxdate) BETWEEN 6 AND 24 THEN 'Mid-term Client'
        ELSE 'Long-term Client'
    END AS client_category
FROM completedclients cc
LEFT JOIN completeddispositions cd 
    ON cd.client_id = cc.client_id
LEFT JOIN completedaccounts ca 
    ON ca.account_id = cd.account_id
CROSS JOIN date_boundary db
WHERE ca.parseddate IS NOT NULL;



-- count of clients based on client
WITH date_boundary AS ( 
    SELECT 
        MAX(fulldatewithtime) AS maxdate
    FROM completedtrans
)
SELECT 
    CASE
        WHEN DATEDIFF(db.maxdate, ca.parseddate) <= 180 THEN 'New Client'
        WHEN DATEDIFF(db.maxdate, ca.parseddate) BETWEEN 181 AND 730 THEN 'Mid-term Client'
        ELSE 'Long-term Client'
    END AS client_category,
count(cc.client_id) as no_of_clients
FROM completedclients cc
LEFT JOIN completeddispositions cd 
    ON cd.client_id = cc.client_id
LEFT JOIN completedaccounts ca 
    ON ca.account_id = cd.account_id
CROSS JOIN date_boundary db
WHERE ca.parseddate IS NOT NULL
group by client_category;












