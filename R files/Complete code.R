processt20 <- function(){

  matchid <- 800
  
  playerdetails <- data.frame() 
  bowlingsummary <- data.frame()
  matches <- data.frame()
  fallofwickets <- data.frame( )
  
  playerdetailsfinal <- data.frame() 
  bowlingsummaryfinal <- data.frame()
  matchesfinal <- data.frame()
  fallofwicketsfinal <- data.frame()
  
  index <- c("1st","2nd","3rd","4th","5th","6th","7th","8th", "9th","10th")
  num <- c(1:10)
  wkt <- data.frame(num,index)
  
  #######################################################
  loadingpath <- "A:/ADBMS/Project/Datafiles/csv/T20/Source/"
  file.names <- dir(loadingpath, pattern =".xlsx")
  
  print("Fetching batting summary details")
  print("Looping through all the files")
  
  
  for(i in 1:length(file.names))
  {
    
    print(paste ("Fetching the file ", file.names[i], sep =""))
    print(paste("fetched at the timestamp", Sys.time()))
    
    filepath <- paste("A:/ADBMS/Project/Datafiles/csv/T20/Source/",file.names[i],sep = "")
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
    cricketcsfnltestt3$overs
    
    outputpath <- paste("A:/ADBMS/Project/Datafiles/csv/T20/output cleaned files/", file.names[i],sep = "")
    
    write.xlsx(cricketcsfnltestt3, outputpath)
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
      matchlocation <- cricketcsfnltestt3[matchlocationnumindex,8]
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
    
    
    matchestest <- data.frame(file.names[i], matchid, 
                              cricketcsfnltestt3[matchdateindex,8],
                              paste( cricketcsfnltestt3[matchesbetweenindex,8] ,"vs", cricketcsfnltestt3[matchesbetweenindex,9] ),
                              cricketcsfnltestt3[matchtypeindex,8],
                              cricketcsfnltestt3[matchgenderindex,8],
                              matchwinner,
                              playerofmatch,
                              cricketcsfnltestt3[tosswonbyindex,8],
                              cricketcsfnltestt3[tosswinnerdecisionindex,8],
                              paste( cricketcsfnltestt3[umpiresformatchindex,8] ,"vs", cricketcsfnltestt3[umpiresformatchindex,9]),
                              matchlocation,
                              cricketcsfnltestt3[matchvenueindex,8]
    )
    
    matches <- rbind(matches, matchestest)
    
    ###  match team batting summary  #### fetching players first
    
    inningsnum <- data.frame( c(1,2), c("1st", "2nd"))
    names(inningsnum) <- c("rowid", "innings")
    
    print(" enter the loop for each innings for fetching batting and bowling details ")
    
    for (k in 1: dim(inningsnum)[2])
    {
      
      innings1stor2nd <-  data.frame(inningsnum[k,])
      names(innings1stor2nd) <- c("rowid", "innings")
      
      print("Splitting the dataset based on innings")
      details <- cricketcsfnltestt3[which(cricketcsfnltestt3$meta == innings1stor2nd[1,2]),]
      
      print( paste(" Fetching the bowling details of ",  innings1stor2nd[1,2],  " Innings"))
      print(" selecting bowlers who bowled for the match")
      
      bowlersact <- cricketcsfnltestt3[which(cricketcsfnltestt3$type4 == "bowler"   & cricketcsfnltestt3$meta == innings1stor2nd[1,2]),]
      bowlersactwhobowled <- sqldf(" select distinct (`1stinningsinfo`) as bowlers, count(*) as ballsbowled from bowlersact  group by `1stinningsinfo`")
      
      country <- subset(details$`1stinningsinfo`, details$type3 == "team")
      battingcountry <- country
      
      if(battingcountry == cricketcsfnltestt3[matchesbetweenindex,8] )
      {
        bowlingcountry <- cricketcsfnltestt3[matchesbetweenindex,9]
      } else {
        bowlingcountry <- cricketcsfnltestt3[matchesbetweenindex,8]
      }
      
      legbyesovers <- sqldf("select overs from details where type4 in ('byes','legbyes') and `1stinningsinfo` = 1 ")
      
      print("checking if there are any bowlers for the match and loop each bowler")
      
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
          
          
          runsgiven <- sqldf(" select sum(d.`1stinningsinfo`) from details d where type5 = 'total' 
                             and d.overs in ( select b.overs from ballsbowled b where b.overs not in (select overs from legbyesovers ) )")
          
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
          
          bowlingsummarytest <- data.frame (matchid,bowlingcountry, innings1stor2nd[1,2], bowlername,totalballsbowled,totaloversbowled,runsgiven, wicketstaken,dotballsbowled,economyrate, widesbowled,noballsbowled,countof6s, countof4s) 
          
          bowlingsummary <- rbind(bowlingsummary, bowlingsummarytest)
          
          
        }
        
      }
      
      
      print( paste(" Fetching the batting summary of ",  innings1stor2nd[1,2]))
      print(" selecting batsmen who bowled for the match")
      
      playersact <- cricketcsfnltestt3[which((cricketcsfnltestt3$type4 == "batsman" | cricketcsfnltestt3$type4 == "non_striker" ) & cricketcsfnltestt3$meta == innings1stor2nd[1,2]),]
      playersactwhobatted <- sqldf(" select distinct (`1stinningsinfo`) from playersact ")
      
      print("fetching the only balls/overs played by all players")
      oversact <-   sqldf(" select * from details c  where c.type4  = 'batsman' ")
      
      print("entered the looping for fetching  each player batting details ")
      
      if ( dim(oversact)[1] != 0)
      {
        
        print("looping through each batsmen ")
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
          runscored <- sqldf(" select  case when sum(c.`1stinningsinfo`) is Null then 0 else sum(c.`1stinningsinfo`) end from details c
                             where  c.type4 = 'runs'  and c.type5 = 'batsman'      and 
                             c.overs in ( select oversplayed  from oversactt2) ")  
          
          ## fetching all the over details for each player
          alldetails <- sqldf(" select * from details c where  c.overs in ( select oversplayed  from oversactt2) ")
          
          wicketball <- subset(details, type4 == "wicket" & type5 == "player_out" & `1stinningsinfo` == playername )      
          
          if (dim(wicketball)[1] == 0)
          {
            wicketdetails <- "Not Out"
          }  else {
            
            ## fetching the wicket details for each player
            wicketdetails <- paste( "b", details[which(details$overs == wicketball[1,10] & details$type4 == "bowler"),8],
                                    details[which(details$type4 == "wicket" & details$type5 == "kind" & details$overs == wicketball[1,10]),8] ,
                                    details[which(details$type4 == "wicket" & details$type5 == "fielders" & details$overs == wicketball[1,10] ),8]
            )
          }
          
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
          
          playerdetailstest <- data.frame (matchid, innings1stor2nd[1,2],battingcountry, playername,runscored[1,1], totalballsplayed, countof4s, countof6s, wicketdetails) 
          playerdetails <- rbind(playerdetails, playerdetailstest)
          
          
        } 
      }
      
      print("fetching the partnership details")
      if ( dim(oversact)[1] != 0 & dim(bowlersactwhobowled)[1] != 0)
      {
        partnership <- data.frame()
        
        print("fetching only the wicket deliveries ")
        wicketballs <- subset(details, details$type4 == "wicket" & details$type5 == "player_out")
        
        if (dim(wicketballs)[1] == 0)
        {
          del <- 1
          wicketballs <- details[c(dim(details)[1]),]
          wicketballs$num <- 1
          wicketballs$overs <- as.numeric(as.character(wicketballs$overs))
          nowickets <- 1
        }else 
        {
          del <- dim(wicketballs)[1]
          wicketballs$num <- c(1:del)
          wicketballs$overs <- as.numeric(as.character(wicketballs$overs))
          nowickets <- 0
        }
        
        print("fetching the runs for each ball ")
        score <- subset(details, details$type5 == "total")
        score$`1stinningsinfo` <- as.numeric(score$`1stinningsinfo`)
        score$overs <- as.numeric(as.character(score$overs))
        
        print(" looping through each wicket ball for fetching runs scored between the partnerships")
        for (i in 1:del)
        {
          wicketball <- wicketballs[i,10]
          if (i == 1)
          {
            prevwicketball <- 0
          } else{
            prevwicketball <- wicketballs[i-1,10]
          }
          
          runs <- filter(score, overs <= wicketball & overs > prevwicketball ) %>%
            summarise(totalruns = sum(`1stinningsinfo`))
          
          total <- paste(i, filter(score, overs <= wicketball  ) %>%
                           summarise(totalruns = sum(`1stinningsinfo`)), sep = "-" )
          
          partnershiptest <- c(runs[1,1],total)
          
          partnershiptest <- data.frame(t(partnershiptest))
          partnership <- rbind(partnership,partnershiptest)
          
        }
        
        output <- inner_join(wicketballs,wkt, by="num") 
        print(" Fetching the details of final wicket partnership")
        
        if (wicketballs[dim(wicketballs)[1],10] != 19.6 & wicketballs[dim(wicketballs)[1],11] != 10 & nowickets == 0)
          
        {
          lastwicketball <- wicketballs[dim(wicketballs)[1],10] 
          finalballofinnings <- max(score$overs)
          
          runs <- filter(score, overs <= finalballofinnings & overs > lastwicketball ) %>%
            summarise(totalruns = sum(`1stinningsinfo`))
          
          total <- paste(dim(wicketballs)[1]+1, filter(score, overs <= finalballofinnings  ) %>%
                           summarise(totalruns = sum(`1stinningsinfo`)), sep = "-" )
          partnershiptest <- c(runs[1,1],total)
          partnershiptest <- data.frame(t(partnershiptest))
          partnership <- rbind(partnership,partnershiptest)  
          
          player1 <- details[which( details$type4 == "batsman" & details$overs == finalballofinnings),9]
          player2 <- details[which( details$type4 == "non_striker" & details$overs == finalballofinnings),9]
          players <- paste(player1,player2, sep="-")
          
          outputadd <- c(NA,"innings",as.character(innings1stor2nd[1,2]), NA,NA,NA,NA,players,players,finalballofinnings,dim(wicketballs)[1]+1)
          output <- rbind(output,outputadd)
        }
        
        fallofwicketstest <- output[,c(3,12,8,10)]
        fallofwicketstest$runs <- partnership[,1]
        fallofwicketstest$part <- partnership[,2]
        
        fallofwicketstest$runs <- as.integer( as.character(fallofwicketstest$runs))
        
        print(" formating the overs properly")
        fallofwicketstest$overs <- as.numeric(fallofwicketstest$overs)
        
        for (H in 1: dim(fallofwicketstest)[1])
        {
          over <- fallofwicketstest[H,4]
          
          if ( over - floor(over) >= 0.7)
          {
            fallofwicketstest[H,4] <- floor(over) + 0.6
          }
        }
        
        print("calculating runrate for each innings")
        for (d in 1: dim(fallofwicketstest)[1])
        {
          present <- fallofwicketstest[d,4]
          if (d == 1)
          {
            past <- as.numeric("0")
          } else{
            past <- as.numeric(fallofwicketstest[d-1,4])
          }
          
          B1 <- (floor(present) *6) + ((present - floor(present)) * 10)
          B2 <- (floor(past) *6) + ((past - floor(past)) * 10)
          floor( (B1 - B2)/6) 
          
          partnershipovers <- floor( (B1 - B2)/6) +  ( ( (B1 - B2) -  (floor( (B1 - B2)/6) * 6) )/ 10)
          partnershipruns <- fallofwicketstest[d,5]
          fallofwicketstest[d,7] <-  (partnershipruns * 6) / ( (as.integer(partnershipovers) * 6) +  ( 10 * ( partnershipovers - floor(partnershipovers )) ) )
          fallofwicketstest[d,8] <- partnershipovers
          
        }
        fallofwicketstest$match <- matchid
        fallofwickets <- rbind(fallofwickets,fallofwicketstest)
      }
      print("inningschange")  
      
    }
    
    print("match over")
    print(" check the files: playerdetails and bowlingsummary")
    print("removing the file")
    file.remove(filepath)
  }
  
  ## creating  files  in modified folder
  
  write.xlsx(playerdetails,"A:/ADBMS/Project/Datafiles/csv/T20/Modified files/playerdetails.xlsx", row.names = FALSE)
  write.xlsx(matches,"A:/ADBMS/Project/Datafiles/csv/T20/Modified files/matches.xlsx", row.names = FALSE)
  write.xlsx(bowlingsummary,"A:/ADBMS/Project/Datafiles/csv/T20/Modified files/bowlingsummary.xlsx", row.names = FALSE)
  write.xlsx(fallofwickets,"A:/ADBMS/Project/Datafiles/csv/T20/Modified files/fallofwickets.xlsx", row.names = FALSE)
  
  ##fetching the  files in final folder
  
  playerdetailsfinal    <-  read.xlsx("A:/ADBMS/Project/Datafiles/csv/T20/Final files/playerdetails.xlsx", sheetIndex = 1)
  bowlingsummaryfinal   <-  read.xlsx("A:/ADBMS/Project/Datafiles/csv/T20/Final files/bowlingsummary.xlsx", sheetIndex = 1)
  matchesfinal          <-  read.xlsx("A:/ADBMS/Project/Datafiles/csv/T20/Final files/matches.xlsx", sheetIndex = 1)
  fallofwicketsfinal    <-  read.xlsx("A:/ADBMS/Project/Datafiles/csv/T20/Final files/fallofwickets.xlsx", sheetIndex = 1)
  
  
  ###  updating final files data frames
  names(playerdetails)[3] <- "country"
  names(bowlingsummary)[2] <- "country"
  playerdetailsfinal    <- rbind(playerdetailsfinal, playerdetails)
  bowlingsummaryfinal   <- rbind(bowlingsummaryfinal,bowlingsummary)
  matchesfinal          <- rbind(matchesfinal, matches)
  names(fallofwickets)[3] <- "X1stinningsinfo"
  
  fallofwicketsfinal    <- rbind(fallofwicketsfinal, fallofwickets)
  
  
  write.xlsx(playerdetailsfinal,"A:/ADBMS/Project/Datafiles/csv/T20/Final files/playerdetails.xlsx", row.names = FALSE)
  write.xlsx(matchesfinal,"A:/ADBMS/Project/Datafiles/csv/T20/Final files/matches.xlsx", row.names = FALSE)
  write.xlsx(bowlingsummaryfinal,"A:/ADBMS/Project/Datafiles/csv/T20/Final files/bowlingsummary.xlsx", row.names = FALSE)
  write.xlsx(fallofwicketsfinal,"A:/ADBMS/Project/Datafiles/csv/T20/Final files/fallofwickets.xlsx", row.names = FALSE)
  
  
  ############# cleaning #################################
  
  names(playerdetails) <- c("matchid","innings", "playername","runscored","ballsplayed","countof4s","countof6s","wicketdetails")
  names(bowlingsummary) <- c("matchid","innings", "bowlername","totalballsbowled", "oversbowled","runsgiven","wicketstaken", "dotballsbowled",  "economyrate","widesbowled","noballsbowled", "countof6sgiven", "countof4sgiven")
  names(matches) <- c("filename", "Match Id","matchdate", "matchbetween","matchtype","matchgender","matchwinner","playerofmatch","tosswonby","tosswinnerdecision","umpiresformatch","matchlocation","matchvenue")
  
}


