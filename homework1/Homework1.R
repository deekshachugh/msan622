library(ggplot2) 
library("RColorBrewer")
library(reshape)

#specify the path where you want to save the plots
setwd("/home/deeksha/github/msan622/homework1")

#dataset
data(movies)
data(EuStockMarkets)

#removing all the rows where budget is less than or equal to zero
movies<-subset(movies, movies$budget>0)

#creating column genre based their class
genre <- rep(NA, nrow(movies))
count <- rowSums(movies[, 18:24])
genre[which(count > 1)] = "Mixed"
genre[which(count < 1)] = "None"
genre[which(count == 1 & movies$Action == 1)] = "Action"
genre[which(count == 1 & movies$Animation == 1)] = "Animation"
genre[which(count == 1 & movies$Comedy == 1)] = "Comedy"
genre[which(count == 1 & movies$Drama == 1)] = "Drama"
genre[which(count == 1 & movies$Documentary == 1)] = "Documentary"
genre[which(count == 1 & movies$Romance == 1)] = "Romance"
genre[which(count == 1 & movies$Short == 1)] = "Short"
movies<-cbind(movies,genre)
movies$budgetmillions<-movies$budget/1000000
#creating the timeseries object in dataset
eu <- transform(data.frame(EuStockMarkets), time = time(EuStockMarkets))

#Plot1
p1<-ggplot(movies,aes(budgetmillions,rating))+geom_point(aes(colour=factor(genre)))
                                                      
p1<-p1+theme(axis.text = element_text(colour="black",size=15))
p1<-p1+xlab("Movie Budget (in millions)")+ylab("Rating of the Movie")
p1<-p1+ggtitle("Rating of movies by budget")
p1<-p1+theme(title=element_text(size=15),legend.title=element_blank(),legend.text=element_text(size=12),axis.title= element_text(size=15,face="bold"),axis.text = element_text(colour="black",size=14))
p1<-p1+labs(fill = "Movie Genres")+theme(legend.position=c(.55,0.965),legend.direction="horizontal")

#using color blind friendly pallete
palette1 <- c("#e41a1c","#377eb8", "#4daf4a", "#984ea3", "#ff7f00", "#ffff33", "#a65628", "#999999", "#f781bf")
p1 <- p1 + scale_colour_manual(values = palette1)
print(p1)
ggsave(p1,file="hw1-scatter.png")

#plot2
movies$genre <- factor(movies$genre, levels=c("Mixed", "Drama", "None","Comedy","Action","Short","Documentary","Romance","Animation"))
p1<-ggplot(movies,aes(genre,fill = genre))+geom_histogram(fill="blue",color="black",binwidth = 0.5)
p1<-p1+theme(axis.text = element_text(colour="black",,size=15))+xlab("Genre")+ylab("Total Count")
p1<-p1+theme(title=element_text(size=15),legend.title=element_text(size=15),legend.text=element_text(size=12),axis.title= element_text(size=15),axis.text = element_text(colour="black",size=14,face="bold"))
p1<-p1+ggtitle("Number of movies by genre")+theme(axis.ticks.x = element_blank(),panel.grid.minor.y = element_blank())+theme(panel.grid.major.x = element_blank(),axis.title.x = element_blank())
p1<-p1+scale_y_continuous(expand = c(0, 20))
print(p1)
ggsave("hw1-bar.png")

#plot3
Genre<-factor(genre)
p1<-ggplot(movies,aes(budgetmillions,rating))+geom_point(color="blue")+facet_wrap(~genre)

p1<-p1+theme(axis.text = element_text(colour="black",,size=15))+xlab("Budget (in Millions)")+ylab("Rating")

p1<-p1+theme(strip.text.x = element_text(size = 14, colour = "black",face="bold"),title=element_text(size=15),legend.position="none",axis.title= element_text(size=15,face="bold"),axis.text = element_text(colour="black",size=14))
p1<-p1+theme(legend.position="none")
p1<-p1+ggtitle("Rating of different genre movies by budget")
print(p1)
ggsave("hw1-multiples.png")

#plot4

pricedata<-melt(eu[,1:4])
timevector<-c(time=eu[,5])
time<-(rep(timevector,4))
prices_time_data<-data.frame(pricedata,time)
names(prices_time_data)[1]<-"Prices"
p1<-ggplot(prices_time_data,aes(time,value,color=Prices))+geom_line()
p1<-p1+theme(axis.title= element_text(size=15,face="bold"),axis.text = element_text(colour="black",size=14))+xlab("Year")+ylab("Price")
p1<-p1+scale_x_continuous(breaks = seq(min(prices_time_data$time)-0.496, max(prices_time_data$time), by = 1))
p1<-p1+theme(title=element_text(size=15),legend.title=element_text(size=15),legend.text=element_text(size=12),axis.title= element_text(size=15,face="bold"),axis.text = element_text(colour="black",size=14,face="bold"))
p1<-p1+ggtitle("Index Prices over Time")
print(p1)

ggsave("hw1-multiline.png")