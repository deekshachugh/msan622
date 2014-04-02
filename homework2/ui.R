library(shiny)


shinyUI(fluidPage(
  
  headerPanel("Movie Reviews"),
  mainPanel(plotOutput("scatterplot"), width = 10),
  fluidRow(
      column(2,offset=1, h5("Ratings Explorer"),
      wellPanel(
        radioButtons( "highlight", "", c("All", "NC-17", "PG", "PG-13","R"))
            )
          ),
      
      column(2, h5("Genres Explorer"),
        wellPanel(
        checkboxGroupInput( "GenreSelection",
        "",
        c("Action", "Animation", "Comedy","Drama","Documentary", "Mixed", "None", "Romance", "Short"),
        selected = c("Action", "Animation", "Comedy","Drama","Documentary", "Mixed", "None", "Romance", "Short")
      ))),
      column(2, h5("Size"),
             wellPanel(
             sliderInput("dotsize", "",  min = 1, max = 10, value = 2)
             )),
      
      column(2,h5("Transparency"),
             wellPanel(
             sliderInput("alphasize", "", min = .1,max = 1, value = 0.99)
             )),
      
      column(2,h5("Color Scheme"),
             wellPanel(
             selectInput( "colorScheme", "", choices = c("Set1","Default", "Accent" , "Set2", "Set3", "Dark2", "Pastel1", "Pastel2")))),
      width = 2
    )
    
    
  )
)