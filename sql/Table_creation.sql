
CREATE DATABASE bank_customer_intelligence;
use bank_customer_intelligence;

CREATE TABLE CompletedAccounts (
    account_id VARCHAR(20) PRIMARY KEY,
    district_id INT,
    frequency VARCHAR(100),
    parseddate DATE,
    year INT,
    month INT,
    day INT
);

CREATE TABLE CompletedCards (
    card_id VARCHAR(20) PRIMARY KEY,
    disp_id VARCHAR(20),
    type VARCHAR(100),
    year INT,
    month INT,
    day INT,
    fulldate DATE
    -- FOREIGN KEY (disp_id) REFERENCES CompletedDispositions(disp_id)
);



CREATE TABLE CompletedClients (
    client_id VARCHAR(20) PRIMARY KEY,
    sex VARCHAR(10),
    fulldate DATE,
    day INT,
    month INT,
    year INT,
    age INT,
    social VARCHAR(15),
    first VARCHAR(50),
    middle VARCHAR(50),
    last VARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(100),
    address_1 VARCHAR(100),
    address_2 VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(10),
    zipcode VARCHAR(10),
    district_id INT
);

CREATE TABLE CompletedDispositions (
    disp_id VARCHAR(20) PRIMARY KEY,
    client_id VARCHAR(20),
    account_id VARCHAR(20),
    type VARCHAR(20)
    -- FOREIGN KEY (client_id) REFERENCES CompletedClients(client_id),
    -- FOREIGN KEY (account_id) REFERENCES CompletedAccounts(account_id)
);


CREATE TABLE CompletedDistrict (
    district_id INT PRIMARY KEY,
    city VARCHAR(50),
    state_name VARCHAR(50),
    state_abbrev VARCHAR(10),
    region VARCHAR(50),
    division VARCHAR(50)
);


CREATE TABLE CompletedLoan (
    loan_id VARCHAR(20) PRIMARY KEY,
    account_id VARCHAR(20),
    amount DECIMAL(10, 2),
    duration INT,
    payments DECIMAL(10, 2),
    status CHAR(1),
    year INT,
    month INT,
    day INT,
    fulldate DATE,
    location INT,
    purpose VARCHAR(50)
    -- FOREIGN KEY (account_id) REFERENCES CompletedAccounts(account_id)
);


CREATE TABLE CompletedOrder (
    order_id INT PRIMARY KEY,
    account_id VARCHAR(20),
    bank_to VARCHAR(10),
    account_to VARCHAR(20),
    amount DECIMAL(10, 2),
    k_symbol VARCHAR(50)
    -- FOREIGN KEY (account_id) REFERENCES CompletedAccounts(account_id)
);

CREATE TABLE CompletedTrans (
    trans_id VARCHAR(20) PRIMARY KEY,
    account_id VARCHAR(20),
    type VARCHAR(20),
    operation VARCHAR(50),
    amount DECIMAL(10, 2),
    balance DECIMAL(10, 2),
    k_symbol VARCHAR(50),
    bank VARCHAR(50),
    account VARCHAR(20),
    year INT,
    month INT,
    day INT,
    fulldate varchar(20),
    fulltime varchar(30),
    fulldatewithtime varchar(50)
    -- FOREIGN KEY (account_id) REFERENCES CompletedAccounts(account_id)
);



CREATE TABLE CRM_CallLogs (
    date_received DATE,
    complaint_id VARCHAR(20),
    client_id VARCHAR(20),
    phone VARCHAR(20),
    vru_line VARCHAR(30),
    call_id INT PRIMARY KEY,
    priority INT,
    type VARCHAR(30),
    outcome VARCHAR(30),
    agent_name VARCHAR(100),
    ser_start TIME,
    ser_exit TIME,
    ser_time TIME
    -- FOREIGN KEY (client_id) REFERENCES CompletedClients(client_id)
);


CREATE TABLE CRM_Events (
    date_received DATE,
    product VARCHAR(100),
    sub_product VARCHAR(100),
    issue VARCHAR(100),
    sub_issue VARCHAR(100),
    complaint_narrative TEXT,
    tags VARCHAR(100),
    consumer_consent VARCHAR(50),
    submitted_via VARCHAR(100),
    date_sent_to_company DATE,
    company_response VARCHAR(100),
    timely_response VARCHAR(30),
    consumer_disputed VARCHAR(20),
    complaint_id VARCHAR(30) PRIMARY KEY,
    client_id VARCHAR(30)
    -- FOREIGN KEY (client_id) REFERENCES CompletedClients(client_id)
);

CREATE TABLE CRM_Reviews (
    review_date DATE,
    stars INT,
    review TEXT,
    product VARCHAR(200),
    district_id INT null
    -- FOREIGN KEY (district_id) REFERENCES CompletedDistrict(district_id)
);

