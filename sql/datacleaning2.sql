SELECT
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN account_id IS NULL or TRIM(account_id) = '' THEN 1 END) AS account_id_nulls,
    COUNT(CASE WHEN district_id IS NULL or TRIM(district_id) = ''  THEN 1 END) AS district_id_nulls,
    COUNT(CASE WHEN frequency IS NULL or TRIM(frequency) = ''  THEN 1 END) AS frequency_nulls,
    COUNT(CASE WHEN parseddate IS NULL or TRIM(parseddate) = ''  THEN 1 END) AS parseddate_nulls,
    COUNT(CASE WHEN year IS NULL or TRIM(year) = ''  THEN 1 END) AS year_nulls,
    COUNT(CASE WHEN month IS NULL or TRIM(month) = ''  THEN 1 END) AS month_nulls,
    COUNT(CASE WHEN day IS NULL or TRIM(day) = ''  THEN 1 END) AS day_nulls
FROM CompletedAccounts;

SELECT
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN disp_id IS NULL OR trim(disp_id) = '' THEN 1 END) AS disp_id_missing,
    COUNT(CASE WHEN type IS NULL OR trim(type) = '' THEN 1 END) AS type_missing,
    COUNT(CASE WHEN year IS NULL THEN 1 END) AS year_nulls,
    COUNT(CASE WHEN month IS NULL THEN 1 END) AS month_nulls,
    COUNT(CASE WHEN day IS NULL THEN 1 END) AS day_nulls,
    COUNT(CASE WHEN fulldate IS NULL THEN 1 END) AS fulldate_nulls
FROM CompletedCards;

SELECT
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN sex IS NULL OR trim(sex) = '' THEN 1 END) AS sex_missing,
    COUNT(CASE WHEN fulldate IS NULL THEN 1 END) AS fulldate_nulls,
    COUNT(CASE WHEN day IS NULL THEN 1 END) AS day_nulls,
    COUNT(CASE WHEN month IS NULL THEN 1 END) AS month_nulls,
    COUNT(CASE WHEN year IS NULL THEN 1 END) AS year_nulls,
    COUNT(CASE WHEN age IS NULL THEN 1 END) AS age_nulls,
    COUNT(CASE WHEN social IS NULL OR trim(social) = '' THEN 1 END) AS social_missing,
    COUNT(CASE WHEN first IS NULL OR trim(first) = '' THEN 1 END) AS first_missing,
    COUNT(CASE WHEN middle IS NULL OR trim(middle) = '' THEN 1 END) AS middle_missing,
    COUNT(CASE WHEN last IS NULL OR trim(last) = '' THEN 1 END) AS last_missing,
    COUNT(CASE WHEN phone IS NULL OR trim(phone) = '' THEN 1 END) AS phone_missing,
    COUNT(CASE WHEN email IS NULL OR trim(email) = '' THEN 1 END) AS email_missing,
    COUNT(CASE WHEN address_1 IS NULL OR trim(address_1) = '' THEN 1 END) AS address_1_missing,
    COUNT(CASE WHEN address_2 IS NULL OR trim(address_2) = '' THEN 1 END) AS address_2_missing,
    COUNT(CASE WHEN city IS NULL OR trim(city) = '' THEN 1 END) AS city_missing,
    COUNT(CASE WHEN state IS NULL OR trim(state) = '' THEN 1 END) AS state_missing,
    COUNT(CASE WHEN zipcode IS NULL OR trim(zipcode) = '' THEN 1 END) AS zipcode_missing,
    COUNT(CASE WHEN district_id IS NULL THEN 1 END) AS district_id_nulls
FROM CompletedClients;

select * from CompletedClients ;

ALTER TABLE CompletedClients DROP COLUMN address_2;



SELECT
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN disp_id IS NULL OR trim(disp_id) = '' THEN 1 END) AS disp_id_null_blank,
    COUNT(CASE WHEN client_id IS NULL OR trim(client_id) = '' THEN 1 END) AS client_id_null_blank,
    COUNT(CASE WHEN account_id IS NULL OR trim(account_id) = '' THEN 1 END) AS account_id_null_blank,
    COUNT(CASE WHEN type IS NULL OR trim(type) = '' THEN 1 END) AS type_null_blank
FROM CompletedDispositions;

SELECT
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN district_id IS NULL THEN 1 END) AS district_id_null,
    COUNT(CASE WHEN city IS NULL OR trim(city) = '' THEN 1 END) AS city_null_blank,
    COUNT(CASE WHEN state_name IS NULL OR trim(state_name) = '' THEN 1 END) AS state_name_null_blank,
    COUNT(CASE WHEN state_abbrev IS NULL OR trim(state_abbrev) = '' THEN 1 END) AS state_abbrev_null_blank,
    COUNT(CASE WHEN region IS NULL OR trim(region) = '' THEN 1 END) AS region_null_blank,
    COUNT(CASE WHEN division IS NULL OR trim(division) = '' THEN 1 END) AS division_null_blank
