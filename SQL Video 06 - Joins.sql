USE Northwind

-- JOIN (INNER JOIN)

SELECT *
FROM Products

SELECT *
FROM Suppliers

SELECT *
FROM Categories

-- 1. Show the ProductID, ProductName, and Supplier Company Name of the supplier for all Products. Order by ProductID. 


SELECT      Products.ProductID,
            Products.ProductName,
            Suppliers.CompanyName AS [Supplier Company Name]
FROM        Products
      JOIN  Suppliers ON Products.SupplierID = Suppliers.SupplierID
ORDER BY    Products.ProductID

-- 2. For only discontinued products with non-zero unitsinstock, show the productID, productname, and Supplier companyname.

SELECT      Products.ProductID,
            Products.ProductName,
            Suppliers.CompanyName AS [Supplier Company Name]
FROM        Products
      JOIN  Suppliers ON Products.SupplierID = Suppliers.SupplierID
WHERE       Products.UnitsInStock <> 0
      AND   Products.Discontinued = 1
ORDER BY    Products.ProductID


-- 3. Show the categoryName, productID, productname, and unitprice of all products. Only show products whose inventory value is greater than $200.
SELECT            Categories.CategoryName,
                  Products.ProductID,
                  Products.ProductName,
                  Products.UnitPrice
FROM              Categories
      JOIN        Products ON Categories.CategoryID = Products.CategoryID
      WHERE       Products.UnitsInStock * Products.UnitPrice > 200
      ORDER BY    Categories.CategoryName,
                  Products.UnitPrice DESC


-- 4. Show the SupplierName, CategoryName, ProductID, and productName of all products. Order columns from left to right.

SELECT            Suppliers.CompanyName AS [SupplierName],
                  Categories.CategoryName,
                  Products.ProductID,
                  Products.ProductName
FROM              Categories
      JOIN        Products    ON    Categories.CategoryID = Products.CategoryID
      JOIN        Suppliers   ON    Products.SupplierID = Suppliers.SupplierID
ORDER BY          Suppliers.CompanyName,
                  Categories.CategoryName,
                  Products.ProductID,
                  Products.ProductName
                  