--- Using a subquery, find the names of all the tracks for the album "Californication"

SELECT name 
FROM tracks
WHERE AlbumId = (SELECT AlbumId
                FROM Albums
                WHERE Title = "Californication")
LIMIT 8;

--- Find the total number of invoices for each customer along with the customer's full name, city and email

SELECT c.firstname, 
       c.lastname, 
       c.city, 
       c.email, 
       i.CustomerId, 
       COUNT(i.CustomerId) AS total_num_of_inv 
FROM invoices i
INNER JOIN customers c ON c.CustomerId = i.CustomerId
GROUP BY i.customerid;

--- Retrieve the track name, album, artistID, and trackID for all the albums

SELECT name, 
       trackid 
FROM tracks
WHERE albumid = (SELECT albumid
                FROM albums
                WHERE title='For Those About To Rock We Salute You');
                
--- Retrieve a list with the managers last name, and the last name of the employees who report to him or her

SELECT a.lastname ManagerLastName, 
       b.lastname EmployeesLastName 
FROM employees a
INNER JOIN employees b ON a.employeeid = b.reportsto;

--- Find the name and ID of the artists who do not have albums

SELECT ar.name, 
       ar.artistid 
FROM artists ar
LEFT JOIN albums a ON ar.artistid=a.artistid
WHERE a.albumid IS null;

--- Use a UNION to create a list of all the employee's and customer's first names and last names ordered by the last name in descending order

SELECT firstname, 
       lastname 
FROM customers
UNION 
SELECT firstname, lastname FROM employees
ORDER BY lastname DESC;

--- See if there are any customers who have a different city listed in their billing city versus their customer city

SELECT c.firstname, 
       c.lastname 
FROM customers c
INNER JOIN invoices i ON i.customerid = c.customerid
WHERE c.City != i.billingcity;