FROM CompletedDistrict;

SELECT
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN loan_id IS NULL OR trim(loan_id) = '' THEN 1 END) AS loan_id_null_blank,
    COUNT(CASE WHEN account_id IS NULL OR trim(account_id) = '' THEN 1 END) AS account_id_null_blank,
    COUNT(CASE WHEN amount IS NULL THEN 1 END) AS amount_null,
    COUNT(CASE WHEN duration IS NULL THEN 1 END) AS duration_null,
    COUNT(CASE WHEN payments IS NULL THEN 1 END) AS payments_null,
    COUNT(CASE WHEN status IS NULL OR trim(status) = '' THEN 1 END) AS status_null_blank,
    COUNT(CASE WHEN year IS NULL THEN 1 END) AS year_null,
    COUNT(CASE WHEN month IS NULL THEN 1 END) AS month_null,
    COUNT(CASE WHEN day IS NULL THEN 1 END) AS day_null,
    COUNT(CASE WHEN fulldate IS NULL THEN 1 END) AS fulldate_null,
    COUNT(CASE WHEN location IS NULL THEN 1 END) AS location_null,
    COUNT(CASE WHEN purpose IS NULL OR trim(purpose) = '' THEN 1 END) AS purpose_null_blank
FROM CompletedLoan;

SELECT
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN order_id IS NULL THEN 1 END) AS order_id_null,
    COUNT(CASE WHEN account_id IS NULL OR trim(account_id) = '' THEN 1 END) AS account_id_null_blank,
    COUNT(CASE WHEN bank_to IS NULL OR trim(bank_to) = '' THEN 1 END) AS bank_to_null_blank,
    COUNT(CASE WHEN account_to IS NULL OR account_to = '' THEN 1 END) AS account_to_null_blank,
    COUNT(CASE WHEN amount IS NULL THEN 1 END) AS amount_null,
    COUNT(CASE WHEN k_symbol IS NULL OR trim(k_symbol)= '' THEN 1 END) AS k_symbol_null_blank
FROM CompletedOrder;

select * from CompletedOrder; 

UPDATE CompletedOrder
SET k_symbol = 'Not Specified'
WHERE k_symbol IS NULL OR TRIM(k_symbol) = '';

SELECT COUNT(*)
FROM CompletedOrder
WHERE k_symbol IS NULL OR TRIM(k_symbol) = '';



SELECT
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN trans_id IS NULL OR trim(trans_id) = '' THEN 1 END) AS trans_id_null_blank,
    COUNT(CASE WHEN account_id IS NULL OR trim(account_id) = '' THEN 1 END) AS account_id_null_blank,
    COUNT(CASE WHEN type IS NULL OR trim(type) = '' THEN 1 END) AS type_null_blank,
    COUNT(CASE WHEN operation IS NULL OR trim(operation) = '' THEN 1 END) AS operation_null_blank,
    COUNT(CASE WHEN amount IS NULL THEN 1 END) AS amount_null,
    COUNT(CASE WHEN balance IS NULL THEN 1 END) AS balance_null,
    COUNT(CASE WHEN k_symbol IS NULL OR trim(k_symbol) = '' THEN 1 END) AS k_symbol_null_blank,
    COUNT(CASE WHEN bank IS NULL OR trim(bank) = '' THEN 1 END) AS bank_null_blank,
    COUNT(CASE WHEN account IS NULL OR trim(account) = '' THEN 1 END) AS account_null_blank,
    COUNT(CASE WHEN year IS NULL THEN 1 END) AS year_null,
    COUNT(CASE WHEN month IS NULL THEN 1 END) AS month_null,
    COUNT(CASE WHEN day IS NULL THEN 1 END) AS day_null,
    COUNT(CASE WHEN fulldate IS NULL OR TRIM(fulldate) = '' THEN 1 END) AS fulldate_null_blank,
    COUNT(CASE WHEN fulltime IS NULL OR TRIM(fulltime) = '' THEN 1 END) AS fulltime_null_blank,
    COUNT(CASE WHEN fulldatewithtime IS NULL OR TRIM(fulldatewithtime) = '' THEN 1 END) AS fulldatewithtime_null_blank
FROM CompletedTrans;

UPDATE CompletedTrans
SET k_symbol = 'unspecified'
WHERE k_symbol IS NULL OR TRIM(k_symbol) = '';

select *
from CompletedTrans
where k_symbol = 'unspecified';

SELECT count(*)
FROM CompletedTrans
WHERE k_symbol IS NULL OR TRIM(k_symbol) = '';

