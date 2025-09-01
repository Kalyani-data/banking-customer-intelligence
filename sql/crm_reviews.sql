select * from crm_reviews ; 

select * from crm_reviews where review is null; 

select * from crm_reviews where review = ''; 

-- Districts with the most positive/negative reviews
SELECT 
    district_id,
    COUNT(*) AS total_reviews,
    AVG(stars) AS avg_rating
FROM CRM_Reviews
WHERE review IS NOT NULL
GROUP BY district_id
ORDER BY avg_rating DESC; 


-- Agents or services with consistently high ratings
SELECT 
    product,
    COUNT(*) AS total_reviews,
    AVG(stars) AS avg_rating
FROM CRM_Reviews
WHERE review IS NOT NULL
GROUP BY product
HAVING COUNT(*) >= 5  
ORDER BY avg_rating DESC;


-- Average star rating by product or region
-- By product
SELECT product, AVG(stars) AS avg_rating
FROM CRM_Reviews
WHERE stars IS NOT NULL
GROUP BY product;


---- By region
SELECT cd.region, AVG(cr.stars) AS avg_rating
FROM CRM_Reviews cr  
join  completeddistrict cd on cr.district_id = cd.district_id
WHERE cr.stars IS NOT NULL
GROUP BY cd.region;

