
cricketcsfnl <- read.xlsx("A:/ADBMS/Project/Datafiles/csv/t20s/match211028.xlsx", sheetIndex = 1)

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
  
  write.xlsx(cricketcsfnltestt3, "A:/cricketcsfnltestt3.xlsx")
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
  
  
  matchestest <- data.frame( matchid, 
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
  
  names(matchestest) <- c("Match Id","matchdate", "matchbetween","matchtype","matchgender","matchwinner","playerofmatch","tosswonby","tosswinnerdecision","umpiresformatch","matchlocation","matchvenue")
  matches <- rbind(matches, matchestest)
  
  inningsnum <- data.frame( c(1,2), c("1st", "2nd"))
  names(inningsnum) <- c("rowid", "innings")
  
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
    
    legbyesovers <- sqldf("select overs from details where type4 in ('byes','legbyes') and `1stinningsinfo` = 1 ")
    
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
        
        bowlingsummarytest <- data.frame (matchid, bowlername,totalballsbowled,totaloversbowled,runsgiven, wicketstaken,dotballsbowled,economyrate, widesbowled,noballsbowled,countof6s, countof4s) 
        
        bowlingsummary <- rbind(bowlingsummary, bowlingsummarytest)
        
        
      }
      
    }
    
  }