SELECT 
  COUNT(*) AS total_rows,
  COUNT(CASE WHEN date_received IS NULL THEN 1 END) AS date_received_null,
  COUNT(CASE WHEN complaint_id IS NULL OR TRIM(complaint_id) = '' THEN 1 END) AS complaint_id_null_blank,
  COUNT(CASE WHEN client_id IS NULL OR TRIM(client_id) = '' THEN 1 END) AS client_id_null_blank,
  COUNT(CASE WHEN phone IS NULL OR TRIM(phone) = '' THEN 1 END) AS phone_null_blank,
  COUNT(CASE WHEN vru_line IS NULL OR TRIM(vru_line) = '' THEN 1 END) AS vru_line_null_blank,
  COUNT(CASE WHEN call_id IS NULL THEN 1 END) AS call_id_null,
  COUNT(CASE WHEN priority IS NULL THEN 1 END) AS priority_null,
  COUNT(CASE WHEN type IS NULL OR TRIM(type) = '' THEN 1 END) AS type_null_blank,
  COUNT(CASE WHEN outcome IS NULL OR TRIM(outcome) = '' THEN 1 END) AS outcome_null_blank,
  COUNT(CASE WHEN agent_name IS NULL OR TRIM(agent_name) = '' THEN 1 END) AS agent_name_null_blank,
  COUNT(CASE WHEN ser_start IS NULL THEN 1 END) AS ser_start_null,
  COUNT(CASE WHEN ser_exit IS NULL THEN 1 END) AS ser_exit_null,
  COUNT(CASE WHEN ser_time IS NULL THEN 1 END) AS ser_time_null
FROM CRM_CallLogs;

select * from crm_calllogs;

SELECT *
FROM CRM_CallLogs
WHERE client_id = '' AND phone IS NOT NULL;

Select * 
from  crm_calllogs
Where Client_id = '' and complaint_id = '';


Select * 
from  crm_calllogs
Where Client_id != '' and complaint_id != '';

SELECT
  CASE
    WHEN TRIM(client_id) = '' AND TRIM(complaint_id) = '' THEN 'No IDs'
    WHEN TRIM(client_id) = '' THEN 'Only Complaint ID'
    WHEN TRIM(complaint_id) = '' THEN 'Only Client ID'
    ELSE 'Both IDs'
  END AS id_status,
  COUNT(*) AS total_calls,
  AVG(TIME_TO_SEC(ser_time)) AS avg_duration_seconds,
  MIN(TIME_TO_SEC(ser_time)) AS min_duration,
  MAX(TIME_TO_SEC(ser_time)) AS max_duration
FROM CRM_CallLogs
GROUP BY id_status;


select * 
from CRM_CallLogs
Where Client_id = '' and complaint_id = '' and TIME_TO_SEC(ser_time) < 10;


SELECT 
  COUNT(*) AS total_rows,
  COUNT(CASE WHEN date_received IS NULL THEN 1 END) AS date_received_null,
  COUNT(CASE WHEN product IS NULL OR TRIM(product) = '' THEN 1 END) AS product_null_blank,
  COUNT(CASE WHEN sub_product IS NULL OR TRIM(sub_product) = '' THEN 1 END) AS sub_product_null_blank,
  COUNT(CASE WHEN issue IS NULL OR TRIM(issue) = '' THEN 1 END) AS issue_null_blank,
  COUNT(CASE WHEN sub_issue IS NULL OR TRIM(sub_issue) = '' THEN 1 END) AS sub_issue_null_blank,
  COUNT(CASE WHEN complaint_narrative IS NULL OR TRIM(complaint_narrative) = '' THEN 1 END) AS complaint_narrative_null_blank,
  COUNT(CASE WHEN tags IS NULL OR TRIM(tags) = '' THEN 1 END) AS tags_null_blank,
  COUNT(CASE WHEN consumer_consent IS NULL OR TRIM(consumer_consent) = '' THEN 1 END) AS consumer_consent_null_blank,
  COUNT(CASE WHEN submitted_via IS NULL OR TRIM(submitted_via) = '' THEN 1 END) AS submitted_via_null_blank,
  COUNT(CASE WHEN date_sent_to_company IS NULL THEN 1 END) AS date_sent_to_company_null,
  COUNT(CASE WHEN company_response IS NULL OR TRIM(company_response) = '' THEN 1 END) AS company_response_null_blank,
  COUNT(CASE WHEN timely_response IS NULL OR TRIM(timely_response) = '' THEN 1 END) AS timely_response_null_blank,
  COUNT(CASE WHEN consumer_disputed IS NULL OR TRIM(consumer_disputed) = '' THEN 1 END) AS consumer_disputed_null_blank,
  COUNT(CASE WHEN complaint_id IS NULL OR TRIM(complaint_id) = '' THEN 1 END) AS complaint_id_null_blank,
  COUNT(CASE WHEN client_id IS NULL OR TRIM(client_id) = '' THEN 1 END) AS client_id_null_blank
