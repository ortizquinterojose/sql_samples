/*
Name:		Jose Ortiz
Lesson:		Temporary Data Structures
Date:		04/03/2023
*/

SELECT	*
FROM [AdventureWorks2019].[HumanResources].[Employee]

--1.	Create 10 temp tables using Adventureworks Database

--Query 1 - Must use the LIKE and BETWEEN operators.	
SELECT		BusinessEntityID
			,JobTitle
			,HireDate
INTO		#SupervisorInfo
FROM		[AdventureWorks2019].[HumanResources].[Employee]
WHERE		[JobTitle] LIKE ('%Supervisor%')
			AND [HireDate] BETWEEN '2008-06-01' AND	'2009-06-30'

SELECT		*
FROM		#SupervisorInfo


-- Query 2 Must use the IN and NOT IN operators.
-- Retrieve all info for Organization Level 3 and 4 but not for any Production Technician - WC60 and Production Technician - WC40 jobtitles 					

SELECT		BusinessEntityID
			,OrganizationLevel
			,JobTitle
			,HireDate
INTO		#OrganizationLevelInfo
FROM		[AdventureWorks2019].[HumanResources].[Employee]
WHERE		OrganizationLevel IN (3,4)
			AND JobTitle NOT IN ('Production Technician - WC60', 'Production Technician - WC40')

SELECT		*
FROM		#OrganizationLevelInfo

-- Query 3 Must use a GROUP BY Statement and 2 aggregates (Temp table should be built using SELECT INTO Statement).
-- retrieve qty of employes by marital status and how many hours have been sick 

SELECT		MaritalStatus 
			,COUNT(MaritalStatus) QtyMaritalStatus
			,AVG(SickLeaveHours) AvgSickLeaveHours
INTO		#employesbyMaritalstatus
FROM		[AdventureWorks2019].[HumanResources].[Employee]
GROUP BY	MaritalStatus

SELECT		*
FROM		#employesbyMaritalstatus


--Query 4 Must use the UNION operator.

DROP TABLE Toys
CREATE TABLE	Toys
				(
				ToyName VARCHAR(50)
				,ToyCost MONEY
				)
INSERT INTO dbo.Toys (ToyName,ToyCost)
SELECT  'Toy Truck','5.00' UNION
SELECT  'Basketball','15.00' UNION
SELECT  'Football','20.00' UNION
SELECT  'Frisbee','4.00' UNION
SELECT  'Bike','65.00' UNION
SELECT  'Teddy Bear','25.00' UNION
SELECT  'Water Gun','35.00' UNION
SELECT  'Baseball Bat','15.00' UNION
SELECT  'Baseball','3.00' UNION
SELECT  'Skateboard','40.00'

SELECT		ToyName 
			,ToyCost
INTO		#Toys
FROM		[New Class].[dbo].[Toys]

SELECT		*
FROM		#Toys

--Query 5 Must be built using at least one column that is a Primary Key with an Identity Column.

DROP TABLE ToysII
CREATE TABLE	ToysII
				(
				ToyNumber INT PRIMARY KEY IDENTITY(100,10)
				,ToyName VARCHAR(50)
				,ToyCost MONEY
				)
INSERT INTO dbo.ToysII (ToyName, ToyCost)
SELECT  'Toy Truck','19.00' UNION
SELECT  'Basketball','5.00' UNION
SELECT  'Football','21.00' UNION
SELECT  'Frisbee','4.00' UNION
SELECT  'Bike','62.00' UNION
SELECT  'Teddy Bear','25.00' UNION
SELECT  'Water Gun','39.00' UNION
SELECT  'Baseball Bat','10.00' UNION
SELECT  'Baseball','7.00' UNION
SELECT  'Skateboard','45.00'

SELECT		*
INTO		#ToysII
FROM		[New Class].[dbo].[Toys]

SELECT		*
FROM		#ToysII


--Query 6 Must be built using a WHERE clause and ORDER BY clause.
--retrieve all info from married employees order by jobtitle 

SELECT		BusinessEntityID 
			,MaritalStatus 
			,JobTitle 
			,HireDate
INTO		#JobTitlebyMaritalStatus
FROM		[AdventureWorks2019].[HumanResources].[Employee]
WHERE		[MaritalStatus]='M'
ORDER BY	JobTitle ASC

