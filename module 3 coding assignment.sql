--- Using a subquery, find the names of all the tracks for the album "Californication"
SELECT name FROM tracks
WHERE AlbumId = (SELECT AlbumId
                FROM Albums
                WHERE Title = "Californication")
LIMIT 8

--- Find the total number of invoices for each customer along with the customer's full name, city and email
SELECT c.firstname, 
       c.lastname, 
       c.city, 
       c.email, 
       i.CustomerId, 
       COUNT(i.CustomerId) AS total_num_of_inv FROM invoices i
INNER JOIN customers c ON c.CustomerId = i.CustomerId
GROUP BY i.customerid
