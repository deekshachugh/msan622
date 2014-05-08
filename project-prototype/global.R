library(ggplot2)
library(ggmap)
library(maps)
library(randomForest)

weather_data <- read.csv("weatherdata.csv",row.names=NULL)
head(weather_data)
weather_data <- weather_data[,2:ncol(weather_data)]
#str(weather_data)
weather_data[,4] <- round(as.numeric(levels(weather_data[,4]))[weather_data[,4]],2)
weather_data[,5] <- round(as.numeric(levels(weather_data[,5]))[weather_data[,5]],1)
weather_data[,6] <- round(as.numeric(levels(weather_data[,6]))[weather_data[,6]],1)
weather_data[,7] <- round(as.numeric(levels(weather_data[,7]))[weather_data[,7]],1)
weather_data$Date <- as.character(weather_data$Date)
weather_data$Date <- as.Date(weather_data$Date,"%Y%m%d")

require(reshape2) # melt
weather_data$month <- format(weather_data$Date,"%b")
weather_data$year <- format(weather_data$Date, "%Y")


molten <- melt(weather_data, id = c("year", "month", "Date", "City", "CityCode",
                            "Latitude", "Longitude"))
molten$value <- round(as.numeric(molten$value),1)

plotOverview <- function(dateRange = c(as.Date("2011-03-01","%Y-%m-%d"),
                         as.Date("2014-01-31","%Y-%m-%d")),
                         city = "Houston,Tx") {
  citydata  <- subset(molten, molten$City == city)
  tempdata <- subset(citydata, variable %in% c(
    "Temperature","Dew.Point.Temperature"))
  
  
  
  
  p <- ggplot(citydata, aes(x = Date, y = as.numeric(value)))
  p <- p + geom_line(data = tempdata,
                     aes(group = variable, color = variable))
  p <- p + xlab("Date") +ylab("In Fahrenheit")
  
  
  p  <- p +  xlim(as.Date(c(dateRange[1],dateRange[2]),format = "%Y-%m-%d"))
  
  
  p <- p + theme(axis.text = element_text(colour = "black",size = 14,face= "bold"))
  
  p <- p + theme(plot.background = element_rect(
    colour = "black", fill = "white", size = 1))
  p <- p + theme(panel.background = element_rect(fill = NA))
  p <- p + theme(axis.line = element_line(colour = "black"))
  p <- p + theme(
    legend.text = element_text(
      colour = "black",
      face = "bold",size = 12),
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


plotbar <- function(city = "Houston,Tx"){
  
  molten$month <- factor(molten$month, levels = c(
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))
  precipdata  <- subset(
    molten, variable == "Precipitation" & year == "2013" & City == city)
  totaldata  <- subset(
    molten, variable == "Precipitation" & year == "2013")
  city_aggdata <- aggregate(precipdata$value,
                            by = list(precipdata$month), sum)
  total_aggdata <- aggregate(totaldata$value,
                             by = list(totaldata$month), sum)
  total_aggdata$x <- total_aggdata$x/length(unique(molten$City))
  avg_data <- data.frame("Average RainFall",total_aggdata$Group.1,total_aggdata$x)
  colnames(avg_data) <- c("Rainfall","Month","Value")
  city_data <- data.frame("RainFall",city_aggdata$Group.1,city_aggdata$x)
  colnames(city_data) <- c("Rainfall","Month","Value")
  final_data <- rbind(avg_data,city_data)
  p <- ggplot(final_data, aes(x = Month, y = Value,fill = Rainfall))
  p <- p + geom_bar(stat = "identity" ,position=position_dodge(),colour="black")
  p <- p + scale_fill_manual(values=c("lightblue", "darkblue"))
  p <- p + scale_y_discrete(expand = c(0, 0))
  p <- p + ylab("Rainfall (in mm)")
  p <- p + ggtitle("Monthly Rainfall - 2013")
  p <- p + theme(axis.text = element_text(colour = "black", size = 12))
  p <- p + theme(plot.background = element_rect(
    colour = "black", fill = "white", size = 1))
  p <- p + theme(panel.background = element_rect(fill = NA))
  p <- p + theme(axis.line = element_line(colour = "black"))
  p <- p + theme(axis.title.x = element_blank())
  p <- p + theme(legend.title = element_blank())
  p <- p + theme(legend.position = c(0.2, 0.9))
  p <- p + theme(legend.text = element_text(size=14))
  
  
  return(p)
}
#plotbar("Houston,Tx")


plotmap <- function(date = "2012-01-21", variable = "Temperature") {
  # Load us map data
  
  #browser()
  all_states <- map_data("state")
  p <- ggplot()
  p <- p + geom_polygon(data = all_states,
                        aes(x = long, y = lat, group = group),
                        fill = "black",color="white")
  subdata <- subset(weather_data, weather_data$Date == date)
  #subdata$Temperature <- paste(subdata$Temperature, "F", sep = " ")
  p <- p + geom_point(data = subdata,
                      aes_string(x = "Longitude",
                                 y = "Latitude",
                                 color= variable),
                      size=9,
                      alpha = 0.8
  )
  #browser()
  # p <- p + geom_text(data = subdata, hjust = -0.9, vjust = 0.9, aes_string(
  #    x = "Longitude", y = "Latitude", label = variable), colour = "black",
  #    size = 5)
  
  p <- p + ggtitle("United States Overview - 54 citites")
  p <- p + theme(plot.title=element_text(family="Times", face="bold", size=20))
  p <- p + theme(axis.title = element_blank())
  p <- p + theme(axis.ticks = element_blank())
  p <- p + theme(axis.text = element_blank())
  p <- p + theme(panel.grid = element_blank())
  p <- p + theme(panel.background = element_rect(fill = "white"))
  p <- p + theme(legend.title = element_text(size = 12))
  p <- p + theme(legend.position = c(0.2, 0.2))
  
  if(variable == "Temperature"){
    p <- p + scale_color_gradient(low = "yellow", high = "red")       
  } else if(variable == "Humidity"){
    p <- p + scale_color_gradient(low = "lightblue", high = "blue")
  } else if(variable == "Dew.Point.Temperature"){
    p <- p + scale_color_gradient(low = "yellow", high = "red")       
  } else if(variable == "Percent.Cloud.Cover"){
    p <- p + scale_color_gradient(low = "lightblue", high = "blue")    
  } else if(variable == "Wind.Speed"){
    p <- p + scale_color_gradient(low="grey", high = "blue")       
  }
  p <- p + theme(legend.direction = "horizontal")
  return(p)
}
plotmap(date = "2012-07-21", variable = "Humidity")


modelPlot <- function(city = "Houston,Tx")
{
  citydata<- subset(weather_data, City == city)
  
  subcitydata <- citydata[366:nrow(citydata),]
  last_year_temp <- citydata$Temperature[1:727]
 
  lagged_data <- data.frame(subcitydata,last_year_temp)
  
  model <- randomForest(Temperature~last_year_temp+ Dew.Point.Temperature+Precipitation+Humidity+Percent.Cloud.Cover, data= lagged_data)
  predicted <- predict(model)
  actual <- lagged_data$Temperature
  
  modeldata <- data.frame(lagged_data$Date, actual, predicted)
  model_data <- melt(modeldata,id="lagged_data.Date")
  p <- ggplot(data = model_data ) + geom_line(aes(x= lagged_data.Date,y = value,color=variable))
  
  p <- p + ylab("Temperature (In Fahreinheit)") + xlab("Date")
  p <- p + theme(axis.text = element_text(colour = "black",size = 14))
  
  p <- p + theme(plot.background = element_rect(
    colour = "black", fill = "white", size = 1))
  p <- p + theme(panel.background = element_rect(fill = NA))
  
  p <- p + theme(axis.line = element_line(colour = "black"))
  p <- p + theme(
    legend.text = element_text(
      colour = "black",
      face = "bold",size = 12),
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
#modelPlot("Houston,Tx")
