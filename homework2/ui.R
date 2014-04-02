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
        c("Action", "Animation", "Comedy","Drama","Documentary", "Mixed", "None", "Romance", "Short"),
        selected = c("Action", "Animation", "Comedy","Drama","Documentary", "Mixed", "None", "Romance", "Short")
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
                  value = 0.99
      ),
      
      selectInput(
        # This will be the variable we access later.
        "colorScheme",
        # This will be the control title.
        "Color Scheme:",
        # This will be the control choices.
        choices = c("Default", "Accent", "Set1", "Set2", "Set3", "Dark2", "Pastel1", "Pastel2")
      ),
      width = 2
    ),
    
    mainPanel(plotOutput("scatterplot"), width = 10)
  )
)