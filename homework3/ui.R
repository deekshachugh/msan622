library(shiny)

shinyUI(fluidPage(  
  h3("U.S States Overview"),  
  fluidRow(
    column(7, tabsetPanel(
      # Add a tab for displaying the histogram.
      tabPanel("Bubble Plot", plotOutput("bubblePlot")),
      
      # Add a tab for displaying the table (will be sorted).
      tabPanel("Scatter Plot", plotOutput("scatterplot")),
      tabPanel("Parallel Coordinates", plotOutput("parallelCoordinates"))
    )),
    
    
    column(2, h5("Region"),
           wellPanel(
             checkboxGroupInput( "region", "", c("All","Northeast", "South", "North Central", "West"), selected = "All")
             
           )
    ),
    column(2, h5("Color By"),
           wellPanel(
             radioButtons( "colorby", "", c("Region","Division"))
             
           )
    ),
    
    column(2, h5("First Coordinate (X-Axis)"),
           wellPanel(
             selectInput( "x_axis", "", c("Population","Income", "Illiteracy", "Life.Exp", "Murder","HS.Grad","Area","Frost"), selected = "All")
             
           )
    ),
    column(2, h5("Second Coordinate (Y-Axis)"),
           wellPanel(
             selectInput( "y_axis", "", c("Population","Income", "Illiteracy", "Life.Exp", "Murder","HS.Grad","Area","Frost"), selected = "All")
             
           )
    ),
    column(2, h5("Third Coordinate (Only for parallel Coordinates)"),
           wellPanel(
             selectInput( "z_axis", "", c("Population","Income", "Illiteracy", "Life.Exp", "Murder","HS.Grad","Area","Frost"), selected = "All")
             
           )
    ),
    column(2 , h5("Color Scheme"),
           wellPanel(
             selectInput( "colorScheme", "", 
                          choices = c("Set1", "Default", "Accent", "Set2", 
                                      "Set3", "Dark2", "Pastel1", "Pastel2"))))
  )
)
)

