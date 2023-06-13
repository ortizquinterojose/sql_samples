/* 
NAME:		JOSE ORTIZ
LESSON:		
DATE:		04/07/2023
*/



/*
WELLCOM TO JOINS LAB
YOU TRY
CREATE TWO TABLES
*/


IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE name='Stg_Emp' AND type='U')
	DROP TABLE Stg_Emp
	GO

CREATE TABLE Stg_Emp 
					(
					EmpID INT
					,EmpName VARCHAR(50)
					)
INSERT INTO dbo.Stg_Emp (EmpID,EmpName)
SELECT  '1','John Doe' UNION
SELECT  '2','Jane Doe' UNION
SELECT  '3','Sally Mae' 

SELECT	*
FROM	dbo.Stg_Emp

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE name='Emp_List' AND type='U')
	DROP TABLE Emp_List
GO

CREATE TABLE Emp_List 
					(
					EmpID INT
					,EmpName VARCHAR(50)
					)
INSERT INTO dbo.Emp_List (EmpID,EmpName)
SELECT  '1','John Doe' UNION
SELECT  '2','Jane Doe' UNION
SELECT  '5','Peggy Sue' 

SELECT	*
FROM	dbo.Emp_List

--ASSIGMENT:Write Two scripts using JOIN to:
-- 1 Show the Company's new employee

SELECT			a.EmpID, a.EmpName
FROM			dbo.Stg_Emp a
LEFT OUTER JOIN dbo.Emp_List b
ON				a.EmpID = b.EmpID
WHERE			b.EmpID IS NULL 

-- 2 Show the Company's former employee

SELECT			b.EmpID, b.EmpName
FROM			dbo.Stg_Emp a
RIGHT OUTER JOIN dbo.Emp_List b
ON				a.EmpID = b.EmpID
WHERE			a.EmpID IS NULL

/*
Combining Data from Multiple Sources lab
*/
--Use AdventureWorks Database to complete the following questions.

--1.	How many Sales Orders (Headers) used Vista credit cards in October 2002.
--		My AdventureWorks is 2019 so I am using year 2011 instead of 2002

SELECT			COUNT(CardType) AS Q1  
			FROM			[AdventureWorks2019].[Sales].[SalesOrderHeader] AS a
			LEFT OUTER JOIN [AdventureWorks2019].[Sales].[CreditCard] AS b
			ON				a.CreditCardID = b.CreditCardID
			WHERE			b.CardType='Vista' 
							AND YEAR(OrderDate)='2011' 
							AND MONTH(OrderDate)='08'


--2		Store the answer to Q1. in a variable.

SELECT	*
FROM	[AdventureWorks2019].[Sales].[SalesOrderHeader]

SELECT	*
FROM	[AdventureWorks2019].[Sales].[CreditCard]


DECLARE	@Q1 INT
SET		@Q1 = 
			(
			SELECT			COUNT(CardType) AS Q1  
			FROM			[AdventureWorks2019].[Sales].[SalesOrderHeader] AS a
			LEFT OUTER JOIN [AdventureWorks2019].[Sales].[CreditCard] AS b
			ON				a.CreditCardID = b.CreditCardID
			WHERE			b.CardType='Vista' 
							AND YEAR(OrderDate)='2011' 
							AND MONTH(OrderDate)='08'
			)
SELECT	@Q1 AS QtySalesOrderVistaCreditcard


--3.	 Create a UDF that accepts start date and end date. The function will return
--the number of Sales Orders (Using Vista credit cards) that took place between 
--the start date and end date entered by the user.

DROP FUNCTION udf_SalesOrders
GO
CREATE FUNCTION udf_SalesOrders(@StartDate DATE, @EndDate DATE)
	RETURNS			INT
		AS
			BEGIN
			RETURN
					(
					SELECT			COUNT(CardType) AS Q3
					FROM			[AdventureWorks2019].[Sales].[SalesOrderHeader] AS a
					LEFT OUTER JOIN [AdventureWorks2019].[Sales].[CreditCard] AS b
					ON				a.CreditCardID = b.CreditCardID
					WHERE			b.CardType='Vista' 
									AND OrderDate BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE)
					)
			END
SELECT [dbo].[udf_SalesOrders]('2011-08-01','2012-08-01') AS SalesOrderVistaCredit

