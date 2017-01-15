######## converting data from loop3
path <- "A:/ADBMS/Project/Datafiles/yaml/RCB/Files/"
file.names <- dir(path, pattern =".yaml")

for(i in 1:length(file.names))
{
  filepath <- paste("A:/ADBMS/Project/Datafiles/yaml/RCB/Files/",file.names[i],sep = "")
  print(filepath)
  
  data <- yaml.load_file(filepath)
  print("sucessfully loaded file")
  
  data <- data.frame(data, row.names = NULL,check.rows = FALSE, check.names = FALSE)
  print("sucessfully converted to dataframe")
  
  matchnumber <- paste("match",file.names[i], sep = "")
  matchnumber <- paste(matchnumber,".xlsx", sep = "")
  print(matchnumber)
  
  path <- paste ("A:/ADBMS/Project/Datafiles/csv/RCB/",matchnumber,sep = "")
  print("sucessfully taken the output path")
  
  write.xlsx(data,path)
  print("sucessfully written to output")
  file.remove(filepath)
  print("###################################")
  
}