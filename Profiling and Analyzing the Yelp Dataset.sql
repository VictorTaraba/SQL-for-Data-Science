--- List the cities with the most reviews in descending order:

SELECT 
  city AS City,
  SUM(review_count) AS "Number of reviews"
FROM business
GROUP BY 1	
ORDER BY 2 DESC

--- Find the distribution of star ratings to the business in the following cities:
--- i. Avon

SELECT   
  stars AS "Star rating", 
  COUNT(stars) AS "Number of ratings"
FROM business
WHERE City = "Avon"
GROUP BY 1

--- ii. Beachwood

SELECT   
  stars AS "Star rating", 
  COUNT(stars) AS "Number of ratings"
FROM business
WHERE City = "Beachwood"
GROUP BY 1

--- Find the top 3 users based on their total number of reviews:
		
SELECT 
  id AS "User ID",
  name AS Name, 
  SUM(review_count) AS "Number of reviews"
FROM user
GROUP BY 1
ORDER BY 3 DESC
LIMIT 3

/* Does posing more reviews correlate with more fans?

Please explain your findings and interpretation of the results:
To answer the question I calculated PCC (Pearson correlation coefficient - it is 
a statistic that measures linear correlation between two variables X and Y. 
It has a value between +1 and −1)
Formula:
PCC = (n*SUM(x*y) - SUM(x)*SUM(y))/SQRT((n*SUM(x^2) - (SUM(x))^2)*(n*SUM(y^2) - (SUM(y))^2)))
where n - total number of elements.

In our case:
x - review_count
y - fans */	
	
--- SQL code to find n:

SELECT  
  COUNT(fans), 
  COUNT(review_count)
FROM user

/* Result:
+-------------+---------------------+
| count(fans) | count(review_count) |
+-------------+---------------------+
|       10000 |               10000 |
+-------------+---------------------+ */

--- Fragment of code to find columns x, y, x*y, x^2, y^2:

SELECT
  x, y,
  x*y AS xy,
  x*x as "x^2",
  y*y as "y^2" 
FROM (
	SELECT 
	  fans AS x, 
	  review_count AS y
	FROM user
	)
	LIMIT 5;

/* Result:
+----+-----+------+-----+-------+
|  x |   y |   xy | x^2 |   y^2 |
+----+-----+------+-----+-------+
| 15 | 245 | 3675 | 225 | 60025 |
|  0 |   2 |    0 |   0 |     4 |
|  0 |  57 |    0 |   0 |  3249 |
|  0 |   8 |    0 |   0 |    64 |
|  0 |   2 |    0 |   0 |     4 |
+----+-----+------+-----+-------+ */

Finding numerator:
SELECT
  10000*SUM(xy) - SUM(x)*SUM(y)
FROM (
  SELECT
    x, y,
    x*y AS xy,
    x*x as "x^2",
    y*y as "y^2" 
  FROM (
    SELECT 
      fans AS x, 
      review_count AS y
    FROM user
  )
)

/* Result:
+-------------------------------+
| 10000*SUM(xy) - SUM(x)*SUM(y) |
+-------------------------------+
|                   52645546480 |
+-------------------------------+ */

--- Finding denominator:

SELECT
  (10000*SUM("x^2")-SUM(x)*SUM(x))*(10000*SUM("y^2")-SUM(y)*SUM(y)) AS denominator
FROM (
  SELECT
    x, y,
    x*y AS xy,
    x*x as "x^2",
    y*y as "y^2" 
  FROM (
    SELECT 
      fans AS x, 
      review_count AS y
    FROM user
  )
)

/* Result:
+-------------------+	
|       denominator |
+-------------------+
| 6.34024751787e+21 |
+-------------------+

Unfortunately, there is no SQRT() function in SQLite, so I calculated square root by hands:
SQRT(6340247517874539190400) = 79625671224.01254

And finally we can calculate PCC: */

SELECT 52645546480/79625671224.01254 AS "Pearson correlation coefficient"

/* Result:	
+---------------------------------+
| Pearson correlation coefficient |
+---------------------------------+
|                  0.661162985137 |
+---------------------------------+

As we can see, the PCC is equal to 0.66. That means that of a linear association 
between the number of fans and the number of reviews is moderate and posistive.
So, posing more reviews correlate with more fans. */

--- Are there more reviews with the word "love" or with the word "hate" in them?

/* Answer:
There are more reviews with the word "love" */

SELECT 
  COUNT(text) AS "Reviews with word 'love'"
FROM  review 
WHERE text LIKE "%love%";

SELECT 
  COUNT(text) AS "Reviews with word 'hate'"
FROM  review 
WHERE text LIKE "%hate%";

--- Find the top 10 users with the most fans:

SELECT 
  name,
  SUM(fans)
FROM user
GROUP BY id
ORDER BY 2 DESC
LIMIT 10
