USE ShopSphere;

SELECT COUNT(*) AS [TotalRows]
FROM [OLE DB Destination];

SELECT *
FROM [OLE DB Destination];

USE ShopSphere;

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'OLE DB Destination'
ORDER BY ORDINAL_POSITION;

USE ShopSphere;

SELECT
    COUNT(*) AS TotalRows,
    COUNT([Customer ID]) AS CustomerID_NonNull,
    COUNT([Customer Name]) AS CustomerName_NonNull,
    COUNT([Customer Segment]) AS CustomerSegment_NonNull,
    COUNT([Order ID]) AS OrderID_NonNull,
    COUNT([Order Date]) AS OrderDate_NonNull,
    COUNT([Product ID]) AS ProductID_NonNull,
    COUNT([Product Name]) AS ProductName_NonNull,
    COUNT([Category]) AS Category_NonNull,
    COUNT([Quantity]) AS Quantity_NonNull,
    COUNT([Unit Price]) AS UnitPrice_NonNull,
    COUNT([Cost Price]) AS CostPrice_NonNull
FROM [OLE DB Destination];

USE ShopSphere;

SELECT
    [Order ID],
    COUNT(*) AS OrderCount
FROM [OLE DB Destination]
GROUP BY [Order ID]
HAVING COUNT(*) > 1
ORDER BY OrderCount DESC;

USE ShopSphere;

SELECT
    [Order ID],
    COUNT(*) AS OrderRows,
    COUNT(DISTINCT [Product ID]) AS UniqueProducts
FROM [OLE DB Destination]
GROUP BY [Order ID]
HAVING COUNT(*) > 1
ORDER BY [Order ID];

USE ShopSphere;

SELECT
    [Order ID],
    [Product ID],
    [Product Name],
    [Quantity],
    [Unit Price],
    [Cost Price],
    [Discount],
    [Sales Amount]
FROM [OLE DB Destination]
WHERE [Order ID] IN (
    SELECT [Order ID]
    FROM [OLE DB Destination]
    GROUP BY [Order ID]
    HAVING COUNT(*) > 1
)
ORDER BY [Order ID];

USE ShopSphere;

WITH DuplicateCheck AS
(
    SELECT
        *,
        ROW_NUMBER() OVER
        (
            PARTITION BY
                [Customer ID],
                [Customer Name],
                [Customer Segment],
                [Order ID],
                [Order Date],
                [Product ID],
                [Product Name],
                [Category],
                [Quantity],
                [Unit Price],
                [Cost Price],
                [Discount],
                [Sales Amount],
                [Country],
                [State],
                [Region],
                [Shipping ID],
                [Shipping Date]
            ORDER BY (SELECT NULL)
        ) AS DuplicateRank
    FROM [OLE DB Destination]
)

SELECT *
FROM DuplicateCheck
WHERE DuplicateRank > 1;

USE ShopSphere;

SELECT COUNT(*) AS TotalRows
FROM [OLE DB Destination];

USE ShopSphere;

TRUNCATE TABLE [OLE DB Destination];

SELECT COUNT(*) AS TotalRows
FROM [OLE DB Destination];

SELECT COUNT(*) AS TotalRows
FROM [OLE DB Destination];

USE ShopSphere;

SELECT TOP 20
    [Customer ID],
    [Customer Name],
    [Order ID]
FROM [OLE DB Destination]
ORDER BY [Customer ID];

USE ShopSphere;

TRUNCATE TABLE [OLE DB Destination];

SELECT COUNT(*) AS TotalRows
FROM [OLE DB Destination];

SELECT COUNT(*) AS TotalRows
FROM [OLE DB Destination];

USE ShopSphere;

SELECT
    COUNT(*) AS TotalRows,
    COUNT(DISTINCT [Order ID]) AS UniqueOrderIDs
FROM [OLE DB Destination];

USE ShopSphere;

TRUNCATE TABLE [OLE DB Destination];

SELECT COUNT(*) AS TotalRows
FROM [OLE DB Destination];

