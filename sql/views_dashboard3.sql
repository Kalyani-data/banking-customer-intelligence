SELECT status, COUNT(*) AS loan_count, 
       AVG(amount) AS avg_amount, 
       AVG(duration) AS avg_duration
FROM CompletedLoan
GROUP BY status;


SELECT status, YEAR(fulldate) AS year, COUNT(*) AS count
FROM CompletedLoan
GROUP BY status, YEAR(fulldate)
ORDER BY status ,year;


-- Loan Performance View
CREATE OR REPLACE VIEW Dashboard3_LoanPerformance AS
SELECT 
    l.loan_id,
    l.account_id,
    l.amount AS loan_amount,
    l.duration AS loan_duration,
    l.payments AS loan_payments,
    l.status AS loan_status,
    l.purpose AS loan_purpose,
    l.fulldate AS loan_date,
    l.year AS loan_year,
    l.month AS loan_month,
    l.day as loan_day,

    -- client info (only owners)
    c.client_id,
    c.age AS client_age,
    c.sex AS client_sex,
    c.city AS client_city,

    -- account info
    a.frequency AS account_frequency,
    a.parseddate AS account_open_date,

    -- district info
    d.region,
    d.state_name,
    d.division
  

FROM CompletedLoan l
JOIN CompletedAccounts a 
    ON l.account_id = a.account_id
JOIN CompletedDispositions disp 
    ON l.account_id = disp.account_id 
   AND disp.type = 'OWNER'
JOIN CompletedClients c 
    ON disp.client_id = c.client_id
JOIN CompletedDistrict d 
    ON a.district_id = d.district_id;

    
select * from Dashboard3_loanperformance; 




