
shinyUI(fluidPage(
  
  titlePanel("Weather Report"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput( "City", "City", c("New York","San Francisco"),selected = c("New York")),
      sliderInput(
        "num", 
        "Months:", 
        min = 4, 
        max = 24,
        value = 12, 
        step = 1
      ),
      
      sliderInput(
        "start", 
        "Starting Point:",
        min =  2011, 
        max =  2013,
        value = 2011, 
        step = 1 ,
        round = FALSE, 
        ticks = TRUE,
        format = "####.##",
        animate = animationOptions(
          interval = 2500, 
          loop = TRUE
        )
      ),
      
      width = 3)
    
    ,
    
    mainPanel(
      tabsetPanel(
        tabPanel("Daily Temperature Overview", plotOutput(
          outputId = "mainPlot", 
          width = "100%", 
          height = "400px"
        ),plotOutput(
          outputId = "overviewPlot",
          width = "100%",
          height = "200px"
        ),width = 9),
        tabPanel("HeatMap"),
        tabPanel("Parallel Coordinates"),
        tabPanel("Small Multiple")
        
      )  
    )
    
  )
))
