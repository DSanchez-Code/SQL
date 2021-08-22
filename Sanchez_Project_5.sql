-- Daniel Sanchez
-- Project 5
-- MIS 504
-- Dr. Stephen Kline
-- Due Date: September 27th, 2020

-- 1. Show the Supplier companyname and the count of how many products we get from that supplier. Make sure to count the primary key of the products table. Order by companyname.

SELECT      Suppliers.CompanyName       AS [Supplier Company Name],
            COUNT(Products.ProductID)   AS [Number of Products]
FROM        Suppliers
   JOIN     Products   ON   Suppliers.SupplierID = Products.SupplierID
GROUP BY    Suppliers.CompanyName,
            Suppliers.SupplierID
ORDER BY    Suppliers.CompanyName

-- 2. Do number 1 again, but only include products that are not discontinued.

SELECT      Suppliers.CompanyName       AS [Supplier Company Name],
            COUNT(Products.ProductID)   AS [Number of Products]
FROM        Suppliers
   JOIN     Products   ON   Suppliers.SupplierID = Products.SupplierID
WHERE       Products.Discontinued != 1
GROUP BY    Suppliers.CompanyName,
            Suppliers.SupplierID
ORDER BY    Suppliers.CompanyName

-- 3. Show the Supplier companyname and the average unitprice of products from that supplier. Only include products that are not discontinued.

SELECT      Suppliers.CompanyName                 AS [Supplier Company Name],
            FORMAT(AVG(Products.UnitPrice),'C')   AS [Average Unit Price]
FROM        Suppliers
   JOIN     Products   ON   Suppliers.SupplierID = Products.SupplierID
WHERE       Products.Discontinued != 1
GROUP BY    Suppliers.CompanyName,
            Suppliers.SupplierID
ORDER BY    Suppliers.CompanyName

-- 4. Show the Supplier companyname and the total inventory value of all products from that supplier. This will involve the SUM() function with some calculations inside the functions.

SELECT      Suppliers.CompanyName                                         AS [Supplier Company Name],
            FORMAT(SUM(Products.UnitsInStock * Products.UnitPrice),'C')   AS [Total Inventory Value]
FROM        Suppliers
   JOIN     Products   ON   Suppliers.SupplierID = Products.SupplierID
GROUP BY    Suppliers.CompanyName
ORDER BY    Suppliers.CompanyName

-- 5. Show the Category name and a count of how many products are in each category.

SELECT      Categories.CategoryName        AS [Category Name],
            COUNT(Products.[CategoryID])   AS [Count of Products]
FROM        Categories
   JOIN     Products   ON   Categories.CategoryID = Products.CategoryID
GROUP BY    Categories.CategoryName,
            Categories.CategoryID
ORDER BY    Categories.CategoryName,
            Categories.CategoryID

-- 6. Show the Category name and a count of how many products in each category that are packaged in jars (have the word 'jars' in the QuantityPerUnit.)

SELECT      Categories.CategoryName        AS [Category Name],
            COUNT(Products.[CategoryID])   AS [Count of Products in Jars]
FROM        Categories
   JOIN     Products   ON   Categories.CategoryID = Products.CategoryID
WHERE       Products.QuantityPerUnit LIKE '%jar%'
GROUP BY    Categories.CategoryName,
            Categories.CategoryID
ORDER BY    Categories.CategoryName,
            Categories.CategoryID

-- 7. Show the Category name, and the minimum, average, and maximum price of products in each category.

SELECT      Categories.CategoryName                 AS [Category Name],
            FORMAT(MIN(Products.[UnitPrice]),'C')   AS [Minimum Price],
            FORMAT(AVG(Products.[UnitPrice]),'C')   AS [Average Price],
            FORMAT(MAX(Products.[UnitPrice]),'C')   AS [Maximum Price]
FROM        Categories
   JOIN     Products   ON   Categories.CategoryID = Products.CategoryID
GROUP BY    Categories.CategoryName,
            Categories.CategoryID
ORDER BY    Categories.CategoryName,
            Categories.CategoryID

-- 8. Show each order ID, its orderdate, the customer ID, and a count of how many items are on each order

SELECT      Orders.OrderID                            AS [Order ID],
            FORMAT (Orders.OrderDate, 'MM/dd/yyyy')   AS [Order Date],
            Orders.CustomerID                         AS [Customer ID],
            COUNT([Order Details].ProductID)          AS [Item Count]
FROM        Orders
   JOIN     [Order Details]   ON   Orders.OrderID = [Order Details].OrderID
GROUP BY    Orders.OrderID,
            Orders.OrderDate,
            Orders.CustomerID