SELECT [Order ID], COUNT(*) AS OrderCount
FROM [OLE DB Destination]
GROUP BY [Order ID]
HAVING COUNT(*) > 1;

SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'OLE DB Destination'
  AND COLUMN_NAME = 'Order Date';

  SELECT TOP 10
    [Order Date]
FROM [OLE DB Destination];

ALTER TABLE [OLE DB Destination]
ADD [OrderDate_New] DATE;

UPDATE [OLE DB Destination]
SET [OrderDate_New] = 
    CAST(DATEADD(DAY, FLOOR([Order Date]), '1899-12-30') AS DATE);

    SELECT TOP 10
    [Order Date],
    [OrderDate_New]
FROM [OLE DB Destination];

SELECT COUNT(*) AS TotalRows,
       COUNT([OrderDate_New]) AS ConvertedDates
FROM [OLE DB Destination];

ALTER TABLE [OLE DB Destination]
DROP COLUMN [Order Date];

EXEC sp_rename 
    '[OLE DB Destination].[OrderDate_New]',
    'Order Date',
    'COLUMN';
    SELECT 
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'OLE DB Destination'
  AND COLUMN_NAME = 'Order Date';

  SELECT 
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'OLE DB Destination'
  AND COLUMN_NAME = 'Order Date';

  SELECT 
    COUNT(*) AS TotalRows,
    COUNT([Order Date]) AS ValidDates
FROM [OLE DB Destination];

SELECT 
    [Order ID],
    COUNT(*) AS OrderCount
FROM [OLE DB Destination]
GROUP BY [Order ID]
HAVING COUNT(*) > 1;

SELECT
    COUNT(*) AS TotalRows,
    COUNT([Customer ID]) AS CustomerID,
    COUNT([Customer Name]) AS CustomerName,
    COUNT([Order ID]) AS OrderID,
    COUNT([Order Date]) AS OrderDate,
    COUNT([Product ID]) AS ProductID,
    COUNT([Product Name]) AS ProductName,
    COUNT([Quantity]) AS Quantity,
    COUNT([Unit Price]) AS UnitPrice,
    COUNT([Cost Price]) AS CostPrice,
    COUNT([Discount]) AS Discount,
    COUNT([Sales Amount]) AS SalesAmount,
    COUNT([Country]) AS Country,
    COUNT([State]) AS State,
    COUNT([Region]) AS Region,
    COUNT([Shipping ID]) AS ShippingID,
    COUNT([Shipping Date]) AS ShippingDate
FROM [OLE DB Destination];

SELECT *
FROM [OLE DB Destination]
WHERE [Sales Amount] IS NULL;

SELECT TOP 10
    [Order ID],
    [Quantity],
    [Unit Price],
    [Discount],
    [Sales Amount],
    [Quantity] * [Unit Price] * (1 - [Discount]) AS ExpectedSalesAmount
FROM [OLE DB Destination]
WHERE [Sales Amount] IS NULL;

SELECT TOP 10
    [Order ID],
    [Quantity],
    [Unit Price],
    [Discount],
    [Sales Amount],
    [Quantity] * [Unit Price] * (1 - [Discount]) AS CalculatedAmount
FROM [OLE DB Destination]
WHERE [Sales Amount] IS NOT NULL;

SELECT COUNT(*) AS MismatchedRows
FROM [OLE DB Destination]
WHERE [Sales Amount] IS NOT NULL
  AND ROUND([Sales Amount], 2) <>
      ROUND([Quantity] * [Unit Price] * (1 - [Discount]), 2);

      SELECT TOP 20
    [Order ID],
    [Quantity],
    [Unit Price],
    [Discount],
    [Sales Amount],
    ROUND(
        [Quantity] * [Unit Price] * (1 - [Discount]), 
        2
    ) AS CalculatedAmount,
    ROUND(
        [Sales Amount] -
        ([Quantity] * [Unit Price] * (1 - [Discount])),
        2
    ) AS Difference