--4.	Using the SalesOrderHeader table - Find out how much Revenue (TotalDue) was brought in by 
--the North American Territory Group from 2002 through 2004

SELECT	*
FROM	[AdventureWorks2019].[Sales].[SalesOrderHeader]

SELECT	*
FROM	[AdventureWorks2019].[Sales].[SalesTerritory]


SELECT			SUM(TotalDue) TotalDue
FROM			[AdventureWorks2019].[Sales].[SalesOrderHeader] AS a		
LEFT OUTER JOIN [AdventureWorks2019].[Sales].[SalesTerritory] AS b
ON				a.TerritoryID = b.TerritoryID
WHERE			b.[Group]= 'North America' 
				AND YEAR(a.DueDate) BETWEEN '2011' AND '2012'

--5.	What is the Sales Tax Rate, StateProvinceCode and CountryRegionCode for Texas?

SELECT			a.TaxRate, b.StateProvinceCode, b.CountryRegionCode 
FROM			[AdventureWorks2019].[Sales].[SalesTaxRate] AS a
LEFT OUTER JOIN [AdventureWorks2019].[Person].[StateProvince] AS b
ON				a.StateProvinceID = b.StateProvinceID
WHERE			b.[Name] LIKE '%Texas%'


--6.	Store the information from Q5 in a variable.

DECLARE @Q5 TABLE
				(
				TaxRate SMALLMONEY
				,StateProvinceCode NCHAR(3)
				,CountryRegionCode NVARCHAR(3)
				)
INSERT INTO		@Q5
SELECT			a.TaxRate, b.StateProvinceCode, b.CountryRegionCode 
FROM			[AdventureWorks2019].[Sales].[SalesTaxRate] AS a
LEFT OUTER JOIN [AdventureWorks2019].[Person].[StateProvince] AS b
ON				a.StateProvinceID = b.StateProvinceID
WHERE			b.[Name] LIKE '%Texas%'

SELECT			*
FROM			@Q5

--7.	Create a UDF that accepts the State Province and returns the associated
--Sales Tax Rate, StateProvinceCode and CountryRegionCode.


CREATE FUNCTION UDF_Q5 (@State VARCHAR(50))  
RETURNS TABLE
AS
RETURN
(

SELECT			a.TaxRate, b.StateProvinceCode, b.CountryRegionCode 
FROM			[AdventureWorks2019].[Sales].[SalesTaxRate] AS a
LEFT OUTER JOIN [AdventureWorks2019].[Person].[StateProvince] AS b
ON				a.StateProvinceID = b.StateProvinceID
WHERE			b.[Name] = @State
)

SELECT	*
FROM	dbo.UDF_Q5('texas')



--8.	Show a list of Product Colors. For each Color show how many SalesDetails there are 
--and the Total SalesAmount (UnitPrice * OrderQty). Only show Colors with a
--Total SalesAmount more than $50,000 and eliminate the products that do not have a color.

SELECT			b.Color, COUNT(a.SalesOrderDetailID) SalesDetails, SUM(UnitPrice*OrderQty) TotalSalesAmount
INTO 			[New Class].dbo.SalesDetailsbyColor 
FROM			[AdventureWorks2019].[Sales].[SalesOrderDetail] AS a	
LEFT OUTER JOIN [AdventureWorks2019].[Production].[Product] AS b
ON				a.ProductID = b.ProductID
GROUP BY		b.Color
HAVING			SUM(UnitPrice*OrderQty)>50000
 	
DELETE	[New Class].dbo.SalesDetailsbyColor WHERE Color IS NULL		
SELECT *
FROM SalesDetailsbyColor


--9.	Create a join using 4 tables in AdventureWorks database.  
--Explain what the join is doing and post it to the Google Group.


SELECT		a.[Name], b.TaxRate, c.CurrencyCode, d.[Group]
FROM		[AdventureWorks2019].[Person].[StateProvince] AS a
INNER JOIN	[AdventureWorks2019].[Sales].[SalesTaxRate] AS b
ON			a.StateProvinceID = b.StateProvinceID
INNER JOIN	[AdventureWorks2019].[Sales].[CountryRegionCurrency] AS c
ON			a.CountryRegionCode = c.CountryRegionCode
INNER JOIN	[AdventureWorks2019].[Sales].[SalesTerritory] AS d
ON			a.TerritoryID = d.TerritoryID