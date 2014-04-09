

library(ggplot2)
library(shiny)

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


getbubblePlot <- function(localFrame,colorScheme,region) {
  if(length(region) == 0 | region =="All") {
    localFrame <-localFrame # None is selected
  } else {
    localFrame<-subset(localFrame,localFrame$Region %in% region) 
  }
  p <- ggplot(localFrame, aes(x = Illiteracy, y = Murder, color = Region, size = Population))
  p <- p + geom_point(alpha = 0.8, position = "jitter")
  p <- p + scale_size_area(max_size = 20, guide = "none")
  p <- p + theme(legend.title = element_blank())
  p <- p + theme(legend.direction = "horizontal")
  p <- p + theme(legend.position = c(0.6, 0))
  p <- p + theme(legend.justification = c(0, 0))
  p <- p + theme(legend.background = element_blank())
  p <- p + theme(legend.key = element_blank())
  p <- p + theme(legend.text = element_text(size = 12))
  p<-p+theme(panel.grid.major = element_line(color = "grey90"),
             panel.background = element_rect(fill = NA))  
  
  p<-p+theme(plot.background = element_rect(colour = 'black', 
                                            fill = 'white', size = 1))
  
  p <- p + guides(colour = guide_legend(override.aes = list(size = 8)))
  p <- p + ggtitle("Murder Rate by Illiteracy")
  p <- p + labs(size = "Population",x = "Illiteracy", y = "Murder rate")
  p <- p + theme(axis.text = element_text(colour="black",size=12))
  p <- p +theme(axis.title = element_text(colour="black",size=14))
  

  return(p)
}

getScatterPlot <- function(localFrame, colorScheme, region){
  
  if(length(region) == 0 | region =="All") {
    localFrame <-localFrame # None is selected
  } else {
    localFrame<-subset(localFrame,localFrame$Region %in% region) 
  }
  
p <-ggplot(localFrame,aes(Population, Murder))+geom_point(aes(colour=factor(Region)),alpha=0.5,size=3)
#p<-p+theme(strip.text.x = element_text(size = 14, colour = "black",face="bold"),title=element_text(size=15))
#p1<-p1+theme(axis.text = element_text(colour="black",size=15))+aes(shape = factor(mpaa))
p<-p+theme(axis.text = element_text(colour="black",size=15))

p1<-p1+xlab("Population") + ylab("Murder Rate")
p<-p+theme(title=element_text(size=15),
             #legend.title=element_text("Division"),
             legend.text=element_text(size=16),
             axis.title= element_text(size=15,face="bold"),
             axis.text = element_text(colour="black",size=14))


p<-p+theme(panel.grid.major = element_line(color = "grey90"),
             panel.background = element_rect(fill = NA)
)  

p<-p+theme(plot.background = element_rect(colour = 'black', fill = 'white', size = 1))
p<-p+theme(axis.line = element_line(color = "black"))
palette <- brewer_pal(type = "qual", palette = colorScheme)(4)   
p <- p +scale_color_manual(values = palette, name ="Region")
p <- p + theme(legend.title = element_blank())
p <- p + theme(legend.direction = "horizontal")
p <- p + theme(legend.position = c(0.6, 0))
p <- p + theme(legend.justification = c(0, 0))
p <- p + theme(legend.background = element_blank())
p <- p + theme(legend.key = element_blank())
p <- p + theme(legend.text = element_text(size = 12))
p
return(p)
}

getparallelCoordinatesPlot <- function(localFrame, colorScheme, region){
  if(length(region) == 0 | region =="All") {
    localFrame <-localFrame # None is selected
  } else {
    localFrame<-subset(localFrame,localFrame$Region %in% region) 
  }
  p <- ggparcoord(data = localFrame, 
                  
                  # Which columns to use in the plot
                  columns = c(3,5,2),
                  groupColumn =11,
                  order = "anyClass",showPoints = FALSE, alphaLines = 0.6,shadeBox = NULL,scale = "uniminmax")
  
  p <- p + theme_minimal()
  p <- p + scale_y_continuous(expand = c(0.02, 0.02))
  p <- p + scale_x_discrete(expand = c(0.02, 0.02))
  
  # Remove axis ticks and labels
  p <- p + theme(axis.ticks = element_blank())
  p <- p + theme(axis.title = element_blank())
  p <- p + theme(axis.text.y = element_blank(),axis.text.x = element_text(colour="black",size=14))
  
  # Clear axis lines
  p <- p + theme(panel.grid.minor = element_blank())
  p <- p + theme(panel.grid.major.y = element_blank())
  
  # Darken vertical lines
  p <- p + theme(panel.grid.major.x = element_line(color = "#bbbbbb"))
  
  # Move label to bottom
  p <- p + theme(legend.position = "bottom", legend.text=element_text(size=14),legend.title=element_blank())
  
  return(p)
  
}


# Color-blind friendly palette from http://jfly.iam.u-tokyo.ac.jp/color/
palette1 <- c("#999999", "#E69F00", "#56B4E9", "#009E73",
              "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

shinyServer(function(input, output) {
  
  cat("Press \"ESC\" to exit...\n")
  
  localFrame <- globalData
  
 
  output$bubblePlot <- renderPlot(
{ bubblePlot <- getbubblePlot(localFrame, input$colorScheme, input$region)
  print(bubblePlot)
}
  )
  
  output$scatterplot <- renderPlot(
{ scatterplot <- getScatterPlot(localFrame,input$colorScheme, input$region)
  print(scatterplot)
})
  
  output$parallelCoordinates <- renderPlot(
{
  ParrallelCoordPlot <- getparallelCoordinatesPlot(
    localFrame,input$colorScheme, input$region)
  print(ParrallelCoordPlot)
}
  )

  })

