#dbhandle <- odbcDriverConnect('driver=SQL Server Native Client 11.0;server=(LocalDb)\\\\MSSQLLocalDB,1433;database=Cricket;trusted_connection=yes')
library(RODBC)
library(rsconnect)
library(shiny)

odbcChannel <- odbcConnect("Cricket")

upcomingmatches <- sqlQuery(odbcChannel,"SELECT * FROM todaysmatches")
cricketplayingnations <- sqlQuery(odbcChannel,"SELECT * FROM cricketplayingnations")

rsconnect::setAccountInfo(name='cricketanalysis',
                          token='16E5AFE1F1F262F2BA912DCC8A70B547',
                          secret='+v+cYGuLpwnd6D4WmsajuGpDfumLFRUiMtK4YOwR')


send.mail(from =  "aravindreddy727090@gmail.com",
          to = "aravindreddy727090@gmail.com",
          subject = "match analysis",
          body = "please find the attachments for the analysis details ",
          smtp = list(host.name = "aspmx.l.google.com", port = 25),
          authenticate = FALSE,
          send = TRUE,
          debug = TRUE)