FROM [OLE DB Destination]
WHERE [Sales Amount] IS NOT NULL
  AND ROUND([Sales Amount], 2) <>
      ROUND([Quantity] * [Unit Price] * (1 - [Discount]), 2)
ORDER BY ABS(
    [Sales Amount] -
    ([Quantity] * [Unit Price] * (1 - [Discount]))
) DESC;

SELECT TOP 20
    [Order ID],
    [Quantity],
    [Unit Price],
    [Cost Price],
    [Discount],
    [Sales Amount]
FROM [OLE DB Destination]
WHERE [Sales Amount] IS NOT NULL
  AND ROUND([Sales Amount], 2) <>
      ROUND([Quantity] * [Unit Price] * (1 - [Discount]), 2)
ORDER BY [Order ID];

SELECT
    COUNT(*) AS TotalMismatches,
    COUNT(DISTINCT [Discount]) AS DifferentDiscounts,
    COUNT(DISTINCT [Cost Price]) AS DifferentCostPrices,
    COUNT(DISTINCT [Unit Price]) AS DifferentUnitPrices
FROM [OLE DB Destination]
WHERE [Sales Amount] IS NOT NULL
  AND ROUND([Sales Amount], 2) <>
      ROUND([Quantity] * [Unit Price] * (1 - [Discount]), 2);

      SELECT TOP 20
    [Order ID],
    [Quantity],
    [Unit Price],
    [Cost Price],
    [Discount],
    [Sales Amount],
    ROUND([Quantity] * [Unit Price], 2) AS GrossAmount,
    ROUND([Quantity] * [Unit Price] * (1 - [Discount]), 2) AS DiscountedAmount,
    ROUND([Sales Amount] / [Quantity], 2) AS ActualUnitSalesPrice
FROM [OLE DB Destination]
WHERE [Sales Amount] IS NOT NULL
  AND ROUND([Sales Amount], 2) <>
      ROUND([Quantity] * [Unit Price] * (1 - [Discount]), 2)
ORDER BY [Order ID];

SELECT
    COUNT(*) AS MismatchedRows,
    COUNT(DISTINCT
        CONCAT(
            [Quantity], '|',
            [Unit Price], '|',
            [Cost Price], '|',
            [Discount], '|',
            [Sales Amount]
        )
    ) AS DistinctCombinations
FROM [OLE DB Destination]
WHERE [Sales Amount] IS NOT NULL
  AND ROUND([Sales Amount], 2) <>
      ROUND([Quantity] * [Unit Price] * (1 - [Discount]), 2);

      SELECT
    COUNT(*) AS NullSalesAmountRows,
    COUNT(DISTINCT [Order ID]) AS DistinctOrders,
    COUNT(DISTINCT [Unit Price]) AS DistinctUnitPrices,
    COUNT(DISTINCT [Discount]) AS DistinctDiscounts
FROM [OLE DB Destination]
WHERE [Sales Amount] IS NULL;

SELECT TOP 20
    [Order ID],
    [Quantity],
    [Unit Price],
    [Cost Price],
    [Discount],
    [Sales Amount],
    ROUND(
        [Quantity] * [Unit Price] * (1 - [Discount]),
        2
    ) AS ExpectedAmount
FROM [OLE DB Destination]
WHERE [Sales Amount] IS NULL
ORDER BY [Order ID];

SELECT
    COUNT(*) AS NullSalesAmountRows,
    COUNT(
        CASE
            WHEN [Quantity] IS NOT NULL
             AND [Unit Price] IS NOT NULL
             AND [Discount] IS NOT NULL
            THEN 1
        END
    ) AS RowsWithRequiredInputs
FROM [OLE DB Destination]
WHERE [Sales Amount] IS NULL;

SELECT COUNT(*)
FROM [OLE DB Destination]
WHERE [Sales Amount] IS NULL;

SELECT COUNT(*) AS NullSalesAmountRows
FROM [OLE DB Destination]
WHERE [Sales Amount] IS NULL;

