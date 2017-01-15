USE CRICKET 
GO

CREATE PROCEDURE Insert_Umpires_table
AS

-- FIRST delete all the details from the umpires test table
DELETE FROM CRICKET..umpirestest

DECLARE @delimiter VARCHAR(50)
SET @delimiter=' vs '  -- <=== Here, you can change the delimiter.
;WITH split AS
( 
    SELECT umpiresformatch, CAST('<M>' + REPLACE([umpiresformatch], @delimiter , '</M><M>') + '</M>' AS XML)  AS [umpires]
    FROM  cricket..temporaryMatchessummary
)
 
-- INSERT the details of the temporary matchsummary into Umpires test table
 INSERT INTO  CRICKET..umpirestest 
 SELECT distinct [umpires].value('/M[1]', 'varchar(50)')  FROM split  
 UNION 
 SELECT distinct [umpires].value('/M[2]', 'varchar(50)')  FROM split 

--- declaring the cursor

DECLARE @Umpirename varchar(255)
DECLARE @NoOfMatches int
DECLARE @PREVCNT1 int
DECLARE @PREVCNT2 int

DECLARE db_Insert_umpires CURSOR FOR  
    SELECT umpirename FROM  CRICKET..umpirestest 

OPEN db_Insert_umpires 
FETCH NEXT FROM db_Insert_umpires INTO @Umpirename

    WHILE @@FETCH_STATUS = 0  
        BEGIN

		set @NoOfMatches =   (select count(*)  FROM  cricket..temporaryMatchessummary where umpiresformatch like   '%' +@Umpirename+ '%' ) 
        set @PREVCNT1=       (select count(*)  FROM  CRICKET..umpires where Umpirename = @Umpirename ) 

		if (@PREVCNT1 = 0 )
                 Insert Into CRICKET..umpires (Umpirename,Noofmatches,Noofmatchesplayed) VALUES(@umpirename, @NoOfMatches)
		else 
		         update  CRICKET..umpires set Noofmatches = @NoOfMatches + NoOfMatches where Umpirename = @Umpirename

		FETCH NEXT FROM db_Insert_umpires INTO @Umpirename 
        END

CLOSE db_Insert_umpires;  
DEALLOCATE db_Insert_umpires; 



