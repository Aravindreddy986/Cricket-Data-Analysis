cricket <- yaml.load("A:/ADBMS/Project/Datafiles/yaml/t20s/loop1/951307.yaml" )
data <- data.frame(cricket, row.names = NULL,check.rows = FALSE, check.names = FALSE)

file.remove("A:/ADBMS/Project/Datafiles/yaml/t20s/loop2/430885.yaml")

######################################################################

playerrunstest <-data.frame()
playerruns <- data.frame()

for (i in 1:dim(playerswhobatted)[1])
{
  
  playername <- as.character( playerswhobatted[i,8])
  print(playername) 
  
  overs <-  sqldf("
                       select * from crickett3 c
                       where c.type1  = 'batsman' 
                                       
                  ")
  overs <- subset(overs, `1stinningsinfo` == playername)
  
  overst1 <- data.frame(overs[,5])
  names(overst1) <- c("oversplayed")
  
runscored <- sqldf("
                      select sum(c.`1stinningsinfo`) from crickett3 c
                      where c.Innings = '1st innings' and 
                      c.type1 = 'runs'         and
                      c. type2 = 'batsman'      and 
                      c. overs in ( select oversplayed  from overst1)
                   ")  
                                          
  playerrunstest <- data.frame( matchid, playername,runscored[1,1])
  playerruns <- rbind(playerruns, playerrunstest)
  
  ####  total balls played
  
  ballsplayed <- sqldf("
                        
                       ")
  
  
} 

#######################################################################


cricketcsvat <- read.xlsx("A:/ADBMS/Project/Datafiles/csv/t20s/match211048.xlsx", sheetIndex = 1)


cricketcsvattest<- cricketcsvat
dim(cricketcsvattest)

####### 1st transformation Aim : transforming rows and columns,  converting to data frame from matrix, adding names

cricketcsvattestt1 <- t(cricketcsvattest)
dim(cricketcsvattestt1)
cricketcsvattestt1 <- data.frame(cricketcsvattestt1)

names <- rownames(cricketcsvattestt1)
rownames(cricketcsvattestt1) <- NULL
cricketcsvattestt1 <- cbind(names,cricketcsvattestt1)

colnames(cricketcsvattestt1, do.NULL = TRUE, prefix = "col")
colnames(cricketcsvattestt1) <- c("desc","1stinnings","2ndinnings")

dim(cricketcsvattestt1)
cricketcsvattestt1[3,1]

# 2nd transformation Aim : converting the desc data type from format to string

cricketcsvattestt2 <- cricketcsvattestt1
cricketcsvattestt2[,1] <- as.character(cricketcsvattestt2[,1])

#3rd transformation : spliting the desc column

splitingdesc  <- separate(data = cricketcsvattestt2, col = desc, into = c("C1", "C2","C3","C4","C5","c6","c7","c8"), sep = "\\.")
cricketcsvattestt3 <- cbind(cricketcsvattestt2,splitingdesc)

allovers <- data.frame(paste(cricketcsvattestt3$C5,cricketcsvattestt3$c6, sep = "."))
cricketcsvattestt3 <- cbind(cricketcsvattestt3,allovers)

cricketcsvattestt3 <- cricketcsvattestt3[,c(-2,-3,-8,-9)]

# naming the columns appropriately 

names(cricketcsvattestt3)<- c("desc","type1","meta","type2","type3","type4","type5","1stinningsinfo","2ndinningsinfo","overs")
head(cricketcsvattestt3)


write.xlsx(crickett3, "A:/cricketcsvattestt4.xlsx")

####################### selecting the teams

cricketcsvattestt3$`1stinningsinfo` <- as.character(cricketcsvattestt3$`1stinningsinfo`)
cricketcsvattestt3$`2ndinningsinfo` <- as.character(cricketcsvattestt3$`2ndinningsinfo`)

### fetching the match details

matchid                 <-  matchid +1
matchdate               <-  which(cricketcsvattestt3$meta == "dates")
matchesbetweenindex     <-  which(cricketcsvattestt3$meta == "teams")
matchtype               <-  which(cricketcsvattestt3$meta == "match_type")
matchgender             <-  which(cricketcsvattestt3$meta == "gender")
matchwinner             <-  which(cricketcsvattestt3$meta == "outcome" & cricketcsvattestt3$type2 == "winner")
playerofmatch           <-  which(cricketcsvattestt3$meta == "player_of_match")
tosswonby               <-  which(cricketcsvattestt3$meta == "toss" & cricketcsvattestt3$type2 == "winner")
tosswinnerdecision      <-  which(cricketcsvattestt3$meta == "toss" & cricketcsvattestt3$type2 == "decision")
umpiresformatch         <-  which(cricketcsvattestt3$meta == "umpires")
matchlocation           <-  which(cricketcsvattestt3$meta == "city")
matchvenue              <-  which(cricketcsvattestt3$meta == "venue")



matchestest <- data.frame( matchid, 
                           cricketcsvattestt3[matchdate,8],
                           paste( cricketcsvattestt3[matchesbetweenindex,8] ,"vs", cricketcsvattestt3[matchesbetweenindex,9] ),
                           cricketcsvattestt3[matchtype,8],
                           cricketcsvattestt3[matchgender,8],
                           cricketcsvattestt3[matchwinner,8],
                           cricketcsvattestt3[playerofmatch,8],
                           cricketcsvattestt3[tosswonby,8],
                           cricketcsvattestt3[tosswinnerdecision,8] ,
                           paste( cricketcsvattestt3[umpiresformatch,8] ,"vs", cricketcsvattestt3[umpiresformatch,9] ),
                           cricketcsvattestt3[matchlocation,8],
                           cricketcsvattestt3[matchvenue,8]
                           
                           )
names(matchestest) <- c("Match Id","matchdate", "matchbetween","matchtype","matchgender","matchwinner","playerofmatch","tosswonby","tosswinnerdecision","umpiresformatch","matchlocation","matchvenue")

matches <- rbind(matches, matchestest)


###  match 1st team batting summary
## fetching players who have batted first

playersact <- cricketcsvattestt3[which((cricketcsvattestt3$type4 == "batsman" | cricketcsvattestt3$type4 == "non_striker" ) & cricketcsvattestt3$meta =="1st"),]

playersactwhobatted <- sqldf(" select distinct (`1stinningsinfo`) from playersact ")
dim(playersactwhobatted)

### fetching the only balls/overs played by all players
oversact <-   sqldf("
                      select * from cricketcsvattestt3 c
                      where c.type4  = 'batsman' and c.meta = '1st'
                   ")
### looping through each player for getting the batting details

for (i in 1:dim(playersactwhobatted)[1])
{
  
  playername <- as.character( playersactwhobatted[i,1])                 ## converting the player name field to the charecter
  print(playername)                                                     ## printing the player name 
  
  oversactt1 <- subset(oversact, `1stinningsinfo` == "AJ Strauss")        ## fetching the overs played by each batsman
  oversactt2 <- data.frame(oversactt1[,10])                             ## fetching only the overs column
  names(oversactt2) <- c("oversplayed")                                 ## naming the column
  
  ##  getting the runs scored by each batsman
  runscored <- sqldf("
                     select sum(c.`1stinningsinfo`) from cricketcsvattestt3 c
                     where c.meta = '1st' and 
                     c.type4 = 'runs'         and
                     c.type5 = 'batsman'      and 
                     c.overs in ( select oversplayed  from oversactt2)
                     ") 
  runscored
  
  alldetails <- sqldf(" select * from cricketcsvattestt3 c
                         where c.meta = '1st' and c.overs in ( select oversplayed  from oversactt2)
                       ")
  alldetails
  
  wicketdetails <- paste( "b", alldetails[which(alldetails$overs == alldetails[which(alldetails$type4 == "wicket" & alldetails$type5 == "player_out"),10] & alldetails$type4 == "bowler"),8],
                               alldetails[which(alldetails$type4 == "wicket" & alldetails$type5 == "fielders"),8], 
                               alldetails[which(alldetails$type4 == "wicket" & alldetails$type5 == "kind"),8]
                         )
  wicketdetails  
  
  
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
  
  playerrunstestact <- data.frame( matchid, playername,runscored[1,1])
  playerrunsact <- rbind(playerrunsact, playerrunstestact)
  
} 


# dotballs <- dotballs +
# wideballsplayed <-   wideballsplayed +
# noballsplayed <-     noballsplayed
# 6s <-  6s +  countof4s + sqldf("select count(*) from detailsact where `1stinningsinfo` = 4 ")















###################################################################################################################


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
  
  
  matchestest <- data.frame( file.names[i], matchid, 
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
                             cricketcsfnltestt3[matchvenue,8]
  )
  
  names(matchestest) <- c("file name", "Match Id","matchdate", "matchbetween","matchtype","matchgender","matchwinner","playerofmatch","tosswonby","tosswinnerdecision","umpiresformatch","matchlocation","matchvenue")
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
  
  playerdetailstest <- data.frame ("764", "764","764", "764", "764", "764", "764") 
  playerdetails <- rbind(playerdetails, setNames(playerdetailstest,names(playerdetails)))
  
  print("Match Change")
  
  
}

legbyeovers <- subset(details, ( (details$type4 == "legbyes" | details$type4 == "byes") & (details$`1stinningsinfo` == 1) ) )

ballsbowled <- subset(bowlersact, bowlersact$`1stinningsinfo` == bowlername) # fetched all balls bowled by the selected bowler

sqldf("select overs from cricketcsfnltestt3")

---------------------------------------------------------------

    
playerdetails[duplicated(playerdetails),]
bowlingsummary[duplicated(bowlingsummary),]

matchesfinal <- matchesfinal[!duplicated(matchesfinal$file.names.i.),]

duplicatematchs <- matchesfinal[duplicated(matchesfinal$file.names.i.),]


fallofwickets[duplicated(fallofwickets),]