ORDER BY    Orders.OrderID

-- 9. Show each productID, its productname, and a count of how many orders it has appeared on.

SELECT      Products.ProductID                 AS [Product ID],
            Products.ProductName               AS [Product Name],
            COUNT([Order Details].ProductID)   AS [Count of Orders]
FROM        Products
   JOIN     [Order Details]   ON   Products.ProductID = [Order Details].ProductID
GROUP BY    Products.ProductID,
            Products.ProductName
ORDER BY    Products.ProductID

-- 10. Do #9 again, but limit to only orders that were place in January of 1997.

SELECT      Products.ProductID                 AS [Product ID],
            Products.ProductName               AS [Product Name],
            COUNT([Order Details].ProductID)   AS [1997 Count of Orders]
FROM        Products
   JOIN     [Order Details]   ON   Products.ProductID = [Order Details].ProductID
   JOIN     Orders            ON   [Order Details].OrderID = Orders.OrderID
WHERE       YEAR(Orders.OrderDate) = 1997
GROUP BY    Products.ProductID,
            Products.ProductName
ORDER BY    Products.ProductID

-- 11. Show each OrderID, its orderdate, the customerID, and the total amount due, not including freight.
-- Sum the amounts due from each product on the order.
-- The amount due is the quantity times the unitprice, times one minus the discount.
-- Order by amount due, descending, so the biggest dollar amount due is at the top.

SELECT      Orders.OrderID                             AS [Order ID],
            FORMAT(Orders.[OrderDate], 'dd/MM/yyyy')   AS [Order Date],
            Customers.CustomerID                       AS [Customer ID],
            CAST(SUM([Order Details].Quantity * [Order Details].UnitPrice * (1 - [Order Details].Discount)) AS DECIMAL (10,2)) AS [Amount Due]
FROM        Products
   JOIN     [Order Details]   ON   Products.ProductID = [Order Details].ProductID
   JOIN     Orders            ON   [Order Details].OrderID = Orders.OrderID
   JOIN     Customers         ON   Orders.CustomerID = Customers.CustomerID
GROUP BY    Orders.OrderID,
            Orders.[OrderDate],
            Customers.CustomerID
ORDER BY    [Amount Due] DESC

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

-- 13. We want to know, for the year 1997, total revenues by month. Show the month number, and the total revenue for that month. Don't include freight.

SELECT      MONTH(Orders.OrderDate)   AS [Month],
            FORMAT(SUM([Order Details].Quantity * [Order Details].UnitPrice * (1 - [Order Details].Discount)),'C')   AS [Total Revenues]
FROM        Orders
   JOIN     [Order Details]   ON   Orders.OrderID = [Order Details].OrderID
WHERE       YEAR(Orders.OrderDate) = 1997
GROUP BY    MONTH(Orders.OrderDate)
ORDER BY    MONTH(Orders.OrderDate)

-- 14. We want to know, for the year 1997, total revenues by employee. Show the EmployeeID, lastname, title, then their total revenues. Don't include freight. 

SELECT      Employees.EmployeeID     AS [Employee ID],
            Employees.LastName       AS [Last Name],
            Employees.Title          AS [Title],
            FORMAT(SUM([Order Details].Quantity * [Order Details].UnitPrice * (1 - [Order Details].Discount)),'C') AS [Total Revenues]
FROM        Employees
   JOIN     Orders            ON   Employees.EmployeeID = Orders.EmployeeID
   JOIN     [Order Details]   ON   Orders.OrderID = [Order Details].OrderID
WHERE       YEAR(Orders.OrderDate) = 1997
GROUP BY    Employees.EmployeeID,
            Employees.LastName,
            Employees.Title
ORDER BY    Employees.EmployeeID

-- 15. We want to know, for the year 1997, a breakdown of revenues by month and category. Show the month number, the categoryname, and the total revenue for that month in that category. Order the records by month then category.

SELECT      MONTH(Orders.OrderDate)   AS [Month],
            Categories.CategoryName   AS [Category Name],
            FORMAT(SUM([Order Details].Quantity * [Order Details].UnitPrice * (1 - [Order Details].Discount)),'C') AS [Total Revenues]
FROM        Orders
   JOIN     [Order Details]   ON   Orders.OrderID =  [Order Details].OrderID
   JOIN     Products          ON   [Order Details].ProductID = Products.ProductID
   JOIN     Categories        ON   Categories.CategoryID = Products.CategoryID
WHERE       YEAR(Orders.OrderDate) = 1997
GROUP BY    MONTH(Orders.OrderDate),
            Categories.CategoryName
ORDER BY    MONTH(Orders.OrderDate),
            Categories.CategoryName
