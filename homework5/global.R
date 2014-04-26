require(ggplot2)
require(shiny)
require(grid)
require(reshape)
require(scales)
source("data.R")
source("pretty.R")

grey <- "#dddddd"

plotOverview <- function(start = 1969, num = 12) {
  xmin <- start
  xmax <- start + (num / 12)
  
  ymin <- 0
  ymax <- 4500
  
  p <- ggplot(molten, aes(x = time, y = value))
  p <- p + geom_line(
    data = subset(molten, variable %in% c("Total_Drivers","Front_Seat","Rear_Seat")),
    aes(
      group = variable,
      fill = variable,
      # not really necessary
      color = variable,
      # swap stacking order
      order = -as.numeric(variable)
    )
  )
  rect <- data.frame (xmin, xmax, ymin, ymax)
  p <- p + geom_rect(data=rect,
    aes(xmin = xmin, xmax = xmax,
    ymin = ymin, ymax = ymax),
    color=grey, alpha=0.5, inherit.aes = FALSE)
  
   p <- p + scale_x_continuous(
     limits = range(molten$time),
     expand = c(0, 0),
     breaks = seq(1969, 1985, by = 1))
#   
   p <- p + scale_y_continuous(
     limits = c(ymin, ymax),
     expand = c(0, 0),
     breaks = seq(ymin, ymax, length.out = 3))
   
   p <- p + theme(panel.border = element_rect(
     fill = NA, colour = grey))
#   
   p <- p + theme(axis.title = element_blank())
   p <- p + theme(panel.grid = element_blank())
   p <- p + theme(panel.background = element_blank())
   p <- p + theme(legend.position = "none")
   p <- p + theme(axis.text = element_text(colour="black",size=12))
   p <- p + geom_segment(aes(x = 1984, y = 2000, xend = 1983.15, yend = 1500),arrow = arrow(length = unit(0.5, "cm")))  
   p <- p + annotate("text", label = "Introduction of Seat Belt Law", size = 6, x = 1982, y = 2250)  
   p <- p + theme(plot.background = element_rect(colour = 'black', fill = 'white', size = 1))
   p <- p + theme( panel.background = element_rect(fill = NA)) 
   p <- p + theme(axis.line = element_line(colour = "black"))
return(p)
}
#p

#plotOverview(1969,12)
plotArea <- function(start = 1969, num = 12) {
  xmin <- start
  xmax <- start + (num / 12)
  
  ymin <- 0
  ymax <- 4500
  
  p <- ggplot(molten, aes(x = time, y = value))
  p <- p + geom_area(
    data = subset(molten, variable %in% c("Total_Drivers","Front_Seat","Rear_Seat")),
    aes(
      group = variable,
      fill = variable,
      # not really necessary
      color = variable,
      # swap stacking order
      order = -as.numeric(variable)
    )
  )
  
  minor_breaks <- seq(
    floor(xmin), 
    ceiling(xmax), 
    by = 1/ 12)
  
  p <- p + scale_x_continuous(
    limits = c(xmin, xmax),
    expand = c(0, 0),
    oob = rescale_none,
    breaks = seq(floor(xmin), ceiling(xmax), by = 1),
    minor_breaks = minor_breaks)
  
  p <- p + scale_y_continuous(
    limits = c(ymin, ymax),
    expand = c(0, 0),
    breaks = seq(ymin, ymax, length.out = 5))
  
  p <- p + theme(axis.title = element_blank())
  
  p <- p + theme(
    legend.text = element_text(
      colour = "black",
      face = "bold"),
    legend.title = element_blank(),
    legend.background = element_blank(),
    legend.direction = "horizontal", 
    legend.position = c(0, 0.9),
    legend.justification = c(0, 0),
    legend.key = element_rect(
      fill = NA,
      colour = "white",
      size = 1))
  p <- p + theme(axis.text = element_text(colour="black",size=12))
  p <- p + theme(plot.background = element_rect(colour = 'black', fill = 'white', size = 1))
  p <- p + theme( panel.background = element_rect(fill = NA))  
  
  return(p)
}

#plotArea(1969,12)


plotCircleplot <- function(start = 1969, num = 12){

  p <- ggplot(
    subset(molten, variable == "DriversKilled"), 
    aes(x = month, y = year)
  )
  
  p <- p + geom_tile(
    aes(fill = value), 
    colour = "white"
  )
  p <-  p + xlab("Month")
  p <-  p + ylab("Year")
  p <- p + scale_y_discrete(expand = c(0, 0))
  
  #p <- p + coord_polar()
 
  p <- p +   scale_fill_gradientn(
    colours = brewer_pal(
      type = "div", 
      palette = "RdGy")(5),
    
    limits = c(0, 200),
    breaks = c(0, 100, 200)
  )
  p <- p + theme(legend.position = "bottom")
  p <- p + theme(legend.title = element_blank())
  p <- p + theme(legend.background = element_blank())
  p <- p + theme(legend.direction = "horizontal" )
  p <- p + theme(axis.text = element_text(colour="black",size=12))
  p <- p + theme(plot.background = element_rect(colour = 'black', fill = 'white', size = 1))
  p <- p + theme( panel.background = element_rect(fill = NA))  
  p <- p + ggtitle("Car Drivers Killed (1969-1984)")
  return(p)
}
#plotCircleplot()

plotMultiPlot<- function(start = 1969, num = 12)
{
  p <- ggplot(
    subset(molten, variable == "VanKilled"), 
    aes(
      x = month, 
      y = value, 
      group = year, 
      color = year
    )
  )
  
  
  p <- p + geom_line(alpha = 1)
  p <- p + scale_months()
  #p <- p + scale_deaths()
  p <- p + coord_polar()
  p <- p + theme_guide()
  
  p <- p + facet_wrap(~ year, ncol = 4)
  p <- p + theme(legend.position = "none")
  p <- p + theme(axis.text = element_text(colour="black",size=12))
  p <- p + theme(axis.text.x = element_text(colour="black",size=9))
  p <- p + theme(plot.background = element_rect(colour = 'black', fill = 'white', size = 1))
  p <- p + theme( panel.background = element_rect(fill = NA))  
  p <- p + ggtitle("Van Drivers Killed (1969-1984)")
  p <- p + ylab("Number of Deaths")
  p <- p + theme(axis.title.x=element_blank())
  
  
  return(p)
  
}