CREATE TABLE LuxuryLoanPortfolio (
    loan_id VARCHAR(20) PRIMARY KEY,
    funded_amount DECIMAL(20,2),
    funded_date VARCHAR(20),
    duration_years INT,                -- NULL allowed by default
    duration_months INT,
    treasury_index_rate DECIMAL(10,3),
    interest_rate_percent DECIMAL(10,3),
    interest_rate DECIMAL(10,5),
    monthly_payment DECIMAL(15,3),
    total_past_payments INT,
    loan_balance DECIMAL(15,3),
    property_value DECIMAL(15,3),
    purpose VARCHAR(100),
    firstname VARCHAR(100),
    middlename VARCHAR(100),
    lastname VARCHAR(100),
    ssn VARCHAR(30),
    phone VARCHAR(30),
    title VARCHAR(200),
    employment_length INT,
    building_class_category VARCHAR(200),
    tax_class_present VARCHAR(20),
    building_class_present VARCHAR(20),
    address_1 VARCHAR(200),
    address_2 VARCHAR(200),
    zipcode VARCHAR(15),
    city VARCHAR(100),
    state VARCHAR(15),
    total_units INT,
    land_sq_ft INT,
    gross_sq_ft INT,
    tax_class_at_sale INT
);



select * from CompletedAccounts; 

select * from CompletedCards; 

select * from CompletedClients; 

select * from CompletedDispositions; 

select * from CompletedDistrict; 

select * from CompletedLoan; 

select * from CompletedOrder; 

select * from CompletedTrans ; 

select * from CRM_CallLogs; 

select * from CRM_Events; 

select * from CRM_Reviews ; 

select * from LuxuryLoanPortfolio; 

 -- Convert 'fulldate' from '24-03-2015' to '2015-03-24'
UPDATE LuxuryLoanPortfolio
SET funded_date = STR_TO_DATE(funded_date, '%d-%m-%Y');

describe  LuxuryLoanPortfolio;

Alter table  LuxuryLoanPortfolio
modify funded_date date; 


describe CompletedTrans;


select * from completedtrans limit 1000; 

-- Update fulldate: '24-03-2015' → '2015-03-24'
UPDATE CompletedTrans
SET fulldate = STR_TO_DATE(fulldate, '%d-%m-%Y')
WHERE fulldate IS NOT NULL
  AND fulldate LIKE '__-__-____'
LIMIT 10;

-- To check if all are updated:
SELECT COUNT(*) FROM CompletedTrans
WHERE fulldate LIKE '__-__-____';

-- Update fulldatewithtime: '2015-03-24T10:21:45' → '2015-03-24 10:21:45'
UPDATE CompletedTrans
SET fulldatewithtime = REPLACE(fulldatewithtime, 'T', ' ')
WHERE fulldatewithtime LIKE '%T%'
LIMIT 50000;
   

SELECT COUNT(*) FROM CompletedTrans
WHERE fulldatewithtime LIKE '%T%';


Describe CompletedTrans; 

ALTER TABLE CompletedTrans
MODIFY COLUMN fulldate DATE;

Alter table completedtrans
modify column fulldatewithtime datetime;

select count(*) 
from CompletedTrans 
where fulldatewithtime is null ; 

select count(*) from completedTrans 
where fulldate is null; 

select * from completedTrans; 


SELECT fulldatewithtime
FROM CompletedTrans
WHERE 
  CAST(SUBSTRING_INDEX(fulldatewithtime, ':', -1) AS UNSIGNED) > 59;

UPDATE CompletedTrans
SET fulldatewithtime = NULL
WHERE 
  CAST(SUBSTRING_INDEX(fulldatewithtime, ':', -1) AS UNSIGNED) > 59;
  
UPDATE CompletedTrans
SET fulldatewithtime = NULL
WHERE 
  CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(fulldatewithtime, ':', 2), ':', -1) AS UNSIGNED) > 59;

  
Alter table completedtrans
modify column fulldatewithtime datetime;

SELECT fulltime
FROM completedtrans
WHERE  Not fulltime REGEXP '^[0-2][0-9]:[0-5][0-9]:[0-5][0-9]$';

UPDATE completedtrans
SET fulltime = NULL
WHERE NOT fulltime REGEXP '^[0-2][0-9]:[0-5][0-9]:[0-5][0-9]$';

Alter table completedtrans
modify column fulltime time;

describe completedtrans;

select count(*) 
from  Completedtrans 
where fulltime is null; 

SELECT COUNT(*) 
FROM Completedtrans 
WHERE fulldatewithtime IS NULL AND fulltime IS NULL;

SELECT *  
FROM Completedtrans 
WHERE fulldatewithtime IS NULL AND fulltime IS NULL;

CREATE TABLE TempTimeFix (
    trans_id VARCHAR(20),
    fulltime VARCHAR(30),
    fulldatewithtime VARCHAR(50)
);

select * from  TempTimeFix; 

select count(*) from TempTimeFix;

-- Update fulldatewithtime: '2015-03-24T10:21:45' → '2015-03-24 10:21:45'
UPDATE TempTimeFix
SET fulldatewithtime = REPLACE(fulldatewithtime, 'T', ' ')
WHERE fulldatewithtime LIKE '%T%'
LIMIT 50000;

SELECT COUNT(*) FROM TempTimeFix
WHERE fulldatewithtime LIKE '%T%';

