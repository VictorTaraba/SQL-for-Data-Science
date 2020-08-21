SELECT 
	  city AS City,
	  SUM(review_count) AS "Number of reviews"
FROM business
GROUP BY 1	
ORDER BY 2 DESC

