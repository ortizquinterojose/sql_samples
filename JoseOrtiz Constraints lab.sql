/* 
Name:		Jose Ortiz
Lesson:		Constraints
Date:		03/14/2023
*/

USE [New Class]

CREATE TABLE Customer 
(
	CustID int null,
	CustName varchar(50) null,
	EntryDate datetime null
	)

CREATE TABLE SalesReps
(
	RepID int null,
	RepName varchar(50) null,
	HireDate datetime null
	)

CREATE TABLE Sales
(
	SalesID int null,
	CustID int null,
	RepID int null,
	SalesDate datetime null,
	UnitCount int null,
	VerificationCode varchar(50) null
	)
--3 Create a Unique Key on dbo.Sales,VerificationCode

ALTER TABLE		[dbo].[Sales]
ADD CONSTRAINT	VerificationCode_contraint UNIQUE ([VerificationCode])

--6.The following tables.columns will default to GetDate() if no Date is given.

ALTER TABLE		[dbo].[Customer]
ADD CONSTRAINT	DF_EntryDate
DEFAULT (GETDATE()) FOR [EntryDate]

ALTER TABLE		[dbo].[SalesReps]
ADD CONSTRAINT	DF_HireDate
DEFAULT (GETDATE()) FOR [HireDate]

ALTER TABLE		[dbo].[Sales]
ADD CONSTRAINT	DF_SalesDate
DEFAULT (GETDATE()) FOR [SalesDate]

--8.Run the following script to ensure the Constraints have been added correctly

INSERT INTO dbo.Customer (CustName)
SELECT  'Ali' UNION
SELECT  'Anand' UNION
SELECT  'Alex' UNION
SELECT  'Jack' UNION
SELECT  'Nina' UNION
SELECT  'Joel' UNION
SELECT  'Keon' UNION
SELECT  'James' UNION
SELECT  'Mike' UNION
SELECT  'Sai' UNION
SELECT  'Terry'

INSERT INTO dbo.SalesReps (RepName)
SELECT  'Joseph' UNION
SELECT  'Jermaine' UNION
SELECT  'Marshall' UNION
SELECT  'Marvin' UNION
SELECT  'Mitchell' UNION
SELECT  'Johnson' UNION
SELECT  'Robert' UNION
SELECT  'Rachel' UNION
SELECT  'Rene' UNION
SELECT  'Brandy'UNION
SELECT  'Dirk'

INSERT INTO dbo.Sales (CustID, RepID,UnitCount,VerificationCode)
SELECT	100,120,1,'Ver01' UNION
SELECT	102,118,2,'Ver02' UNION
SELECT	104,116,3,'Ver03' UNION
SELECT	106,114,4,'Ver04' UNION
SELECT	108,112,5,'Ver05' UNION
SELECT	110,110,1,'Ver06' UNION
SELECT	112,108,2,'Ver07' UNION
SELECT	114,106,3,'Ver08' UNION
SELECT	116,104,4,'Ver09' UNION
SELECT	118,102,5,'Ver10' UNION
SELECT	120,100,6,'Ver11'

SELECT *
FROM [dbo].[Customer]

SELECT *
FROM [dbo].[Sales]

SELECT *
FROM [dbo].[SalesReps]


