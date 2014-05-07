

shinyServer(function(input, output) {

 
  output$mapPlot <- renderPlot({
    #print(ggplot(mtcars,aes(wt,mpg))+geom_point())
    print(plotmap(input$mapPlotDate, input$mapPlotVariable))
  })
  output$bar <- renderPlot({
    
    print(plotbar())
  })
  
  
})