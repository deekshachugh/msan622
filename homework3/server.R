

library(ggplot2)
library(shiny)
library(GGally)
library(scales)
#loading the states data
loadData <- function() {
  df <- data.frame(state.x77,
                   State = state.name,
                   Abbrev = state.abb,
                   Region = state.region,
                   Division = state.division
  )
  df <- df[order(df$Population, decreasing = TRUE),]
  
  return(df)
}

#assigning global value to data
globalData <- loadData()

#returns a bubble plot
getbubblePlot <- function(localFrame, colorby, region, range, size, states) {
  
  #to check whether the zoom in range is just one point
  if(range[1] == range[2]){
    range <- c(0,2.81)
  }
  
  #filtered the data based on region
  if(length(region) == 0 ) {    
    localFrame <-localFrame # None is selected    
  } else {
    localFrame<-subset(localFrame,localFrame$Region %in% region) 
  }
  
  # to plot the data based on region or division
  if(colorby == "Region"){ 
    if(states == TRUE){
  p <- ggplot(localFrame, aes(x = Illiteracy, y = Murder, color = Region, size = Population, label = Abbrev))
  p <- p + geom_text(size=5, color="black")
    }
    else{
  p <- ggplot(localFrame, aes(x = Illiteracy, y = Murder, color = Region, size = Population))
      
    }
    
  p <- p + theme(legend.position = c(0.7, 0))
  p <- p + theme(legend.title = element_blank())
  p <- p + theme(legend.direction = "horizontal")
  p <- p + theme(legend.background = element_blank())
  p <- p + theme(legend.key = element_blank())
  p <- p + theme(legend.text = element_text(size = 9))
  p <- p + scale_colour_discrete(limits = levels(localFrame$Region))
  
  }
  else{
    if(states == TRUE){
      p <- ggplot(localFrame, aes(x = Illiteracy, y = Murder, color = Division, size = Population,label = Abbrev))
      p <- p + geom_text(size=5, color="black")
    }
    else{
      p <- ggplot(localFrame, aes(x = Illiteracy, y = Murder, color = Division, size = Population))
  p <- p + scale_colour_discrete(limits = levels(localFrame$Division))
  }}
  # Provide annotation about the size of the bubble
 
  p <- p + annotate("text", label = "Size of the bubble is by Population",
                    x = (range[1]+range[2])/2, y = 15, size = 4, colour = "black")
  # provide the zoom in support
  p <- p + xlim(range)
  p <- p + geom_point(alpha = 0.8, position = "jitter")
  p <- p + scale_size_area(max_size = size, guide = "none")
  p <- p+theme(panel.grid.major = element_line(color = "grey90"), 
  panel.background = element_rect(fill = NA))
  p <- p+theme(plot.background = element_rect(colour = 'black', fill = 'white', size = 1))
  p <- p + guides(colour = guide_legend(override.aes = list(size = 8))) 
  p <- p + ggtitle("Murder Rate by Illiteracy") 
  p <- p + labs(size = "Population",x = "Illiteracy", y = "Murder rate")
  p <- p + theme(axis.text = element_text(colour="black",size=12))
  p <- p + theme(axis.title = element_text(colour="black",size=14))
  return(p)
}


getScatterPlot <- function(localFrame, colorby, region){  
  #filters the region in the data
  if(length(region) == 0 ) {
    localFrame <-localFrame 
  } else {
    localFrame<-subset(localFrame,localFrame$Region %in% region) 
  }
  
p <- ggpairs( localFrame, columns =c(3:6), color= 'Region', diag=list(continuous="density"), 
              axisLabels='show',upper = list(params = c(size = 4)), legends =TRUE)


#Added few theme options to individual ggpair plot
for(i in c(1:4)){
    for(j in c(1:4)){
      p1 <- getPlot(p,i,j)
      p1 <- p1 + theme(panel.grid.major = element_line(color = "grey90"),
             panel.background = element_rect(fill = NA))
      p1 <- p1 + theme(plot.background = element_rect(colour = 'black', 
                                                fill = 'white', size = 1))
      p1 <- p1 + scale_colour_discrete(limits = levels(localFrame$Region))
      p1 <- p1 + theme(axis.text = element_text(colour="black",size=10))
      p1 <- p1 + theme(legend.position = "none")
      
      if(i==1 & j == 1){
        p1 <- p1 + theme(
          legend.position=c(0.75,0.6),
                         legend.direction="vertical",
                         legend.box="horizontal",
          legend.key = element_rect(fill = "transparent"),
          legend.background = element_rect(fill = "transparent"),
                         #legend.margin = unit(0.2, "cm"),
                         legend.title =element_blank())  
      }
      p <- putPlot(p, p1, i, j)
    }
  }  
p
return(p)
}

