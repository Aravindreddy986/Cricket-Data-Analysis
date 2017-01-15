USE CRICKET 
GO

CREATE PROCEDURE Insert_OR_UPDATE_Venue__Cricketplaying_nations_table
AS

Declare @matchdate varchar(255)
DECLARE @matchlocation varchar(255)
DECLARE @matchvenue varchar(255)
DECLARE @matchtype varchar(10)
DECLARE @matchgender varchar(30)
DECLARE @matchwinner varchar(255)
DECLARE @tosswonby varchar(255)
DECLARE @tosswinnerdecision varchar(255)
DECLARE @team1 varchar(255)
DECLARE @team2 varchar(255)
DECLARE @batting1st varchar(255)
DECLARE @batting2nd varchar(255)
DECLARE @scenario varchar(255)

--- Splitting the team names in the temporary match summary table
DECLARE @delimiter VARCHAR(50)
SET @delimiter=' vs '  -- <=== Here, you can change the delimiter.
;WITH SPlit AS
( 
    SELECT matchdate,matchlocation, matchvenue,matchtype,matchgender, marchbetween,
		   CAST('<M>'+ REPLACE(marchbetween, @delimiter,'</M><M>' ) + '</M>' AS XML)  AS teams,
		   tosswonby, tosswinnerdecision, 
		   'null' as batting1st, 'NULL' as batting2nd, matchwinner, 'null' as scenario
    FROM  cricket..temporaryMatchessummary
)

SELECT matchdate,matchlocation, matchvenue, matchtype,matchgender, marchbetween, 
		   teams.value('/M[1]', 'varchar(50)') as team1,
		   teams.value('/M[2]', 'varchar(50)') as team2,
		   tosswonby, tosswinnerdecision,batting1st,batting2nd, matchwinner, scenario into #temp
           FROM SPlit

		   ALTER table #temp ALTER COLUMN batting1st varchar(100)
		   ALTER table #temp ALTER COLUMN batting2nd varchar(100)
		   ALTER table #temp ALTER COLUMN scenario varchar(100)

-- Fetching the match winner details like 1st batting or 2nd batting and scenario matches played in venue's

DECLARE db_split CURSOR FOR  
            SELECT matchdate,matchlocation, matchvenue, matchtype,matchgender,  
		   team1,team2,tosswonby, tosswinnerdecision, batting1st, batting2nd, matchwinner, scenario
           FROM #temp
                    
OPEN db_split 
FETCH NEXT FROM db_split INTO @matchdate,@matchlocation, @matchvenue, @matchtype, @matchgender, @team1, @team2, 
                              @tosswonby, @tosswinnerdecision,@batting1st, @batting2nd, @matchwinner, @scenario

    WHILE @@FETCH_STATUS = 0  
        BEGIN
        
		if (@tosswinnerdecision = 'bat')
		     update #temp set batting1st = @tosswonby where 
			 matchdate = @matchdate and matchvenue = @matchvenue and  matchtype = @matchtype and matchgender = @matchgender and team1 = @team1 and team2 = @team2

             update #temp set batting2nd = CASE WHEN batting1st = team1 then team2 else team1 END  where 
			 matchdate = @matchdate and matchvenue = @matchvenue and  matchtype = @matchtype and matchgender = @matchgender and team1 = @team1 and team2 = @team2

		if  (@tosswinnerdecision = 'field')
		     update #temp set batting2nd = @tosswonby where 
			 matchdate = @matchdate and matchvenue = @matchvenue and  matchtype = @matchtype and matchgender = @matchgender and team1 = @team1 and team2 = @team2
			 update #temp set batting1st = CASE WHEN batting2nd = team1 then team2 ELSE team1 end where 
			 matchdate = @matchdate and matchvenue = @matchvenue and  matchtype = @matchtype and matchgender = @matchgender and team1 = @team1 and team2 = @team2 

        update #temp set scenario = CASE  WHEN matchwinner = batting1st then '1st'
		                                  WHEN matchwinner = batting2nd  then  '2nd'
										  when matchwinner = 'No Result' then   'NR'    END 
		where 	 matchdate = @matchdate and matchvenue = @matchvenue and  matchtype = @matchtype and matchgender = @matchgender and team1 = @team1 and team2 = @team2 
		
		FETCH NEXT FROM db_split INTO @matchdate,@matchlocation, @matchvenue, @matchtype, @matchgender, @team1, @team2, 
                              @tosswonby, @tosswinnerdecision,@batting1st, @batting2nd, @matchwinner, @scenario

        END

CLOSE db_split;  
DEALLOCATE db_split;  

--- updating or inserting the details in the CRICKET..venuedetails

DECLARE @totalnofmatchesplayed INT
DECLARE @matcheswonbybatting1stteam INT
DECLARE @matcheswonbybatting2ndteam INT
DECLARE @noresult INT
DECLARE @cntt2    INT

