library(ggplot2)
library(ggmap)
library(maps)

data <- read.csv("/home/deeksha/github/msan622/project-prototype/weatherdata.csv")

data <- data[,2:ncol(data)]
data[,4] <- round(as.numeric(levels(data[,4]))[data[,4]],1)
data[,5] <- round(as.numeric(levels(data[,5]))[data[,5]],1)
data[,6] <- round(as.numeric(levels(data[,6]))[data[,6]],1)
data[,7] <- round(as.numeric(levels(data[,7]))[data[,7]],1)
data$Date <- as.character(data$Date)
data$Date <- as.Date(data$Date,"%Y%m%d")

require(reshape2) # melt
data$month <- format(data$Date,"%b")
data$year <- format(data$Date, "%Y")


molten <- melt(data, id = c("year", "month", "Date", "City", "CityCode",
                            "Latitude", "Longitude"))
molten$value <- round(as.numeric(molten$value),1)

plotOverview <- function(start = as.Date("2011-03-01","%Y-%m-%d"),
                         num = 30,
                         city = "Houston,Tx") {
  citydata  <- subset(molten, molten$City == city)
  tempdata <- subset(citydata, variable %in% c(
    "Temperature","Dew.Point.Temperature"))

  xmin = as.Date("2011-03-01","%Y-%m-%d")
  xmax <- xmin + num
  ymax <- max(as.numeric(tempdata$value))
  ymin <- min(as.numeric(tempdata$value))

  p <- ggplot(citydata, aes(x = Date, y = as.numeric(value)))
  p <- p + geom_line(data = tempdata,
                     aes(group = variable, color = variable))
  p <- p + xlab("Date") +ylab("In Fahrenheit")

  rect <- data.frame (xmin, xmax, ymin, ymax)
  p  <- p +  xlim(as.Date(c("1/3/2011", "31/1/2013"), format = "%d/%m/%Y"))

  p <- p + geom_rect(data = rect,
                     aes(xmin = xmin, xmax = xmax,
                         ymin = ymin, ymax = ymax),
                     color = grey, alpha = 0.5, inherit.aes = FALSE)
  p <- p + theme(axis.text = element_text(colour = "black",size = 12))

  p <- p + theme(plot.background = element_rect(
    colour = "black", fill = "white", size = 1))
  p <- p + theme(panel.background = element_rect(fill = NA))
  p <- p + theme(axis.line = element_line(colour = "black"))
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
  return(p)
}
#plotOverview(as.Date("2011-03-01","%Y-%m-%d"), num = 30)


plotMonthly <- function(start = as.Date("2011-03-01","%Y-%m-%d"),
                        num = 30,
                        city = "Houston,Tx") {
  citydata  <- subset(molten, molten$City == city)
  tempdata <- subset(citydata,
                     variable %in% c("Temperature","Dew.Point.Temperature"))
  xmin <- as.Date("2011-03-01","%Y-%m-%d")
  xmax <- xmin + num
  ymax <- max(as.numeric(tempdata$value))
  ymin <- min(as.numeric(tempdata$value))

  p <- ggplot(citydata, aes(x = Date, y = as.numeric(value)))
  p <- p + geom_line(data = tempdata ,
                     aes(group = variable, color = variable))
  p <- p + xlab("Date") + ylab("In Fahrenheit")

  p <- p + xlim(as.Date(c("2011-03-01", "2011-04-01"), format = "%Y-%m-%d"))

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
  p <- p + theme(axis.text = element_text(colour = "black",size = 12))
  p <- p + theme(plot.background = element_rect(
    colour = "black", fill = "white", size = 1))
  p <- p + theme(panel.background = element_rect(fill = NA))
  p <- p + theme(axis.line = element_line(colour = "black"))
  return(p)
}
#plotmonthly(start,num)


plotbar <- function(city){
  molten$month <- factor(molten$month, levels = c(
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))
  precipdata  <- subset(
    molten, variable == "Precipitation" & year == "2013" & City == city)
  aggdata <- aggregate(as.numeric(precipdata$value),
                       by = list(precipdata$month), sum)
  p <- ggplot(aggdata, aes(x = Group.1, y = x))
  p <- p + geom_bar(stat = "identity", fill = "lightblue")
  p <- p + scale_y_discrete(expand = c(0, 0))
  p <- p + ylab("Rainfall (in mm)")
  p <- p + ggtitle("Precipitation (2013)")
  p <- p + theme(axis.text = element_text(colour = "black", size = 12))
  p <- p + theme(plot.background = element_rect(
    colour = "black", fill = "white", size = 1))
  p <- p + theme(panel.background = element_rect(fill = NA))
  p <- p + theme(axis.line = element_line(colour = "black"))
  p <- p + theme(axis.title.x = element_blank())
  return(p)
}




plotmap <- function(date = "2012-01-21", variable = 'Temperature') {
  # Load us map data
  print(c(date, variable))
  #browser()
  all_states <- map_data("state")
  p <- ggplot()
  p <- p + geom_polygon(data = all_states,
                        aes(x = long, y = lat, group = group),
                        fill = "grey",color="black")
  subdata <- subset(data, data$Date == date)
  #subdata$Temperature <- paste(subdata$Temperature, "F", sep = " ")
  p <- p + geom_point(data = subdata,aes_string(x = "Longitude", y = "Latitude",color= variable),size=10
                      )
  #browser()
 # p <- p + geom_text(data = subdata, hjust = -0.9, vjust = 0.9, aes_string(
#    x = "Longitude", y = "Latitude", label = variable), colour = "black",
#    size = 5)
  
  p <- p + ggtitle("United States Overview")
  p <- p + theme(axis.title = element_blank())
  p <- p + theme(axis.ticks = element_blank())
  p <- p + theme(axis.text = element_blank())
  p <- p + theme(panel.grid = element_blank())
  p <- p + theme(panel.background = element_rect(fill= 'black'))
  p <- p + scale_color_gradient(low="yellow", high = 'red', guide = guide_colorbar(direction = "vertical"))
  return(p)
}
#plotmap()
