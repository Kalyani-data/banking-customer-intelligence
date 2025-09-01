SELECT
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN account_id IS NULL THEN 1 END) AS account_id_nulls,
    COUNT(CASE WHEN district_id IS NULL THEN 1 END) AS district_id_nulls,
    COUNT(CASE WHEN frequency IS NULL THEN 1 END) AS frequency_nulls,
    COUNT(CASE WHEN parseddate IS NULL THEN 1 END) AS parseddate_nulls,
    COUNT(CASE WHEN year IS NULL THEN 1 END) AS year_nulls,
    COUNT(CASE WHEN month IS NULL THEN 1 END) AS month_nulls,
    COUNT(CASE WHEN day IS NULL THEN 1 END) AS day_nulls
FROM CompletedAccounts;

SELECT
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN card_id IS NULL THEN 1 END) AS card_id_nulls,
    COUNT(CASE WHEN disp_id IS NULL THEN 1 END) AS disp_id_nulls,
    COUNT(CASE WHEN type IS NULL THEN 1 END) AS type_nulls,
    COUNT(CASE WHEN year IS NULL THEN 1 END) AS year_nulls,
    COUNT(CASE WHEN month IS NULL THEN 1 END) AS month_nulls,
    COUNT(CASE WHEN day IS NULL THEN 1 END) AS day_nulls,
    COUNT(CASE WHEN fulldate IS NULL THEN 1 END) AS fulldate_nulls
FROM CompletedCards;


SELECT
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN client_id IS NULL THEN 1 END) AS client_id_nulls,
    COUNT(CASE WHEN sex IS NULL THEN 1 END) AS sex_nulls,
    COUNT(CASE WHEN fulldate IS NULL THEN 1 END) AS fulldate_nulls,
    COUNT(CASE WHEN day IS NULL THEN 1 END) AS day_nulls,
    COUNT(CASE WHEN month IS NULL THEN 1 END) AS month_nulls,
    COUNT(CASE WHEN year IS NULL THEN 1 END) AS year_nulls,
    COUNT(CASE WHEN age IS NULL THEN 1 END) AS age_nulls,
    COUNT(CASE WHEN social IS NULL THEN 1 END) AS social_nulls,
    COUNT(CASE WHEN first IS NULL THEN 1 END) AS first_nulls,
    COUNT(CASE WHEN middle IS NULL THEN 1 END) AS middle_nulls,
    COUNT(CASE WHEN last IS NULL THEN 1 END) AS last_nulls,
    COUNT(CASE WHEN phone IS NULL THEN 1 END) AS phone_nulls,
    COUNT(CASE WHEN email IS NULL THEN 1 END) AS email_nulls,
    COUNT(CASE WHEN address_1 IS NULL THEN 1 END) AS address_1_nulls,
    COUNT(CASE WHEN address_2 IS NULL THEN 1 END) AS address_2_nulls,
    COUNT(CASE WHEN city IS NULL THEN 1 END) AS city_nulls,
    COUNT(CASE WHEN state IS NULL THEN 1 END) AS state_nulls,
    COUNT(CASE WHEN zipcode IS NULL THEN 1 END) AS zipcode_nulls,
    COUNT(CASE WHEN district_id IS NULL THEN 1 END) AS district_id_nulls
FROM CompletedClients;

SELECT
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN disp_id IS NULL THEN 1 END) AS disp_id_nulls,
    COUNT(CASE WHEN client_id IS NULL THEN 1 END) AS client_id_nulls,
    COUNT(CASE WHEN account_id IS NULL THEN 1 END) AS account_id_nulls,
    COUNT(CASE WHEN type IS NULL THEN 1 END) AS type_nulls
FROM CompletedDispositions;


SELECT
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN district_id IS NULL THEN 1 END) AS district_id_nulls,
    COUNT(CASE WHEN city IS NULL THEN 1 END) AS city_nulls,
    COUNT(CASE WHEN state_name IS NULL THEN 1 END) AS state_name_nulls,
    COUNT(CASE WHEN state_abbrev IS NULL THEN 1 END) AS state_abbrev_nulls,
    COUNT(CASE WHEN region IS NULL THEN 1 END) AS region_nulls,
    COUNT(CASE WHEN division IS NULL THEN 1 END) AS division_nulls
FROM CompletedDistrict;

SELECT
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN loan_id IS NULL THEN 1 END) AS loan_id_nulls,
    COUNT(CASE WHEN account_id IS NULL THEN 1 END) AS account_id_nulls,
    COUNT(CASE WHEN amount IS NULL THEN 1 END) AS amount_nulls,
    COUNT(CASE WHEN duration IS NULL THEN 1 END) AS duration_nulls,
    COUNT(CASE WHEN payments IS NULL THEN 1 END) AS payments_nulls,
    COUNT(CASE WHEN status IS NULL THEN 1 END) AS status_nulls,
    COUNT(CASE WHEN year IS NULL THEN 1 END) AS year_nulls,
    COUNT(CASE WHEN month IS NULL THEN 1 END) AS month_nulls,
    COUNT(CASE WHEN day IS NULL THEN 1 END) AS day_nulls,
    COUNT(CASE WHEN fulldate IS NULL THEN 1 END) AS fulldate_nulls,
    COUNT(CASE WHEN location IS NULL THEN 1 END) AS location_nulls,
    COUNT(CASE WHEN purpose IS NULL THEN 1 END) AS purpose_nulls