FROM CRM_Events;

select * from crm_events;


SELECT 
  COUNT(*) AS total_rows,
  COUNT(CASE WHEN review_date IS NULL THEN 1 END) AS review_date_null,
  COUNT(CASE WHEN stars IS NULL THEN 1 END) AS stars_null,
  COUNT(CASE WHEN review IS NULL OR TRIM(review) = '' THEN 1 END) AS review_null_blank,
  COUNT(CASE WHEN product IS NULL OR TRIM(product) = '' THEN 1 END) AS product_null_blank,
  COUNT(CASE WHEN district_id IS NULL THEN 1 END) AS district_id_null
FROM CRM_Reviews;

SELECT 
  COUNT(*) AS total_rows,
  COUNT(CASE WHEN loan_id IS NULL OR TRIM(loan_id) = '' THEN 1 END) AS loan_id_null_blank,
  COUNT(CASE WHEN funded_amount IS NULL THEN 1 END) AS funded_amount_null,
  COUNT(CASE WHEN funded_date IS NULL OR TRIM(funded_date) = '' THEN 1 END) AS funded_date_null_blank,
  COUNT(CASE WHEN duration_years IS NULL THEN 1 END) AS duration_years_null,
  COUNT(CASE WHEN duration_months IS NULL THEN 1 END) AS duration_months_null,
  COUNT(CASE WHEN treasury_index_rate IS NULL THEN 1 END) AS treasury_index_rate_null,
  COUNT(CASE WHEN interest_rate_percent IS NULL THEN 1 END) AS interest_rate_percent_null,
  COUNT(CASE WHEN interest_rate IS NULL THEN 1 END) AS interest_rate_null,
  COUNT(CASE WHEN monthly_payment IS NULL THEN 1 END) AS monthly_payment_null,
  COUNT(CASE WHEN total_past_payments IS NULL THEN 1 END) AS total_past_payments_null,
  COUNT(CASE WHEN loan_balance IS NULL THEN 1 END) AS loan_balance_null,
  COUNT(CASE WHEN property_value IS NULL THEN 1 END) AS property_value_null,
  COUNT(CASE WHEN purpose IS NULL OR TRIM(purpose) = '' THEN 1 END) AS purpose_null_blank,
  COUNT(CASE WHEN firstname IS NULL OR TRIM(firstname) = '' THEN 1 END) AS firstname_null_blank,
  COUNT(CASE WHEN middlename IS NULL OR TRIM(middlename) = '' THEN 1 END) AS middlename_null_blank,
  COUNT(CASE WHEN lastname IS NULL OR TRIM(lastname) = '' THEN 1 END) AS lastname_null_blank,
  COUNT(CASE WHEN ssn IS NULL OR TRIM(ssn) = '' THEN 1 END) AS ssn_null_blank,
  COUNT(CASE WHEN phone IS NULL OR TRIM(phone) = '' THEN 1 END) AS phone_null_blank,
  COUNT(CASE WHEN title IS NULL OR TRIM(title) = '' THEN 1 END) AS title_null_blank,
  COUNT(CASE WHEN employment_length IS NULL THEN 1 END) AS employment_length_null,
  COUNT(CASE WHEN building_class_category IS NULL OR TRIM(building_class_category) = '' THEN 1 END) AS building_class_category_null_blank,
  COUNT(CASE WHEN tax_class_present IS NULL OR TRIM(tax_class_present) = '' THEN 1 END) AS tax_class_present_null_blank,
  COUNT(CASE WHEN building_class_present IS NULL OR TRIM(building_class_present) = '' THEN 1 END) AS building_class_present_null_blank,
  COUNT(CASE WHEN address_1 IS NULL OR TRIM(address_1) = '' THEN 1 END) AS address_1_null_blank,
  COUNT(CASE WHEN address_2 IS NULL OR TRIM(address_2) = '' THEN 1 END) AS address_2_null_blank,
  COUNT(CASE WHEN zipcode IS NULL OR TRIM(zipcode) = '' THEN 1 END) AS zipcode_null_blank,
  COUNT(CASE WHEN city IS NULL OR TRIM(city) = '' THEN 1 END) AS city_null_blank,
  COUNT(CASE WHEN state IS NULL OR TRIM(state) = '' THEN 1 END) AS state_null_blank,
  COUNT(CASE WHEN total_units IS NULL THEN 1 END) AS total_units_null,
  COUNT(CASE WHEN land_sq_ft IS NULL THEN 1 END) AS land_sq_ft_null,
  COUNT(CASE WHEN gross_sq_ft IS NULL THEN 1 END) AS gross_sq_ft_null,
  COUNT(CASE WHEN tax_class_at_sale IS NULL THEN 1 END) AS tax_class_at_sale_null
FROM LuxuryLoanPortfolio;







