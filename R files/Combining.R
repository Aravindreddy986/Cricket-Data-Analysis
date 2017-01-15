playerdetailstemp1 <- data.frame() 
bowlingsummarytemp1 <- data.frame()
matchestemp1 <- data.frame()
fallofwicketstemp1 <- data.frame( )

playerdetailstemp2 <- data.frame() 
bowlingsummarytemp2 <- data.frame()
matchestemp2 <- data.frame()
fallofwicketstemp2 <- data.frame( )

playerdetailstemp1    <-  read.xlsx("A:/ADBMS/Project/Datafiles/csv/T20/Final files - Copy/playerdetails.xlsx", sheetIndex = 1)
bowlingsummarytemp1   <-  read.xlsx("A:/ADBMS/Project/Datafiles/csv/T20/Final files - Copy/bowlingsummary.xlsx", sheetIndex = 1)
matchestemp1          <-  read.xlsx("A:/ADBMS/Project/Datafiles/csv/T20/Final files - Copy/matches.xlsx", sheetIndex = 1)
fallofwicketstemp1    <-  read.xlsx("A:/ADBMS/Project/Datafiles/csv/T20/Final files - Copy/fallofwickets.xlsx", sheetIndex = 1)

playerdetailsfinal    <-  read.xlsx("A:/ADBMS/Project/Datafiles/csv/T20/Final files/playerdetails.xlsx", sheetIndex = 1)
bowlingsummaryfinal   <-  read.xlsx("A:/ADBMS/Project/Datafiles/csv/T20/Final files/bowlingsummary.xlsx", sheetIndex = 1)
matchesfinal          <-  read.xlsx("A:/ADBMS/Project/Datafiles/csv/T20/Final files/matches.xlsx", sheetIndex = 1)
fallofwicketsfinal    <-  read.xlsx("A:/ADBMS/Project/Datafiles/csv/T20/Final files/fallofwickets.xlsx", sheetIndex = 1)

playerdetailstemp2    <-  read.xlsx("A:/ADBMS/Project/Datafiles/csv/T20/Modified files/playerdetails.xlsx", sheetIndex = 1)
bowlingsummarytemp2   <-  read.xlsx("A:/ADBMS/Project/Datafiles/csv/T20/Modified files/bowlingsummary.xlsx", sheetIndex = 1)
matchestemp2          <-  read.xlsx("A:/ADBMS/Project/Datafiles/csv/T20/Modified files/matches.xlsx", sheetIndex = 1)
fallofwicketstemp2    <-  read.xlsx("A:/ADBMS/Project/Datafiles/csv/T20/Modified files/fallofwickets.xlsx", sheetIndex = 1)


## combining all matches first

matchesfinal <- rbind(matchesfinal,matchestemp1)
matchesfinal <- rbind(matchesfinal, matchestemp2)

matchesfinal <-  matchesfinal[,-1]
matchesfinal <- matchesfinal[order(matchesfinal$matchid),]

duplicatematchs <- matchesfinal[duplicated(matchesfinal$file.names.i.),]
duplicatematchs <- rbind(duplicatematchs, subset(matchesfinal, (matchesfinal$matchid == "76" | matchesfinal$matchid == "78" )) )
duplicatematchs <- duplicatematchs[order(duplicatematchs$matchid),]

matchesfinal <- matchesfinal[!duplicated(matchesfinal$file.names.i.),]
matchesfinal <- subset(matchesfinal, (matchesfinal$matchid != 76 ) )
matchesfinal <- subset(matchesfinal, (matchesfinal$matchid != 78 ) )

duplicatematchids <- data.frame(duplicatematchs$matchid)


####################################################################

playerdetailsfinal <- rbind(playerdetailsfinal,playerdetailstemp1)
playerdetailsfinal <- rbind(playerdetailsfinal,playerdetailstemp2)

playerdetailsfinal <- playerdetailsfinal[,-1]
playerdetailsfinal <- playerdetailsfinal[order(playerdetailsfinal$matchid),]


#####################################################################
bowlingsummaryfinal <- rbind(bowlingsummaryfinal,bowlingsummarytemp1)
bowlingsummaryfinal <- rbind(bowlingsummaryfinal,bowlingsummarytemp2)

bowlingsummaryfinal <- bowlingsummaryfinal[,-1]
bowlingsummaryfinal <- bowlingsummaryfinal[order(bowlingsummaryfinal$matchid),]

##################################################################################

fallofwicketsfinal <- rbind(fallofwicketsfinal,fallofwicketstemp1)
fallofwicketsfinal <- rbind(fallofwicketsfinal,fallofwicketstemp2)

fallofwicketsfinal <- fallofwicketsfinal[,-1]
fallofwicketsfinal <- fallofwicketsfinal[order(fallofwicketsfinal$match),]

########################## removing duplicate file details ###########################################################


for (i in 1:dim(duplicatematchids)[1])
{

  matchidd <- duplicatematchids[i,1]
  print(matchidd)
  playerdetailsfinal <- playerdetailsfinal[playerdetailsfinal$matchid != matchidd,]
  bowlingsummaryfinal <- bowlingsummaryfinal[bowlingsummaryfinal$matchid != matchidd,]
  fallofwicketsfinal <- fallofwicketsfinal[fallofwicketsfinal$match != matchidd,]
    
}

########################## removing duplicate file details ###########################################################

duplicatematches <- data.frame()
for (i in 350:376)
{
  
  matchidd <- i
  print(matchidd)
  
  duplicatematchestest <- subset( matchesfinal, (matchesfinal$matchid ==  as.character(matchidd) ) )
  duplicatematches <- rbind(duplicatematches,duplicatematchestest)
  
  matchesfinal <- subset(matchesfinal, (matchesfinal$matchid !=  as.character(matchidd) )  )
  playerdetailsfinal <- playerdetailsfinal[playerdetailsfinal$matchid != matchidd,]
  bowlingsummaryfinal <- bowlingsummaryfinal[bowlingsummaryfinal$matchid != matchidd,]
  fallofwicketsfinal <- fallofwicketsfinal[fallofwicketsfinal$match != matchidd,]
  
  
}

duplicatematches <- duplicatematches[order(duplicatematches$file.names.i.),]
