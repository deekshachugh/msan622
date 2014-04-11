library(shiny)



shinyUI(fluidPage(
                  
                  titlePanel("U.S States Overview"),
                  
                  sidebarLayout(
                    
                    sidebarPanel(
                      fluidRow(
                        
                        column(6, h5("Region"),
                               
                                   checkboxGroupInput( "region", "", c( "Northeast", "South", "North Central", "West"), selected = c( "Northeast", "South", "North Central", "West"))   ),
                        column(6, h5("Color By"),
                               
                               radioButtons( "colorby", "", c("Region","Division"), selected=c("Region"))             
                        )
                        
                      ),
                      br(),
                      br(),h5("Zoom In (Bubble Plot Only)"),
                      sliderInput("range", "",  min = 0, max = 3, step = 0.1, value = c(0,3)))

                    ,
                    
                    mainPanel(
                      tabsetPanel(
                        tabPanel("Bubble Plot", plotOutput("bubblePlot")),      
                        tabPanel("Scatter Plot", plotOutput("scatterplot")),
                        tabPanel("Parallel Coordinates", plotOutput("parallelCoordinates"))
                      )  
                    )
                    
                  )
))
