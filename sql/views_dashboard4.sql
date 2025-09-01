
-- View_CRM_Complaints
CREATE OR REPLACE VIEW dashboard4_CRM_Complaints AS
SELECT
    ce.complaint_id,
    ce.client_id,
    cc.sex,
    cc.age,
    cc.district_id,
    cd.region,
    cd.division,
    cd.city,
    cd.state_name,
    ce.product,
    ce.sub_product,
    ce.issue,
    ce.sub_issue,
    ce.date_received,
    ce.date_sent_to_company,
    ce.company_response,
    ce.timely_response,
    ce.consumer_disputed,
    -- Pre-calculate resolution category
    CASE 
        WHEN ce.company_response IN ('Untimely response', 'In Progress') OR ce.timely_response = 'No' THEN 'Escalated'
        WHEN ce.company_response IN ('Closed with explanation', 'Closed with relief', 'Closed without relief', 
                                     'Closed with non-monetary relief', 'Closed with monetary relief', 'Closed')
             AND ce.consumer_disputed = 'Yes' THEN 'Resolved but Disputed'
        ELSE 'Resolved'
    END AS resolution_category
FROM CRM_Events ce
LEFT JOIN CompletedClients cc ON ce.client_id = cc.client_id
LEFT JOIN CompletedDistrict cd ON cc.district_id = cd.district_id;



-- View_CRM_CallLogs
CREATE OR REPLACE VIEW dashboard4_CRM_CallLogs AS
SELECT
    cl.call_id,
    cl.client_id,
    cc.sex,
    cc.age,
    cc.district_id,
    cd.region,
    cd.division,
    cd.state_name,
    cd.city,
    cl.complaint_id,
    cl.agent_name,
    cl.ser_start,
    cl.ser_exit,
    cl.ser_time,
    cl.type,
    cl.outcome,
    cl.priority,
    -- Join to events to get resolution category
    CASE 
        WHEN ce.company_response IN ('Untimely response', 'In Progress') OR ce.timely_response = 'No' THEN 'Escalated'
        WHEN ce.company_response IN ('Closed with explanation', 'Closed with relief', 'Closed without relief', 
                                     'Closed with non-monetary relief', 'Closed with monetary relief', 'Closed')
             AND ce.consumer_disputed = 'Yes' THEN 'Resolved but Disputed'
        ELSE 'Resolved'
    END AS resolution_category
FROM CRM_CallLogs cl
LEFT JOIN CRM_Events ce ON cl.complaint_id = ce.complaint_id
LEFT JOIN CompletedClients cc ON cl.client_id = cc.client_id
LEFT JOIN CompletedDistrict cd ON cc.district_id = cd.district_id;


-- View_CRM_Reviews
CREATE OR REPLACE VIEW dashboard4_CRM_Reviews AS
SELECT
    cr.review_date,
    cr.stars,
    cr.review,
    cr.product,
    cr.district_id,
    cd.region,
    cd.state_name,
    cd.city,
    cd.division
FROM CRM_Reviews cr
LEFT JOIN CompletedDistrict cd ON cr.district_id = cd.district_id;




select * from CRM_CallLogs; 

select * from CRM_Events; 

select * from CRM_Reviews ; 

select resolution_category,count(*) from dashboard4_CRM_Complaints
group by resolution_category; 
