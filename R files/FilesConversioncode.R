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
  matchnumber <-   strsplit(matchnumber, '[.]')[[1]]
  matchnumber <- paste(matchnumber,".xlsx", sep = "")
  
  print(matchnumber[1])
  path <- paste ("A:/ADBMS/Project/Datafiles/csv/t20s/",matchnumber[1],sep = "")
  print("sucessfully taken the output path")
  
  write.xlsx(data,path)
  print("sucessfully written to output")
  file.remove(filepath)
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
  matchnumber <-   strsplit(matchnumber, '[.]')[[1]]
  matchnumber <- paste(matchnumber,".xlsx", sep = "")
  print(matchnumber[1])
  path <- paste ("A:/ADBMS/Project/Datafiles/csv/t20s/",matchnumber[1],sep = "")
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
  matchnumber <-   strsplit(matchnumber, '[.]')[[1]]
  matchnumber <- paste(matchnumber,".xlsx", sep = "")
  
  print(matchnumber[1])
  path <- paste ("A:/ADBMS/Project/Datafiles/csv/t20s/",matchnumber[1],sep = "")
  print("sucessfully taken the output path")
  
  write.xlsx(data,path)
  print("sucessfully written to output")
  file.remove(filepath)
  print("###################################")
  
}


############ code for converting new files  ##################################################

t20conversion <- function(toemail){
  
  pathfornewfiles <- "A:/ADBMS/Project/Datafiles/yaml/t20s/new files/"
  
  file.names <- dir(pathfornewfiles, pattern =".yaml")
  
  for(i in 1:length(file.names))
  {
    tryCatch(
      {
        filepath <- paste("A:/ADBMS/Project/Datafiles/yaml/t20s/new files/",file.names[i],sep = "")
        print(filepath)
        
        data <- yaml.load_file(filepath)
        print("sucessfully loaded file")
        
        data <- data.frame(data, row.names = NULL,check.rows = FALSE, check.names = FALSE)
        print("sucessfully converted to dataframe")
        
        matchnumber <- paste("match",file.names[i], sep = "")
        matchnumber <-   strsplit(matchnumber, '[.]')[[1]]
        matchnumber <- paste(matchnumber,".xlsx", sep = "")
        
        print(matchnumber[1])
        path <- paste ("A:/ADBMS/Project/Datafiles/csv/T20/Source back up/",matchnumber[1],sep = "")
        write.xlsx(data,path)
        path <- paste ("A:/ADBMS/Project/Datafiles/csv/T20/Source/",matchnumber[1],sep = "")
        write.xlsx(data,path)
        print("sucessfully written to the output path")
        
        file.remove(filepath)
        print("###################################")
      },
      error = function(e) {
        print(paste("error in the file in the path: ", filepath, sep = "")  )
        send.mail(from =  "aravindreddy727090@gmail.com",to = toemail,
                  subject = "Error files", body = "Please find the attachment for error files ",
                  smtp = list(host.name = "aspmx.l.google.com", port = 25),authenticate = FALSE,
                  send = TRUE,attach.files = c(filepath), debug = TRUE)
        errorfilepath <- paste("A:/ADBMS/Project/Datafiles/yaml/t20s/error files/",file.names[i],sep = "")
        file.rename(filepath,errorfilepath)
        
      }
    )
  }
  
  ############ remove all the back up new files #####################################
  
  unlink("A:/ADBMS/Project/Datafiles/yaml/t20s/new files - Copy/*",recursive = TRUE)
  
}
