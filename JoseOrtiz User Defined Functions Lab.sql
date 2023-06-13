/*
Name:		Jose Ortiz
Lesson:		User Defined Functions (UDF)
Date:		03/31/2023
*/


USE [AdventureWorks2019]


SELECT *
FROM [HumanResources].[Employee]

--1.	 Create a UDF that accepts EmployeeID (2012: BusinessEntityID) 
--and returns UserLoginID.  The UserLoginID is the last part of the LogID column.  
--It’s only the part that comes after the \

DROP	FUNCTION fx_UserLoginID
GO

CREATE	FUNCTION fx_UserLoginID
	(@UserLoginID INT)
	RETURNS VARCHAR(50)
	AS 
	BEGIN
		RETURN
			(
			SELECT	RIGHT(LoginID,LEN(LoginID)-CHARINDEX('\',LoginID)) 
			FROM	[HumanResources].[Employee]
			WHERE	BusinessEntityID = @UserLoginID
			)
	END

SELECT [dbo].[fx_UserLoginID] (1) AS UserLoginID

--2.	Create a UDF that accepts EmployeeID (2012: BusinessEntityID) 
--and returns their age.

DROP	FUNCTION fx_EmployeeAge
GO

CREATE	FUNCTION fx_EmployeeAge
	(@UserLoginID INT)
	RETURNS int	
	AS 
	BEGIN
		RETURN
			(
			SELECT	DATEDIFF(YY,BirthDate,GETDATE()) 
			FROM	[HumanResources].[Employee]
			WHERE	BusinessEntityID = @UserLoginID
			)
	END

SELECT	[dbo].[fx_EmployeeAge](1) AS EmployeeAge

	
--3.	Create a UDF that accepts the Gender and returns the avg VacationHours

DROP	FUNCTION fx_AvgVacationHours
GO

CREATE	FUNCTION fx_AvgVacationHours
(@Gender nchar(1))
	RETURNS INT
	AS
	BEGIN
		RETURN
			(
			SELECT		AVG(VacationHours) 
			FROM		[HumanResources].[Employee]
			WHERE		Gender = @Gender 
			)
	END

SELECT	[dbo].[fx_AvgVacationHours]('M') AS AvgVacationHours

/*4.	Create a UDF that accepts ManagerID (2012: JobTitle) and returns all of that 
Managers (2012: JobTitle) Employee Information.
a.	LoginID
b.	Gender
c.	HireDate
*/
DROP	FUNCTION fx_ManagerEmployeeInformation
GO

CREATE	FUNCTION fx_ManagerEmployeeInformation
	(@ManagerID NVARCHAR(50))
	RETURNS TABLE
	AS
	RETURN
			(
				SELECT	
						LoginID
						,Gender
						,HireDate
				FROM	[HumanResources].[Employee]
				WHERE	JobTitle = @ManagerID
				)

SELECT	*
FROM	fx_ManagerEmployeeInformation('Design Engineer')