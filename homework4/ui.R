library(shiny)



shinyUI(
  navbarPage("State of the Union",
             tabsetPanel(
               tabPanel("Most Frequent Words", plotOutput("barPlot",height=550)),
               tabPanel("Obama vs Bush", plotOutput("wordCloud",height=550)),
               tabPanel("Obama 2014 vs 2013", plotOutput("freqplot",height=550))
             )  
  )
)
