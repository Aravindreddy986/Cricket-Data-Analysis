ui <- fluidPage(
  headerPanel('Cricket Data Analysis'),
  sidebarPanel( 
    selectInput('desiredteam', 'Please select the Team', cricketplayingnations$countryname,selected = cricketplayingnations$countryname[8] ),
    textInput('emailto', 'Email address')),
  mainPanel( plotOutput('analysis'))
)

server <- function(input, output) {
  
    output$analysis <- renderPlot({ 
    
    sqlquery <-  paste( paste("SELECT * FROM analysis('",input$desiredteam,sep = ""), "')", sep="" ) 
    
    selecteddata <- sqlQuery(odbcChannel,sqlquery)
    selecteddata <- selecteddata[,c(-1,-4,-5,-6,-11)]
  
    #imagefilepath <- paste( paste("A:/ADBMS/Project/analysis/",input$desiredteam,sep = ""), ".jpeg",sep = "") 
    #jpeg(file = imagefilepath )
  
    outp <- ctree( result~., data = selecteddata)
    plot(outp)
    #dev.copy(jpeg,imagefilepath)
  })
  
}

shinyApp(ui = ui, server = server)
