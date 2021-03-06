######## converting data from loop1 

path <- "A:/ADBMS/Project/Datafiles/yaml/t20s/error files/"
file.names <- dir(path, pattern =".yaml")

for(i in 1:length(file.names))
{
  tryCatch( 
    {
      filepath <- paste("A:/ADBMS/Project/Datafiles/yaml/t20s/error files/",file.names[i],sep = "")
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
      
    },
    error = function(e) {
              print(paste("error in the file in the path: ", filepath, sep = "")  )
       file.
              send.mail(from =  "aravindreddy727090@gmail.com",
                        to = c( "aravindreddy727090@gmail.com"),
                        subject = "Error files",
                        body = "Please find the attachment for error files ",
                        smtp = list(host.name = "aspmx.l.google.com", port = 25),
                        authenticate = FALSE,
                        send = TRUE,
                        attach.files = c(filepath),
                        debug = TRUE)
      } ) 
    
}









