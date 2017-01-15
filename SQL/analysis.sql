use cricket 

declare @team1 varchar(255)
set @team1 = 'India'

select MS.marchbetween, @team1 as interestedteam ,RTRIM(LTRIM(replace( replace(MS.marchbetween,@team1,''),'vs',''))) as opposition,
MS.matchwinner, MS.match_id, MS.matchgender,MS.matchvenue, MS.tosswonby,MS.tosswinnerdecision, 
RTRIM(LTRIM(replace( CASE when MS.tosswinnerdecision = 'bat' Then MS.tosswonby ELSE replace(MS.marchbetween,MS.tosswonby,'') END ,'vs',''))) as battingfirst,
MS.playerofmatch, 
CASE when MS.matchwinner = (Select distinct country from Cricket..batsmendetails where Match_Id = MS.match_id and innings = '1st') Then '1st' Else '2nd' End as battinginningsofmatchwinningteam,
CASE WHEN MS.matchwinner = (Select distinct country from Cricket..batsmendetails where Match_Id = MS.match_id and innings = '1st') Then '2nd' ELSE '1st' END as battinginningsofmatchlosingteam,
(select top(1) playername from Cricket..batsmendetails where Match_Id = MS.Match_Id and country = @team1 Order by runscored desc, ballsplayed asc) as HSplayername,
(select top(1) runscored from Cricket..batsmendetails where Match_Id = MS.Match_Id and country = @team1 Order by runscored desc, ballsplayed asc) as Hscore,
(select count(*) from Cricket..batsmendetails where Match_Id = MS.Match_Id and country = @team1 and wicketdetails != 'Not Out' ) as totalwicketslost,
(select sum(runsscored) from cricket..fallofwickets where Match_Id = MS.Match_Id and innings in (select distinct innings from Cricket..batsmendetails where Match_Id = MS.Match_Id and country = @team1  )) as totalrunsscored,
(select sum(runsscored) from cricket..fallofwickets where Match_Id = MS.Match_Id and innings in (select distinct innings from Cricket..batsmendetails where Match_Id = MS.Match_Id and country = @team1  ) and wicket in ('1st','2nd','3rd','4th','5th')) as Toorderpartnershipruns,
(select top(1) wicket from cricket..fallofwickets where Match_Id = MS.Match_Id and innings in (select distinct innings from Cricket..batsmendetails where Match_Id = MS.Match_Id and country = @team1  ) order by runsscored desc) as Toppartnershipwicket,
(select max(runsscored)  from cricket..fallofwickets where Match_Id = MS.Match_Id and innings in (select distinct innings from Cricket..batsmendetails where Match_Id = MS.Match_Id and country = @team1  ) ) as Toppartnershipruns
into #temp
from Matchessummary MS
where marchbetween like '%'+@team1+'%' 
and matchwinner != 'No Result'
order by match_id


select * from #temp where totalwicketslost > 7 and matchwinner = 'India'
