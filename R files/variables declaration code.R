###  global declarations
ballsplayed <- 0



playerdetails <- data.frame() 
bowlingsummary <- data.frame()
matches <- data.frame()
fallofwickets <- data.frame( )

playerdetailsfinal <- data.frame() 
bowlingsummaryfinal <- data.frame()
matchesfinal <- data.frame()
fallofwicketsfinal <- data.frame()

names(playerdetails) <- c("matchid","innings", "playername","runscored","ballsplayed","countof4s","countof6s","wicketdetails")
names(bowlingsummary) <- c("matchid","innings", "bowlername","totalballsbowled", "oversbowled","runsgiven","wicketstaken", "dotballsbowled",  "economyrate","widesbowled","noballsbowled", "countof6sgiven", "countof4sgiven")
names(matches) <- c("filename", "Match Id","matchdate", "matchbetween","matchtype","matchgender","matchwinner","playerofmatch","tosswonby","tosswinnerdecision","umpiresformatch","matchlocation","matchvenue")

names(matchestest) <- c("filename", "Match Id","matchdate", "matchbetween","matchtype","matchgender","matchwinner","playerofmatch","tosswonby","tosswinnerdecision","umpiresformatch","matchlocation","matchvenue")


index <- c("1st","2nd","3rd","4th","5th","6th","7th","8th", "9th","10th")
num <- c(1:10)
wkt <- data.frame(num,index)

getwd()

temp <- tempfile()
download.file("http://www.cricsheet.org/downloads/t20s.zip",temp)

