/* 
Name:		Jose Ortiz
Lesson:		Working with Variables
Date:		03/26/2023
*/

--1.	 Create the following table.
USE [New Class]
IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE name='Flights' and type='U')

	DROP TABLE Flights

	GO

	CREATE TABLE Flights
	(
		FlightID INT PRIMARY KEY IDENTITY(100,1) NOT NULL,
		FlightDateTime DATETIME NULL,
		FlightDepartureCity VARCHAR(50) NULL,
		FlightDestinationCity VARCHAR(50) NULL,
		Ontime INT NULL
		)

--2.	 Run the following script to Insert Data into the table.

INSERT	INTO dbo.Flights (FlightDateTime, FlightDepartureCity, FlightDestinationCity, Ontime)
SELECT '1/1/2012','Dallas-Texas','L.A.',1  UNION
SELECT '1/2/2012','Austin-Texas','New York',1  UNION
SELECT '1/3/2012','Houston-Texas','New Jersy',0  UNION
SELECT '1/4/2012','San Antonio-Texas','Mesquite',1  UNION
SELECT '1/5/2012','Lewisville-Texas','Albany',0  UNION
SELECT '1/6/2012','Orlando-Florida','Atlanta',1  UNION
SELECT '1/7/2012','Chicago-Illinois','Oklahoma City',1  UNION
SELECT '1/8/2012','New Orleans-Louisiana','Memphis',0  UNION
SELECT '1/9/2012','Miami-Florida','Charlotte',1  UNION
SELECT '1/10/2012','Sacramento-California','San Francisco',1

SELECT	*
FROM	[dbo].[Flights]

--3.	Create and set a Variable equal to the number of Flights that were late.

DECLARE		@LateFlights INT
SET			@LateFlights = (
							SELECT		COUNT([Ontime])
							FROM		[dbo].[Flights]
							WHERE		[Ontime]=0
							)
SELECT		@LateFlights AS Lateflights

--4.	Multiply that amount by the amount lost per late flight ($1,029) 
--and store the amount in another variable.

DECLARE		@LostxLateFlight MONEY,
			@TotalLostxLateFlight MONEY
SET			@LostxLateFlight=1029
SET			@TotalLostxLateFlight=(@LostxLateFlight*@LateFlights)
SELECT		@TotalLostxLateFlight AS TotalLostAmountLateFlight

--5.	Take the total amount lost (#4) and subtract it from Total profit ($45,000) 
--and store that number in a variable.

DECLARE		@TotalProfit MONEY,
			@NetProfit MONEY
SET			@TotalProfit=45000
SET			@NetProfit= (@TotalProfit-@TotalLostxLateFlight)
SELECT		@NetProfit

--6.	Find out the Earliest FlightDate and add 10 years to it and store it in a variable.

DECLARE		@EarliestFlightDateplus10Years DATETIME,
			@PlusYears INT
SET			@PlusYears = 10
SET			@EarliestFlightDateplus10Years=
			(
			SELECT	DATEADD(YY,@PlusYears,MIN([FlightDateTime]))
			FROM	[dbo].[Flights]
			)
SELECT		@EarliestFlightDateplus10Years


--7.	Find out the day of the week for the Latest FlightDate and store it in a variable.

DECLARE		@LatestFlightDateDW VARCHAR(30)
SET			@LatestFlightDateDW=
			(
			SELECT	DATENAME(DW,MAX([FlightDateTime]))
			FROM	[dbo].[Flights]
			)
SELECT		@LatestFlightDateDW

--8.	Create a table variable with Departure City and State in 2 different columns along
--with Flight Destination City and Ontime. 

DECLARE		@Flights	TABLE (
								FlightDepartCity VARCHAR(50)
								,FlightDepartState VARCHAR(50)
								,FlightDestinationCity VARCHAR(50)
								,Ontime INT
								)
INSERT INTO @Flights
SELECT		SUBSTRING([FlightDepartureCity],1,CHARINDEX('-',[FlightDepartureCity])-1) 
			AS DepartureCity
			,SUBSTRING([FlightDepartureCity],(CHARINDEX('-',[FlightDepartureCity])+1),LEN([FlightDepartureCity]))
			AS DepartureState
			,FlightDestinationCity
			,Ontime
FROM		[dbo].[Flights]

SELECT		*
FROM		@Flights

--9.	Create a Table Variable storing all info from the dbo.Flights table of flights 
--that were on time

DECLARE			@FlightsonTime	TABLE (
								FlightID INT 
								,FlightDateTime DATETIME
								,FlightDepartureCity VARCHAR(50)
								,FlightDestinationCity VARCHAR(50)
								,Ontime INT
								)
INSERT	INTO	@FlightsonTime
SELECT	*
FROM	[dbo].[Flights]
WHERE	Ontime = 1

SELECT	*
FROM	@FlightsonTime


--10.	Create a Table Variable storing all info from the dbo.Flights table of non Texas Flights.

DECLARE		@TexasFlights	TABLE (
								FlightID INT 
								,FlightDateTime DATETIME
								,FlightDepartureCity VARCHAR(50)
								,FlightDestinationCity VARCHAR(50)
								,Ontime INT
								)
INSERT	INTO @TexasFlights
SELECT	*
FROM	[dbo].[Flights]
WHERE	FlightDepartureCity NOT LIKE '%texas%'

SELECT	*
FROM	@TexasFlights

--Run the following Script

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE name='HospitalStaff' and type='U')

	DROP TABLE HospitalStaff

	GO

