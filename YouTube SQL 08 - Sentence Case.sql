USE Northwind

SELECT      CustomerID
FROM        Customers

SELECT      CustomerID,
            UPPER(CustomerID) AS Upper,
            LOWER(CustomerID) AS Lower
FROM   Customers




            LEFT(CustomerID,1) + LOWER(RIGHT(CustomerID, LEN(CustomerID)-1)) AS [Sentence Case]


















-- 12. We want to know, for the year 1997, the total revenues by category.
-- Show the CategoryID, categoryname, and the total revenue from products in that category.
-- This is very much like #11. Don't include freight.

SELECT      Categories.CategoryID     AS [Category ID],
            Categories.CategoryName   AS [Category],
            CAST(SUM([Order Details].Quantity * [Order Details].UnitPrice * (1 - [Order Details].Discount)) AS DECIMAL(10,2)) AS [Total Revenues]
FROM        Categories
   JOIN     Products          ON   Categories.CategoryID = Products.CategoryID
   JOIN     [Order Details]   ON   Products.ProductID = [Order Details].ProductID
   JOIN     Orders            ON   [Order Details].OrderID = Orders.OrderID
WHERE       YEAR(Orders.OrderDate) = 1997
GROUP BY    Categories.CategoryID,
            Categories.CategoryName
ORDER BY    [Total Revenues] DESC

-- 1. Show the CategoryName, CategoryDescription, and number of products in each category.
-- You will have trouble grouping by CategoryDescription, because of its data type.

SELECT   Categories.CategoryName       AS [Category Name],
         CAST(Categories.[Description] AS VARCHAR) AS [Description],
         COUNT(Products.ProductID)     AS [Number of Products]
FROM     Categories
   JOIN  Products ON Categories.CategoryID = Products.CategoryID
GROUP BY Categories.CategoryName,
         CAST(Categories.[Description] AS VARCHAR)
ORDER BY Categories.CategoryName

-- 2. We want to know the percentage of buffer stock we hold on every product.
-- We want to see this as a percentage above/below the reorderLevel.
-- Show the ProductID, productname, unitsInstock, reOrderLevel, and the percent above/below the reorderlevel.
-- So if unitsInstock is 13 and the reorderLevel level is 10, the percent above/below would be 0.30. Make sure you convert at the appropriate times to ensure no rounding occurs. Check your work carefully.

SELECT   ProductID,
         ProductName,
         UnitsInStock,
         ReorderLevel,
         (CAST(UnitsInStock AS NUMERIC) - CAST(ReorderLevel AS NUMERIC)) / CAST(ReorderLevel AS NUMERIC) AS [% Above/Below Reorder Level]
FROM     Products
WHERE    ReorderLevel <> 0
ORDER BY ProductID

-- 3. Show the orderID, orderdate, and total amount due for each order, including freight.
-- Make sure that the amount due is a money data type and that there is no loss in accuracy as conversions happen.
-- Do not do any unnecessary conversions. The trickiest part of this is the making sure that freight is NOT in the SUM.

SELECT   Orders.OrderID,
         Orders.OrderDate,
         CAST(SUM(  [Order Details].unitprice
             * [Order Details].quantity
             * (1.0 - [Order Details].discount)
            + Orders.Freight) AS MONEY) AS [Amount Due]
FROM     Orders
   JOIN  [Order Details] ON Orders.OrderID = [Order Details].OrderID
GROUP BY Orders.OrderID,
         Orders.OrderDate,
         Orders.Freight
ORDER BY Orders.OrderID

