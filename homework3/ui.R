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
                      checkboxInput("states","Show States", FALSE),
                      br(),h5("Zoom In (Bubble Plot Only)"),
                      sliderInput("range", "",  min = 0, max = 2.9, step = 0.1, value = c(0,2.85)),
                      br(),h5("Bubble Size (Bubble Plot Only)"),
                      sliderInput("size", "",  min = 10, max = 30, step = 1, value = c(23))
                      
                      )

                    ,
                    
                    mainPanel(
                      tabsetPanel(
                        tabPanel("Crime Rate Overview", plotOutput("bubblePlot")),      
                        tabPanel("Social Overview", plotOutput("scatterplot")),
                        tabPanel("Demographical Overview", plotOutput("parallelCoordinates"))
                      )  
                    )
                    
                  )
))