FROM CompletedLoan;

SELECT
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN order_id IS NULL THEN 1 END) AS order_id_nulls,
    COUNT(CASE WHEN account_id IS NULL THEN 1 END) AS account_id_nulls,
    COUNT(CASE WHEN bank_to IS NULL THEN 1 END) AS bank_to_nulls,
    COUNT(CASE WHEN account_to IS NULL THEN 1 END) AS account_to_nulls,
    COUNT(CASE WHEN amount IS NULL THEN 1 END) AS amount_nulls,
    COUNT(CASE WHEN k_symbol IS NULL THEN 1 END) AS k_symbol_nulls
FROM CompletedOrder;

SELECT
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN trans_id IS NULL THEN 1 END) AS trans_id_nulls,
    COUNT(CASE WHEN account_id IS NULL THEN 1 END) AS account_id_nulls,
    COUNT(CASE WHEN type IS NULL THEN 1 END) AS type_nulls,
    COUNT(CASE WHEN operation IS NULL THEN 1 END) AS operation_nulls,
    COUNT(CASE WHEN amount IS NULL THEN 1 END) AS amount_nulls,
    COUNT(CASE WHEN balance IS NULL THEN 1 END) AS balance_nulls,
    COUNT(CASE WHEN k_symbol IS NULL THEN 1 END) AS k_symbol_nulls,
    COUNT(CASE WHEN bank IS NULL THEN 1 END) AS bank_nulls,
    COUNT(CASE WHEN account IS NULL THEN 1 END) AS account_nulls,
    COUNT(CASE WHEN year IS NULL THEN 1 END) AS year_nulls,
    COUNT(CASE WHEN month IS NULL THEN 1 END) AS month_nulls,
    COUNT(CASE WHEN day IS NULL THEN 1 END) AS day_nulls,
    COUNT(CASE WHEN fulldate IS NULL THEN 1 END) AS fulldate_nulls,
    COUNT(CASE WHEN fulltime IS NULL THEN 1 END) AS fulltime_nulls,
    COUNT(CASE WHEN fulldatewithtime IS NULL THEN 1 END) AS fulldatewithtime_nulls
FROM CompletedTrans;

select * 
from CompletedTrans; 

UPDATE CompletedTrans
SET operation = 'unknown'
WHERE operation IS NULL;

UPDATE CompletedTrans
SET k_symbol = 'unspecified'
WHERE k_symbol IS NULL;

UPDATE CompletedTrans
SET bank = 'NA'
WHERE bank IS NULL;

select * 
from completedtrans
where account  in ('Na', 'na', 'NA');

UPDATE CompletedTrans
SET account = 'NA'
WHERE account IS NULL;





SELECT
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN date_received IS NULL THEN 1 END) AS date_received_nulls,
    COUNT(CASE WHEN complaint_id IS NULL THEN 1 END) AS complaint_id_nulls,
    COUNT(CASE WHEN client_id IS NULL THEN 1 END) AS client_id_nulls,
    COUNT(CASE WHEN phone IS NULL THEN 1 END) AS phone_nulls,
    COUNT(CASE WHEN vru_line IS NULL THEN 1 END) AS vru_line_nulls,
    COUNT(CASE WHEN call_id IS NULL THEN 1 END) AS call_id_nulls,
    COUNT(CASE WHEN priority IS NULL THEN 1 END) AS priority_nulls,
    COUNT(CASE WHEN type IS NULL THEN 1 END) AS type_nulls,
    COUNT(CASE WHEN outcome IS NULL THEN 1 END) AS outcome_nulls,
    COUNT(CASE WHEN agent_name IS NULL THEN 1 END) AS agent_name_nulls,
    COUNT(CASE WHEN ser_start IS NULL THEN 1 END) AS ser_start_nulls,
    COUNT(CASE WHEN ser_exit IS NULL THEN 1 END) AS ser_exit_nulls,
    COUNT(CASE WHEN ser_time IS NULL THEN 1 END) AS ser_time_nulls
FROM CRM_CallLogs;

