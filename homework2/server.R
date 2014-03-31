library(ggplot2)
library(shiny)
library(scales)

data(movies) 


loadData <- function() {
  data("movies", package = "ggplot2")
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
  movies$budgetmillions<-movies$budget/1000000
  df<-subset(movies, movies$mpaa != "")
  
  return(df)
}

getPlot <- function(localFrame,highlight,GenreSelection) {
  p1<-ggplot(localFrame,aes(budgetmillions,rating))+geom_point(aes(colour=factor(mpaa)))
  p1<-p1+theme(axis.text = element_text(colour="black",size=15))
  p1<-p1+xlab("Movie Budget (in millions)")+ylab("Rating of the Movie")
  p1<-p1+ggtitle("Rating of movies by budget")
  p1<-p1+theme(title=element_text(size=15),legend.title=element_blank(),legend.text=element_text(size=12),axis.title= element_text(size=15,face="bold"),axis.text = element_text(colour="black",size=14))
  p1<-p1+labs(fill = "Movie Genres")+theme(legend.position=c(.55,0.965),legend.direction="horizontal")
  
  palette <- brewer_pal(type = "qual", palette = "Set1")(5)
  Mpaa <- levels(localFrame$mpaa)
  Genre <- levels(localFrame$genre)
  palette[which(!Mpaa %in% highlight)] <- "#EEEEEE"
  palette[which(!Genre %in% GenreSelection)] <- "#EEEEEE"
  
  p1 <- p1 + scale_color_manual(values = palette)
  
  return(p1)
}

shinyServer(function(input, output) {
  
  cat("Press \"ESC\" to exit...\n")
  localFrame <- globalData
  
  # Choose what having no species selected should mean.
  getHighlight <- reactive({
    result <- levels(localFrame$mpaa)
    #         if(length(input$highlight) == 0) {
    #             return(result)
    #         }
    #         else {
    return(result[which(result %in% input$highlight)])
    #         }
  })
  
  getGenreSelected<- reactive({
    result <- levels(localFrame$genre)
    return(result[which(result %in% input$GenreSelection)])
  })
  output$scatterplot <- renderPlot({
    print(getPlot(localFrame,getHighlight(),getGenreSelected()))
  })
})