-- 4. Our company is located in Wilmington NC, the eastern time zone (UTC-5).
-- We've been mostly local, but are now doing business in other time zones.
-- Right now all of our dates in the orders table are actually our server time, and the server is located in an Amazon data center outside San Francisco,
-- in the pacific time zone (UTC-8).
-- For only the orders we ship to France, show the orderID, customerID, orderdate in UTC-5, and the shipped date in UTC+1 (France's time zone.)
-- You might find the TODATETIMEOFFSET() function helpful in this regard, and also the SWITCHOFFSET() function.
-- Remember the implied time zone (EST) when you do this.

SELECT   Orders.OrderID,
         Orders.CustomerID,
         DATEADD(hour,-1,Orders.OrderDate) AS [Order Date (UTC-5)],
         DATEADD(hour,+5,Orders.ShippedDate) AS [Shipped Date (UTC+1)]
FROM     Orders
WHERE    ORDERS.ShipCountry = 'FRANCE'
ORDER BY Orders.OrderID

-- 5. We are realizing that our data is taking up more space than necessary, which is making some of our regular data become "big data", in other words, difficult to deal with.
-- In preparation for a data migration, we'd like to convert many of the fields in the Customers table to smaller data types. We anticipate having 1 million customers, and this conversion could save us up to 58MB on just this table.
-- Do a SELECT statement that shows all fields in the table, in their original order, and rows ordered by customerID, with these fields converted:
-- CustomerID converted to CHAR(5) - saves at least 5 bytes per record
-- PostalCode converted to VARCHAR(10) - saves up to 5 bytes per record
-- Phone converted to VARCHAR(24) - saves up to 24 bytes per record
-- Fax converted to VARCHAR(24) - saves up to 24 bytes per record

SELECT   CAST(CustomerID AS CHAR(5))      AS [Customer ID],
         CAST(PostalCode AS VARCHAR(10))  AS [Postal Code],
         CAST(Phone      AS VARCHAR(24))  AS [Phone],
         CAST(Fax        AS VARCHAR(24))  AS [Fax]
FROM     Customers
ORDER BY [CustomerID]

-- 6. Show a list of products, their unit price, and their ROW_NUMBER() based on price, ASC. Order the records by productname.

SELECT   ProductID,
         ProductName,
         FORMAT(UnitPrice,'C') AS [UnitPrice],
         ROW_NUMBER() OVER (ORDER BY UnitPrice ASC) AS [Unit Price Row Number]
FROM     Products
ORDER BY ProductName

-- 7. Do #6, but show the DENSE_RANK() based on price, ASC, rather than ROW_NUMBER().

SELECT   ProductID,
         ProductName,
         FORMAT(UnitPrice,'C') AS [UnitPrice],
         DENSE_RANK() OVER (ORDER BY UnitPrice ASC) AS [Unit Price Rank]
FROM     Products
ORDER BY ProductName

-- 8. Show a list of products ranked by price into three categories based on price: 1, 2, 3.
-- The highest 1/3 of the products will be marked with a 1, the second 1/3 as 2, the last 1/3 as 3.
-- HINT: this is NTILE(3), order by unitprice DESC.

SELECT   ProductID,
         ProductName,
         NTILE(3) OVER (ORDER BY UnitPrice DESC) AS [Unit Price Percentile (Highest Ranked Thirds)]
FROM     Products
ORDER BY [Unit Price Percentile (Highest Ranked Thirds)]

-- 9. Show a list of products from categories 1, 2, 7, 4 and 5. Show their RANK() based on value in inventory.

SELECT   ProductID,
         ProductName,
         FORMAT((UnitPrice * UnitsInStock),'C') AS [Value in Inventory],
         RANK() OVER (ORDER BY (UnitPrice * UnitsInStock) DESC) AS [Value in Inventory Rank]
FROM     Products
WHERE    CategoryID IN (1,2,7,4,5)
ORDER BY [Value in Inventory Rank]

-- 10. Show a list of orders, ranked based on freight cost, highest to lowest. Order the orders by the orderdate.

SELECT   OrderID,
         FORMAT(Freight,'C') AS [Freight],
         RANK() OVER (ORDER BY Freight DESC) AS [Freight Cost Rank]
FROM     Orders
ORDER BY OrderDate
