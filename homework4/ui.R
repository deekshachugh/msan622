library(shiny)



shinyUI(

  
                  
                    mainPanel(
                      tabsetPanel(
                        tabPanel("Most Frequent Words", plotOutput("barPlot")), br(),
                        
                        tabPanel("Obama vs Bush", plotOutput("wordCloud")), br(),
                        tabPanel("Obama 2014 vs 2013", plotOutput("freqplot"))
                        
                      )  
                    #)
                    
                  )
)
