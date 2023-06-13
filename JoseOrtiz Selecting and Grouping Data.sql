
/*
Name:	Jose Ortiz
Lesson:	Selecting and Grouping Data Lab
Date:	03/13/2023
*/

INSERT INTO BBALL_STATS([PlayerID], [PlayerName], [PlayerNum], [PlayerPosition], [Assist], [Rebounds], [GamesPlayed], [Points], [PlayersCoach])
select 1,'ali',20,'guard',125,80,10,60,'thompson' union
select 2,'james',22,'forward',65,100,10,65,'garret' union
SELECT 3,'ralph',24, 'center',30 ,120,9,70,'samson' union
   SELECT 4,'terry',30,'guard',145,90,9,75,'garret' union
   SELECT 5,'dirk',32,'forward',70,110,10,80,'thompson'union
   SELECT 6,'alex',34,'center',35 ,130,10,90,'garret' union
   SELECT 7,'nina',40,'guard',155 ,100,9,100 ,'samson'union
   SELECT 8,'krystal',42,'forward',75,100,9,95,'thompson' union
   SELECT 9,'bud',44, 'center',40,125,10,90,'thompson' union
   SELECT 10,'tiger',50, 'guard',160,90,10,85,'samson' union
   SELECT 11,'troy',52, 'forward',80,125,10,80,'samson' union
   SELECT 12,'anand',54, 'center',50,145,10,110,'samson' union
   SELECT 13,'kishan',60, 'guard',120,150,9,115,'samson' union
   SELECT 14,'spock',62, 'forward',85,105,8,120,'thompson' union
SELECT 15,'cory',64, 'center',55,175,10,135,'samson'
GO

SELECT * FROM dbo.BBall_Stats

--a.	Find the Number of Players at each Position

SELECT		PlayerPosition, COUNT (PlayerPosition) AS #Of_Players 
FROM		[dbo].[BBall_Stats]
GROUP BY	PlayerPosition

--b.	Find the Number of Players assigned to each Coach

SELECT		PlayersCoach, COUNT (PlayersCoach) AS Players_Assigned
FROM		[dbo].[BBall_Stats]
GROUP BY	PlayersCoach 

--c.	Find the Most Points scored per game by Position

SELECT		[PlayerPosition], MAX([Points]/[GamesPlayed]) AS PointsxGame
FROM		[dbo].[BBall_Stats]
GROUP BY	PlayerPosition
ORDER BY	2 desc

--d.	Find the Number of Rebounds per game by Coach

SELECT		[PlayersCoach], SUM([Rebounds]/[GamesPlayed]) AS ReboundxGame
FROM		[dbo].[BBall_Stats]
GROUP BY	[PlayersCoach]
ORDER BY	2 desc

--e.	Find the Average number of Assist by Coach

SELECT		[PlayersCoach], AVG([Assist]) AS AvgAssist
FROM		[dbo].[BBall_Stats]
GROUP BY	[PlayersCoach]
ORDER BY	2 desc

--f.	Find the Average number of Assist per game by Position

SELECT		[PlayerPosition], AVG([Assist]/[GamesPlayed]) AS AvgAssistxGame
FROM		[dbo].[BBall_Stats]
GROUP BY	PlayerPosition
ORDER BY	2 desc

--g.	Find the Total number of Points by each Player Position.

SELECT		[PlayerPosition], SUM([Points]) AS TotalPoints 
FROM		[dbo].[BBall_Stats]
GROUP BY	PlayerPosition
ORDER BY	2 desc

SELECT * FROM dbo.BBall_Stats
