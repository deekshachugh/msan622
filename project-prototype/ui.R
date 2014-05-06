library(shiny)

shinyUI(
  navbarPage(
    "Weather Analysis",
    tabPanel(
      "Daily temperature Overview",
      sidebarLayout(
        sidebarPanel(
          selectizeInput("dailyTemperatureCity", "City", choices = unique(molten$City)),
          sliderInput(
            "months",
            "Number of months",
            min = 4,
            max = 24,
            value = 12,
            step = 1
          ),
          br(),
          sliderInput(
            "startYear",
            "Starting point",
            min =  2011,
            max =  2013,
            value = 2011,
            step = 0.1 ,
            round = FALSE,
            ticks = TRUE,
            format = "####.##",
            animate = animationOptions(
              interval = 2500,
              loop = TRUE
            )
          ),
          uiOutput("dailyTemperatureOverview")
        ), # end of sidebarPanel
        mainPanel(
          plotOutput(
            outputId = "mainPlot"
          ),
          plotOutput(
            outputId = "overviewPlot"
          )
        ) # end of main panel
      ) # end of sidebarLayout
    ), # end of tabpanel
    tabPanel(
      "Rainfall",
      sidebarLayout(
        sidebarPanel(
          selectizeInput("rainfallCity", "City", choices = unique(molten$City)),
          uiOutput("rainfallOutput")
        ), # end of sidebarPanel
        mainPanel(
          plotOutput(
            outputId = "barPlot"
          )
        ) # end of main panel
      ) # end of sidebarLayout
    ), # end of tabpanel
    tabPanel(
      "Map Plot",
      sidebarLayout(
        sidebarPanel(
          selectizeInput("mapPlotDate", "Date", choices = unique(molten$Date)),
          radioButtons(
            "mapPlotVariable", "Variables:", c(
              "Temperature", "Dew.Point.Temperature", "Precipitation",
              "Humidity", "Wind.Speed", "Percent.Cloud.Cover"),
            selected = "Temperature"),
          uiOutput("mapPlotOutput")
        ), # end of sidebarPanel
        mainPanel(
          plotOutput(
            outputId = "mapPlot"
          )
        ) # end of main panel
      ) # end of sidebarLayout
    ) # end of tabpanel
  ) # end of navbarPage
) # end of shinyUI