CREATE TABLE [dbo].[HospitalStaff](
	[EmpID] [int] IDENTITY(1000,1) NOT NULL,
	[NameJob] [varchar](50) NULL,
	[HireDate] [datetime] NULL,
	[Location] [varchar](150) NULL,
 CONSTRAINT [PK_HospitalStaff] PRIMARY KEY CLUSTERED 
(
	[EmpID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

INSERT INTO [dbo].[HospitalStaff] ([NameJob],[HireDate],[Location])
SELECT		'Dr. Johnson_Doctor'	,'1/1/2012',	'Dallas-Texas' UNION
SELECT		'Nurse Jackie_Nurse'	,'10/15/2011',	'Mesquite-Texas' UNION
SELECT		'Anne_Nurse Assistant'	,'11/1/2010',	'Denton-Texas' UNION
SELECT		'Dr. Jackson_Doctor'	,'4/2/2008',	'Irving-Texas' UNION
SELECT		'Jamie_Nurse'			,'2/15/2005',	'San Francisco-California' UNION
SELECT		'Aesha_Nurse Assistant'	,'6/30/2003',	'Oakland-California' UNION
SELECT		'Dr. Ali_Doctor'		,'7/4/1999',	'L.A.-California' UNION
SELECT		'Evelyn_Nurse'			,'1/7/2007',	'Fresno-California' UNION
SELECT		'James Worthy_Nurse Assistant'	,'1/1/2012',	'Orlando-Florida' UNION
SELECT		'Anand_Doctor'			,'3/1/2012',	'Miami-Florida'


SELECT		*
FROM		dbo.HospitalStaff


--11.	Create a Variable to store how many employees have been employed with the company 
--for more than 3 years.

DECLARE		@EmployeesOlderThan3years INT
SET			@EmployeesOlderThan3years=
			(
			SELECT	COUNT([EmpID])
			FROM	[dbo].[HospitalStaff]
			WHERE	DATEADD(YY,3,[HireDate])<GETDATE()
			)
SELECT		@EmployeesOlderThan3years AS AmountOfEmployeesMore3Years

--12.	Create and populate a Variable to store the number of all employees from Texas

DECLARE		@TexasEmployees INT
SET			@TexasEmployees=
			(
			SELECT	COUNT([EmpID])
			FROM	[dbo].[HospitalStaff]
			WHERE	[Location] LIKE '%texas%'
			)
SELECT		@TexasEmployees AS EmployeesFromTexas

--13.	Create and populate a Variable to store the number of Doctor’s from Texas

DECLARE		@DoctorsFromTexas INT
SET			@DoctorsFromTexas=
			(
			SELECT	COUNT([EmpID])
			FROM	[dbo].[HospitalStaff]
			WHERE	[Location] LIKE '%texas%' AND
					[NameJob] LIKE'%doctor%'
			)
SELECT		@DoctorsFromTexas AS DoctorsFromTexas

--14.	Create a table variable using data in the dbo.HospitalStaff table with the 
--following 4 columns

--a.	Name – Located in the NameJob Column : Everything before the _
--b.	Job – Located in the NameJob Column : Everything after the _
--c.	HireDate
--d.	City – Located in the Location Column: Everything before the –
--e.	State – Located in the Location Column: Everyting after the –

DECLARE		@Hospital TABLE
					(
					Name VARCHAR(50)
					,Job VARCHAR(50)
					,HireDate DATETIME
					,City VARCHAR(50)
					,State VARCHAR(50)
					)
INSERT INTO	@Hospital
SELECT		SUBSTRING([NameJob],1,(CHARINDEX('_',[NameJob])-1)) AS Name
			,SUBSTRING([NameJob],(CHARINDEX('_',[NameJob])+1),LEN([NameJob])) AS Job
			,HireDate
			,SUBSTRING([Location],1,(CHARINDEX('-',[Location])-1)) AS City
			,SUBSTRING([Location],(CHARINDEX('-',[Location])+1),LEN([Location])) AS State
FROM		[dbo].[HospitalStaff]
SELECT		*
FROM		@Hospital



--15.	Create a Table Variable using data in the dbo.HospitalStaff table with the 
--following 4 columns
--a.	NameJob
--b.	DateYear – The Year of the HireDate
--c.	DateMonth – The Month of the HireDate
--d.	DateDay – The Day of the HireDate 

DECLARE @Employee TABLE
						(
						NameJob VARCHAR(50)
						,DateYear INT 
						,DateMonth VARCHAR(50) 
						,DateDay VARCHAR(50)
						)
INSERT INTO @Employee
SELECT	SUBSTRING([NameJob],(CHARINDEX('_',[NameJob])+1),LEN([NameJob])) AS Job
		,YEAR([HireDate]) AS YearHired
		,DATENAME(MM,[HireDate]) AS MonthHired
		,DATENAME(DW,[HireDate]) AS DayHired
FROM	[dbo].[HospitalStaff]
SELECT	*
FROM	@Employee
