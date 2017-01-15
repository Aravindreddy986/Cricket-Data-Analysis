create index IX_cricket_batsmendetails_matchid_innings on Cricket..batsmendetails(match_id,innings)

create index IX_cricket_batsmendetails on Cricket..batsmendetails(match_id,playername)

create index IX_cricket_fall_of_wickets on cricket..fallofwickets(match_id,innings)

create index IX_cricket_playerdetails on cricket..playerdetails(country,playername) 

create index IX_cricket_player_batting_details on cricket..playerbattingdetails(batsmenid,country)

create index IX_cricket_player_bowling_details on cricket..playerbowlingdetails (bowlerid,country)
