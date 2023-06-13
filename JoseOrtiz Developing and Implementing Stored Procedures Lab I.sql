 /*
NAME:		JOSE ORTIZ
LESSON:		Developing and Implementing Stored Procedures
DATE:		05/11/2023
*/

/*1.	Name: CREATE PROCEDURE proc_TerritorySalesByYear
a.	Parameter: OrderYear
(Passing Value)
b.	Display the Total sales by territory for the Year Parameter
(The following is for the results set, which will be created in your statement in order to pass your parameter to receive the total sales by each territory)
*/

select *
from [AdventureWorks2019].[Sales].[SalesOrderHeader]

CREATE PROCEDURE proc_TerritorySalesByYear
	@OrderYear INT
AS 
BEGIN
	SET NOCOUNT ON;

	SELECT	TerritoryID, SUM(TotalDue) TotalSales 
	FROM	[AdventureWorks2019].[Sales].[SalesOrderHeader]
	WHERE	Datename(YY,OrderDate)= @OrderYear
	GROUP BY TerritoryID

END

EXEC proc_TerritorySalesByYear 2012

/*2.	Name: CREATE PROCEDURE proc_SalesByTerritory
a.	Parameter: Territory Name
(Passing Value)
b.	Results set: Display Total sales by Year for the Territory Name Parameter
(The following is for the results set, which will be created in your statement in 
order to pass your parameter to receive the total sales by each year)
*/


select *
from [AdventureWorks2019].[Sales].[SalesTerritory]

select *
from [AdventureWorks2019].[Sales].[SalesOrderHeader]

CREATE PROCEDURE proc_SalesByTerritory
	@TerritoryName VARCHAR(50)
AS 
BEGIN
	SET NOCOUNT ON;
		SELECT	Datename(yy,a.OrderDate) Year, SUM(a.TotalDue) TotalSales
		FROM	[AdventureWorks2019].[Sales].[SalesOrderHeader] AS a
		LEFT JOIN	[AdventureWorks2019].[Sales].[SalesTerritory] AS b
		ON	a.TerritoryID = b.TerritoryID
		WHERE    b.[Name] = @TerritoryName
		GROUP BY b.[Name], Datename(yy,a.OrderDate) 
		ORDER BY Datename(yy,a.OrderDate) DESC
		
END

EXEC proc_SalesByTerritory 'Canada'

/*
3.	 Name: CREATE PROCEDURE proc_TerritoryTop5Sales_ByProduct
a.	Parameter: Territory Name
(Passing Value)
b.	Results set: Top 5 Products by year
(The following is for the results set, which will be created in your statement in order to pass in Territory Name to receive the Top 5 Products sold (Sum of Line Total) by each Year)
*/


SELECT *
FROM [AdventureWorks2019].[Sales].[SalesOrderDetail]

select *
from [AdventureWorks2019].[Sales].[SalesOrderHeader]

select *
from [AdventureWorks2019].[Sales].[SalesTerritory]

select *
from [AdventureWorks2019].[Production].[Product]

CREATE PROCEDURE proc_TerritoryTop5Sales_ByProduct
				@TerritoryName VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;
DECLARE			@Practica1 TABLE
							(
							ProductName VARCHAR(50)
							,TotalSales MONEY
							,[Year] INT
							)
INSERT INTO		@Practica1

SELECT			d.Name, SUM(a.LineTotal) AS TotalSales, YEAR(a.ModifiedDate) 
FROM			[AdventureWorks2019].[Sales].[SalesOrderDetail] AS a	
LEFT OUTER JOIN	[AdventureWorks2019].[Sales].[SalesOrderHeader] AS b
ON				a.SalesOrderID = b.SalesOrderID
LEFT OUTER JOIN	[AdventureWorks2019].[Sales].[SalesTerritory] AS c
ON				b.TerritoryID = c.TerritoryID
LEFT OUTER JOIN [AdventureWorks2019].[Production].[Product] AS d
ON				a.ProductID = d.ProductID
WHERE			c.[Name] = @TerritoryName 
GROUP BY		d.Name, YEAR(a.ModifiedDate)
ORDER BY 		YEAR(a.ModifiedDate) DESC,SUM(a.LineTotal) DESC;


