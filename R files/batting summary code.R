
#######################################################
loadingpath <- "A:/ADBMS/Project/Datafiles/csv/t20s/Loop1/"
file.names <- dir(loadingpath, pattern =".xlsx")

print("Fetching batting summary details")
print("Looping through all the files")

for(i in 1:length(file.names))
{
  print(paste ("Fetching the file ", file.names[i], sep =""))
  
          filepath <- paste("A:/ADBMS/Project/Datafiles/csv/t20s/Loop1/",file.names[i],sep = "")
          print(filepath)
  
          cricketcsfnl <- read.xlsx(filepath, sheetIndex = 1)
  
          cricketcsfnltest<- cricketcsfnl
          dim(cricketcsfnltest)

##### 1st transformation Aim : transforming rows and columns,  converting to data frame from matrix, adding names
  
          print(" 1st Transformation started")
  
          cricketcsfnltestt1 <- t(cricketcsfnltest)
          dim(cricketcsfnltestt1)
          cricketcsfnltestt1 <- data.frame(cricketcsfnltestt1)
  
          names <- rownames(cricketcsfnltestt1)
          rownames(cricketcsfnltestt1) <- NULL
          cricketcsfnltestt1 <- cbind(names,cricketcsfnltestt1)
  
          colnames(cricketcsfnltestt1, do.NULL = TRUE, prefix = "col")
          colnames(cricketcsfnltestt1) <- c("desc","1stinnings","2ndinnings")
  
          dim(cricketcsfnltestt1)
          cricketcsfnltestt1[3,1]
  
# 2nd transformation Aim : converting the desc data type from format to string
          print(" 2nd Transformation started")
  
          cricketcsfnltestt2 <- cricketcsfnltestt1
          cricketcsfnltestt2[,1] <- as.character(cricketcsfnltestt2[,1])
  
#3rd transformation : spliting the desc column
          print(" 3rd Transformation started")
  
          splitingdesc  <- separate(data = cricketcsfnltestt2, col = desc, into = c("C1", "C2","C3","C4","C5","c6","c7","c8"), sep = "\\.")
          cricketcsfnltestt3 <- cbind(cricketcsfnltestt2,splitingdesc)
  
          allovers <- data.frame(paste(cricketcsfnltestt3$C5,cricketcsfnltestt3$c6, sep = "."))
          cricketcsfnltestt3 <- cbind(cricketcsfnltestt3,allovers)
  
          cricketcsfnltestt3 <- cricketcsfnltestt3[,c(-2,-3,-8,-9)]
  
# naming the columns appropriately 
  
          names(cricketcsfnltestt3)<- c("desc","type1","meta","type2","type3","type4","type5","1stinningsinfo","2ndinningsinfo","overs")
          head(cricketcsfnltestt3)
  
####################### selecting the teams
  
          cricketcsfnltestt3$`1stinningsinfo` <- as.character(cricketcsfnltestt3$`1stinningsinfo`)
          cricketcsfnltestt3$`2ndinningsinfo` <- as.character(cricketcsfnltestt3$`2ndinningsinfo`)
  
### fetching the match details
  
  matchid                      <-  matchid +1
  matchdateindex               <-  which(cricketcsfnltestt3$meta == "dates")
  matchesbetweenindex          <-  which(cricketcsfnltestt3$meta == "teams")
  matchtypeindex               <-  which(cricketcsfnltestt3$meta == "match_type")
  matchgenderindex             <-  which(cricketcsfnltestt3$meta == "gender")
  matchwinnerindex             <-  which(cricketcsfnltestt3$meta == "outcome" & cricketcsfnltestt3$type2 == "winner")
  playerofmatchindex           <-  which(cricketcsfnltestt3$meta == "player_of_match")
  tosswonbyindex               <-  which(cricketcsfnltestt3$meta == "toss" & cricketcsfnltestt3$type2 == "winner")
  tosswinnerdecisionindex      <-  which(cricketcsfnltestt3$meta == "toss" & cricketcsfnltestt3$type2 == "decision")
  umpiresformatchindex         <-  which(cricketcsfnltestt3$meta == "umpires")
  matchlocationnumindex        <-  which(cricketcsfnltestt3$meta == "city")
  matchvenueindex              <-  which(cricketcsfnltestt3$meta == "venue")
  

  if (  is.na(matchlocationnumindex[1]) )
  {
    matchlocation <- NA
  } else {
    matchlocation <- cricketcsfnltestt3[matchlocationnum,8]
  } 
  
  if (is.na(matchwinnerindex[1]))
  {
    matchwinner <- "No Result"
  } else {
    matchwinner <- cricketcsfnltestt3[matchwinnerindex,8]
  }
  
  if (is.na(playerofmatchindex[1]))
  {
    playerofmatch <- NA
  } else {
    playerofmatch <- cricketcsfnltestt3[playerofmatchindex,8]
  }
    
    
    matchestest <- data.frame( matchid, 
                             cricketcsfnltestt3[matchdateindex,8],
                             paste( cricketcsfnltestt3[matchesbetweenindex,8] ,"vs", cricketcsfnltestt3[matchesbetweenindex,9] ),
                             cricketcsfnltestt3[matchtypeindex,8],
                             cricketcsfnltestt3[matchgenderindex,8],
                             matchwinner,
                             playerofmatch,
                             cricketcsfnltestt3[tosswonby,8],
                             cricketcsfnltestt3[tosswinnerdecision,8],
                             paste( cricketcsfnltestt3[umpiresformatch,8] ,"vs", cricketcsfnltestt3[umpiresformatch,9]),
                             matchlocation,
                             cricketcsfnltestt3[matchvenueindex,8]
                           )
  
  names(matchestest) <- c("Match Id","matchdate", "matchbetween","matchtype","matchgender","matchwinner","playerofmatch","tosswonby","tosswinnerdecision","umpiresformatch","matchlocation","matchvenue")
  matches <- rbind(matches, matchestest)
  
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
  
  file.remove(filepath)
  print("Match Change")
  
  
}






