#Using a subquery, find the names of all the tracks for the album "Californication"
SELECT name FROM tracks
WHERE AlbumId = (SELECT AlbumId
                FROM Albums
                WHERE Title = "Californication")
LIMIT 8
