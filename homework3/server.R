

library(ggplot2)
library(shiny)
library(GGally)
library(scales)
library(reshape)

# Objects defined outside of shinyServer() are visible to
# all sessions. Objects defined instead of shinyServer()
# are created per session. Place large shared data outside
# and modify (filter/sort) local copies inside shinyServer().

# See plot.r for more comments.

# Note: Formatting is such that code can easily be shown
# on the projector.

# Loads global data to be shared by all sessions.
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

globalData <- loadData()


getbubblePlot <- function(localFrame, colorby, region, range) {
  
  if(range[1] == range[2]){
    range <- c(0,3)
  }
  if(length(region) == 0 ) {
    
    localFrame <-localFrame # None is selected    
  } else {
    localFrame<-subset(localFrame,localFrame$Region %in% region) 
  }
  print(nrow(localFrame))
  if(colorby == "Region"){
 
  p <- ggplot(localFrame, aes(x = Illiteracy, y = Murder, color = Region, size = Population,label = Abbrev))
  p <- p + theme(legend.position = c(0.7, 0))
  p <- p + theme(legend.title = element_blank())
  p <- p + theme(legend.direction = "horizontal")
  p <- p + theme(legend.background = element_blank())
  p <- p + theme(legend.key = element_blank())
  p <- p + theme(legend.text = element_text(size = 9))

  p <- p + scale_colour_discrete(limits = levels(localFrame$Region))
  p <- p + geom_text(size=5, color="black")
  }
  else{
  p <- ggplot(localFrame, aes(x = Illiteracy, y = Murder, color=Division, size = Population, label = Abbrev))
  p <- p + scale_colour_discrete(limits = levels(localFrame$Division))
  }
  p <- p + annotate("text", label = "Size of the bubble is by Population",
                    x = (range[1]+range[2])/2, y = 15, size = 4, colour = "black")
  
  p <- p + xlim(range)
  p <- p + geom_point(alpha = 0.8, position = "jitter")
  
                   
  p <- p + scale_size_area(max_size = 23, guide = "none")
  
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
  
  if(length(region) == 0 ) {
    localFrame <-localFrame # None is selected
  } else {
    localFrame<-subset(localFrame,localFrame$Region %in% region) 
  }
  
p <- ggpairs( localFrame, columns =c(3:6), color= 'Region',
              
              diag=list(continuous="density"), axisLabels='show',upper = list(params = c(size = 4)))
  
  for(i in c(1:4)){
    for(j in c(1:4)){
      p1 <- getPlot(p,i,j)
      #p1 <- p1 +  theme(axis.text = element_text(colour="black",size=12))
      p1 <- p1 + theme(panel.grid.major = element_line(color = "grey90"),
             panel.background = element_rect(fill = NA))
      p1 <- p1 + theme(plot.background = element_rect(colour = 'black', 
                                                fill = 'white', size = 1))
      p1 <- p1 + scale_colour_discrete(limits = levels(localFrame$Region))
      p1 <- p1 + theme(axis.text = element_text(colour="black",size=10))
      if(j > i){
        p1 <- p1 + theme(text = element_text(color="black"))
      }
      p <- putPlot(p, p1, i, j)
    }
  }  


return(p)
}

getparallelCoordinatesPlot <- function(localFrame, colorby, region){
  if(length(region) == 0 ) {
    localFrame <-localFrame # None is selected
  } else {
    localFrame<-subset(localFrame,localFrame$Region %in% region) 
  }
  localFrame$Region <- factor(localFrame$Region)
  localFrame$Division <- factor(localFrame$Division)
  if(colorby == "Region"){
  p <- ggparcoord(data = localFrame, 
                  columns = c(3,5,6,2),
                  groupColumn =11,
                  scale = "uniminmax",
                  order = "anyClass",showPoints = FALSE, alphaLines = 0.6,
                  shadeBox = NULL)
  p <- p + theme(legend.position = "bottom", legend.text=element_text(size=14),legend.title=element_blank())
  p <- p + scale_colour_discrete(limits = levels(localFrame$Region))
  p
  }
  else
  {
    p <- ggparcoord(data = localFrame, 
                    columns = c(3,5,6,2),
                    groupColumn =12,
                    scale = "uniminmax",
                    order = "anyClass",showPoints = FALSE, alphaLines = 0.6, shadeBox = NULL)
    p <- p + scale_colour_discrete(limits = levels(localFrame$Division))
  }
  p<-p+theme(panel.grid.major = element_line(color = "grey90"),
             panel.background = element_rect(fill = NA))  
  
  p<-p+theme(plot.background = element_rect(colour = 'black', 
                                            fill = 'white', size = 1))
  #p <- p + theme_minimal()
  p <- p + scale_y_continuous(expand = c(0.02, 0.02))
  
  p <- p + scale_x_discrete(expand = c(0.02, 0.02))
  
  # Remove axis ticks and labels
  p <- p + theme(axis.ticks = element_blank())
  
  p <- p + theme(axis.title = element_blank())
  p <- p + theme(axis.text = element_text(colour="black",size=14))
  p <- p + theme(axis.text.y = element_blank())
  # Clear axis lines
  p <- p + theme(panel.grid.minor = element_blank())
  p <- p + theme(panel.grid.major.y = element_blank())
  
  # Darken vertical lines
  p <- p + theme(panel.grid.major.x = element_line(color = "#bbbbbb"))
  min_y <- min(p$data$value)
  max_y <- max(p$data$value)
  pad_y <- (max_y - min_y) * 0.1
  
  # Calculate label positions for each veritcal bar
  lab_x <- rep(1:4, times = 2) # 2 times, 1 for min 1 for max
  lab_y <- rep(c(min_y - pad_y, max_y + pad_y), each = 4)
  
  # Get min and max values from original dataset
  lab_z <- c(sapply(localFrame[, c(3,5,6,2)], min), sapply(localFrame[, c(3,5,6,2)], max))
  
  # Convert to character for use as labels
  lab_z <- as.character(lab_z)
  
  # Add labels to plot
  p <- p + annotate("text", x = lab_x, y = lab_y, label = lab_z, size = 3)
  
  
  
  return(p)
  
}


# Color-blind friendly palette from http://jfly.iam.u-tokyo.ac.jp/color/
palette1 <- c("#999999", "#E69F00", "#56B4E9", "#009E73",
              "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

shinyServer(function(input, output) {
  
  cat("Press \"ESC\" to exit...\n")
  
  localFrame <- globalData
  
 
  output$bubblePlot <- renderPlot(
{ bubblePlot <- getbubblePlot(localFrame, input$colorby, input$region, input$range)
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

