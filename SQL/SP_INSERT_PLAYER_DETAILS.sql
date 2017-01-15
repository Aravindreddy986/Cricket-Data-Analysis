USE CRICKET 
GO

CREATE PROCEDURE INSERT_PLAYER_DETAILS
AS

--- fetching the details from the temporarybatsmendetails and temporarybowlingsummary

Select Match_Id,country,playername into #temp from Cricket..temporarybatsmendetails
Insert into #temp 
Select Match_Id,country,bowlername  from Cricket..temporarybowlingsummary 

--- declaring the cursor
DECLARE @PREVCNT int
DECLARE @country varchar(255)
DECLARE @playername varchar(255)
DECLARE @matchescnt int

DECLARE db_Insert_PLAYER_DETAILS CURSOR FOR  
        select country, playername, count(distinct match_id) from #temp
        group by country, playername
        order by country, playername 
 
OPEN db_Insert_PLAYER_DETAILS
FETCH NEXT FROM db_Insert_PLAYER_DETAILS INTO @country,@playername,@matchescnt

    WHILE @@FETCH_STATUS = 0  
        BEGIN

        set @PREVCNT = (Select count(*) from cricket..playerdetails where country = @country and playername = @playername ) 

		if (@PREVCNT = 0 )
                 Insert Into cricket..playerdetails (playername,Country,noofmatchesplayed) VALUES(@playername,@country, @matchescnt)
		else 
		         update  cricket..playerdetails set noofmatchesplayed = @matchescnt + noofmatchesplayed where country = @country and playername = @playername 

		FETCH NEXT FROM db_Insert_PLAYER_DETAILS INTO @country,@playername,@matchescnt 
        END

CLOSE db_Insert_PLAYER_DETAILS;  
DEALLOCATE db_Insert_PLAYER_DETAILS; 

-- insert or updating the details in the cricket..playerbattingdetails
Declare @tempcnt int
Declare @playername1 varchar(255)
declare @country1 varchar(255)
declare @batsmenid int
declare @notouts int
declare @noofmatchesplayed int
declare @totalrunscored int
declare @totalballsplayed int
declare @highestscore int 
declare @noof4s int
declare @noof6s int

DECLARE db_Insert_PLAYER_BATTING_DETAILS CURSOR FOR  
         Select   tbd.playername,tbd.country, 
				 batsmenid = (select playerid from cricket..playerdetails pd where pd.Country = tbd.country and pd.playername = tbd.playername ),
				 noofouts =  (select count(*) from Cricket..temporarybatsmendetails tpd1 where tpd1.Country = tbd.country and tpd1.playername = tbd.playername and tpd1.wicketdetails like '%Not Out%' ),
				 count(distinct tbd.match_id) as noofmatchesplayed ,sum(tbd.runscored) as totalrunscored , 
				 sum(tbd.ballsplayed) as totalballsplayed , max(tbd.runscored) as highestscore,
				 sum(tbd.countof4s) as noof4s, sum(tbd.countof6s) as noof6s
         from Cricket..temporarybatsmendetails tbd
         group by tbd.playername,tbd.country
         order by tbd.playername,tbd.country

OPEN db_Insert_PLAYER_BATTING_DETAILS
FETCH NEXT FROM db_Insert_PLAYER_BATTING_DETAILS INTO @playername1,@country1, @batsmenid,@notouts,@noofmatchesplayed,@totalrunscored,@totalballsplayed,@highestscore,@noof4s,@noof6s

WHILE @@FETCH_STATUS = 0  
        BEGIN

        set @tempcnt = (Select count(*) from cricket..playerbattingdetails where batsmenid= @batsmenid and country = @country1 and batsmenname = @playername1 ) 

		if (@tempcnt = 0 )
                 Insert Into cricket..playerbattingdetails VALUES(@batsmenid, @playername1,@country1,@noofmatchesplayed,@notouts,@noof4s,@noof6s,@totalrunscored,@totalballsplayed,@highestscore)
		else 
		         update  cricket..playerbattingdetails 
				 set noofinningsplayed = @noofmatchesplayed + noofinningsplayed,
				     noofnotouts = @notouts + noofnotouts,
					 noof4s = @noof4s + noof4s,
					 noof6s = @noof6s + noof6s,
					 totalnoofruns = @totalrunscored + totalnoofruns,
					 totalballsplayed = @totalballsplayed + totalballsplayed,
					 highestscore = @highestscore + highestscore
				                                           
				 where batsmenid= @batsmenid and country = @country1 and batsmenname = @playername1 

		FETCH NEXT FROM db_Insert_PLAYER_BATTING_DETAILS INTO @playername1,@country1, @batsmenid,@notouts,@noofmatchesplayed,@totalrunscored,@totalballsplayed,@highestscore,@noof4s,@noof6s
        END