SELECT		*
FROM		#JobTitlebyMaritalStatus

--Query 7	Must be built using a GROUP BY clause and HAVING Clause.
--retrive avg sick hours per job title but only those that where higher than 40 

SELECT		JobTitle 
			,AVG(SickLeaveHours) AS AvgSicLeavekHours
INTO		#JobTitlebyAvgSickHours
FROM		[AdventureWorks2019].[HumanResources].[Employee]
GROUP BY	JobTitle
HAVING		AVG(SickLeaveHours)>40

SELECT		*
FROM		#JobTitlebyAvgSickHours

--Query 8 Must be built using WHERE / GROUP BY / HAVING / ORDER BY clauses
--retrive sickhours by jobtitle

SELECT		JobTitle
			,AVG(SickLeaveHours) SickLeaveHours
INTO		#AvgSickHoursMariage
FROM		[AdventureWorks2019].[HumanResources].[Employee]
WHERE		MaritalStatus='M'
GROUP BY	JobTitle
HAVING		AVG(SickLeaveHours)>40
ORDER BY	2 DESC, 1 

SELECT		*
FROM		#AvgSickHoursMariage

--Query 9 Must be built using 3 System Functions.
--retrive employee jobtitle, years employed and month when the employee was hired

SELECT		BusinessEntityID
			,JobTitle
			,DATEDIFF(YY,HireDate,GETDATE()) YearsAsEmployee
			,DATENAME(MM,[BirthDate]) HiredMonth
INTO		#EmployeeInfo
FROM		[AdventureWorks2019].[HumanResources].[Employee]

SELECT		*
FROM		#EmployeeInfo

--Query 10 Must be built using 3 other System Functions.
--retrive employe LoginID

