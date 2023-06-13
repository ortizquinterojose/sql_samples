/*
Name:		Jose Ortiz
Lesson:		System Functions
Date:		03/24/2023
*/




--Run the Following Script and answer the Questions Below

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Loan]') AND type in (N'U'))
DROP TABLE [dbo].[Loan]

CREATE TABLE [dbo].[Loan](
	[LoanNumber] [int] IDENTITY(1000,1) NOT NULL,
	[CustomerFname] [varchar](50) NULL,
	[CustomerLname] [varchar](50) NULL,
	[PropertyAddress] [varchar](150) NULL,
	[City] [varchar](150) NULL,
	[State] [varchar](50) NULL,
	[BankruptcyAttorneyName] [varchar](50) NULL,
	[UPB] MONEY NULL,
	[LoanDate] [Datetime] NULL
 CONSTRAINT [PK_Loan] PRIMARY KEY CLUSTERED 
(
	[LoanNumber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

TRUNCATE TABLE dbo.Loan

INSERT INTO [dbo].[Loan]
           ([CustomerFname]
           ,[CustomerLname]
           ,[PropertyAddress]
           ,[City]
           ,[State]
           ,[BankruptcyAttorneyName]
		   ,[UPB]
		   ,[LoanDate])
SELECT	'Mr. Anand','Dasari','1212 Main St.','Plano','TX','Jerry',85000,'1/1/2012' UNION
SELECT	'Mr. John','Nasari','1215 Joseph St.','Garland','TX','Jerry',95000,'4/2/2012' UNION
SELECT	'Dr. Ali','Muwwakkil','2375 True True St.','Atlanta','GA','Diesel',115000,'5/3/2008' UNION
SELECT	'Mr. John','Brown','11532 Chain St.','SanFrancisco','CA','Mora',350000,'6/13/2004' UNION
SELECT	'Dr. Kishan','Johnson','4625 Miller Rd.','Atlanta','GA','Diesel',225000,'8/9/2002' UNION
SELECT	'Mr. John','Jackson','972 Flower Rd.','Dallas','TX','Jerry',150000,'3/1/2012' UNION
SELECT	'Sr. Ralph','Jenkins','1518 Mission Ridge St.','SanFrancisco','CA','Mora',650000,'12/15/2011' UNION
SELECT	'Dr. John','Howard','102 Washington','Dallas','TX','Jerry',450000,'4/5/2010' UNION
SELECT	'Mrs. Marsha','Tamrie','1301 Solana','SanFrancisco','CA','Mora',750000,'7/1/2000' UNION
SELECT	'Mrs. Alexis','Gibson','1111 Phillips Rd.','Atlanta','GA','Diesel',99000,'6/1/2012' 
        
SELECT * FROM [dbo].[Loan] 

/*8.	Write a SQL query to retrieve loan number, state, city, UPB and todays date for loans in the state 
of TX that have a UPB greater than $100,000 or loans that are in the state of CA or FL that have a UPB 
greater than or equal to $500,000*/

SELECT	
		LoanNumber
		,State 
		,City 
		,UPB 
		,GETDATE()	TodayDate
FROM	[dbo].[Loan]	
WHERE	State='TX' AND UPB>100000 OR State IN ('CA','FL') AND UPB>500000

/*9.	Write a SQL query to retrieve loan number, customer first name, customer last name, property address,
and bankruptcy attorney name.  I want all the records that have the same attorney name to be together, 
then the customer last name in order from Z-A (ex.Customer last name of Wyatt comes before customer 
last name of Anderson)*/

SELECT
		LoanNumber
		,CustomerFname
		,CustomerLname
		,PropertyAddress
		,BankruptcyAttorneyName
FROM	[dbo].[Loan]
ORDER BY 5, 3 DESC 

/* 10.	Write a sql query to retrieve the loan number, state and city, customer first name for 
loans that are in the states of CA,TX,FL,NV,NM but exclude the following cities 
(Dallas, SanFrancisco, Oakland) and only return loans where customer first name begins with John.*/


SELECT
		LoanNumber
		,State
		,City
		,CustomerFname	
FROM	[dbo].[Loan]
WHERE	State IN ('CA','TX','FL','NV','NM') 
		AND City NOT IN ('Dallas', 'SanFrancisco', 'Oakland') 
		AND CustomerFname LIKE '%John%' 

--11.	Find out how many days old each Loan is?

SELECT	
		[LoanNumber]
		,DATEDIFF(DD,[LoanDate],GETDATE()) AS LoanTime_Days
FROM	[dbo].[Loan]

--12.	Find the State with the highest Avg UPB.

SELECT		TOP 1
			State
			,AVG(UPB) AS AvgUPB
FROM		[dbo].[Loan]
GROUP BY	State



/*13.	Each Loan has a length of 30 years.  Retrieve the LoanNumber, Attorney Name 
and the anticipated Finish Date of the Loan.*/

SELECT
			[LoanNumber]
			,[BankruptcyAttorneyName]
			,DATEADD(DD,30,[LoanDate]) Loan_FinishDate
FROM		[dbo].[Loan]

/*14.	The Title of the Customer is Located in the CustomerFname Column.  
Separate the title into its own column and also retrieve CustomerFname, CustomerLname, 
City, State and LoanDate of Loans that are more than 1 yr old.*/

SELECT 
		LEFT([CustomerFname],CHARINDEX(' ',[CustomerFname])) 
		AS Title
		,RIGHT([CustomerFname],(LEN([CustomerFname])-CHARINDEX(' ',[CustomerFname]))) 
		AS FirstName
		,[CustomerLname]
		,[City]
		,[State]
		,[LoanDate]
FROM	[dbo].[Loan]
WHERE	DATEDIFF(DD,[LoanDate],GETDATE())>365