SELECT
    COUNT(*) AS TotalRows,
    SUM(CASE WHEN [Sales Amount] IS NULL THEN 1 ELSE 0 END) AS NullSalesAmountRows
FROM [OLE DB Destination];

USE ShopSphere;

TRUNCATE TABLE [OLE DB Destination];

SELECT COUNT(*) AS TotalRows
FROM [OLE DB Destination];

SELECT COUNT(*) AS NullSalesAmountRows
FROM [OLE DB Destination]
WHERE [Sales Amount] IS NULL;

TRUNCATE TABLE [OLE DB Destination];

SELECT COUNT(*) AS TotalRows
FROM [OLE DB Destination];

-- 1. Total rows
SELECT COUNT(*) AS TotalRows
FROM [OLE DB Destination];


-- 2. NULL Sales Amount
SELECT COUNT(*) AS NullSalesAmount
FROM [OLE DB Destination]
WHERE [Sales Amount] IS NULL;


-- 3. Sales Amount mismatches
SELECT COUNT(*) AS MismatchedRows
FROM [OLE DB Destination]
WHERE [Sales Amount] IS NOT NULL
AND ROUND([Sales Amount], 2) <>
    ROUND([Quantity] * [Unit Price] * (1 - [Discount]), 2);


-- 4. Date NULLs
SELECT COUNT(*) AS NullOrderDates
FROM [OLE DB Destination]
WHERE [Order Date] IS NULL;

SELECT
    [Order ID],
    [Product ID],
    COUNT([Product ID]) AS NumOfProduct
FROM [OLE DB Destination]
GROUP BY
    [Order ID],
    [Product ID]
HAVING COUNT([Product ID]) > 1;

SELECT
    [Order ID],
    [Shipping ID] ,
    COUNT([Shipping ID]) AS NumOfShippedOrders
FROM [OLE DB Destination]
GROUP BY
    [Order ID],
    [Shipping ID]
HAVING COUNT([Shipping ID]) > 1;

SELECT
    COUNT(DISTINCT[Customer ID]) AS NumOfReocurringCustomers
FROM [OLE DB Destination]
GROUP BY
    [Customer Name]
HAVING COUNT(DISTINCT[Customer ID]) > 1;


USE [ShopSphere];

CREATE TABLE CUSTOMERS (
    CUSTOMER_ID VARCHAR(100) PRIMARY KEY,
    CUSTOMER_NAME VARCHAR(255) NOT NULL,
    CUSTOMER_SEGMENT VARCHAR(225) NOT NULL,
    COUNTRY VARCHAR(200) NOT NULL,
    STATE VARCHAR(200) NOT NULL,
    REGION VARCHAR(200) NOT NULL
);

USE [ShopSphere];

CREATE TABLE PRODUCTS (
PRODUCT_ID VARCHAR(100) PRIMARY KEY,
PRODUCT_NAME VARCHAR(255) NOT NULL,
CATEGORY VARCHAR (200) NOT NULL
);

USE [ShopSphere];

CREATE TABLE ORDERS (
ORDER_ID VARCHAR(100) PRIMARY KEY,
CUSTOMER_ID VARCHAR(100) NOT NULL,
ORDER_DATE DATE  NOT NULL,
FOREIGN KEY (CUSTOMER_ID)
REFERENCES CUSTOMERS(CUSTOMER_ID)
);

USE [ShopSphere];

CREATE TABLE ORDERS_DETAILS (
ORDER_ID VARCHAR(100) NOT NULL,
PRODUCT_ID VARCHAR(100) NOT NULL,
QUANTITY  INT  NOT NULL,
UNIT_PRICE DECIMAL(10,2)  NOT NULL,
COST_PRICE DECIMAL (10,2)  NOT NULL,
DISCOUNT   DECIMAL (5,2) NOT NULL,
SALES_AMOUNT DECIMAL(10,2) NOT NULL,
PRIMARY KEY (ORDER_ID, PRODUCT_ID),

    FOREIGN KEY (ORDER_ID)
        REFERENCES ORDERS(ORDER_ID),

    FOREIGN KEY (PRODUCT_ID)
        REFERENCES PRODUCTS(PRODUCT_ID)
);


