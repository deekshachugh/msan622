

shinyServer(function(input, output) {

 
  output$mapPlot <- renderPlot({
    #print(ggplot(mtcars,aes(wt,mpg))+geom_point())
    print(plotmap(input$mapPlotDate, input$mapPlotVariable))
  })
  output$barPlot <- renderPlot({
    
    print(plotbar(input$rainfallCity))
  })
  
  output$overviewPlot <- renderPlot({
    
    print(plotOverview(input$dateRange, input$dailyTemperatureCity))
  })
  output$modelingPlot <- renderPlot({
    
    print(modelPlot(input$predictCity))
  })
  
})