library(shiny)
library(shinydashboard)
library(marker)
library(plyr)

############ Create Sequence editor #############
##################################################

#### User interface
ui <- dashboardPage(

    ### App title 
    dashboardHeader(title= p(span("Lidi's SeqEdit", style="color:black"))),
    
      ###### Input in sidebar 
      dashboardSidebar(
        
        ### Text input ##bases 
   textAreaInput(inputId = "bases",
            label=" Sequence:",
            value = "",
            placeholder = "ACGT",
            ),
  
        ### Select transformation
  selectInput(inputId= "operation", label="Select transformation:", 
              choices=c("None","Reverse","Complement","Reverse Complement"),
              selected="None", multiple=FALSE),
  
  actionButton(inputId = "remvnum", label = "Remove Numbers", icon =icon("eraser")),
  
  actionButton(inputId = "remvspace", label = "Remove Spaces", icon =icon("backspace")),
  
  actionButton(inputId = "remvbrk", label = "Remove Line Breaks", icon =icon("backspace")),

  use_marker(), # include dependencies
  tags$head(
    tags$style(
      ".red{background-color:#FFB8C3;}"
    )
  ),
  textInput("search", label = ("Search Sequence"), value = "", 
            placeholder = "Highlight this text"),
  
  actionButton(inputId = "up", label = "Upper Case", icon =icon("arrow-alt-circle-up")),
  
  actionButton(inputId = "low", label = "Lower Case", icon =icon("arrow-alt-circle-down"))

  
      ),##dashboardSidebar panel parenthesis 
  
  
  dashboardBody (
    fluidPage(
     
   valueBoxOutput("molweight", width = 12),
        
   box( 
     title = "Editor Output",
       solidHeader = T,
       verbatimTextOutput(outputId = "editor"),
        width = 12
        )

   ) ## mainPanel parenthesis 
  ) ## dashboardBody parenthesis
)   ## dashboard parenthesis 
  
################################ User interface END. ##########################


################################ Output server START. #########################
server<- function(input,output,session) {
  
#### input$bases are now reactive as bases()
bases  <- reactive({ input$bases })


###### Out search function 
my_marker <- marker$new("#editor")
observeEvent(input$search, {
  my_marker$
    unmark()$ # unmark all before we mark
    mark(input$search, className = "red") # highlight text
})



######## Out Quick Details
output$molweight <- renderValueBox({
 
  length <- nchar(gsub("[[:digit:]]+|[[:blank:]]","",input$bases))

  valueBox("Quick Details",
           HTML(paste0(  "<b>","Sequence Length= ","</b>", length,
                         "<b>","    GC%=  ", "</b>",round(c(nchar(gsub("[^CG]+","", input$bases, ignore.case = TRUE))/length)*100,2),
                     "<b>", "    dsDNA= ","</b>", formatC(c(length * 607.4 + 157.9), format = "e", digits = 2)," g/mol",
                     "<b>","    ssDNA= ","</b>",formatC(c(length * 303.7 + 79), format = "e", digits = 2)," g/mol",
                     "<b>","    ssRNA= ","</b>",formatC(c(length * 320.5 + 159), format = "e", digits = 2)," g/mol"
                    
                     )),
            icon = icon("list-alt"), 
           color = "blue", width = 12)
  })
  


########## Out remove space/num buttons
observeEvent(input$remvnum, {

  remvnum <- paste0(gsub("[[:digit:]]+", "", bases()))
  updateTextAreaInput(session, "bases",value= remvnum)
})


observeEvent(input$remvspace,{
  
  remvspace <- paste0( gsub("[[:blank:]]", "", bases()))
  updateTextAreaInput(session, "bases", value= remvspace)
 
})


observeEvent(input$remvbrk,{
  
  remvbrk <- paste0( gsub("[\r\n]+", "", bases()))
  updateTextAreaInput(session, "bases", value= remvbrk)
  
})

observeEvent(input$up,{
  
  up <- toupper(bases())
  updateTextAreaInput(session, "bases", value= up)
  
})

observeEvent(input$low,{
  
  low <- tolower(bases())
  updateTextAreaInput(session, "bases", value= low)
  
})



####### Out Main Panel
  output$editor<- renderText({

      ###### Reverse operation
                 if(input$operation =="Reverse"){
                  req(input$bases)
                  
                   sapply(strsplit(bases(),""), 
                         function(x) paste(rev(x), collapse=""))  
                 }
    
    ##fun <- function(x) {
    #  a <-gsub("[[:alpha:]]+", NA ,strsplit(toupper(x), ""))
    # return(replace(a, which(is.na(a)), rev(na.omit (gsub("[[:digit:]]+", NA ,strsplit(toupper(x), ""))))))
    # }#
    
    ####### Complement operation          
                else if(input$operation=="Complement") {
                  req(input$bases)
                  paste(sapply(strsplit(bases(),""),function(x) 
                    revalue(x, c("A"="T", "T"="A","C"="G","G"="C","U"="A"))),collapse = "")
                }
    
    ######### Reverse complement operation 
                else if( input$operation =="Reverse Complement"){
                  req(input$bases)
                  comp<-paste(sapply(strsplit(bases(),""),function(x) 
                    revalue(x, c("A"="T", "T"="A","C"="G","G"="C","U"="A"))),collapse = "")
                  sapply(strsplit(comp, ""), function(x) paste(rev(x), collapse=""))
                } 
    
    
                else if( input$operation == "None") {
                  req(input$bases)
                  bases()
                }

    
  
  })### renderText brackets     
  


}  ### Server bracket

################################ Output server END. ###########################


################################ Open the app. #################################
shinyApp(ui=ui,server=server)