CREATE TABLE SHIPPING (
SHIPPING_ID VARCHAR(100) PRIMARY KEY,
ORDER_ID VARCHAR(100) NOT NULL,
SHIPPING_DATE DATE  NOT NULL,
FOREIGN KEY (ORDER_ID)
REFERENCES ORDERS(ORDER_ID)
);

INSERT INTO CUSTOMERS (
    CUSTOMER_ID,
    CUSTOMER_NAME,
    CUSTOMER_SEGMENT,
    COUNTRY,
    STATE,
    REGION
)
SELECT DISTINCT

    [Customer ID],
    [Customer Name],
    [Customer Segment],
    [Country],
    [State],
    [Region]
FROM [OLE DB Destination];

SELECT
    [Customer ID],
    COUNT(*) AS NumberOfRows
FROM [OLE DB Destination]
GROUP BY [Customer ID]
HAVING COUNT(*) > 1
ORDER BY NumberOfRows DESC;

SELECT
    COUNT(*) AS TotalRows,
    COUNT(DISTINCT [Customer ID]) AS UniqueCustomers
FROM [OLE DB Destination];

SELECT [Customer ID], COUNT(DISTINCT[Customer name])AS CUSTOMER_NAME,
COUNT(DISTINCT[Customer Segment])AS SEGMENT,
COUNT(DISTINCT[Country])AS COUNTRY,
COUNT(DISTINCT[State])AS STATE,
COUNT(DISTINCT[Region]) AS REGION
FROM [OLE DB Destination]
GROUP BY [Customer ID]
HAVING COUNT(DISTINCT[Customer name]) >1 
OR COUNT(DISTINCT[Customer Segment]) >1
OR COUNT(DISTINCT[Country])>1 
OR COUNT(DISTINCT[State]) >1
OR COUNT(DISTINCT[Region]) >1 ;

SELECT
    [Customer ID],
    [Customer Name],
    [Customer Segment],
    [Country],
    [State],
    [Region]
FROM [OLE DB Destination]
WHERE [Customer ID] = 'CUST017';

SELECT [Customer ID],COUNT(DISTINCT TRIM([Customer Name]))AS NAME,
COUNT(DISTINCT TRIM([Customer Segment])) AS SEGMENT,
COUNT(DISTINCT TRIM([Country])) AS COUNTRY,
COUNT(DISTINCT TRIM([State])) AS STATE,
COUNT(DISTINCT TRIM([Region]))AS REGION
FROM [OLE DB Destination]
GROUP BY [Customer ID]
HAVING COUNT(DISTINCT TRIM([Customer Name]))>1
OR COUNT(DISTINCT TRIM([Customer Segment])) > 1
OR COUNT(DISTINCT TRIM([Country])) > 1 
OR COUNT(DISTINCT TRIM([State])) >1
OR COUNT(DISTINCT TRIM([Region]))>1;

ALTER TABLE CUSTOMERS
DROP COLUMN [Country], [State], [Region];

SELECT *
FROM CUSTOMERS;


INSERT INTO CUSTOMERS (
    CUSTOMER_ID,
    CUSTOMER_NAME,
    CUSTOMER_SEGMENT
)
SELECT DISTINCT

    [Customer ID],
    TRIM([Customer Name]),
    TRIM([Customer Segment])
FROM [OLE DB Destination];

SELECT *
FROM CUSTOMERS;

SELECT COUNT(*) AS TotalCustomers
FROM CUSTOMERS;

SELECT COUNT(DISTINCT [Product ID])
FROM [OLE DB Destination];

SELECT
    [Product ID],
    COUNT(DISTINCT TRIM([Product Name])) AS NAME,
    COUNT(DISTINCT TRIM([Category])) AS Category
