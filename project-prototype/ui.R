shinyUI(
  navbarPage(
    "Weather Report",
    # Tab 1 : Bar Plot Layout
    tabPanel(
      "Map Plot",
      fluidRow(
        column(
          width = 3,
          selectizeInput("mapPlotDate", "Date", choices = unique(molten$Date)),
          radioButtons(
            "mapPlotVariable", "Variables:", c(
              'Temperature', 'Dew.Point.Temperature',
              'Humidity', 'Wind.Speed', 'Percent.Cloud.Cover'),
            selected = 'Temperature')),
        column(
          width = 9,
          plotOutput(
            "mapPlot",
            height = 550)
        )
      )
      #tabPanel("Data")
      #column(6,tabPanel("Bar Plot",plotOutput("bar_plot1",height='100%',width='100%') )),
      #column(6,tabPanel("Bar Plot",plotOutput("bar_plot2",height='100%',width='100%') ))
      #plotOutput("mapPlot",height='100%',width='100
    )#end of tabpanel
    )#end of navbarpage
  )#end of shinyUI
  