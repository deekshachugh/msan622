shinyServer(function(input, output) {
  output$mainPlot <- renderPlot({
    print(plotArea(input$start, input$num))
  })
  
  output$overviewPlot <- renderPlot({
    print(plotOverview(input$start, input$num))
  })
  
  output$circlePlot <- renderPlot({
    print(plotCircleplot(input$start, input$num))
  })
  
  output$multiPlot <- renderPlot({
    print(plotMultiPlot(input$start, input$num))
  })
})