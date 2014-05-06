
shinyServer(function(input, output, session) {
  output$dailyTemperatureOverview <- renderUI({
    getDailyTemperatureCity <- reactive({
      results <- input$dailyTemperatureCity
      return(results)
    })

    getMonths <- reactive({
      results <- input$months
      return(results)
    })

    getStartYear <- reactive({
      results <- input$startYear
      return(results)
    })

    output$mainPlot <- renderPlot({
      print(plotMonthly(getStartYear(), getMonths(), getDailyTemperatureCity()))
    })

    output$overviewPlot <- renderPlot({
      print(plotOverview(getStartYear(), getMonths(), getDailyTemperatureCity()))
    })
  })

  output$rainfallOutput <- renderUI({
    getRainfallCity <- reactive({
      results <- input$rainfallCity
      return(results)
    })

    output$barPlot <- renderPlot({
      print(plotbar(getRainfallCity()))
    })
  })

  output$mapPlotOutput <- renderUI({
    getMapPlotDate <- reactive({
      results <- input$mapPlotDate
      return(results)
    })

    getMapPlotVariable <- reactive({
      results <- input$mapPlotVariable
      return(results)
    })

    output$mapPlot <- renderPlot({
      print(plotmap(getMapPlotDate(), getMapPlotVariable()))
    })
  })
})
