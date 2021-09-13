USE Northwind


-- 1. From the Customers table, show the CustomerID and ContactName of all customers. Order by CustomerID. Rename the columns [ID] and [name].

SELECT      CustomerID AS [ID],
            ContactName AS [name]
FROM        Customers
ORDER BY    CustomerID

-- 2. Show the CustomerID, ContactName, location of the space character in the contactname, and the length of the contactName. Use the CHARINDEX() and LEN() functions.

SELECT      CustomerID,
            ContactName,
            CHARINDEX(' ',ContactName) AS [location of space],
            LEN(ContactName) AS [length of ContactName]
FROM        Customers

-- 3. Show the CustomerID, ContactName, and the last name of the contact.

-- Han Solo
-- 12345678

-- Baby Yoda
-- 123456789

SELECT      CustomerID,
            ContactName,
            RIGHT(ContactName,
               LEN(ContactName)
               - CHARINDEX(' ',ContactName)) AS [Last Name]
FROM        Customers


-- 4. Show the CustomerID and the customerID converted to lower case (use LOWER()).

SELECT      CustomerID,
            LOWER(CustomerID) AS [customerID]
FROM        Customers

-- 5. Show the CustomerID, and the contactname. We'd also like to see the customer name like this: first initial, one space, then the lastname, all in one column called [short name].

SELECT      CustomerID,
            ContactName,
            LEFT(ContactName,1) + ' ' +
            RIGHT(ContactName,
               LEN(ContactName)
               - CHARINDEX(' ',ContactName)) AS [short name]
FROM        Customers
