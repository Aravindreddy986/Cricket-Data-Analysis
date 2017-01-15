###########################

sqlquery <-  reactive(  paste( paste("SELECT * FROM analysis('",input$desiredteam,sep = ""), "')",sep="" ) )  

selecteddata <- reactive ( sqlQuery(odbcChannel,sqlquery))
selecteddata <- reactive(selecteddata[,c(-1,-4,-5,-6,-11)])

imagefilepath <- reactive( paste( paste("A:/ADBMS/Project/analysis/",input$desiredteam,sep = ""), ".jpeg",sep = "") )

reactive(jpeg(file = imagefilepath ))

outp <- reactive( ctree( result~., data = selecteddata) )

output$analysis <- renderPlot({ plot(outp) })

reactive( plot(outp) )
reactive(dev.off())

send.mail(from =  "aravindreddy727090@gmail.com",
          to = "aravindreddy727090@gmail.com",
          subject = "match analysis",
          body = "please find the attachments for the analysis details ",
          smtp = list(host.name = "aspmx.l.google.com", port = 25),
          authenticate = FALSE,
          send = TRUE,
          debug = TRUE)
