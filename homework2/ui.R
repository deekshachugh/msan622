library(shiny)

shinyUI(fluidPage(  
  h3("Movie Ratings"),  
  fluidRow(
    column(8, plotOutput("scatterplot")),
    column(2, h5("Genres Explorer"),
           wellPanel(
             checkboxGroupInput( "GenreSelection",
                                 "",
                                 c("Action", "Animation", "Comedy","Drama","Documentary", "Mixed", "None", "Romance", "Short"),
                                 selected = c("Action", "Animation", "Comedy","Drama","Documentary", "Mixed", "None", "Romance", "Short")
             ))),
    
    column(2, h5("Year"),
           wellPanel(
             radioButtons( "highlight", "", c("All","2000 or later", "1990 or later","1980 or later", "1970 or later", "1960 or later","1950 or later"), selected = "All")
             
           )
    )
  ),
  
  fluidRow(postion = "center",
           column(2, offset = 1, h5("Color Scheme"),
                  wellPanel(
                    selectInput( "colorScheme", "", choices = c("Set1", "Default", "Accent", "Set2", "Set3", "Dark2", "Pastel1", "Pastel2")))),
           column(2, h5("Size"),
                  wellPanel(
                    sliderInput("dotsize", "",  min = 1, max = 10, value = 2)
                  )),
           
           column(2, h5("Transparency"),
                  wellPanel(
                    sliderInput("alphasize", "", min = .1,max = 1, value = 0.6, step = 0.1)
                  ))
           
  )
)
)