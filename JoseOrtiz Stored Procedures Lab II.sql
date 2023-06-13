/*
Name:		Jose Ortiz
Lesson:		Developing and Implementing Stored Procedures
Date:		04/17/2023
*/



USE [New Class]

--Stored Procedures LabII

--Write SQL queries below based on table layout in Example 1.0.


TRUNCATE TABLE #TableA
TRUNCATE TABLE #TableB

CREATE  TABLE #TableA (Field INT)

INSERT INTO #TableA VALUES (1);
INSERT INTO #TableA VALUES (2);
INSERT INTO #TableA VALUES (3);
INSERT INTO #TableA VALUES (4);
INSERT INTO #TableA VALUES (4);
INSERT INTO #TableA VALUES (5);
INSERT INTO #TableA VALUES (6);


SELECT *
FROM #TableA	


CREATE  TABLE #TableB (Field INT)

INSERT INTO #TableB VALUES (2);
INSERT INTO #TableB VALUES (5);
INSERT INTO #TableB VALUES (7);
INSERT INTO #TableB VALUES (6);
INSERT INTO #TableB VALUES (3);
INSERT INTO #TableB VALUES (3);
INSERT INTO #TableB VALUES (9);

SELECT *
FROM #TableA
SELECT *
FROM #TableB

--1. Display data from TableA where the values are identical in TableB.
SELECT		DISTINCT(a.Field)
FROM		#TableA a
INNER JOIN	#TableB b
ON		a.Field=b.Field


--2. Display data from TableA where the values are not available in TableB.
SELECT		DISTINCT(a.Field)
FROM		#TableA a
LEFT JOIN	#TableB b
ON		a.Field=b.Field
WHERE	b.field is null

--3. Display data from TableB where the values are not available in TableA.
SELECT		b.Field
FROM		#TableB b
LEFT OUTER JOIN	#TableA a
ON		a.Field=b.Field
WHERE a.field is null

--Create SP’s based on the queries of the corresponding questions below.

/*4.	Create a Stored Procedure that passes in the SalesOrderID as a parameter. 
This stored procedure will return the SalesOrderID, the Date of the transaction and 
a count of how many times the item was purchased.*/

CREATE PROC proc_SalesOrderDetails
	@SalesOrderID INT
AS
	BEGIN
		SELECT		SalesOrderID 
					,CAST(ModifiedDate AS DATE) TrasnsactionDate 
					,COUNT(DISTINCT(ProductID)) AS Items
		FROM		[AdventureWorks2019].[Sales].[SalesOrderDetail]
		WHERE		SalesOrderID = @SalesOrderID
		GROUP BY	SalesOrderID, CAST(ModifiedDate AS DATE)
END

EXEC	proc_SalesOrderDetails 67445


/*5. 	Create a Stored Procedure that passes in the SalesOrderID as a parameter. 
This stored procedure will return the SalesOrderID, Date of the transaction, shipping date, City and State.*/


CREATE PROC proc_SalesInfo
	@SalesOrderID INT
AS
	BEGIN
		SELECT			a.SalesOrderID 
						,CAST(a.OrderDate AS DATE) TransaccionDate 
						,CAST(a.ShipDate AS DATE) ShippingDate 
						,b.City 
						,c.Name AS State
        FROM			[AdventureWorks2019].[Sales].[SalesOrderHeader]	a	
        LEFT OUTER JOIN [AdventureWorks2019].[Person].[Address] b
        ON				a.ShipToAddressID = b.AddressID
        LEFT OUTER JOIN	[AdventureWorks2019].[Sales].[SalesTerritory] c
        ON				a.TerritoryID = c.TerritoryID
        WHERE			SalesOrderID = @SalesOrderID
	END
EXEC	proc_SalesInfo  43668  



/*6. 	Create a stored procedure that passes in the Territory Name as a parameter.
This stored procedure will return the Territory Group, CountryRegionCode, 
Count of SalesHeaders in 2001, and the Count of SalesDetails in 2001*/

CREATE PROC proc_TerritoryNameInfo
	@TerritoryName VARCHAR(50)
AS
BEGIN
SELECT			c.[Group] AS TerritoryGroup 
				,c.CountryRegionCode 
				,Count(a.SalesOrderID) SalesHeaders 
				,Count(b.SalesOrderID) SalesDetails
FROM			[AdventureWorks2019].[Sales].[SalesOrderHeader] a
LEFT OUTER JOIN	[AdventureWorks2019].[Sales].[SalesOrderDetail] b
ON				a.SalesOrderID = b.SalesOrderID
LEFT OUTER JOIN	[AdventureWorks2019].[Sales].[SalesTerritory] c
ON				a.TerritoryID = c.TerritoryID
WHERE	        c.[Name]=@TerritoryName AND YEAR(a.OrderDate)='2011' AND YEAR(b.ModifiedDate)='2011'
GROUP BY		c.[Group], c.CountryRegionCode
END

EXEC proc_TerritoryNameInfo 'Central'


/*7. 	Create a stored procedure that passes in the Product name as a parameter. 
This stored procedure will return the lowest price in History, Highest Price in History, 
difference between the two prices, Count of SalesDetails and the Sum of LineTotal.*/


CREATE PROC Proc_ProductHistory
	@Name VARCHAR(50)
AS
	BEGIN
		SELECT			b.[Name] 
						,MIN(a.UnitPrice) AS LowestpriceHistory 
						,MAX(a.UnitPrice) AS HighestPriceHistory 
						,MAX(a.UnitPrice)-MIN(a.UnitPrice) AS DiffBetweenMaxandMIn 
						,COUNT(a.ProductID) AS SalesDetails
		FROM			[AdventureWorks2019].[Sales].[SalesOrderDetail] a
		LEFT OUTER JOIN	[AdventureWorks2019].[Production].[Product] b
		ON				a.ProductID = b.ProductID
		WHERE			b.[Name]=@Name
		GROUP BY		b.[Name]
	END

EXEC Proc_ProductHistory 'Mountain-100 Black, 44'



/*8.   Create a SP that passes in the OrderYear as a parameter.
This stored procedure will return the Count of the SalesHeaders 
and SalesDetails for the OrderYear parameter*/

ALTER PROC proc_SalesHeadersDetailsbyYear
	@Year INT
	AS
		BEGIN
			SELECT			COUNT(a.SalesOrderID) SalesHeaders, COUNT(b.SalesOrderDetailID) SalesDetails
			FROM			[AdventureWorks2019].[Sales].[SalesOrderHeader] a
			LEFT OUTER JOIN [AdventureWorks2019].[Sales].[SalesOrderDetail] b
			ON				a.SalesOrderID=b.SalesOrderID
			WHERE			YEAR(a.OrderDate)=@Year 
		END

EXEC proc_SalesHeadersDetailsbyYear 2011


	