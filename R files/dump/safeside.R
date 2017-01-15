
#### required libraries 

library(yaml) 
library(xlsx)
library(sqldf)
library(tcltk)
library(tidyr)
library(RMySQL)

####  few declarations

matchid <- 0
matchestest <-data.frame()
matches <- data.frame()

playerrunstestact <-data.frame()
playerrunsact <- data.frame()
overs <- data.frame()

wicketdetails <-  data.frame()
playerdetails <- data.frame () 
ballsplayed <- 0

######## converting data from loop1 

path <- "A:/ADBMS/Project/Datafiles/yaml/t20s/loop1/"
file.names <- dir(path, pattern =".yaml")

for(i in 1:length(file.names))
{
  filepath <- paste("A:/ADBMS/Project/Datafiles/yaml/t20s/loop1/",file.names[i],sep = "")
  print(filepath)
  
  data <- yaml.load_file(filepath)
  print("sucessfully loaded file")
  data <- data.frame(data, row.names = NULL,check.rows = FALSE, check.names = FALSE)
  print("sucessfully converted to dataframe")
  
  matchnumber <- paste("match",file.names[i], sep = "")
  matchnumber <- paste(matchnumber,".xlsx", sep = "")
  
  print(matchnumber)
  path <- paste ("A:/ADBMS/Project/Datafiles/csv/t20s/",matchnumber,sep = "")
  print("sucessfully taken the output path")
  
  write.xlsx(data,path)
  print("sucessfully written to output")
  print("###################################")
  
}

######## converting data from loop2 
path <- "A:/ADBMS/Project/Datafiles/yaml/t20s/loop2/"
file.names <- dir(path, pattern =".yaml")

for(i in 1:length(file.names))
{
  filepath <- paste("A:/ADBMS/Project/Datafiles/yaml/t20s/loop2/",file.names[i],sep = "")
  print(filepath)
  data <- yaml.load_file(filepath)
  print("sucessfully loaded file")
  data <- data.frame(data, row.names = NULL,check.rows = FALSE, check.names = FALSE)
  print("sucessfully converted to dataframe")
  matchnumber <- paste("match",file.names[i], sep = "")
  matchnumber <- paste(matchnumber,".xlsx", sep = "")
  print(matchnumber)
  path <- paste ("A:/ADBMS/Project/Datafiles/csv/t20s/",matchnumber,sep = "")
  print("sucessfully taken the output path")
  
  write.xlsx(data,path)
  print("sucessfully written to output")
  file.remove(filepath)
  print("###################################")
  
}

######## converting data from loop3
path <- "A:/ADBMS/Project/Datafiles/yaml/t20s/loop3/"
file.names <- dir(path, pattern =".yaml")

for(i in 1:length(file.names))
{
  filepath <- paste("A:/ADBMS/Project/Datafiles/yaml/t20s/loop3/",file.names[i],sep = "")
  print(filepath)
  data <- yaml.load_file(filepath)
  print("sucessfully loaded file")
  data <- data.frame(data, row.names = NULL,check.rows = FALSE, check.names = FALSE)
  print("sucessfully converted to dataframe")
  matchnumber <- paste("match",file.names[i], sep = "")
  matchnumber <- paste(matchnumber,".xlsx", sep = "")
  print(matchnumber)
  path <- paste ("A:/ADBMS/Project/Datafiles/csv/t20s/",matchnumber,sep = "")
  print("sucessfully taken the output path")
  
  write.xlsx(data,path)
  print("sucessfully written to output")
  file.remove(filepath)
  print("###################################")
  
}

#######################################################
#Loading a single file 211028#
##########################################################

cricketcsvat <- read.xlsx("A:/ADBMS/Project/Datafiles/csv/t20s/match211028.xlsx", sheetIndex = 1)

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


write.xlsx(cricketcsvattestt3, "A:/cricketcsvattestt3.xlsx")

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


###  match team batting summary  #### fetching players first

inningsnum <- data.frame( c(1,2), c("1st", "2nd"))
names(inningsnum) <- c("rowid", "innings")

for (k in 1: dim(inningsnum)[2])
  
{
  innings1stor2nd <-  data.frame(inningsnum[1,])
  names(innings1stor2nd) <- c("rowid", "innings")
  
  ## selecting the players who played the match
  print(innings1stor2nd)
  
  playersact <- cricketcsvattestt3[which((cricketcsvattestt3$type4 == "batsman" | cricketcsvattestt3$type4 == "non_striker" ) & cricketcsvattestt3$meta == innings1stor2nd[1,2]),]
  playersactwhobatted <- sqldf(" select distinct (`1stinningsinfo`) from playersact ")
  playersactwhobatted
  
  ### fetching the only balls/overs played by all players
  
  oversact <-   sqldf("
                      select * from cricketcsvattestt3 c join innings1stor2nd i on i.innings = c.meta
                      where c.type4  = 'batsman' 
                      ")
  
}






### fetching the only balls/overs played by all players

oversact <-   sqldf("
                    select * from cricketcsvattestt3 c
                    where c.type4  = 'batsman' and c.meta = '1st'
                    ")

### looping through each player for getting the batting details

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
  
  runscored <- sqldf("
                     select  case when sum(c.`1stinningsinfo`) is Null then 0 else sum(c.`1stinningsinfo`) end from cricketcsvattestt3 c
                     where c.meta = '1st' and 
                     c.type4 = 'runs'         and
                     c.type5 = 'batsman'      and 
                     c.overs in ( select oversplayed  from oversactt2)
                     ")  
  
  alldetails <- sqldf(" select * from cricketcsvattestt3 c
                      where c.meta = '1st' and c.overs in ( select oversplayed  from oversactt2)
                      ")

  wicketdetails <- paste( "b", alldetails[which(alldetails$overs == alldetails[which(alldetails$type4 == "wicket" & alldetails$type5 == "player_out"),10] & alldetails$type4 == "bowler"),8],
                          alldetails[which(alldetails$type4 == "wicket" & alldetails$type5 == "fielders"),8], 
                          alldetails[which(alldetails$type4 == "wicket" & alldetails$type5 == "kind"),8]
  )
  
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
  playerrunstestact <- data.frame( matchid, playername,runscored[1,1])
  playerrunsact <- rbind(playerrunsact, playerrunstestact)
  
} 