Alter table TempTimefix 
modify column fulldatewithtime datetime;

SELECT trans_id, fulldatewithtime
FROM TempTimeFix
WHERE NOT fulldatewithtime REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2} ([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$';


UPDATE TempTimeFix
SET fulldatewithtime = DATE_ADD(
    LEFT(fulldatewithtime, 10),
    INTERVAL TIME_TO_SEC(
        MAKETIME(
            CAST(SUBSTRING(fulldatewithtime, 12, 2) AS UNSIGNED),
            CAST(SUBSTRING(fulldatewithtime, 15, 2) AS UNSIGNED),
            CAST(SUBSTRING(fulldatewithtime, 18, 2) AS UNSIGNED)
        )
    ) SECOND
)
WHERE fulldatewithtime REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$';

Alter table TempTimefix 
modify column fulldatewithtime datetime;

Alter table TempTimefix 
modify column fulltime datetime;

ALTER TABLE TempTimeFix
MODIFY COLUMN fulltime TIME;

SELECT trans_id, fulltime
FROM TempTimeFix
WHERE NOT fulltime REGEXP '^([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$';

UPDATE TempTimeFix
SET fulltime = SEC_TO_TIME(ROUND(CAST(fulltime AS DECIMAL(10,8)) * 86400))
WHERE fulltime REGEXP '^[0-9.]+$';

ALTER TABLE TempTimeFix
MODIFY COLUMN fulltime TIME;

SELECT trans_id, fulltime
FROM TempTimeFix
WHERE NOT fulltime REGEXP '^([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$';

UPDATE TempTimeFix
SET fulltime = SEC_TO_TIME(
    CAST(SUBSTRING_INDEX(fulltime, ':', 1) AS UNSIGNED) * 3600 +
    CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(fulltime, ':', 2), ':', -1) AS UNSIGNED) * 60 +
    CAST(SUBSTRING_INDEX(fulltime, ':', -1) AS UNSIGNED)
)
WHERE NOT fulltime REGEXP '^([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$';

ALTER TABLE TempTimeFix
MODIFY COLUMN fulltime TIME;

select * from TempTimeFix;

describe TempTimeFix;

-- Update only 50,000 mismatched rows at a time
WITH to_update AS (
  SELECT CT.trans_id
  FROM Completedtrans CT
  JOIN TempTimeFix TTF ON CT.trans_id = TTF.trans_id
  WHERE CT.fulltime != TTF.fulltime
  LIMIT 10000
)
UPDATE Completedtrans CT
JOIN TempTimeFix TTF ON CT.trans_id = TTF.trans_id
JOIN to_update TU ON CT.trans_id = TU.trans_id
SET CT.fulltime = TTF.fulltime;

UPDATE Completedtrans CT
JOIN TempTimeFix TTF ON CT.trans_id = TTF.trans_id
SET CT.fulltime = TTF.fulltime
WHERE CT.fulltime != TTF.fulltime OR CT.fulltime IS NULL;

-- Then update:
UPDATE Completedtrans CT
JOIN TempTimeFix TTF ON CT.trans_id = TTF.trans_id
SET CT.fulldatewithtime = TTF.fulldatewithtime
WHERE CT.fulldatewithtime != TTF.fulldatewithtime or CT.fulldatewithtime is null ;

SELECT
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN trans_id IS NULL THEN 1 END) AS trans_id_nulls,
    COUNT(CASE WHEN fulltime  IS NULL THEN 1 END) AS fulltime_nulls,
    COUNT(CASE WHEN fulldatewithtime IS NULL THEN 1 END) AS fulldatewithtime_nulls
FROM TempTimeFix;

UPDATE CompletedTrans
SET fulldatewithtime = CONCAT(fulldate, ' ', fulltime)
WHERE fulldatewithtime IS NULL 
  AND fulldate IS NOT NULL 
  AND fulltime IS NOT NULL;

SELECT COUNT(*) AS mismatched_rows
FROM CompletedTrans
WHERE fulldate IS NOT NULL
  AND fulltime IS NOT NULL
  AND fulldatewithtime IS NOT NULL
  AND fulldatewithtime != CONCAT(fulldate, ' ', fulltime);

SELECT *
FROM CompletedTrans
WHERE fulldate IS NOT NULL
  AND fulldate NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$';
  
SELECT *
FROM CompletedTrans
WHERE fulltime IS NOT NULL
  AND fulltime NOT REGEXP '^[0-9]{2}:[0-9]{2}:[0-9]{2}$';
  
SELECT *
FROM CompletedTrans
WHERE fulldatewithtime IS NOT NULL
  AND fulldatewithtime NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$';
  
  
select * from CompletedAccounts; 

select * from CompletedCards; 

select * from CompletedClients; 

select * from CompletedDispositions; 

select * from CompletedDistrict; 

select * from CompletedLoan; 

select * from CompletedOrder; 

select * from CompletedTrans ; 

select * from CRM_CallLogs; 

select * from CRM_Events; 

select * from CRM_Reviews ; 

select * from LuxuryLoanPortfolio; 