SELECT
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN date_received IS NULL THEN 1 END) AS date_received_nulls,
    COUNT(CASE WHEN product IS NULL THEN 1 END) AS product_nulls,
    COUNT(CASE WHEN sub_product IS NULL THEN 1 END) AS sub_product_nulls,
    COUNT(CASE WHEN issue IS NULL THEN 1 END) AS issue_nulls,
    COUNT(CASE WHEN sub_issue IS NULL THEN 1 END) AS sub_issue_nulls,
    COUNT(CASE WHEN complaint_narrative IS NULL THEN 1 END) AS complaint_narrative_nulls,
    COUNT(CASE WHEN tags IS NULL THEN 1 END) AS tags_nulls,
    COUNT(CASE WHEN consumer_consent IS NULL THEN 1 END) AS consumer_consent_nulls,
    COUNT(CASE WHEN submitted_via IS NULL THEN 1 END) AS submitted_via_nulls,
    COUNT(CASE WHEN date_sent_to_company IS NULL THEN 1 END) AS date_sent_to_company_nulls,
    COUNT(CASE WHEN company_response IS NULL THEN 1 END) AS company_response_nulls,
    COUNT(CASE WHEN timely_response IS NULL THEN 1 END) AS timely_response_nulls,
    COUNT(CASE WHEN consumer_disputed IS NULL THEN 1 END) AS consumer_disputed_nulls,
    COUNT(CASE WHEN complaint_id IS NULL THEN 1 END) AS complaint_id_nulls,
    COUNT(CASE WHEN client_id IS NULL THEN 1 END) AS client_id_nulls
FROM CRM_Events;

SELECT
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN review_date IS NULL THEN 1 END) AS review_date_nulls,
    COUNT(CASE WHEN stars IS NULL THEN 1 END) AS stars_nulls,
    COUNT(CASE WHEN review IS NULL THEN 1 END) AS review_nulls,
    COUNT(CASE WHEN product IS NULL THEN 1 END) AS product_nulls,
    COUNT(CASE WHEN district_id IS NULL THEN 1 END) AS district_id_nulls
FROM CRM_Reviews;


SELECT
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN loan_id IS NULL THEN 1 END) AS loan_id_nulls,
    COUNT(CASE WHEN funded_amount IS NULL THEN 1 END) AS funded_amount_nulls,
    COUNT(CASE WHEN funded_date IS NULL THEN 1 END) AS funded_date_nulls,
    COUNT(CASE WHEN duration_years IS NULL THEN 1 END) AS duration_years_nulls,
    COUNT(CASE WHEN duration_months IS NULL THEN 1 END) AS duration_months_nulls,
    COUNT(CASE WHEN treasury_index_rate IS NULL THEN 1 END) AS treasury_index_rate_nulls,
    COUNT(CASE WHEN interest_rate_percent IS NULL THEN 1 END) AS interest_rate_percent_nulls,
    COUNT(CASE WHEN interest_rate IS NULL THEN 1 END) AS interest_rate_nulls,
    COUNT(CASE WHEN monthly_payment IS NULL THEN 1 END) AS monthly_payment_nulls,
    COUNT(CASE WHEN total_past_payments IS NULL THEN 1 END) AS total_past_payments_nulls,
    COUNT(CASE WHEN loan_balance IS NULL THEN 1 END) AS loan_balance_nulls,
    COUNT(CASE WHEN property_value IS NULL THEN 1 END) AS property_value_nulls,
    COUNT(CASE WHEN purpose IS NULL THEN 1 END) AS purpose_nulls,
    COUNT(CASE WHEN firstname IS NULL THEN 1 END) AS firstname_nulls,
    COUNT(CASE WHEN middlename IS NULL THEN 1 END) AS middlename_nulls,
    COUNT(CASE WHEN lastname IS NULL THEN 1 END) AS lastname_nulls,
    COUNT(CASE WHEN ssn IS NULL THEN 1 END) AS ssn_nulls,
    COUNT(CASE WHEN phone IS NULL THEN 1 END) AS phone_nulls,
    COUNT(CASE WHEN title IS NULL THEN 1 END) AS title_nulls,
    COUNT(CASE WHEN employment_length IS NULL THEN 1 END) AS employment_length_nulls,
    COUNT(CASE WHEN building_class_category IS NULL THEN 1 END) AS building_class_category_nulls,
    COUNT(CASE WHEN tax_class_present IS NULL THEN 1 END) AS tax_class_present_nulls,
    COUNT(CASE WHEN building_class_present IS NULL THEN 1 END) AS building_class_present_nulls,
    COUNT(CASE WHEN address_1 IS NULL THEN 1 END) AS address_1_nulls,
    COUNT(CASE WHEN address_2 IS NULL THEN 1 END) AS address_2_nulls,
    COUNT(CASE WHEN zipcode IS NULL THEN 1 END) AS zipcode_nulls,
    COUNT(CASE WHEN city IS NULL THEN 1 END) AS city_nulls,
    COUNT(CASE WHEN state IS NULL THEN 1 END) AS state_nulls,
    COUNT(CASE WHEN total_units IS NULL THEN 1 END) AS total_units_nulls,
    COUNT(CASE WHEN land_sq_ft IS NULL THEN 1 END) AS land_sq_ft_nulls,
    COUNT(CASE WHEN gross_sq_ft IS NULL THEN 1 END) AS gross_sq_ft_nulls,
    COUNT(CASE WHEN tax_class_at_sale IS NULL THEN 1 END) AS tax_class_at_sale_nulls
FROM LuxuryLoanPortfolio;




