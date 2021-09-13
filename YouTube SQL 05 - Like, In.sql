USE Northwind

SELECT *
FROM products

-- 1. Find Products that are packaged in jars.

SELECT      ProductName,
            QuantityPerUnit
FROM        Products
WHERE       QuantityPerUnit LIKE '%jar%'

-- 2. Show all productnames that end in the word 'Lager'.

SELECT      ProductName
FROM        Products
WHERE       ProductName LIKE '% Lager'
ORDER BY    ProductName

-- 3. Select ProductID, ProductName, and SupplierID of all products that have the word "Ale" or "Lager"
-- in the productname. Order by ProductID.

SELECT      ProductID,
            ProductName,
            SupplierID
FROM        Products
WHERE       ProductName LIKE '% ale %'
      OR    ProductName LIKE 'ale %'
      OR    ProductName LIKE '% ale'
      OR    ProductName LIKE '% lager %'
      OR    ProductName LIKE 'lager %'
      OR    ProductName LIKE '% lager'
ORDER BY    ProductID

-- 4. Show all products that are in one of these categories: 2, 4, 5, or 7. Use the IN clause.
--    Show the name and unitprice of each product.

SELECT      ProductName,
            UnitPrice,
            UnitsInStock,
            ReorderLevel
FROM        Products
WHERE       CategoryID IN (2, 4, 5, 7)
      AND   UnitsInStock < ReorderLevel
ORDER BY     ProductName