SELECT		BusinessEntityID
			,JobTitle
			,RIGHT([LoginID],(LEN([LoginID])-CHARINDEX('\',[LoginID]))) AS LoginID
INTO		#employeLoginID
FROM		[AdventureWorks2019].[HumanResources].[Employee]

SELECT		*
FROM		#employeLoginID
 

--2.	Create the same 10 tables as CTE’s.

-- Query 1 Must use the LIKE and BETWEEN operators
-- Retrieve all info for Supervisor Positions that were hired during the period of jun 2008 and jun 2010

WITH		CTE_SupervisorInfo	(
								BusinessEntityID 
								,JobTitle 
								,HireDate 
								)
AS				
(
SELECT		BusinessEntityID
			,JobTitle
			,HireDate
FROM		[AdventureWorks2019].[HumanResources].[Employee]
WHERE		[JobTitle] LIKE ('%Supervisor%')
			AND [HireDate] BETWEEN '2008-06-01' AND	'2009-06-30'
)
SELECT		*
FROM		CTE_SupervisorInfo


-- Query 2 Must use the IN and NOT IN operators.
-- Retrieve all info for Organization Level 3 and 4 but not for any Production Technician - WC60 and Production Technician - WC40 jobtitles 

WITH		CTE_OrganizationLevelInfo	(
										BusinessEntityID 
										,OrganizationLevel 
										,JobTitle 
										,HireDate 
										)
AS					
(
SELECT		BusinessEntityID
			,OrganizationLevel
			,JobTitle
			,HireDate
FROM		[AdventureWorks2019].[HumanResources].[Employee]
WHERE		OrganizationLevel IN (3,4)
			AND JobTitle NOT IN ('Production Technician - WC60', 'Production Technician - WC40')
)

SELECT		*
FROM		CTE_OrganizationLevelInfo

-- Query 3 Must use a GROUP BY Statement and 2 aggregates (Temp table should be built using SELECT INTO Statement).
-- retrieve qty of employes by marital status and how many hours have been sick 

WITH		CTE_employesbyMaritalstatus	(
										MaritalStatus 
										,QtyMaritalStatus 
										,AvgSickLeaveHours 
										)
AS	
(
SELECT		MaritalStatus 
			,COUNT(MaritalStatus) QtyMaritalStatus
			,AVG(SickLeaveHours) AvgSickLeaveHours
FROM		[AdventureWorks2019].[HumanResources].[Employee]
GROUP BY	MaritalStatus
)

SELECT		*
FROM		CTE_employesbyMaritalstatus


--Query 4 Must use the UNION operator.

DROP TABLE Toys
CREATE TABLE	Toys
				(
				ToyName VARCHAR(50)
				,ToyCost MONEY
				)
INSERT INTO dbo.Toys (ToyName,ToyCost)
SELECT  'Toy Truck','5.00' UNION
SELECT  'Basketball','15.00' UNION
SELECT  'Football','20.00' UNION
SELECT  'Frisbee','4.00' UNION
SELECT  'Bike','65.00' UNION
SELECT  'Teddy Bear','25.00' UNION
SELECT  'Water Gun','35.00' UNION
SELECT  'Baseball Bat','15.00' UNION
SELECT  'Baseball','3.00' UNION
SELECT  'Skateboard','40.00'

WITH CTE_Toys	(
				ToyName 
				,ToyCost
				)
AS
(
SELECT			ToyName 
				,ToyCost
FROM		[New Class].[dbo].[Toys]
)

SELECT		*
FROM		CTE_Toys

--Query 5 Must be built using at least one column that is a Primary Key with an Identity Column. 

DROP TABLE ToysII
CREATE TABLE	ToysII
				(
				ToyNumber INT PRIMARY KEY IDENTITY(100,10)
				,ToyName VARCHAR(50)
				,ToyCost MONEY
				)
INSERT INTO dbo.ToysII (ToyName, ToyCost)
SELECT  'Toy Truck','19.00' UNION
SELECT  'Basketball','5.00' UNION
SELECT  'Football','21.00' UNION
SELECT  'Frisbee','4.00' UNION
SELECT  'Bike','62.00' UNION
SELECT  'Teddy Bear','25.00' UNION
SELECT  'Water Gun','39.00' UNION
SELECT  'Baseball Bat','10.00' UNION
SELECT  'Baseball','7.00' UNION
SELECT  'Skateboard','45.00'

WITH	CTE_ToysII	(
					ToyName 
					,ToyCost
					)
AS
(
SELECT				ToyName 
					,ToyCost
					
FROM		[New Class].[dbo].[Toys]
)

SELECT		*
FROM		CTE_ToysII


--Query 6 Must be built using a WHERE clause and ORDER BY clause.
--retrieve all info from married employees order by jobtitle 

WITH		CTE_JobTitlebyMaritalStatus	(
										BusinessEntityID 
										,MaritalStatus 
										,JobTitle 
										,HireDate 
										)
AS
(
SELECT		BusinessEntityID 
			,MaritalStatus 
			,JobTitle 
			,HireDate 
FROM		[AdventureWorks2019].[HumanResources].[Employee]
WHERE		[MaritalStatus]='M'
)

SELECT		*
FROM		CTE_JobTitlebyMaritalStatus

--Query 7	Must be built using a GROUP BY clause and HAVING Clause.
--retrive avg sick hours per job title but only those that where higher than 40 

WITH		CTE_JobTitlebyAvgSickHours	(
										JobTitle 
										,AvgSickHours 
										)
AS
(
SELECT		JobTitle 
			,AVG(SickLeaveHours) AS AvgSicLeavekHours
FROM		[AdventureWorks2019].[HumanResources].[Employee]
GROUP BY	JobTitle
HAVING		AVG(SickLeaveHours)>40
)
SELECT		*
FROM		CTE_JobTitlebyAvgSickHours

--Query 8 Must be built using WHERE / GROUP BY / HAVING / ORDER BY clauses
--retrive sickhours by jobtitle

WITH		CTE_AvgSickHoursMariage	(
									JobTitle 
									,AvgSickHours
									)
AS
(
SELECT		JobTitle
			,AVG(SickLeaveHours) SickLeaveHours
FROM		[AdventureWorks2019].[HumanResources].[Employee]
WHERE		MaritalStatus='M'
GROUP BY	JobTitle
HAVING		AVG(SickLeaveHours)>40
)

SELECT		*
FROM		CTE_AvgSickHoursMariage

--Query 9 Must be built using 3 System Functions.
--retrive employee jobtitle, years employed and month when the employee was hired

WITH		CTE_EmployeeInfo	(
								BusinessEntityID 
								,JobTitle 
								,YearsAsEmployee 
								,HiredMonth 
								)
AS
(
SELECT		BusinessEntityID
			,JobTitle
			,DATEDIFF(YY,HireDate,GETDATE()) YearsAsEmployee
			,DATENAME(MM,[BirthDate]) HiredMonth
FROM		[AdventureWorks2019].[HumanResources].[Employee]
)

SELECT		*
FROM		CTE_EmployeeInfo

--Query 10 Must be built using 3 other System Functions.
--retrive employe LoginID

WITH		CTE_employeLoginID	(
								BusinessEntityID 
								,JobTitle 
								,LoginID 
								)
AS
(
SELECT		BusinessEntityID
			,JobTitle
			,RIGHT([LoginID],(LEN([LoginID])-CHARINDEX('\',[LoginID]))) AS LoginID
FROM		[AdventureWorks2019].[HumanResources].[Employee]
)

SELECT		*
FROM		CTE_employeLoginID


--3.	Create the same 10 tables as Table Variables.

-- Query 1 Must use the LIKE and BETWEEN operators
-- Retrieve all info for Supervisor Positions that were hired during the period of jun 2008 and jun 2010

DECLARE		@SupervisorInfo TABLE	(
									BusinessEntityID INT
									,JobTitle VARCHAR(50)
									,HireDate DATE
									)
INSERT INTO @SupervisorInfo						

SELECT		BusinessEntityID
			,JobTitle
			,HireDate
FROM		[AdventureWorks2019].[HumanResources].[Employee]
WHERE		[JobTitle] LIKE ('%Supervisor%')
			AND [HireDate] BETWEEN '2008-06-01' AND	'2009-06-30'

SELECT		*
FROM		@SupervisorInfo


-- Query 2 Must use the IN and NOT IN operators.
-- Retrieve all info for Organization Level 3 and 4 but not for any Production Technician - WC60 and Production Technician - WC40 jobtitles 

DECLARE		@OrganizationLevelInfo TABLE	(
											BusinessEntityID INT
											,OrganizationLevel SMALLINT
											,JobTitle VARCHAR(50)
											,HireDate DATE
											)
INSERT INTO @OrganizationLevelInfo						


SELECT		BusinessEntityID
			,OrganizationLevel
			,JobTitle
			,HireDate
FROM		[AdventureWorks2019].[HumanResources].[Employee]
WHERE		OrganizationLevel IN (3,4)
			AND JobTitle NOT IN ('Production Technician - WC60', 'Production Technician - WC40')

SELECT		*
FROM		@OrganizationLevelInfo

-- Query 3 Must use a GROUP BY Statement and 2 aggregates (Temp table should be built using SELECT INTO Statement).
-- retrieve qty of employes by marital status and how many hours have been sick 

DECLARE		@employesbyMaritalstatus TABLE	(
											MaritalStatus NCHAR(1)
											,QtyMaritalStatus INT
											,AvgSickLeaveHours INT
											)
INSERT INTO @employesbyMaritalstatus	


SELECT		MaritalStatus 
			,COUNT(MaritalStatus) QtyMaritalStatus
			,AVG(SickLeaveHours) AvgSickLeaveHours
FROM		[AdventureWorks2019].[HumanResources].[Employee]
GROUP BY	MaritalStatus

SELECT		*
FROM		@employesbyMaritalstatus


--Query 4 Must use the UNION operator.

DROP TABLE Toys
CREATE TABLE	Toys
				(
				ToyName VARCHAR(50)
				,ToyCost MONEY
				)
INSERT INTO dbo.Toys (ToyName,ToyCost)
SELECT  'Toy Truck','5.00' UNION
SELECT  'Basketball','15.00' UNION
SELECT  'Football','20.00' UNION
SELECT  'Frisbee','4.00' UNION
SELECT  'Bike','65.00' UNION
SELECT  'Teddy Bear','25.00' UNION
SELECT  'Water Gun','35.00' UNION
SELECT  'Baseball Bat','15.00' UNION
SELECT  'Baseball','3.00' UNION
SELECT  'Skateboard','40.00'

DECLARE			@Toys TABLE		
				(
				ToyName VARCHAR(50)
				,ToyCost MONEY
				)
INSERT INTO		@Toys
SELECT			*
FROM			[New Class].[dbo].[Toys]

SELECT			*
FROM			@Toys

--Query 5 Must be built using at least one column that is a Primary Key with an Identity Column. 

DROP TABLE ToysII
CREATE TABLE	ToysII
				(
				ToyNumber INT PRIMARY KEY IDENTITY(100,10)
				,ToyName VARCHAR(50)
				,ToyCost MONEY
				)
INSERT INTO dbo.ToysII (ToyName, ToyCost)
SELECT  'Toy Truck','19.00' UNION
SELECT  'Basketball','5.00' UNION
SELECT  'Football','21.00' UNION
SELECT  'Frisbee','4.00' UNION
SELECT  'Bike','62.00' UNION
SELECT  'Teddy Bear','25.00' UNION
SELECT  'Water Gun','39.00' UNION
SELECT  'Baseball Bat','10.00' UNION
SELECT  'Baseball','7.00' UNION
SELECT  'Skateboard','45.00'

DECLARE	@ToysII	TABLE 
				(
				ToyName VARCHAR(50)
				,ToyCost MONEY
				)
INSERT INTO		@ToysII
SELECT			*
FROM			[New Class].[dbo].[Toys]
 
SELECT			*
FROM			@ToysII

--Query 6 Must be built using a WHERE clause and ORDER BY clause.
--retrieve all info from married employees order by jobtitle 

DECLARE		@JobTitlebyMaritalStatus TABLE	(
											BusinessEntityID INT
											,MaritalStatus NCHAR(1)
											,JobTitle VARCHAR(50)
											,HireDate DATE
											)
INSERT INTO @JobTitlebyMaritalStatus

SELECT		BusinessEntityID 
			,MaritalStatus 
			,JobTitle 
			,HireDate 
FROM		[AdventureWorks2019].[HumanResources].[Employee]
WHERE		[MaritalStatus]='M'
ORDER BY	JobTitle ASC

SELECT		*
FROM		@JobTitlebyMaritalStatus

--Query 7	Must be built using a GROUP BY clause and HAVING Clause.
--retrive avg sick hours per job title but only those that where higher than 40 

DECLARE		@JobTitlebyAvgSickHours TABLE	(
											JobTitle VARCHAR(50)
											,AvgSickHours INT
											)
INSERT INTO @JobTitlebyAvgSickHours

SELECT		JobTitle 
			,AVG(SickLeaveHours) AS AvgSicLeavekHours
FROM		[AdventureWorks2019].[HumanResources].[Employee]
GROUP BY	JobTitle
HAVING		AVG(SickLeaveHours)>40

SELECT		*
FROM		@JobTitlebyAvgSickHours

--Query 8 Must be built using WHERE / GROUP BY / HAVING / ORDER BY clauses
--retrive sickhours by jobtitle

DECLARE		@AvgSickHoursMariage TABLE	(
										JobTitle VARCHAR(50)
										,AvgSickHours INT
										)
INSERT INTO @AvgSickHoursMariage

SELECT		JobTitle
			,AVG(SickLeaveHours) SickLeaveHours
FROM		[AdventureWorks2019].[HumanResources].[Employee]
WHERE		MaritalStatus='M'
GROUP BY	JobTitle
HAVING		AVG(SickLeaveHours)>40
ORDER BY	2 DESC, 1 

SELECT		*
FROM		@AvgSickHoursMariage

--Query 9 Must be built using 3 System Functions.
--retrive employee jobtitle, years employed and month when the employee was hired

DECLARE		@EmployeeInfo TABLE	(
								BusinessEntityID INT
								,JobTitle NVARCHAR(50)
								,YearsAsEmployee INT
								,HiredMonth VARCHAR(50)
								)
INSERT INTO @EmployeeInfo

SELECT		BusinessEntityID
			,JobTitle
			,DATEDIFF(YY,HireDate,GETDATE()) YearsAsEmployee
			,DATENAME(MM,[BirthDate]) HiredMonth
FROM		[AdventureWorks2019].[HumanResources].[Employee]

SELECT		*
FROM		@EmployeeInfo

--Query 10 Must be built using 3 other System Functions.
--retrive employe LoginID

DECLARE		@employeLoginID TABLE	(
									BusinessEntityID INT
									,JobTitle NVARCHAR(50)
									,LoginID VARCHAR(50)
									)
INSERT INTO @employeLoginID

SELECT		BusinessEntityID
			,JobTitle
			,RIGHT([LoginID],(LEN([LoginID])-CHARINDEX('\',[LoginID]))) AS LoginID
FROM		[AdventureWorks2019].[HumanResources].[Employee]

SELECT		*
FROM		@employeLoginID
 

