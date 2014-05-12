library(ggplot2)
library(ggmap)
library(maps)
library(randomForest)
library(RCurl)
library(GGally)
x <- getURL("http://deekshachugh.github.io/misc/weatherdata.csv")
#x <- getURL("https://raw.githubusercontent.com/deekshachugh/msan622/master/project-prototype/weatherdata.csv")
weatherdata <- read.csv(text = x)
#weatherdata <- read.csv("/home/deeksha/github/msan622/project-prototype/data/weatherdata.csv")
weather_data <- weatherdata[,2:ncol(weatherdata)]

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
molten$value <- round(as.numeric(molten$value),2)

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
                                 color = variable),
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
    p <- p + scale_color_gradient(low = "grey", high = "blue")
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
  predicted_temperature <- predict(model)
  actual_temperature <- lagged_data$Temperature
  
  modeldata <- data.frame(lagged_data$Date, actual_temperature, predicted_temperature)
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

parallelPlot <- function(city = "Houston,Tx", season1 = "Summer"){
  city_data <- subset(weather_data, City ==city)
  year_data <- subset(city_data, year =="2013")
  
  year_data$season<-ifelse(year_data$month %in% c("Mar","Apr","May"),"Spring",
                           ifelse(year_data$month %in% c("Jun","Jul","Aug"),"Summer",
                                  ifelse(year_data$month %in% c("Sep","Oct","Nov"),"Autumn",
                                         ifelse(year_data$month %in% c("Dec","Jan","Feb"),"Winter",""))))
  year_data$season <- as.factor(year_data$season)
  p <- ggparcoord(data = year_data, 
                  columns = c(2,3,5,7),
                  groupColumn =ncol(year_data),
                  scale = "uniminmax",
                  shadeBox = NULL) 
  factor_season <- c("Autumn","Spring","Summer","Winter")
  palette <- c("#E41A1C", "#377EB8", "#4DAF4A" ,"#984EA3")
#   if(length(season1) == 0 | length(season1) == 4) {
#     palette <- brewer_pal(type = "qual", palette = "Set1")(4)   
#     p <- p + scale_color_manual(values = palette)
#     
#   } else {
#     l <- length(season1)
#     
#     palette <- brewer_pal(type = "qual", palette = "Set1")(l)
#     palette <- append(palette, c(rep("black",times=4-l)))
#     p <- p + scale_color_manual(values = palette)
#     }
#  
col <- data.frame(color = palette,factor_season)
col$newcolor <- rep("d",times=4)
#col$aplha <-rep("d",times=4)
for(i in 1:nrow(col)){
  if(col[i,"factor_season"] %in% season1){
   
    d <- as.character(col[i,"color"])
    col[i,"newcolor"] <- d
    #col[i,"alpha"] <- 1
    
  }
  else{
   
    col[i,"newcolor"] <- "grey"
   # col[i,"alpha"] <- 0.2
  }
  
}

p <- p + scale_color_manual(values = col$newcolor)
  
p <- p + ggtitle("Seasonal Trend - 2013")

p <-p+theme(panel.grid.major = element_line(color = "grey90"),
             panel.background = element_rect(fill = NA))  
p <-p+theme(plot.background = element_rect(colour = 'black', 
                                            fill = 'white', size = 1))
  
  p <- p + scale_y_continuous(expand = c(0.02, 0.02))
  p <- p + scale_x_discrete(expand = c(0.02, 0.02))
  # Remove axis ticks and labels
  p <- p + theme(axis.ticks = element_blank(),legend.key = element_rect(fill = "transparent"),
                 legend.background = element_rect(fill = "transparent"))
  min_y <- min(p$data$value)
  max_y <- max(p$data$value)
  pad_y <- (max_y - min_y) * 0.1  
  lab_x <- rep(1:4, times = 2)
  lab_y <- rep(c(min_y - pad_y, max_y + pad_y), each = 4)
  
  # Get min and max values from original dataset
  lab_z <- c(sapply(year_data[, c(2,3,5,7)], min), sapply(year_data[, c(2,3,5,7)], max))
  # Convert to character for use as labels
  lab_z <- as.character(lab_z)
  # Add labels to plot
  p <- p + annotate("text", x = lab_x, y = lab_y, label = lab_z, size = 5, color ="black")
  p <- p + theme(text = element_text(colour="black",size=14))
  
  p <- p + theme(axis.title = element_blank())
  
  p <- p + theme(axis.text.y = element_blank())
  # Clear axis lines
  p <- p + theme(panel.grid.minor = element_blank())
  p <- p + theme(panel.grid.major.y = element_blank())
  # Darken vertical lines
  p <- p + theme(panel.grid.major.x = element_line(color = "black"))
  p
  return(p)
}