DECLARE db_Insert_UPDATE_VENUE_TABLE CURSOR FOR  
                         Select t1.matchvenue, t1.matchlocation, 
                         t1.matchtype, t1.matchgender, 
	                     count(*) as totalnofmatchesplayed ,
						 (select count(*) from #temp t2 where t2.matchvenue = t1.matchvenue and  t2.matchtype = t1.matchtype and t2.matchgender = t1.matchgender and t2.scenario = '1st' )AS matcheswonbybatting1stteam,
						 (select count(*) from #temp t2 where   matchvenue = t1.matchvenue and  matchtype = t1.matchtype and matchgender = t1.matchgender and scenario = '2nd') as matcheswonbybatting2ndteam,
						 (select count(*) from #temp t2 where  matchvenue = t1.matchvenue and  matchtype = t1.matchtype and matchgender = t1.matchgender and scenario = 'NR') as noresult
                         from #temp t1
                         group by matchlocation, matchvenue, matchtype,matchgender

OPEN db_Insert_UPDATE_VENUE_TABLE 
FETCH NEXT FROM db_Insert_UPDATE_VENUE_TABLE INTO  @matchvenue, @matchlocation, @matchtype, @matchgender, @totalnofmatchesplayed, @matcheswonbybatting1stteam,@matcheswonbybatting2ndteam,@noresult

WHILE @@FETCH_STATUS = 0  
        BEGIN

        set @cntt2 = (select count(*)  FROM  CRICKET..venuedetails where venuename = @matchvenue and matchlocation = @matchlocation and matchtype = @matchtype and matchgender = @matchgender ) 

		if (@cntt2 = 0 )
                 Insert Into CRICKET..venuedetails (venuename,matchlocation, matchtype,matchgender, Noofmatchesplayed,Noofmatchesgotnoresult,Noofmatcheswonbybattingfirst, Noofmatcheswonbybattingsecond) 
				                            VALUES (@matchvenue, @matchlocation, @matchtype, @matchgender, @totalnofmatchesplayed,@noresult,@matcheswonbybatting1stteam, @matcheswonbybatting2ndteam )
		else 
		         update  CRICKET..venuedetails set Noofmatchesplayed = Noofmatchesplayed + @totalnofmatchesplayed,
				                                   Noofmatchesgotnoresult = Noofmatchesgotnoresult + @noresult ,
												   Noofmatcheswonbybattingfirst = Noofmatcheswonbybattingfirst + @matcheswonbybatting1stteam,
												   Noofmatcheswonbybattingsecond = Noofmatcheswonbybattingsecond + @matcheswonbybatting2ndteam
										       where venuename = @matchvenue and matchlocation = @matchlocation and matchtype = @matchtype and matchgender = @matchgender 


		FETCH NEXT FROM db_Insert_UPDATE_VENUE_TABLE INTO @matchvenue, @matchlocation, @matchtype, @matchgender, @totalnofmatchesplayed, @matcheswonbybatting1stteam,@matcheswonbybatting2ndteam,@noresult 
        END

CLOSE db_Insert_UPDATE_VENUE_TABLE;  
DEALLOCATE db_Insert_UPDATE_VENUE_TABLE; 


-- updating or inserting the details in the Cricket..cricketplayingnations
DECLARE @countryname varchar(255)
DECLARE @noofmatchesplayed INT
DECLARE @noofmatcheswon INT
DECLARE @nooftosswon  INT
DECLARE @noofmatcheslost INT
DECLARE @NOOFRESULTmatches INT
DECLARE @cntt3 INT

DECLARE db_Insert_UPDATE_CRICKET_PLAYING_NATIONS_TABLE CURSOR FOR  
                         select distinct team1 from #temp 
						 union 
						 select distinct team2 from #temp 

OPEN db_Insert_UPDATE_CRICKET_PLAYING_NATIONS_TABLE 
FETCH NEXT FROM db_Insert_UPDATE_CRICKET_PLAYING_NATIONS_TABLE INTO @countryname

WHILE @@FETCH_STATUS = 0  
        BEGIN
        
		SET @noofmatchesplayed = ( select count(*) from #temp where marchbetween like '%'+ @countryname + '%' ) 		
		SET @nooftosswon =    (select count(*) from #temp where tosswonby = @countryname)
		SET @noofmatcheswon = (select count(*) from #temp where matchwinner = @countryname)
		SET @NOOFRESULTmatches = ( select count(*) from #temp where marchbetween like '%'+ @countryname + '%' and scenario = 'NR')
		SET @noofmatcheslost = @noofmatchesplayed - @noofmatcheswon - @NOOFRESULTmatches

		set @cntt3 = (select count(*) from Cricket..cricketplayingnations where countryname = @countryname)

		if (@cntt3 = 0)
		 INSERT INTO Cricket..cricketplayingnations(countryname,noofmatchesplayed,nooftosswon,noofmatcheswon,noofmatcheslost,Noresultmatches) 
		 VALUES(@countryname,@noofmatchesplayed,@nooftosswon,@noofmatcheswon,@noofmatcheslost,@NOOFRESULTmatches)
		
		else 

			UPDATE Cricket..cricketplayingnations set noofmatchesplayed = noofmatchesplayed + @noofmatchesplayed,
													  nooftosswon = nooftosswon + @nooftosswon,
													  noofmatcheswon = noofmatcheswon + @noofmatcheswon,
													  noofmatcheslost = noofmatcheslost + @noofmatcheslost,
													  Noresultmatches = Noresultmatches + @NOOFRESULTmatches
												where countryname = @countryname

FETCH NEXT FROM db_Insert_UPDATE_CRICKET_PLAYING_NATIONS_TABLE INTO @countryname
END

CLOSE db_Insert_UPDATE_CRICKET_PLAYING_NATIONS_TABLE;  
DEALLOCATE db_Insert_UPDATE_CRICKET_PLAYING_NATIONS_TABLE;
 
DROP table #temp
GO
