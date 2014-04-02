library(shiny)

data(iris)

shinyUI(
  pageWithSidebar(
    headerPanel("Movies Data"),
    
    sidebarPanel(
      radioButtons(
        "highlight",
        "MPAA Rating",
        c("All", "NC-17", "PG", "PG-13","R")
       
      ),
      
      checkboxGroupInput(
        "GenreSelection",
        "Movie Genres:",
        c("Action", "Animation", "Comedy","Drama","Documentary", "Romance", "Short"),
        selected = c("Action", "Animation", "Comedy","Drama","Documentary", "Romance", "Short")
      ),
      sliderInput("dotsize", 
                  "Dot Size:", 
                  min = 1,
                  max = 10, 
                  value = 2
      ),
      
      sliderInput("alphasize", 
                  "Alpha Size:", 
                  min = .1,
                  max = 1, 
                  value = .5
      ),
      
      selectInput(
        # This will be the variable we access later.
        "colorScheme",
        # This will be the control title.
        "Color Scheme:",
        # This will be the control choices.
        choices = c("None", "Qualitative 1", "Qualitative 2", "Color-Blind Friendly")
      ),
      width = 2
    ),
    
    mainPanel(plotOutput("scatterplot"), width = 10)
  )
)