USE Northwind

-- Aggregate Functions (COUNT, SUM, MIN, MAX, AVG, etc)
-- Group By, Single and Multiple Columns
-- Joins, Single and Multi-Joins
-- Formatting as Currency

-- 1. Show the Supplier Companyname and the count of how many products we get from that Supplier. Order by companyname.

SELECT      s.CompanyName        AS [Supplier Company Name],
            COUNT(p.ProductID)   AS [Number of Products]
FROM        Suppliers as s
   JOIN     Products as p ON   s.SupplierID = p.SupplierID
GROUP BY    s.CompanyName
ORDER BY    s.CompanyName

-- 2. Show the Supplier Companyname and the average Unitprice of products from that Supplier. Only include products that are not discontinued.

SELECT      s.CompanyName                  AS [Supplier Company Name],
            AVG(p.UnitPrice)   AS [Average Unit Price]
FROM        Suppliers AS s
   JOIN     Products AS p  ON   s.SupplierID = p.SupplierID
WHERE       p.Discontinued != 1
GROUP BY    s.CompanyName
ORDER BY    s.CompanyName

-- 3. Show the Category name, and the minimum, maximum, and average price of products in each category.

SELECT      c.CategoryName AS [Category Name],
            FORMAT(MIN(p.[UnitPrice]),'C')    AS [Minimum Price],
            FORMAT(MAX(p.[UnitPrice]),'C4')   AS [Maximum Price],
            FORMAT(AVG(p.[UnitPrice]),'C0')   AS [Average Price]
FROM        Categories AS c
   JOIN     Products AS p ON   c.CategoryID = p.CategoryID
GROUP BY    c.CategoryName,
            c.CategoryID
ORDER BY    c.CategoryName,
            c.CategoryID

-- 4. Show each ProductID, its Productname, and a count of how many Orders it has appeared on and limit to only orders that were placed in January of 1997.

SELECT      Products.ProductID                 AS [Product ID],
            Products.ProductName               AS [Product Name],
            COUNT([Order Details].ProductID)   AS [January 1997 Count of Orders]
FROM        Products
   JOIN     [Order Details]   ON   Products.ProductID = [Order Details].ProductID
   JOIN     Orders            ON   [Order Details].OrderID = Orders.OrderID
WHERE       YEAR(Orders.OrderDate) = 1997 AND MONTH(Orders.OrderDate) = 01
GROUP BY    Products.ProductID,
            Products.ProductName
ORDER BY    Products.ProductID

