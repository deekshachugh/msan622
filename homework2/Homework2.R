library(ggplot2) 
data(movies) 
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
movies<-subset(movies, movies$budget>0)
unique(movies$mpaa)
movies<-subset(movies, movies$mpaa != "")
nrow(movies)
movies$budgetmillions<-movies$budget/1000000
p1<-ggplot(movies,aes(budgetmillions,rating))+geom_point(aes(colour=factor(mpaa)))
p1<-p1+theme(axis.text = element_text(colour="black",size=15))
p1<-p1+xlab("Movie Budget (in millions)")+ylab("Rating of the Movie")
p1<-p1+ggtitle("Rating of movies by budget")
p1<-p1+theme(title=element_text(size=15),legend.title=element_blank(),legend.text=element_text(size=12),axis.title= element_text(size=15,face="bold"),axis.text = element_text(colour="black",size=14))
p1<-p1+labs(fill = "Movie Genres")+theme(legend.position=c(.55,0.965),legend.direction="horizontal")
