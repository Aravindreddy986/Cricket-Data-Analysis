Select * from cricket..Matchessummary where marchbetween like '%New Zealand%' 
and matchwinner != 'No Result'

Select * from cricket..temporaryMatchessummary 

Select count(*) from cricket..Matchessummary 
Select count(*) from cricket..temporaryMatchessummary 
-----------------------------------------------------------------------------
DELETE FROM Cricket..umpires
Select * from Cricket..umpires 
SELECT sum(noofmatches) from Cricket..umpires

DELETE from Cricket..venuedetails
select * from Cricket..venuedetails
Select sum(noofmatchesplayed)  from Cricket..venuedetails 

DELETE from Cricket..cricketplayingnations 
Select * from Cricket..cricketplayingnations 
Select sum(noofmatchesplayed)  from Cricket..cricketplayingnations
-------------------------------------------------------------------------------
Select * from Cricket..batsmendetails
Select * from Cricket..temporarybatsmendetails  

Select count(*) from Cricket..batsmendetails
Select count(*) from Cricket..temporarybatsmendetails

------------------------------------------------------------------------------
Select * from Cricket..bowlingsummary 
Select * from Cricket..temporarybowlingsummary

Select count(*) from Cricket..bowlingsummary 
Select count(*) from Cricket..temporarybowlingsummary 
------------------------------------------------------------------------------
Select *from cricket..playerdetails order by country, playername

select * from cricket..playerbattingdetails 
select * from cricket..playerbowlingdetails

---------------------------------------------------------------------------------
Select * from cricket..fallofwickets
Select * from cricket..temporaryfallofwickets

Select count(*) from cricket..fallofwickets
Select count(*) from cricket..temporaryfallofwickets

select distinct wicket from cricket..fallofwickets
-----------------------------------------------------------------

