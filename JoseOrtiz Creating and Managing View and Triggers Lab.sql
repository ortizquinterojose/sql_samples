/* 
Name:	Jose Ortiz
Lesson: Creating and Managing View and Triggers
Date:	04/19/2023
*/

USE JoseOrtiz

/*
1.	CREATE the following tables –
	a.	Dept_triggers – Add Identity Column (1000,1)
	b.	Emp_triggers– Add Identity Column (1000,1)
	c.	Emphistory
*/

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE name='dept_triggers' and type='U')

DROP TABLE dept_triggers

GO


CREATE	TABLE	dept_triggers 
		(
		deptid INT PRIMARY KEY IDENTITY(1000,1) NOT NULL
		,deptname VARCHAR(50)
		);

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE name='emp_triggers' and type='U')

DROP TABLE emp_triggers

GO


CREATE	TABLE	emp_triggers
		(
		empid INT PRIMARY KEY IDENTITY(1000,1) NOT NULL
		,empname VARCHAR(50)
		,deptid INT
		);

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE name='emphistory' and type='U')

DROP TABLE emphistory

GO

CREATE	TABLE	emphistory
		(
		empid INT
		,empname VARCHAR(50)
		,deptid INT
		,isactive INT
		);

--2.	TRIGGERS 

--a.	Trigger 1 - Build a trigger on the emp table after insert 
--that adds a record into the emp_History table and marks IsActive column to 1


CREATE TRIGGER	tr_tblemp_triggers_forinsert 
ON emp_triggers
FOR INSERT
AS
BEGIN
	DECLARE @empid INT
	DECLARE @empname VARCHAR(50)
	DECLARE	@deptid INT
	DECLARE	@isactive INT

	SELECT	@empid = i.empid FROM inserted i;
	SELECT	@empname = i.empname FROM inserted i;
	SELECT	@deptid = i.deptid FROM inserted i;
	SELECT	@isactive = 1

	INSERT INTO emphistory (
							empid
							,empname 
							,deptid 
							,isactive 
							)
	VALUES (@empid,@empname,@deptid,@isactive)

	PRINT 'AFTER INSERT trigger fired.'
END


--b.	Trigger 2 – Build a tirgger on the emp table after an update of the empname 
--or deptid column - It updates the subsequent empname and/or deptid in the emp_history table.


CREATE TRIGGER	tr_tblemp_triggers_forupdate 
ON emp_triggers
FOR UPDATE
AS
BEGIN
	DECLARE @empid INT
	DECLARE @empname VARCHAR(50)
	DECLARE	@deptid INT
	DECLARE	@isactive INT

	SELECT	@empid = i.empid FROM inserted i;
	SELECT	@empname = i.empname FROM inserted i;
	SELECT	@deptid = i.deptid FROM inserted i;
	SELECT	@isactive = 1
	
	IF UPDATE(empname)
	UPDATE	emphistory SET empname = @empname WHERE empid = @empid
		
	IF UPDATE(deptid)
	UPDATE	emphistory SET deptid = @deptid WHERE empid = @empid
	

	
	PRINT 'AFTER UPDATE trigger fired.'
END


--c.	Build a trigger on the emp table after delete that marks the isactive status = 0 
--in the emp_History table.


CREATE TRIGGER	tr_tblemp_triggers_afterDelete 
ON emp_triggers
FOR DELETE
AS
BEGIN
	UPDATE	[dbo].[emphistory]
	SET		[dbo].[emphistory].[isactive] = 0
	FROM	deleted AS i
	WHERE	i.empid = [dbo].[emphistory].[empid]
	AND		i.empname = [dbo].[emphistory].[empname]
	AND		i.deptid = [dbo].[emphistory].[deptid]
		
	PRINT 'AFTER DELETE trigger fired.'
END


--3.	Run this script – Results should show 10 records in the emp history table 
--all with an active status of 0



INSERT INTO dbo.emp_triggers
SELECT 'Ali',1000
INSERT INTO dbo.emp_triggers
SELECT 'Buba',1000
INSERT INTO dbo.emp_triggers
SELECT 'Cat',1001
INSERT INTO dbo.emp_triggers
SELECT 'Doggy',1001
INSERT INTO dbo.emp_triggers
SELECT 'Elephant',1002
INSERT INTO dbo.emp_triggers
SELECT 'Fish',1002
INSERT INTO dbo.emp_triggers
SELECT 'George',1003
INSERT INTO dbo.emp_triggers
SELECT 'Mike',1003
INSERT INTO dbo.emp_triggers
SELECT 'Anand',1004
INSERT INTO dbo.emp_triggers
SELECT 'Kishan',1004
DELETE FROM dbo.emp_triggers

SELECT *
FROM emp_triggers

SELECT *
FROM emphistory


