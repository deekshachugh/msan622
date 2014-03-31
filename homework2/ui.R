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
      width = 2
    ),
    
    mainPanel(plotOutput("scatterplot"), width = 10)
  )
)