#Parallel Coordinates Plot
getparallelCoordinatesPlot <- function(localFrame, colorby, region){
  #filters the region specified in the application
  if(length(region) == 0 ) {
    localFrame <-localFrame 
  } else {
    localFrame<-subset(localFrame,localFrame$Region %in% region) 
  }
  localFrame$Region <- factor(localFrame$Region)
  localFrame$Division <- factor(localFrame$Division)
  
  #colors the lines of the parallel plot by region or division 
  #depending on the value specified in the application
  if(colorby == "Region"){
  p <- ggparcoord(data = localFrame, 
                  columns = c(1,2,8,7),
                  groupColumn =11,
                  scale = "uniminmax",
                  order = c(1,2,8,7),showPoints = FALSE, alphaLines = 1,
                  shadeBox = NULL)
  p <- p + theme(legend.position = "bottom", legend.text=element_text(size=14),
                 legend.title=element_blank())
  #p <- p + scale_colour_discrete(limits = levels(localFrame$Region))
  }
  else
  {
    p <- ggparcoord(data = localFrame, columns = c(1,2,8,7),
                    groupColumn =12, scale = "uniminmax",
                    order = c(1,2,8,7),showPoints = FALSE, alphaLines = 1 )
   # p <- p + scale_colour_discrete(limits = levels(localFrame$Division))
  }
  #palette <- c("#111111","#111000","000111","001111")
  palette <- brewer_pal(type = "qual", palette = "Set1")(9)   
  p <- p +scale_color_manual(values = palette)
  p<-p+theme(panel.grid.major = element_line(color = "grey90"),
             panel.background = element_rect(fill = NA))  
  p<-p+theme(plot.background = element_rect(colour = 'black', 
                                            fill = 'black', size = 1))
  
  p <- p + scale_y_continuous(expand = c(0.02, 0.02))
  p <- p + scale_x_discrete(expand = c(0.02, 0.02))
  # Remove axis ticks and labels
  p <- p + theme(axis.ticks = element_blank(),legend.key = element_rect(fill = "transparent"),
                 legend.background = element_rect(fill = "transparent")
  )
  p <- p + theme(axis.title = element_blank())
  
  p <- p + theme(axis.text.y = element_blank())
  # Clear axis lines
  p <- p + theme(panel.grid.minor = element_blank())
  p <- p + theme(panel.grid.major.y = element_blank())
  # Darken vertical lines
  p <- p + theme(panel.grid.major.x = element_line(color = "#bbbbbb"))
  min_y <- min(p$data$value)
  max_y <- max(p$data$value)
  pad_y <- (max_y - min_y) * 0.1  
  lab_x <- rep(1:4, times = 2)
  lab_y <- rep(c(min_y - pad_y, max_y + pad_y), each = 4)
  
  # Get min and max values from original dataset
  lab_z <- c(sapply(localFrame[, c(1,2,8,7)], min), sapply(localFrame[, c(1,2,8,7)], max))
  # Convert to character for use as labels
  lab_z <- as.character(lab_z)
  # Add labels to plot
  p <- p + annotate("text", x = lab_x, y = lab_y, label = lab_z, size = 5, color ="white")
  p <- p + theme(text = element_text(colour="white",size=14))
  return(p)
  
}



shinyServer(function(input, output) {
  
  cat("Press \"ESC\" to exit...\n")
  
  localFrame <- globalData
  
 
  output$bubblePlot <- renderPlot(
{ bubblePlot <- getbubblePlot(localFrame, input$colorby, input$region, input$range, input$size, input$states)
  print(bubblePlot)
}
  )
  
  output$scatterplot <- renderPlot(
{ scatterplot <- getScatterPlot(localFrame,input$colorby, input$region)
  print(scatterplot)
})
  
  output$parallelCoordinates <- renderPlot(
{
  ParrallelCoordPlot <- getparallelCoordinatesPlot(
    localFrame,input$colorby, input$region)
  print(ParrallelCoordPlot)
}
  )

  })

