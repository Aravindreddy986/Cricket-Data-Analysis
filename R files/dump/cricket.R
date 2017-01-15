###  yaml file: 211048 and few declarations  

matchid <- 0

matchestest <-data.frame()
matches <- data.frame()

playerrunstest <-data.frame()
playerruns <- data.frame()
overs <- data.frame()


#### loading the data from csv

cricketcsv <- read.csv("A:/Data files/convertcsv (3).csv", header = FALSE, sep = ",")

crickettest <- cricketcsv
dim(crickettest)

####### 1st transformation : transforming rows and columns,  converting to data frame from matrix, adding names

crickett1 <- t(crickettest)
dim(crickett1)
crickett1 <- data.frame(crickett1)

colnames(crickett1, do.NULL = TRUE, prefix = "col")
colnames(crickett1) <- c("desc", "1stinnings","2ndinnings")

dim(crickett1)
crickett1[3,1]

# 2nd transformation: converting the desc data type from format to string
crickett2 <- crickett1
crickett2[,1] <- as.character(crickett1[,1])

#3rd transformation : spliting the desc column
library("tidyr")
splitingdesc  <- separate(data = crickett2, col = desc, into = c("C1", "C2","C3","C4","C5","c6"), sep = "/")
dim(splitingdesc)
crickett3 <- cbind(crickett2,splitingdesc)

crickett3 <- crickett3[,c(-2,-3)]

dim(crickett3)
head(crickett3)

crickett3 <- crickett3[order(crickett3$C3),]


# naming the columns appropriately 

names(crickett3)[2: dim(crickett3)[2]] <- c("Innings","team_deliveries","deliveriescount","overs","type1","type2","1stinningsinfo","2ndinningsinfo")
head(crickett3)

library(xlsx)
write.xlsx(crickett3, "A:/crickett3.xlsx")

#### selecting the teams

crickett3$`1stinningsinfo` <- as.character(crickett3$`1stinningsinfo`)
crickett3$`2ndinningsinfo` <- as.character(crickett3$`2ndinningsinfo`)

matchid <- matchid +1
teams <- which(crickett3$team_deliveries == "team")

### inserting the data into the matches data
if ( dim(matches)[1] >= 1)
{
  matchestest <- data.frame( matchid, paste( crickett3[which(crickett3$team_deliveries == "team")[1],8] ,"vs", crickett3[which(crickett3$team_deliveries == "team")[2],9] ))
  names(matchestest) <- c("Match Id", "matchbetween")
  
}else 
{
  
  matches <- data.frame( matchid, paste( crickett3[which(crickett3$team_deliveries == "team")[1],8] ,"vs", crickett3[which(crickett3$team_deliveries == "team")[2],9] ))
  names(matches) <- c("Match Id", "matchbetween")
  
}

matches <- rbind(matches, matchestest)


###  match 1st team batting summary
## fetching players first

players <- crickett3[which((crickett3$type1 == "batsman" | crickett3$type1 == "non_striker" ) & crickett3$Innings =="1st innings"),]

playerswhobatted <- sqldf(" select distinct (`1stinningsinfo`) from players ")
dim(playerswhobatted)

for (i in 1:dim(playerswhobatted)[1])
{
  
  playername <- as.character( playerswhobatted[i,1])
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
  
} 



















