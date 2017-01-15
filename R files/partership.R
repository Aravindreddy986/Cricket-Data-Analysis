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
cricketcsfnltestt3$overs

#write.xlsx(cricketcsfnltestt3, "A:/cricketcsfnltestt3.xlsx")
####################### selecting the teams

cricketcsfnltestt3$`1stinningsinfo` <- as.character(cricketcsfnltestt3$`1stinningsinfo`)
cricketcsfnltestt3$`2ndinningsinfo` <- as.character(cricketcsfnltestt3$`2ndinningsinfo`)

############ fetching the partnerships details for the match  

###  match team batting summary  #### fetching players first

inningsnum <- data.frame( c(1,2), c("1st", "2nd"))
names(inningsnum) <- c("rowid", "innings")

print(" enter the loop for each innings for fetching batting and bowling details ")

for (k in 1: dim(inningsnum)[2])
{
  partnership <- data.frame()
  
   innings1stor2nd <-  data.frame(inningsnum[k,])
   names(innings1stor2nd) <- c("rowid", "innings")
  
   print("Splitting the dataset based on innings")
   details <- cricketcsfnltestt3[which(cricketcsfnltestt3$meta == innings1stor2nd[1,2]),]
  
   print("fetching only the wicket deliveries ")
   wicketballs <- data.frame(subset(details, details$type4 == "wicket" & details$type5 == "player_out"))
   wicketballs$num <- c(1:dim(wicketballs)[1])
   wicketballs$overs <- as.numeric(as.character(wicketballs$overs))
   
   print("fetching the runs for each ball ")
   score <- subset(details, details$type5 == "total")
   score$`1stinningsinfo` <- as.numeric(score$`1stinningsinfo`)
   score$overs <- as.numeric(as.character(score$overs))
   
   print(" looping through each wicket ball for fetching runs scored between the partnerships")
   for (i in 1:dim(wicketballs)[1])
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
   
   if (wicketballs[dim(wicketballs)[1],10] != 19.6 & wicketballs[dim(wicketballs)[1],11] != 10)
     
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
   fallofwickets <- rbind(fallofwickets,fallofwicketstest)
}
# normalizing the data

fallofwicketst <- fallofwickets[,c(1,2,5,8,7,3,6)]
