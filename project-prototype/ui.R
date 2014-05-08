shinyUI(
  navbarPage(
    "Weather Analysis",
    # Tab 1 : Bar Plot Layout
    tabPanel(
      "US Overview",
      fluidRow(
        column(
          width = 3,
          selectizeInput("mapPlotDate", "Date", choices = unique(molten$Date)),
          radioButtons(
            "mapPlotVariable", "Variables:", c(
              'Temperature', 'Dew.Point.Temperature',
              'Humidity', 'Percent.Cloud.Cover'),
            selected = 'Temperature')),
        column(
          width = 9,
          plotOutput(
            "mapPlot",
            height = 550)
        )
      )# end of fluid row
      #tabPanel("Data")
      #column(6,tabPanel("Bar Plot",plotOutput("bar_plot1",height='100%',width='100%') )),
      #column(6,tabPanel("Bar Plot",plotOutput("bar_plot2",height='100%',width='100%') ))
      #plotOutput("mapPlot",height='100%',width='100
    )#end of tabpanel
    ,
    tabPanel(
      "Precipitation",
      fluidRow(
        column(
          width = 3,
          selectizeInput("rainfallCity", "City", choices = unique(molten$City))
          ),
        column(
          width = 9,
          plotOutput(
            "barPlot",
            height = 550)
        )
      )# end of fluid row
    ),# end of tabpanel
    tabPanel(
      "Daily Temperature Overview",
      fluidRow(
        column(
          width = 3,
          selectizeInput("dailyTemperatureCity", "City", choices = unique(molten$City)),

          dateRangeInput(
            "dateRange",
            "Date Range",
            start =  "2011-03-01",
            end =  "2014-01-31"
            #value = c(as.Date("2011-03-01","%Y-%m-%d"),as.Date("2014-01-31","%Y-%m-%d")),
            #step = 30 
            
          )
        ),
        column(
          width = 9,

          plotOutput(
            outputId = "overviewPlot",height = 550
          )
        )
      )# end of fluid row
    ),# end of tabpanel
    tabPanel(
      "Temperature Prediction",
      fluidRow(
        column(
          width = 3,
          selectizeInput("predictCity", "City", choices = unique(molten$City))
        ),
        column(
          width = 9,
          
          plotOutput(
            outputId = "modelingPlot",height = 550
          )
        )
        
      )# end of fluid row
    )# end of tabpanel
    
    )#end of navbarpage
  )#end of shinyUI
  