CLOSE db_Insert_PLAYER_BATTING_DETAILS;  
DEALLOCATE db_Insert_PLAYER_BATTING_DETAILS; 

-- insert or updating the details in the cricket..playerbattingdetails
Declare @tempcnt2 int
declare @bowlerid int
Declare @bowlername varchar(255)
declare @country2 varchar(255)
declare @noofinningsbowled int
declare @totalballsbowled int
declare @totalrunsgiven int
declare @totalwicketstaken int
declare @totaldotballsbowled int
declare @totalwidesbowled int 
declare @totalnoballsbowled int
declare @totalcountof4sgiven int
declare @totalcountof6sgiven int

DECLARE db_Insert_PLAYER_BOWLING_DETAILS CURSOR FOR  
         Select   bowlerid = (select playerid from cricket..playerdetails pd where pd.Country = tbs.country and pd.playername = tbs.bowlername),
				 tbs.bowlername,tbs.country, 
		         count(distinct tbs.match_id) as noofinningsbowled ,
				 sum(tbs.totalballsbowled) as totalballsbowled , 
				 sum(tbs.runsgiven) as totalrunsgiven,
				 sum(tbs.wicketstaken)  as totalwicketstaken,
				 sum(tbs.dotballsbowled) as totaldotballsbowled,
				 sum(tbs.widesbowled) as totalwidesbowled,
				 sum(tbs.noballsbowled) as totalnoballsbowled,
				 sum(tbs.countof4sgiven) as total4sgiven,
				 sum(tbs.countof6sgiven) as totalcountof6sgiven

       from Cricket..temporarybowlingsummary tbs
         group by tbs.bowlername,tbs.country
         order by tbs.bowlername,tbs.country

OPEN db_Insert_PLAYER_BOWLING_DETAILS

FETCH NEXT FROM db_Insert_PLAYER_BOWLING_DETAILS INTO @bowlerid,@bowlername,@country2, @noofinningsbowled, @totalballsbowled,@totalrunsgiven,@totalwicketstaken,@totaldotballsbowled,@totalwidesbowled,@totalnoballsbowled,@totalcountof4sgiven,@totalcountof6sgiven
WHILE @@FETCH_STATUS = 0  
        BEGIN

        set @tempcnt2 = (Select count(*) from cricket..playerbowlingdetails where bowlerid= @bowlerid and country = @country2 and bowlername = @playername ) 

		if (@tempcnt2 = 0 )
                 Insert Into cricket..playerbowlingdetails VALUES(@bowlerid,@bowlername,@country2, @noofinningsbowled, @totalballsbowled,@totalrunsgiven,@totalwicketstaken,@totaldotballsbowled,@totalwidesbowled,@totalnoballsbowled,@totalcountof4sgiven,@totalcountof6sgiven)
	    else 
		 update cricket..playerbowlingdetails set   noofinningbowled = @noofinningsbowled + noofinningbowled,
													totalballsbowled = @totalballsbowled + totalballsbowled,
													totalrunsgiven   =  @totalrunsgiven + totalrunsgiven,
													totalwicketstaken =  @totalwicketstaken  + totalwicketstaken,
													totaldotballsbowled = @totaldotballsbowled + totaldotballsbowled,
													totalwidesbowled = @totalwidesbowled + totalwidesbowled,
													totalnoballsbowled = @totalnoballsbowled+ totalnoballsbowled, 
													totalcountof4sgiven = @totalcountof4sgiven + totalcountof4sgiven,
													totalcountof6sgiven = @totalcountof6sgiven + totalcountof6sgiven 


		 where bowlerid= @bowlerid and country = @country2 and bowlername = @playername

		FETCH NEXT FROM db_Insert_PLAYER_BOWLING_DETAILS INTO @bowlerid,@bowlername,@country2, @noofinningsbowled, @totalballsbowled,@totalrunsgiven,@totalwicketstaken,@totaldotballsbowled,@totalwidesbowled,@totalnoballsbowled,@totalcountof4sgiven,@totalcountof6sgiven
        END

CLOSE db_Insert_PLAYER_BOWLING_DETAILS;  
DEALLOCATE db_Insert_PLAYER_BOWLING_DETAILS; 

Drop Table #temp
