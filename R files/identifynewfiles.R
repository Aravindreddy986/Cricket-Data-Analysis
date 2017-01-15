yamltest <- function(){
  
########################## dowload new files ##########################################

download("http://www.cricsheet.org/downloads/tests.zip", dest="dataset.zip", mode="wb") 
unzip ("dataset.zip", exdir = "A:/ADBMS/Project/Datafiles/yaml/test/all files")

############# code which will identify the new files ################################

allfiles <- dir("A:/ADBMS/Project/Datafiles/yaml/test/all files/", pattern =".yaml")
allfiles <- data.frame(allfiles)

oldfiles <- dir("A:/ADBMS/Project/Datafiles/yaml/test/old files/", pattern = ".yaml")
oldfiles <- data.frame(oldfiles)

newfiles <- sqldf("select * from allfiles where allfiles not in (select oldfiles from oldfiles)")

for (i in 1:nrow(newfiles))
{
  frompath <- paste("A:/ADBMS/Project/Datafiles/yaml/test/all files/",newfiles[i,1],sep = "")
  
  topath <- "A:/ADBMS/Project/Datafiles/yaml/test/old files/"
  newfilespath <- "A:/ADBMS/Project/Datafiles/yaml/test/new files/"
  newfilesbackuppath <- "A:/ADBMS/Project/Datafiles/yaml/test/new files - Copy/"
  
  file.copy(from=frompath, to=topath, copy.mode = TRUE)
  file.copy(from=frompath, to=newfilespath, copy.mode = TRUE)
  file.copy(from=frompath, to=newfilesbackuppath, copy.mode = TRUE)
  
}
############# clearing the all files directory ##############################################
unlink("A:/ADBMS/Project/Datafiles/yaml/test/all files/*",recursive = TRUE)

############ Now convert the new yaml files to CSV  ##################################################
testfiles <- data.frame(c(nrow(allfiles),nrow(newfiles)))
return(testfiles)

}

