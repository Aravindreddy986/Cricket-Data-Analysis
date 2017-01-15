
Declare @team1 varchar(255)
DECLARE @team2 varchar(255)

DECLARE @match_id int

DECLARE db_rectifying CURSOR FOR  
            SELECT distinct match_id from Cricket..temporarybowlingsummary
           
                    
OPEN db_rectifying
FETCH NEXT FROM db_rectifying INTO @match_id
    
	 WHILE @@FETCH_STATUS = 0  
        BEGIN

		set @team1 = (select distinct country from Cricket..temporarybowlingsummary  where match_id = @match_id and innings = '1st' )
        set @team2 = (Select distinct country from Cricket..temporarybowlingsummary where match_id = @match_id and innings = '2nd' )

		Update Cricket..temporarybowlingsummary  set country = @team2 where  match_id = @match_id and innings = '1st'
		Update Cricket..temporarybowlingsummary  set country = @team1 where  match_id = @match_id and innings = '2nd'
        
		FETCH NEXT FROM db_rectifying INTO @match_id
        END

CLOSE db_rectifying;  
DEALLOCATE db_rectifying;  

-- match id's 253 Ireland vs West Indies
Update Cricket..temporarybowlingsummary  set country = 'West Indies' where  match_id = 253 and innings = '1st'

--322  - England vs New Zealand
Update Cricket..temporarybowlingsummary  set country = 'New Zealand' where  match_id = 322 and innings = '1st'

-- 467 West Indies vs Bangladesh

Update Cricket..temporarybowlingsummary  set country = 'West Indies' where  match_id = 467 and innings = '1st'

--581  Bangladesh vs Ireland

Update Cricket..temporarybowlingsummary  set country = 'Ireland' where  match_id = 581 and innings = '1st'
