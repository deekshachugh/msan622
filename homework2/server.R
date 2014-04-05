library(ggplot2)
library(shiny)
library(scales)

#data to be considered
data(movies) 

head(movies)
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

#reading the data 
globalData <- loadData()

getPlot <- function(localFrame, highlight, alphasize, dotsize, GenreSelection, colorScheme) {
  if(length(GenreSelection) == 0) {
    localFrame <-localFrame # None is selected
  } else {
    localFrame<-subset(localFrame,localFrame$genre %in% GenreSelection) 
  }
  if(highlight == "All") {
    localFrame <-localFrame # None is selected
  } else {
    number <- as.numeric(substring(highlight,1,4))
    localFrame<-subset(localFrame, year >= number)
  }
  #p1<-ggplot(localFrame,aes(budgetmillions,rating))+geom_point(aes(colour=factor(mpaa)),alpha=alphasize,size=dotsize,position = position_jitter())
  p1<-ggplot(localFrame,aes(budgetmillions,rating))+geom_point(aes(colour=factor(mpaa)),alpha=alphasize,size=dotsize)+facet_wrap(~mpaa)
  p1<-p1+theme(strip.text.x = element_text(size = 14, colour = "black",face="bold"),title=element_text(size=15))
  #p1<-p1+theme(axis.text = element_text(colour="black",size=15))+aes(shape = factor(mpaa))
  p1<-p1+theme(axis.text = element_text(colour="black",size=15))
  
  p1<-p1+xlab("Movie Budget (in millions)")+ylab("Rating of the Movie")
  p1<-p1+theme(title=element_text(size=15),
               legend.title=element_blank(),
               legend.text=element_text(size=16),
               axis.title= element_text(size=15,face="bold"),
               axis.text = element_text(colour="black",size=14))
  

  p1<-p1+labs(fill = "Movie Genres")+theme(panel.grid.major = element_line(color = "grey90"),
                                           panel.background = element_rect(fill = NA)
  )  
  
  p1<-p1+theme(plot.background = element_rect(colour = 'black', fill = 'white', size = 1))
  p1<-p1+theme(axis.line = element_line(color = "black"),legend.position="none")
  p1<-p1+scale_x_continuous(labels = dollar)
  palette <- brewer_pal(type = "qual", palette = colorScheme)(4)   
  p1 <- p1 +scale_color_manual(values = palette)
  return(p1)
}


shinyServer(function(input, output) {
  
  cat("Press \"ESC\" to exit...\n")
  localFrame <- globalData
  

  getHighlight <- reactive({
    #result <- levels(localFrame$mpaa)    
    
    return(input$highlight)
    
  })
  
  getGenreSelected<- reactive({
    result <- levels(localFrame$genre)
    return(result[which(result %in% input$GenreSelection)])
  })
  
  output$scatterplot <- renderPlot({
    print(getPlot(localFrame,getHighlight(),input$alphasize, input$dotsize,getGenreSelected(),input$colorScheme),width =400,height=800)
  })
})
