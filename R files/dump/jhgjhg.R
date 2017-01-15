###  match team batting summary  #### fetching players first

inningsnum <- data.frame( c(1,2), c("1st", "2nd"))
names(inningsnum) <- c("rowid", "innings")

for (k in 1: dim(inningsnum)[2])
  
{
  innings1stor2nd <-  data.frame(inningsnum[k,])
  names(innings1stor2nd) <- c("rowid", "innings")
  
  print( paste(" Fetching the details of ",  innings1stor2nd[1,2]))
  ## selecting the players who played the match
  
  playersact <- cricketcsfnltestt3[which((cricketcsfnltestt3$type4 == "batsman" | cricketcsfnltestt3$type4 == "non_striker" ) & cricketcsfnltestt3$meta == innings1stor2nd[1,2]),]
  playersactwhobatted <- sqldf(" select distinct (`1stinningsinfo`) from playersact ")
  
  print("players who have played the match")
  playersactwhobatted
  
  ## splitting the datset based on the innings
  
  print("Splitting the dataset based on innings")
  cricketcsfnltestt4 <- subset(cricketcsfnltestt3, cricketcsfnltestt3$meta == innings1stor2nd[1,2])
  
  ### fetching the only balls/overs played by all players
  
  print("fetching the only balls/overs played by all players")
  oversact <-   sqldf(" select * from cricketcsfnltestt4 c  where c.type4  = 'batsman' ")
  
  ### looping through each player for getting the batting details
  print("entered the looping for fetching  each player batting details")
  
  if ( dim(oversact)[1] != 0)
  {
    
    
    for (i in 1:dim(playersactwhobatted)[1])
    {
      countof4s <- 0
      countof6s <- 0 
      wideballsplayed <- 0
      noballsplayed <- 0
      
      playername <- as.character( playersactwhobatted[i,1])                 ## converting the player name field to the charecter
      print(playername)                                                     ## printing the player name 
      
      oversactt1 <- subset(oversact, `1stinningsinfo` == playername )        ## fetching the overs played by each batsman
      oversactt2 <- data.frame(oversactt1[,10])                             ## fetching only the overs column
      names(oversactt2) <- c("oversplayed")                                 ## naming the column
      
      ## fetching the runs scpred by each player
      runscored <- sqldf(" select  case when sum(c.`1stinningsinfo`) is Null then 0 else sum(c.`1stinningsinfo`) end from cricketcsfnltestt4 c
                         where  c.type4 = 'runs'  and c.type5 = 'batsman'      and 
                         c.overs in ( select oversplayed  from oversactt2) ")  
      
      ## fetching all the over details for each player
      alldetails <- sqldf(" select * from cricketcsfnltestt4 c where  c.overs in ( select oversplayed  from oversactt2) ")
      
      ## fetching the wicket details for each player
      wicketdetails <- paste( "b", alldetails[which(alldetails$overs == alldetails[which(alldetails$type4 == "wicket" & alldetails$type5 == "player_out"),10] & alldetails$type4 == "bowler"),8],
                              alldetails[which(alldetails$type4 == "wicket" & alldetails$type5 == "fielders"),8], 
                              alldetails[which(alldetails$type4 == "wicket" & alldetails$type5 == "kind"),8] )
      
      
      ## fetching the count of 4s, 6s balls played,
      for (j in 1: dim(oversactt2))
      {
        over <- as.character(oversactt2[j,1])
        detailsact <- subset(alldetails, overs == over)  
        
        countof4s <- countof4s + sqldf("select count(*) from detailsact where `1stinningsinfo` = 4  and type4 = 'runs' and type5 = 'batsman' ")
        countof6s <- countof6s + sqldf("select count(*) from detailsact where `1stinningsinfo` = 6  and type4 = 'runs' and type5 = 'batsman' ")
        wideballsplayed <- wideballsplayed + sqldf("select count(*) from detailsact where `1stinningsinfo` = 1 and type4 = 'wides' ")
        noballsplayed <-   noballsplayed +  sqldf("select count(*) from detailsact where `1stinningsinfo` = 1 and type4 = 'noballs' ")
        
      }
      
      ballsplayed <- sqldf("select count(*) from oversactt2")
      if (ballsplayed > wideballsplayed)
      {
        totalballsplayed <- ballsplayed - wideballsplayed
      } else {
        totalballsplayed <- wideballsplayed -  ballsplayed
      }
      
      playerdetailstest <- data.frame (matchid, playername,runscored[1,1], totalballsplayed, countof4s, countof6s, wicketdetails) 
      playerdetails <- rbind(playerdetails, playerdetailstest)
      
      
    } 
    
    print("Innings change")
  }
}



################################################################################################################################################################

print("fetching bowling summary ")

for (k in 1: dim(inningsnum)[2])
{
  
  innings1stor2nd <-  data.frame(inningsnum[k,])
  names(innings1stor2nd) <- c("rowid", "innings")
  
  print( paste(" Fetching the details of ",  innings1stor2nd[1,2],  " Innings"))
  print(" selecting bowlers who bowled for the match")
  
  print("Splitting the dataset based on innings")
  details <- cricketcsfnltestt3[which(cricketcsfnltestt3$meta == innings1stor2nd[1,2]),]
  
  bowlersact <- cricketcsfnltestt3[which(cricketcsfnltestt3$type4 == "bowler"   & cricketcsfnltestt3$meta == innings1stor2nd[1,2]),]
  bowlersactwhobowled <- sqldf(" select distinct (`1stinningsinfo`) as bowlers, count(*) as ballsbowled from bowlersact  group by `1stinningsinfo`")
  head(bowlersactwhobowled)
  
  legbyeovers <- subset(details, ( (details$type4 == "legbyes" | details$type4 == "byes") & (details$`1stinningsinfo` == 1) ) )
  legbyeovers <- legbyeovers[10]
  
  print("checking if there are any bowlers for the match")
  if(dim(bowlersactwhobowled)[1] != 0)  # checking if there are any bowlers for the match
  {
    print("looping through each bowler ")
    for (j in 1: dim(bowlersactwhobowled)[1])   #print("looping through each bowler ")
      
    {
      countof4s <- 0
      countof6s <- 0
      widesbowled <- 0
      noballsbowled <- 0
      dotballsbowled <- 0
      wicketstaken <- 0
      legbyes <- 0
      
      print(bowlersactwhobowled[j,1])
      bowlername <- bowlersactwhobowled[j,1]
      
      totalballsbowled <- bowlersactwhobowled[j,2]
      
      print(" fetched all balls bowled by the selected bowler")
      ballsbowled <- subset(bowlersact, bowlersact$`1stinningsinfo` == bowlername) # fetched all balls bowled by the selected bowler
      
      ballsbowledwithoutlegbyes <- sqldf(" select * from ballsbowled b outer join legbyeovers l on ")
      runsgiven <- sqldf(" select sum(d.`1stinningsinfo`) from details d inner join ballsbowled b on d.overs = b.overs ")
      
      print(" loop through each ball bowled by the selected bowler")
      for (a in 1: dim(ballsbowled)[1])                                             #loop through each ball bowled by the selected bowler
      {
        balldetails <- subset(details, details$overs == ballsbowled[a,10] )
        widesbowled <- widesbowled + sqldf("select count(*) from balldetails where `1stinningsinfo` = 1 and type4 = 'wides' ")
        noballsbowled <-   noballsbowled +  sqldf("select count(*) from balldetails where `1stinningsinfo` = 1 and type4 = 'noballs' ")
        countof4s <- countof4s + sqldf("select count(*) from balldetails where `1stinningsinfo` = 4  and type4 = 'runs' and type5 = 'batsman' ")
        countof6s <- countof6s + sqldf("select count(*) from balldetails where `1stinningsinfo` = 6  and type4 = 'runs' and type5 = 'batsman' ")
        wicketstaken <- wicketstaken + sqldf("select count(*) from balldetails where type4 = 'wicket' and type5 = 'kind' and `1stinningsinfo` in ('caught', 'bowled','lbw','stumped','hit wicket', 'hitwicket') ")
        legbyes <- legbyes + sqldf("select count(*) from balldetails where type4 in ('legbyes','byes') and `1stinningsinfo` = 1")
        dotballsbowled <- dotballsbowled + sqldf(" select count(*) from balldetails where type5 = 'total' and `1stinningsinfo` = 0")
      }
      
      totalballsbowled1 <- (totalballsbowled - widesbowled - noballsbowled)/6
      whole <- floor(totalballsbowled1)    
      fraction <- (totalballsbowled1 - whole)* 0.6
      totaloversbowled <- whole + fraction 
      dotballsbowled <- dotballsbowled + legbyes
      economyrate    <-   (runsgiven/totalballsbowled1)
      
      bowlingsummarytest <- data.frame (matchid, bowlername,totalballsbowled,totaloversbowled,runsgiven, wicketstaken,dotballsbowled,economyrate, widesbowled,noballsbowled,countof6s, countof4s) 
      names(bowlingsummary) <- c("matchid","bowlername","numberofballsbowled", "totaloversbowled","runsgiven","wicketstaken", "dotballsbowled",  "economyrate","widesbowled","noballsbowled", "countof6sgiven", "countof4sgiven")
      
      bowlingsummary <- rbind(bowlingsummary, bowlingsummarytest)
      
      
    }
    
  }
  
}
