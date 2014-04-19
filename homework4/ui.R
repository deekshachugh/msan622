library(shiny)



shinyUI(

                  
                  
                    mainPanel(
                      tabsetPanel(
                        tabPanel("Top 10 Words", plotOutput("barPlot")),     
                        tabPanel("Different Words", plotOutput("wordCloud"))
                        
                      )  
                    #)
                    
                  )
)
