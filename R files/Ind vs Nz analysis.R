odbcChannel <- odbcConnect("Cricket")

RShowDoc("RODBC", package="RODBC")

analysisNZ <- sqlQuery(odbcChannel,"SELECT * FROM analysis('New Zealand')")
analysisNZ1 <- analysisNZ[,c(-1,-4,-5,-6,-11)]

# Give the chart file a name.
jpeg(file = "A:/ADBMS/Project/analysis/newzealand.jpeg")

# Create the tree.
output.tree <- ctree( result~., data = analysisNZ1)

# Plot the tree.
plot(output.tree)

# Save the file.
dev.off()


analysisInd <- sqlQuery(odbcChannel,"SELECT * FROM analysis('India')")
analysisIndt1 <- analysisInd[,c(-1,-4,-5,-6,-11)]

# Give the chart file a name.
jpeg(file = "A:/ADBMS/Project/analysis/india.jpeg")

# Create the tree.
output.tree <- ctree( result~., data = selecteddata)

# Plot the tree.
plot(output.tree)

# Save the file.
dev.off()

### send email with attachments code

send.mail(from =  "aravindreddy727090@gmail.com",
          to = c( "Mkrishnamallik@gmail.com"),
          subject = "India vs New Zealand match analysis",
          body = "please find the attachments for the analysis details ",
          smtp = list(host.name = "aspmx.l.google.com", port = 25),
          authenticate = FALSE,
          send = TRUE,
          attach.files = c("A:/ADBMS/Project/analysis/india.jpeg", "A:/ADBMS/Project/analysis/newzealand.jpeg"),
          
          debug = TRUE)
