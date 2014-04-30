library(ggplot2)
setwd("/home/deeksha/github/msan622/project-dataset")
data <- read.csv("COmpleteweatherdata.csv")
head(data)
data$Date <- as.character(data$Date)
data$Date <- as.Date(data$Date,"%Y%m%d")

require(reshape2) # melt
data$month <- format(data$Date,"%b")
data$year <- format(data$Date, "%Y")


molten <- melt(data, id = c("year", "month", "Date","City"))
head(molten)
plotOverview <- function(start=as.Date("2011-03-01","%Y-%m-%d"), num = 30 ) {
citydata  <- subset(molten, molten$City == "KNYC")
tempdata <- subset(citydata, variable %in% c("T","Td"))
xmin = as.Date("2011-03-01","%Y-%m-%d")
xmax <- xmin + num
ymax <- max(as.numeric(tempdata$value))
ymin <- min(as.numeric(tempdata$value))

p <- ggplot(citydata, aes(x = Date, y = as.numeric(value)))
p <- p + geom_line(data = tempdata ,
    aes(
      group = variable,      
      color = variable )
  )
p <- p + xlab("Date") +ylab("in degrees Fahrenheit")

rect <- data.frame (xmin, xmax, ymin, ymax)
p  <- p +  xlim(as.Date(c('1/3/2011', '1/1/2013'), format="%d/%m/%Y") )

p <- p + geom_rect(data=rect,
                     aes(xmin = xmin, xmax = xmax,
                         ymin = ymin, ymax = ymax),
                     color=grey, alpha=0.5, inherit.aes = FALSE)
  p <- p + theme(axis.text = element_text(colour="black",size=12))

  p <- p + theme(plot.background = element_rect(colour = 'black', fill = 'white', size = 1))
  p <- p + theme( panel.background = element_rect(fill = NA)) 
  p <- p + theme(axis.line = element_line(colour = "black"))
  return(p)
}

#plotOverview(as.Date("2011-03-01","%Y-%m-%d"), num = 30)


plotmonthly <- function(start = as.Date("2011-03-01","%Y-%m-%d"), num = 30) {
  citydata  <- subset(molten, molten$City == "KNYC")
  tempdata <- subset(citydata, variable %in% c("T","Td"))
  xmin <- as.Date("2011-03-01","%Y-%m-%d")
  xmax <- xmin + num
  ymax <- max(as.numeric(tempdata$value))
  ymin <- min(as.numeric(tempdata$value))
  
  p <- ggplot(citydata, aes(x = Date, y = as.numeric(value)))
  p <- p + geom_line(data = tempdata ,
                     aes(
                       group = variable,      
                       color = variable )
  )
  p <- p + xlab("Date") + ylab("in degrees Fahrenheit")
  
  p <- p + xlim(as.Date(c(start, start + 30 ), format="%m-%d-%Y") )
  
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

#plotmonthly(start,num)