FROM [OLE DB Destination]
GROUP BY [Product ID]
HAVING COUNT(DISTINCT TRIM([Product Name])) > 1
    OR COUNT(DISTINCT TRIM([Category])) > 1;

    INSERT INTO PRODUCTS(
    PRODUCT_ID,
    PRODUCT_NAME,
    CATEGORY)
    SELECT DISTINCT
    
    [Product ID],
    TRIM([Product Name]),
    TRIM([Category])
    FROM [OLE DB DESTINATION];

    SELECT *
    FROM PRODUCTS

    SELECT DISTINCT[ORDER ID]
    FROM [OLE DB Destination]

    SELECT [ORDER ID],COUNT(DISTINCT TRIM ([CUSTOMER ID])) AS NUMBER_OF_CUSTOMERS
    FROM [OLE DB Destination]
    GROUP BY [ORDER ID]
    HAVING COUNT(DISTINCT TRIM ([CUSTOMER ID]))>1;

    SELECT
    [Order ID],
    COUNT(*) AS NumberOfRows
FROM [OLE DB Destination]
GROUP BY [Order ID]
HAVING COUNT(*) > 1;


INSERT INTO ORDERS
(
ORDER_ID,CUSTOMER_ID, ORDER_DATE)
SELECT DISTINCT
[ORDER ID] , TRIM([CUSTOMER ID]), [ORDER DATE]
FROM [OLE DB Destination];

INSERT INTO ORDERS_DETAILS
(
ORDER_ID,PRODUCT_ID,QUANTITY,UNIT_PRICE,COST_PRICE,DISCOUNT,SALES_AMOUNT
)
SELECT DISTINCT
TRIM([ORDER ID]),TRIM([PRODUCT ID]),[QUANTITY],[UNIT PRICE],[COST PRICE],[DISCOUNT],[SALES AMOUNT]
FROM [OLE DB Destination];

INSERT INTO SHIPPING
(
SHIPPING_ID,
ORDER_ID,
SHIPPING_DATE)
SELECT DISTINCT 
TRIM([SHIPPING ID]), TRIM([ORDER ID]), [SHIPPING DATE]
FROM [OLE DB Destination];

SELECT COUNT(*) AS MissingShippingDates
FROM [OLE DB Destination]
WHERE [Shipping Date] IS NULL;

SELECT
    [Shipping ID],
    [Order ID],
    [Shipping Date]
FROM [OLE DB Destination]
WHERE [Shipping Date] IS NULL;

ALTER TABLE SHIPPING
ALTER COLUMN SHIPPING_DATE DATE NULL;


INSERT INTO SHIPPING
(
SHIPPING_ID,
ORDER_ID,
SHIPPING_DATE)
SELECT DISTINCT 
TRIM([SHIPPING ID]), TRIM([ORDER ID]), [SHIPPING DATE]
FROM [OLE DB Destination];
 
 --DATA VALIDATION 
 SELECT ODD.[CUSTOMER ID],C.CUSTOMER_ID 
 FROM [OLE DB Destination] ODD
 LEFT JOIN CUSTOMERS C
 ON ODD.[Customer ID]=C.CUSTOMER_ID
 WHERE C.CUSTOMER_ID IS NULL

 SELECT  ORD.PRODUCT_ID,P.PRODUCT_ID 
 FROM ORDERS_DETAILS ORD
 LEFT JOIN PRODUCTS P
 ON  ORD.PRODUCT_ID = P.PRODUCT_ID
 WHERE ORD.PRODUCT_ID IS NULL;

 SELECT ORD.ORDER_ID, O.ORDER_ID
 FROM ORDERS_DETAILS ORD
 LEFT JOIN ORDERS O
 ON ORD.ORDER_ID = O.ORDER_ID
 WHERE O.ORDER_ID IS NULL 

 SELECT S.ORDER_ID, O.ORDER_ID
 FROM SHIPPING S
 LEFT JOIN ORDERS O
 ON S.ORDER_ID = O.ORDER_ID
 WHERE O.ORDER_ID IS NULL 

 SELECT SUM([Sales Amount])
FROM [OLE DB Destination];

SELECT SUM(SALES_AMOUNT)
FROM ORDERS_DETAILS;

