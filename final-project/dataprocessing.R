data <- read.csv("/home/deeksha/github/msan622/project-dataset/COmpleteweatherdata.csv")
head(data)
colnames(data) <- c("Date", "Temperature", "Dew Point Temperature","Precipitation","Humidity","Wind Speed","Percent Cloud Cover", "City")

latlongdata <- read.csv("/home/deeksha/Desktop/airports/airports_fsx_icao_lat_lon_alt_feet.txt",header=F)
head(latlongdata)
colnames(latlongdata) <- c("City","Latitude","Longitude","x")
library(plyr)
joineddata1 <- join(data, latlongdata[,1:3], by = "City")
head(joineddata1)

mapping <- read.csv("/media/deeksha/e/Deeksha/Dropbox/Coursework/PracticumIII/Data/MappingCityCOde.csv",header =F)

head(mapping)
names(mapping)<-c("CityCode","City")
library(plyr)
joineddata <- join(joineddata1, mapping[,1:2], by = "City")
head(joineddata)
#joineddata <- joineddata[,c(1:7,9:11)]

ncol(joineddata)
colnames(joineddata)[8] <- "CityCode"
colnames(joineddata)[11] <- "City"
joineddata <- joineddata[!is.na(joineddata$City),]
write.csv(joineddata,"/home/deeksha/github/msan622/project-prototype/weatherdata.csv")

summary(joineddata)
