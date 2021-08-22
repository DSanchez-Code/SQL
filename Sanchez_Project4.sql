-- Daniel Sanchez
-- Project 4
-- MIS 504
-- Dr. Douglas Kline
-- Due Date: September 20th, 2020

-- 1. Show the Supplier companyname, then Suppliers.supplierID, then Products.supplierID, then the productname. Order by SupplierID. Use JOIN and verify that the records match up appropriately.

SELECT      Suppliers.CompanyName,
            Suppliers.SupplierID    AS [Supplier ID (Suppliers)],
            Products.SupplierID     AS [Supplier ID (Products)],
            Products.ProductName
FROM        Products
      JOIN  Suppliers ON Products.SupplierID = Suppliers.SupplierID
ORDER BY    Suppliers.SupplierID

-- 2. Show the Supplier Company Name, ProductName, and unitprice for all products. unitprice descending, then by productID.

SELECT      Suppliers.CompanyName AS [Supplier Company Name],
            Products.ProductName,
            Products.UnitPrice
FROM        Products
      JOIN  Suppliers ON Products.SupplierID = Suppliers.SupplierID
ORDER BY    Products.Unitprice DESC,
            Products.ProductID

-- 3. Show the ProductID, ProductName, and Supplier Company Name of the supplier for all Products. Order by ProductID. 

SELECT      Products.ProductID,
            Products.ProductName,
            Suppliers.CompanyName AS [Supplier Company Name]
FROM        Products
      JOIN  Suppliers ON Products.SupplierID = Suppliers.SupplierID
ORDER BY    Products.ProductID

-- 4. For only discontinued products with non-zero unitsinstock, show the productID, productname, and Supplier companyname.

SELECT      Products.ProductID,
            Products.ProductName,
            Suppliers.CompanyName AS [Supplier Company Name]
FROM        Products
      JOIN  Suppliers ON Products.SupplierID = Suppliers.SupplierID
WHERE       Products.UnitsInStock <> 0
      AND   Products.Discontinued = 1
ORDER BY    Products.ProductID

-- 5. We need a report that tells us everything we need to place an order.
-- This should be only non-discontinued products whose (unitsInstock + unitsOnOrder) is less than or equal to the Reorderlevel.
-- As the final column, it should show how many to order. We usually order enough so that (unitsInStock+UnitsOnOrder) is equal to twice the reorderlevel.
-- Columns should be SupplierID, CompanyName, companyphone, productID, productName, amount to order. Order by SupplierID, then by productID.

SELECT      Suppliers.SupplierID,
            Suppliers.CompanyName,
            Suppliers.Phone AS [companyphone],
            Products.ProductID,
            Products.ProductName,
            (Products.ReorderLevel * 2) - (Products.UnitsInStock + Products.UnitsOnOrder) AS [amount to order]
FROM        Products
      JOIN  Suppliers ON Products.SupplierID = Suppliers.SupplierID
WHERE       Products.Discontinued = 0
      AND   (Products.UnitsInStock + Products.UnitsOnOrder) <= Products.ReorderLevel
ORDER BY    Suppliers.SupplierID,
            Products.ProductID

-- 6. Do # 5 again, but also add the cost, which will be the order amount multiplied by the unitprice.

SELECT            Suppliers.SupplierID,
                  Suppliers.CompanyName,
                  Suppliers.Phone AS [companyphone],
                  Products.ProductID,
                  Products.ProductName,
                  (Products.ReorderLevel * 2) - (Products.UnitsInStock + Products.UnitsOnOrder) AS [amount to order],
                  FORMAT(((Products.ReorderLevel * 2) - (Products.UnitsInStock + Products.UnitsOnOrder)) * Products.UnitPrice, 'C') AS [Cost]
FROM              Products
      JOIN        Suppliers ON Products.SupplierID = Suppliers.SupplierID
WHERE             Products.Discontinued = 0
      AND         Products.UnitsInStock + Products.UnitsOnOrder <= Products.ReorderLevel
ORDER BY          Suppliers.SupplierID,
                  Products.ProductID

-- 7. (shifting to categories and products) Show the productID, productname, unitprice, and categoryname of all products.

SELECT            Products.ProductID,
                  Products.ProductName,
                  Products.UnitPrice,
                  Categories.CategoryName
FROM              Products
      JOIN        Categories ON Products.CategoryID = Categories.CategoryID
      ORDER BY    Categories.CategoryName,
                  Products.ProductID

-- 8. Show the categoryName, productID, productname, and unitprice of all products. Only show products whose inventory value is greater than $200.

SELECT            Categories.CategoryName,
                  Products.ProductID,
                  Products.ProductName,
                  Products.UnitPrice
FROM              Categories
      JOIN        Products ON Categories.CategoryID = Products.CategoryID
      WHERE       Products.UnitsInStock * Products.UnitPrice > 200
      ORDER BY    Categories.CategoryName,
                  Products.UnitPrice DESC

-- 9. Show the CategoryName, productID, productName, and supplierName of all products. Order columns from left to right.(Note this is a 3-table join.)

SELECT            Categories.CategoryName,
                  Products.ProductID,
                  Products.ProductName,
                  Suppliers.CompanyName AS [SupplierName]
FROM              Categories
      JOIN        Products    ON    Categories.CategoryID = Products.CategoryID
      JOIN        Suppliers   ON    Products.SupplierID = Suppliers.SupplierID
ORDER BY          Categories.CategoryName,
                  Products.ProductID,
                  Products.ProductName,
                  Suppliers.CompanyName

-- 10. Show the SupplierName, CategoryName, ProductID, and productName of all products. Order columns from left to right.

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
                  