
from <- sprintf("aravindreddy986@gmail.com", Sys.info()[4])
to <- "aravindreddy986@gmail.com"

subject <- "Hello from R"
body <- "This is the result of the test:"

sendmail(from, to, subject, body,control=list(smtpServer="ASPMX.L.GOOGLE.COM"))

control <- list(smtpServer="ASPMX.L.GOOGLE.COM")

sendmail(from=from,to=to,subject=subject,msg=body,control=control)

sendmail("aravindreddy727090@gmail.com", subject="Notification from R",message="Calculation finished!", password="rmail")

sender <- "aravindreddy727090@gmail.com"
recipients <- c("aravindreddy727090@gmail.com")

send.mail(from = sender,
          to = recipients,
          subject = "Subject of the email",
          body = "Body of the email",
          smtp = list(host.name = "ASPMX.L.GOOGLE.COM", port = 25, 
                      user.name = "aravindreddy727090@gmail.com",            
                      passwd = "aravind@678", ssl = TRUE),
          authenticate = TRUE,
          send = TRUE)


send.mail(from =  "aravindreddy727090@gmail.com",
          to = c( "aravindreddy727090@gmail.com"),
          subject = "Subject of the email",
          body = "Body of the email",
          smtp = list(host.name = "smtp.gmail.com", port = 465),
          authenticate = TRUE,
          send = TRUE)


#To send an email with one or more file attachments, and set the debug parameter to see a detailed log message:
  
  send.mail(from =  "aravindreddy727090@gmail.com",
            to = c( "aravindreddy727090@gmail.com"),
            subject = "Subject of the email",
            body = "Body of the email",
            smtp = list(host.name = "aspmx.l.google.com", port = 25),
            authenticate = FALSE,
            send = TRUE,
            attach.files = c("A:/ADBMS/Project/Datafiles/yaml/t20s/error files/287875.yaml"),
            
            debug = TRUE)
  
  send.mail(from="aravindreddy727090@gmail.com",
            to="aravindreddy727090@gmail.com",
            subject="Test Email",
            body="PFA the desired document",
            html=T,
            smtp=list(host.name = "smtp.gmail.com",
                      port = 465,
                      user.name = "aravindreddy727090@gmail.com",
                      passwd = "aravind@678",
                      ssl = T),
            authenticate=T  )
  
  install.packages("shinythemes")
  install.packages("shinydashboard")
  
  library(shinythemes)
  library(shinydashboard)
  