--4.	 Create 5 views – Each view will use 3 tables and have 9 columns with 3 coming from each table.
--a.	Create a view using 3 Human Resources Tables (Utilize the  WHERE clause)


CREATE VIEW		vw_HumanResourcesrates
AS
SELECT			a.NationalIDNumber 
				,a.JobTitle 
				,a.HireDate 
				,b.DepartmentID 
				,b.ShiftID 
				,b.StartDate 
				,c.RateChangeDate 
				,c.Rate 
				,c.PayFrequency
FROM			[AdventureWorks2019].[HumanResources].[Employee] a
LEFT OUTER JOIN	[AdventureWorks2019].[HumanResources].[EmployeeDepartmentHistory] b
ON				a.BusinessEntityID = b.BusinessEntityID
LEFT OUTER JOIN	[AdventureWorks2019].[HumanResources].[EmployeePayHistory] c
ON				a.BusinessEntityID = c.BusinessEntityID
WHERE			a.JobTitle = 'Design Engineer'

SELECT *
FROM vw_HumanResourcesrates

--b.	Create a view using 3 Person Tables (Utilize 3 system functions)

CREATE VIEW vw_PersonTables
AS
SELECT			a.FirstName ,a.LastName 
				,CAST(a.ModifiedDate AS DATE) AS Date
				,RIGHT(b.EmailAddress,LEN(b.EmailAddress)-CHARINDEX('@',b.EmailAddress)) AS EmailDomain
				,LEFT(c.PhoneNumber,CHARINDEX('-',c.PhoneNumber)-1) AS PhoneAreaCode
FROM			[AdventureWorks2019].[Person].[Person] a
LEFT OUTER JOIN	[AdventureWorks2019].[Person].[EmailAddress] b
ON				a.BusinessEntityID = b.BusinessEntityID
LEFT OUTER JOIN	[AdventureWorks2019].[Person].[PersonPhone] c
ON				a.BusinessEntityID = c.BusinessEntityID

SELECT	*
FROM	vw_PersonTables


--c.	Create a view using 3 Production Tables (Utilize the Group By Statement)

CREATE VIEW vw_ProductionTables
AS

SELECT			a.Color 
				,b.ReviewerName 
				,COUNT(a.ProductID) ProductQty   
				,SUM(c.OrderQty) OrderQty
FROM			[AdventureWorks2019].[Production].[Product] a
LEFT OUTER JOIN	[AdventureWorks2019].[Production].[ProductReview] b
ON				a.ProductID = b.ProductID
LEFT OUTER JOIN	[AdventureWorks2019].[Production].[WorkOrder] c
ON				b.ProductID = c.ProductID
GROUP BY		a.Color ,b.ReviewerName

SELECT	*
FROM	vw_ProductionTables

--d.	Create a view using 3 Purchasing Tables (Utilize the  HAVING clause)

CREATE VIEW vw_PurchasingTables
AS
SELECT			a.PurchaseOrderID ,c.Name ,SUM(a.LineTotal) TotalOrder, YEAR(b.OrderDate) Year
FROM			[AdventureWorks2019].[Purchasing].[PurchaseOrderDetail] a
LEFT OUTER JOIN	[AdventureWorks2019].[Purchasing].[PurchaseOrderHeader] b
ON				a.PurchaseOrderID = b.PurchaseOrderID
LEFT OUTER JOIN	[AdventureWorks2019].[Purchasing].[ShipMethod] c
ON				b.ShipMethodID = c.ShipMethodID
WHERE			YEAR(b.OrderDate) = 2011
GROUP BY		a.PurchaseOrderID, c.Name, YEAR(b.OrderDate)
HAVING			SUM(a.LineTotal) > 10000

SELECT	*
FROM	vw_PurchasingTables

--e.	Create a view using 3 Sales Tables (Utilize the  CASE  Statement)

CREATE VIEW vw_SalesTables
AS

SELECT			a.TerritoryID 
				,COUNT(a.SalesOrderID) QtySalesOrder 
				,SUM(b.SalesYTD) TotalSalesYTD 
				,Count(c.CustomerID) TotalCustomers 
				,CASE 
					WHEN COUNT(a.SalesOrderID) > 25000000 THEN 'Big Territory'
					WHEN COUNT(a.SalesOrderID) > 4000000 THEN 'Medium Territory'
					WHEN COUNT(a.SalesOrderID) > 30000 THEN 'Small Territory'
				END TerritorySize
FROM			[AdventureWorks2019].[Sales].[SalesOrderHeader] a
LEFT OUTER JOIN	[AdventureWorks2019].[Sales].[SalesPerson] b
ON				a.TerritoryID = b.TerritoryID
LEFT OUTER JOIN	[AdventureWorks2019].[Sales].[Customer] c
ON				b.TerritoryID = c.TerritoryID
GROUP BY		a.TerritoryID


SELECT	*
FROM	vw_SalesTables