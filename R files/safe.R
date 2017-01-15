library(shinythemes)
library(shinydashboard)
library(yaml) 
library(xlsx)
library(tcltk)
library(stats)
library(sqldf)
library(tidyr)
library(dplyr)
library(downloader)
library(RODBC)
library(mailR)
library(rpart)
library(ggplot2)
library(sendmailR)
#library(gmailr)
library(beepr)
library(devtools)
library(gmailR)
library(mygmailR)
library(mail)
library(mailR)
library(neuralnet)
#library(RMySQL)
# Load the party package. It will automatically load other dependent packages.
library(party)
library(RODBC)
library(rsconnect)
library(shiny)

models <- data.frame(c("Select", "Neural Network","Logistic Regression","Convoluted Neural Network","Principal Component Analysis","K-nearest-neighbors, Euclidean (L2)"))


colnames(models) <- "Models"

ui <- shinyUI( navbarPage(title = "Visualization of Neural Networks",
                          theme = shinytheme("united"),         
                          
                          tabsetPanel(
                            tabPanel("Single Input NN",    
                                     
                                     ui <- fluidPage(
                                       sidebarPanel( 
                                         sliderInput(inputId = "xInput", label = "Give input x point",value = 5, min = -10, max = 10),
                                         sliderInput(inputId = "yInput", label = "Give input y point",value = 0.5, min = 0, max = 1),
                                         sliderInput(inputId = "Weight", label = "Give weight point",value = 1, min = -10, max = 10, step = 0.1)),
                                       mainPanel(plotOutput('analysis'))
                                     )),
                            tabPanel("MNIST data", 
                                     ui <- fluidPage( 
                                       sidebarPanel(
                                         #fileInput('loaddata',"Load the data"),
                                         selectInput( "model", 'Please select the model you want to build', models$Models,selected = models$Models[1] ),
                                         actionButton(inputId = "GetInputs", label = "Get the Inputs"),
                                         actionButton(inputId = "run", label = "Run the Model"))
                                       
                                       #mainPanel(plotOutput("Model"))
                                       #uiOutput("Aravind")
                                     )
                            )
                          )
))

server <- function(input, output){
  output$analysis <- renderPlot({ 
    
    x <- -10:10
    y <- 1.0/(1.0 + exp(input$Weight*x ))
    
    plot(x,y,type="l",cex=.8,axes = TRUE, pch=1,col="red")
    points(input$xInput, input$yInput,type="p",cex=4,pch=2,col="blue")
    arrows(-3, 0.5,-3,(0.5 - (  (1.0/(1.0 + exp(input$Weight*input$xInput ))) - input$yInput) *x *(1-y) ), col= 'pink') })
  
  observeEvent( input$GetInputs,
                {
                  
                  insertUI(
                    selector = "#GetInputs",
                    where = "afterEnd",
                    ui = textInput(paste0("txt", input$add),
                                   "Insert some text")
                  )
                  
                  
                }
  )
  
  observeEvent( input$run, insertUI(
    selector = "#run",
    where = "afterEnd",
    ui = plotOutput("Model")))
  
  inptmdl <- reactive(
    input$model
  )  
  
  output$Model <- renderPlot ({ 
    if("Neural Network" == inptmdl()) {             
      nn <- neuralnet(case~age+parity+induced+spontaneous,data=infert,hidden=2,err.fct = "ce",linear.output = FALSE)
      plot(nn) }
  })
}

shinyApp(ui = ui, server = server)