WITH CTE_Top5
	AS
			(
			Select *, ROW_NUMBER() OVER (PARTITION BY Year ORDER BY Year DESC) as TopSaleProduct
			FROM @Practica1
			)

SELECT		*
FROM		CTE_Top5
WHERE		TopSaleProduct <=5
ORDER BY	[Year] DESC, TotalSales DESC

END

EXEC proc_TerritoryTop5Sales_ByProduct 'Central'


/*
4.	 Stored Procedure with Output Parameters 
     a. Add a MgrID column to your emp table. */

ALTER TABLE [New Class].[dbo].[emp] ADD MgrID INT  

SELECT * FROM [New Class].[dbo].[emp]




 /*   b. Populate it accordingly using the integer data type and same number of characters 
 as the empID column*/
     
UPDATE [dbo].[emp] SET [MgrID] = 10 WHERE [empid] in (1); 
UPDATE [dbo].[emp] SET [MgrID] = 9 WHERE [empid] in (2);
UPDATE [dbo].[emp] SET [MgrID] = 8 WHERE [empid] in (3);	 
UPDATE [dbo].[emp] SET [MgrID] = 7 WHERE [empid] in (4);
UPDATE [dbo].[emp] SET [MgrID] = 6 WHERE [empid] in (5);
UPDATE [dbo].[emp] SET [MgrID] = 5 WHERE [empid] in (6);
UPDATE [dbo].[emp] SET [MgrID] = 4 WHERE [empid] in (7);
UPDATE [dbo].[emp] SET [MgrID] = 3 WHERE [empid] in (8);
UPDATE [dbo].[emp] SET [MgrID] = 2 WHERE [empid] in (9);
UPDATE [dbo].[emp] SET [MgrID] = 1 WHERE [empid] in (10);


SELECT * FROM [New Class].[dbo].[emp]

	 
/*c. Build a SP that passes in empID and returns an output parameter of the mgrID - 
(Create the SP and verify it works correctly) 
(Keep in mind that the mgrID will also be an individual’s empID., since managers are also employees)*/

CREATE PROC proc_mgrIDbyempID 
	
AS
	BEGIN
		SELECT	MgrID 
		FROM	[New Class].[dbo].[emp]
		WHERE	empID=1
	END

EXEC proc_mgrIDbyempID

/* d. (Start a New Query and separate it from the previous Stored Procedure) Declare an empid int and 
manager_name Varchar (50) variable*/

DECLARE @empID INT
DECLARE @manager_name VARCHAR(50)
;

/*e. Hard code your new empid variable and Pass it into your new SP to return the mgrid 
(Use an actual empid in the variable location to test and Pass it into your new SP to return the mgrID)*/


ALTER PROC proc_mgrIDbyempID 
	@empID INT
AS
	BEGIN
	SET NOCOUNT ON;
	SELECT	MgrID 
		FROM	[New Class].[dbo].[emp]
		WHERE	empID=@empID
		
	END

EXEC proc_mgrIDbyempID 1

/*f. Capture that mgrid in a variable and use that mgrid variable to determine the Managers name
(Create another statement which locates the Manager’s Name by using mgrID)*/

ALTER PROC proc_mgrIDbyempID 
	@empID INT,
	@manager_name VARCHAR(50) OUTPUT
AS
	BEGIN
	SET NOCOUNT ON;
	SET @manager_name= 
		(
		SELECT	CAST(MgrID AS VARCHAR(50)) 
		FROM	[New Class].[dbo].[emp]
		WHERE	empID=@empID
		)
		
	END


DECLARE @CatchOutput VARCHAR(50)
EXEC	proc_mgrIDbyempID 4, @manager_name= @CatchOutput OUTPUT

	SELECT	empname AS Manager_Name
	FROM	[New Class].[dbo].[emp]
	WHERE	MgrID=@CatchOutput

/*e. Print the Managers name*/

PRINT @CatchOutput
	 



