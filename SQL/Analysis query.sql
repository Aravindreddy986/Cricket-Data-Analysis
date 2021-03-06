USE CRICKET
GO
create function analysis(@team1 varchar(255))
RETURNS @analysis Table(matchbetween varchar(255), result varchar(10),interestedteamname varchar(255),opposition varchar(255), matchwinner varchar(255), matchgender varchar(255), matchvenue varchar(255),
tosswonby varchar(255), tosswinnerdecision varchar(255),interestedteambattinginnings varchar(10), playerofmatch varchar(255), totalrunsscored int, highestscore int, totalwicketlost int, toporderpartnership int, toppartnershipwicket varchar(10), toppartnershipruns int)
As
 
BEGIN
Insert into @analysis
                   select MS.marchbetween,
				            CASE WHEN MS.matchwinner = @team1 Then 'won' Else 'lost' end as result,  
							 @team1 as interestedteam , 
					         RTRIM(LTRIM(replace( replace(MS.marchbetween,@team1,''),'vs',''))) as opposition,
                             MS.matchwinner, MS.matchgender,MS.matchvenue, MS.tosswonby,MS.tosswinnerdecision, 
                             CASE WHEN RTRIM(LTRIM(replace( CASE when MS.tosswinnerdecision = 'bat' Then MS.tosswonby ELSE replace(MS.marchbetween,MS.tosswonby,'') END ,'vs',''))) = @team1 THEN '1st' ELSE '2nd' END  as interestedteambattinginnings,
                             MS.playerofmatch, 
                             (select sum(runsscored) from cricket..fallofwickets where Match_Id = MS.Match_Id and innings in (select distinct innings from Cricket..batsmendetails where Match_Id = MS.Match_Id and country = @team1  )) as totalrunsscored,
                             (select top(1) runscored from Cricket..batsmendetails where Match_Id = MS.Match_Id and country = @team1 Order by runscored desc, ballsplayed asc) as Hscore,
                             (select count(*) from Cricket..batsmendetails where Match_Id = MS.Match_Id and country = @team1 and wicketdetails != 'Not Out' ) as totalwicketslost,
                             (select sum(runsscored) from cricket..fallofwickets where Match_Id = MS.Match_Id and innings in (select distinct innings from Cricket..batsmendetails where Match_Id = MS.Match_Id and country = @team1  ) and wicket in ('1st','2nd','3rd','4th','5th')) as Toorderpartnershipruns,
                             (select top(1) wicket from cricket..fallofwickets where Match_Id = MS.Match_Id and innings in (select distinct innings from Cricket..batsmendetails where Match_Id = MS.Match_Id and country = @team1  ) order by runsscored desc) as Toppartnershipwicket,
                             (select max(runsscored)  from cricket..fallofwickets where Match_Id = MS.Match_Id and innings in (select distinct innings from Cricket..batsmendetails where Match_Id = MS.Match_Id and country = @team1  ) ) as Toppartnershipruns

					from cricket..Matchessummary MS
					where marchbetween like '%'+@team1+'%' 
					and matchwinner != 'No Result'
					order by match_id

RETURN;
END;


