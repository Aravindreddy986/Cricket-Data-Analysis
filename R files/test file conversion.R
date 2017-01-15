
############ code for converting new files  ##################################################

pathfornewfiles <- "A:/ADBMS/Project/Datafiles/yaml/test/new files/"

file.names <- dir(pathfornewfiles, pattern =".yaml")

for(i in 1:length(file.names))
{
  tryCatch(
    {
      filepath <- paste("A:/ADBMS/Project/Datafiles/yaml/test/new files/",file.names[i],sep = "")
      print(filepath)
      
      data <- yaml.load_file(filepath)
      print("sucessfully loaded file")
      
      data <- data.frame(data, row.names = NULL,check.rows = FALSE, check.names = FALSE)
      print("sucessfully converted to dataframe")
      
      matchnumber <- paste("match",file.names[i], sep = "")
      matchnumber <-   strsplit(matchnumber, '[.]')[[1]]
      matchnumber <- paste(matchnumber,".xlsx", sep = "")
      
      print(matchnumber[1])
      path <- paste ("A:/ADBMS/Project/Datafiles/csv/test/Source back up/",matchnumber[1],sep = "")
      write.xlsx(data,path)
      path <- paste ("A:/ADBMS/Project/Datafiles/csv/test/Source/",matchnumber[1],sep = "")
      write.xlsx(data,path)
      print("sucessfully written to the output path")
      
      file.remove(filepath)
      print("###################################")
    },
    error = function(e) {
      print(paste("error in the file in the path: ", filepath, sep = "")  )
      send.mail(from =  "aravindreddy727090@gmail.com",to = c( "aravindreddy727090@gmail.com"),
                subject = "Error files", body = "Please find the attachment for error files ",
                smtp = list(host.name = "aspmx.l.google.com", port = 25),authenticate = FALSE,
                send = TRUE,attach.files = c(filepath), debug = TRUE)
      errorfilepath <- paste("A:/ADBMS/Project/Datafiles/yaml/test/error files/",file.names[i],sep = "")
      file.rename(filepath,errorfilepath)
      
    }
  )
}

############ remove all the back up new files #####################################

unlink("A:/ADBMS/Project/Datafiles/yaml/test/new files - Copy/*",recursive = TRUE)

