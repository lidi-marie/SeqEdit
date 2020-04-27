########## Shiny practice ##########
####################################
rm(list=ls())
library(shiny)
library(plyr)
library(rclipboard)
library(shinyShortcut)

install.packages("ggplot2")

############ Create Sequence editor #############
##################################################

#### User interface
ui <- fluidPage(
  
    ### App title 
    titlePanel(p(span("Lidis", style="color:blue"),code("Sequence Editor"))),
    
    sidebarLayout(

      ###### Input in sidebar 
      sidebarPanel(
        
        ### Text input ##bases 
   textAreaInput(inputId = "bases",
            label=" Sequence:",
            value = "",
            placeholder = "ACGT",
            width = '250px',
            height="300px"),
  
        ### Select operation to text 
  selectInput(inputId= "operation", label="Select transformation:", 
              choices=c("Reverse","Complement","Reverse Complement"),
              selected="Reverse", multiple=FALSE),
  
  textOutput(outputId = "calculator")
  
  ), ##Sidebar panel parenthesis 
               
  mainPanel( ### Output in main panel 
  textOutput(outputId = "editor")
  

   ) ## mainPanel parenthesis 
  ) ## sidebarLayout parenthesis
)   ## fluidPage parenthesis 
  
################################ User interface END. ##########################

################################ Output server START. #########################

server<- function(input,output) {
  
#  bases<- reactive({
#    req(input$rmv)
#    req(input$bases)
#    if (input$rmv ==TRUE)
#      input$bases<- sapply(strsplit(toupper(input$bases),""), function(x) sub("1","",x,
#        ignore.case = TRUE, fixed = TRUE))  
#           })
  
  
output$calculator <- reactive({
    
                    req(input$bases)
                    nchar(input$bases)
    }),
  
  output$editor<- renderText({
  
    
      ###### Reverse operation
                 if(input$operation =="Reverse"){
                  req(input$bases)
                  sapply(strsplit(toupper(input$bases), ""), 
                                  function(x) paste(rev(x), collapse=""))
                }
      
    ####### Complement operation          
                else if(input$operation=="Complement") {
                  req(input$bases)
                  paste(sapply(strsplit(toupper(input$bases),""),function(x) 
                    revalue(x, c("A"="T", "T"="A","C"="G","G"="C","U"="A"))),collapse = "")
                }
    
    ######### Reverse complement operation 
                else if( input$operation =="Reverse Complement"){
                  req(input$bases)
                  comp<-paste(sapply(strsplit(toupper(input$bases),""),function(x) 
                    revalue(x, c("A"="T", "T"="A","C"="G","G"="C","U"="A"))),collapse = "")
                  sapply(strsplit(comp, ""), function(x) paste(rev(x), collapse=""))
                }
  
  
  }) ### renderText brackets      

}  ### Server bracket

################################ Output server END. ###########################


################################ Open the app. #################################
shinyApp(ui=ui,server=server,options = list(port=7658))

