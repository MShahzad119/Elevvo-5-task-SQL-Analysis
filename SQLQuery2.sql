-- Top selling products

SELECT TOP 10 t.Name AS TrackName, SUM(il.Quantity) AS TotalSold
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
GROUP BY t.TrackId, t.Name
ORDER BY TotalSold DESC;




--Revenue per Region
SELECT c.Country, SUM(i.Total) AS Revenue
FROM Invoice i
JOIN Customer c ON i.CustomerId = c.CustomerId
GROUP BY c.Country
ORDER BY Revenue DESC;



--Monthly Performance
SELECT FORMAT(i.InvoiceDate, 'yyyy-MM') AS Month, SUM(i.Total) AS MonthlyRevenue
FROM Invoice i
GROUP BY FORMAT(i.InvoiceDate, 'yyyy-MM')
ORDER BY Month;













--Top Track Per Country (Using Window Function)
SELECT Country, TrackName, TotalSold
FROM (
    SELECT c.Country, t.Name AS TrackName, SUM(il.Quantity) AS TotalSold,
           RANK() OVER (PARTITION BY c.Country ORDER BY SUM(il.Quantity) DESC) AS rnk
    FROM InvoiceLine il
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    JOIN Customer c ON i.CustomerId = c.CustomerId
    JOIN Track t ON il.TrackId = t.TrackId
    GROUP BY c.Country, t.Name
) AS ranked
WHERE rnk = 1
ORDER BY Country;
