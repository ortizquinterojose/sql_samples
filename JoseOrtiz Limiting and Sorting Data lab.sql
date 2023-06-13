/* 
Name:	Jose Ortiz
Lesson: Limiting and Sorting Data
Date:	03/17/2023
*/

--1.	 Use the same table created in the previous lab. ..

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE name='Menu' and type='U')

	DROP TABLE Menu

	GO

	CREATE TABLE Menu
	(
		ItemID INT PRIMARY KEY IDENTITY(1000,1) NOT NULL,
		ItemName VARCHAR(50) NULL,
		ItemType VARCHAR(50) NOT NULL,
		CostToMake MONEY CHECK (CostToMake>0) NULL,
		Price MONEY NULL,
		WeeklySales INT NULL,
		MonthlySales INT NULL,
		YearlySales INT NULL
		)

--2.	 Run the following script to populate the table 

INSERT INTO dbo.Menu
SELECT		'Big Mac','Hamburger',1.25,3.24,1015,5000,15853
union
SELECT		'Quarter Pounder / Cheese','Hamburger',1.15,3.24,1000,4589,16095
union
SELECT		'Half Pounder / Cheese','Hamburger',1.35,3.50,500,3500,12589
union
SELECT		'Whopper','Hamburger',1.55,3.99,989,4253,13000
union
SELECT		'Kobe Cheeseburger','Hamburger',2.25,5.25,350,1500,5000
union
SELECT		'Grilled Stuffed Burrito','Burrito',.75,5.00,2000,7528,17896
union
SELECT		'Bean Burrito','Burrito',.50,1.00,1750,7000,18853
union
SELECT		'7 layer Burrito','Burrito',.78,2.50,350,1000,2563
union
SELECT		'Dorrito Burrito','Burrito',.85,1.50,600,2052,9857
union
SELECT		'Turkey and Cheese Sub','Sub Sandwich',1.75,5.50,1115,7878,16853
union
SELECT		'Philly Cheese Steak Sub','Sub Sandwich',2.50,6.00,726,2785,8000
union
SELECT		'Tuna Sub','Sub Sandwich',1.25,4.50,825,3214,13523
union
SELECT		'Meatball Sub','Sub Sandwich',1.95,6.50,987,4023,15287
union
SELECT		'Italian Sub','Sub Sandwich',2.25,7.00,625,1253,11111
union
SELECT		'3 Cheese Sub','Sub Sandwich',.25,6.00,815,3000,11853

--3.	Retrieve all Burritos and sort by Price

SELECT		*
FROM		[dbo].[Menu]
WHERE		ItemType = 'Burrito'
ORDER BY	Price	

--4.	Retrieve all items that Cost more than $1.00 to make and sort by WeeklySales

SELECT		*
FROM		[dbo].[Menu]
WHERE		CostToMake > 1
ORDER BY	WeeklySales

--5.	What’s the sum of total profit by ItemType

SELECT		ItemType, SUM(YearlySales-((YearlySales/Price)*CostToMake)) AS TotalProfit
FROM		[dbo].[Menu]
GROUP BY	ItemType



--6.	Retrieve Total Weekly Sales by ItemType of only items with more than 3000 weekly Sales.  Sort by Total Weekly Sales descending.

SELECT		ItemType, SUM(WeeklySales) AS TotalWeeklySales
FROM		[dbo].[Menu]
GROUP BY	ItemType
HAVING		SUM(WeeklySales)>3000 
ORDER BY	2 DESC

--7.	Find out the profit made Weekly, Monthly and Yearly on Big Mac’s

SELECT 
			ItemName
			,SUM(WeeklySales-((WeeklySales/Price)*CostToMake)) AS WeeklyProfit
			,SUM(MonthlySales-((MonthlySales/Price)*CostToMake)) AS MonthlyProfit
			,SUM(YearlySales-((YearlySales/Price)*CostToMake)) AS RearlyProfit
FROM		[dbo].[Menu]
WHERE		ItemName = 'Big Mac'
GROUP BY	ItemName

--8.	Retrieve the ItemType has more than $20,000 in Monthly Sales

SELECT		ItemType, SUM(MonthlySales) AS MonthlySales
FROM		[dbo].[Menu]
GROUP BY	ItemType		
HAVING		SUM(MonthlySales)>20000

--9.	Retrieve the ItemType that had the best Profit from MonthlySales

SELECT TOP	1 ItemType, SUM(MonthlySales-((MonthlySales/Price)*CostToMake)) AS MonthlyProfit
FROM		[dbo].[Menu]
GROUP BY	ItemType
ORDER BY	MonthlyProfit DESC






SELECT *
FROM [dbo].[Menu]