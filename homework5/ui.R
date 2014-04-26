
shinyUI(fluidPage(
  
  titlePanel("Road Casualties in Great Britain 1969–84"),
  
  sidebarLayout(
    sidebarPanel(
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
        min = 1969, 
        max = 1983,
        value = 1969, 
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
        tabPanel("UK Drivers Deaths", plotOutput(
          outputId = "mainPlot", 
          width = "100%", 
          height = "400px"
        ),plotOutput(
          outputId = "overviewPlot",
          width = "100%",
          height = "200px"
        ),width = 9),      
        tabPanel("Car Drivers Killed",
                 plotOutput(
                   outputId = "circlePlot", 
                   width = 800, 
                   height = 550
                 )),
        tabPanel("Van Drivers Killed",
                 plotOutput(
                   outputId = "multiPlot", 
                   width = 800, 
                   height = 550
                 ))
        
      )  
    )
    
  )
))
