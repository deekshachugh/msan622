require(tm)        # corpus
require(SnowballC) # stemming

library(tm)
library(ggplot2)
library(shiny)

library(scales)
#loading the states data
loadData1 <- function() {
  source("Obama.R")
  source("bush.R")
  bar_obama_df <- head(sotu_obama_df, 10)
  bar_obama_df$word <- factor(bar_obama_df$word, 
                              levels = bar_obama_df$word, 
                              ordered = TRUE)
  
  bar_bush_df <- head(sotu_bush_df, 10)
  bar_bush_df$word <- factor(bar_bush_df$word, 
                             levels = bar_bush_df$word, 
                             ordered = TRUE)
  
  bar_obama_df$name = "Obama"
  bar_bush_df$name = "Bush"
  df <- rbind(bar_obama_df,bar_bush_df)
  
  
  return(df)
}

loadData2 <- function() {
  speeches<-Corpus(DirSource("data"))
  #head(speeches)
  # Get word counts
  obama.wc<-length(unlist(strsplit(speeches[[1]], " ")))
  bush.wc<-length(unlist(strsplit(speeches[[2]], " ")))
  
  # Create a Term-Document matrix
  add.stops=c("applause","will", "can", "get", "that", "year", "let","must")
  speech.control=list(stopwords=c(stopwords(),add.stops), removeNumbers=TRUE, removePunctuation=TRUE)
  speeches.matrix<-TermDocumentMatrix(speeches, control=speech.control)
  
  # Create data frame from matrix
  speeches.df<-as.data.frame(inspect(speeches.matrix))
 
  speeches.df<-subset(speeches.df, obama.txt>0 & bush.txt>0)
  speeches.df<-transform(speeches.df, freq.dif=obama.txt-bush.txt)    
  
  
  ### Step 2: Create values for even y-axis spacing for each vertical
  #           grouping of word freqeuncies
  
  # Create separate data frames for each frequency type
  obama.df<-subset(speeches.df, freq.dif > 23)   # Said more often by Obama
  bush.df<-subset(speeches.df, freq.dif < -12)   # Said more often by Bush
  
  equal.df<-head(subset(speeches.df, freq.dif == 0),30)  # Said equally
  
  # This function takes some number as spaces and returns a vector
  # of continuous values for even spacing centered around zero
  optimal.spacing<-function(spaces) {
    if(spaces>1) {
      spacing<-1/spaces
      if(spaces%%2 > 0) {
        lim<-spacing*floor(spaces/2)
        return(seq(-lim,lim,spacing))
      }
      else {
        lim<-spacing*(spaces-1)
        return(seq(-lim,lim,spacing*2))
      }
    }
    else {
      return(0)
    }
  }
  
  # Get spacing for each frequency type
  obama.spacing<-sapply(table(obama.df$freq.dif), function(x) optimal.spacing(x))
  bush.spacing<-sapply(table(bush.df$freq.dif), function(x) optimal.spacing(x))
  equal.spacing<-sapply(table(equal.df$freq.dif), function(x) optimal.spacing(x))
  
  # Add spacing to data frames
  obama.optim<-rep(0,nrow(obama.df))
  for(n in names(obama.spacing)) {
    obama.optim[which(obama.df$freq.dif==as.numeric(n))]<-obama.spacing[[n]]
  }
  obama.df<-transform(obama.df, Spacing=obama.optim)
  
  bush.optim<-rep(0,nrow(bush.df))
  for(n in names(bush.spacing)) {
    bush.optim[which(bush.df$freq.dif==as.numeric(n))]<-bush.spacing[[n]]
  }
  bush.df<-transform(bush.df, Spacing=bush.optim)
  
  equal.df$Spacing<-as.vector(equal.spacing)
  obama.df$category <- "obama"
  bush.df$category <- "bush"
  equal.df$category <- "equal"
  data <- rbind(obama.df,bush.df,equal.df)
  return(data)
  
}
#assigning global value to data
barplotData <- loadData1()
clouddata <- loadData2()

#returns a bar plot
getbarplot <- function(localFrame ) {
  
  
  pallette <- c("#FF0000","#006400") 
  p <- ggplot(localFrame, aes(x = word, y= freq, fill = name)) +geom_bar(stat="identity")+scale_fill_manual(values = pallette)
  p<- p + ggtitle("State of the Union (Bush vs Obama)") 
  p <- p + xlab("Top 10 Word Stems (Stop Words Removed)") +
    ylab("Frequency") 
 
  p <- p + scale_x_discrete(expand = c(0, 0)) 
  p <- p + scale_y_continuous(expand = c(0, 0)) 
  p <- p + theme(panel.grid = element_blank()) 
  p <- p + theme(axis.ticks = element_blank()) 
  p <- p + theme(title=element_text(size=15),
               legend.title=element_blank(),
              
               axis.title= element_text(size=15,face="bold"),
               text = element_text(colour="white",size=14,face="bold"))
  
  p <- p + theme(legend.background = element_blank())
  p <- p + theme(panel.grid.major = element_line(color = "grey90"), panel.background = element_rect(fill = NA))
  p <-p +theme(plot.background = element_rect(colour = 'black', fill = 'black', size = 1))
  p <- p + theme(legend.position = c(0.9, 0.9))
  
  return(p)
}


getWordCloud <- function(localFrame_cloud){  
  obama.df <- subset(localFrame_cloud,localFrame_cloud$category == "obama")
  bush.df <- subset(localFrame_cloud,localFrame_cloud$category == "bush")
  equal.df <- subset(localFrame_cloud,localFrame_cloud$category == "equal")
  
  p <- ggplot(obama.df, aes(x=freq.dif, y=Spacing))+geom_text(aes(size=obama.txt, label=row.names(obama.df), color=freq.dif))+
    geom_text(data=bush.df, aes(x=freq.dif, y=Spacing, label=row.names(bush.df), size=bush.txt, color=freq.dif))+
    geom_text(data=equal.df, aes(x=freq.dif, y=Spacing, label=row.names(equal.df), size=obama.txt, color=freq.dif))+
    scale_size(range=c(3,11), name="Word Frequency")+scale_colour_gradient(low="darkgreen", high="red", guide="none")+
    scale_x_continuous(breaks=c(min(bush.df$freq.dif),0,max(obama.df$freq.dif)),labels=c("Said More by Bush","Said Equally","Said More by Obama"))+
    scale_y_continuous(breaks=c(0),labels=c(""))+xlab("")+ylab("")+
    theme(panel.grid.major=element_blank(),panel.grid.minor=element_blank())
 
  p <- p + theme(axis.ticks = element_blank()) 
  
  p <- p+theme(title=element_text(size=15),
               
               text=element_text(size=15,color="white",face="bold"),
               axis.title= element_text(size=15,face="bold"))
  
  
  p <- p+theme(panel.background = element_rect(fill = NA))
  p <-  p +theme(plot.background = element_rect(colour = 'black', fill = 'black'))
  p <- p + theme(legend.position = c(0.9, 0.9))
  
  
  
  p <- p + theme(legend.background = element_blank())
  
  
return(p)
}

getfreqplot<- function(localFrame)
{
  source("Obama.R")
  freq_df <- data.frame(
    sotu2013 = sotu_matrix[, "Obama2013.txt"],
    sotu2014 = sotu_matrix[, "Obama2014.txt"],
    stringsAsFactors = FALSE)
  
  rownames(freq_df) <- rownames(sotu_matrix)
  
  
  freq_df <- freq_df[order(
    rowSums(freq_df), 
    decreasing = TRUE),]
  
  freq_df <- head(freq_df, 20)
  
  p <- ggplot(freq_df, aes(sotu2013, sotu2014))
  
  p <- p + geom_text(
    label = rownames(freq_df),
    position = position_jitter(
      width = 2,
      height = 2),color="red", size = 10)
  
  p <- p + xlab("Frequency of Words - 2013") + ylab("Frequency of Words - 2014")
  p <- p + ggtitle("Obama (2014 vs 2013)")
  p <- p + theme(axis.line = element_line(colour = "white"),
                 panel.grid.major = element_blank(), panel.grid.minor = element_blank())
  
  
  
 # p <- p + coord_fixed(
  #  ratio = 5/6, 
   # xlim = c(0, 50),
  #  ylim = c(0, 50))
  
  p <- p+theme(title=element_text(size=15),
               legend.title=element_blank(),
               #legend.text=element_text(size=16),
               axis.title= element_text(size=15,face="bold"),
               text = element_text(colour="white",size=14,face="bold"))
  
  p <- p + theme(legend.background = element_blank())
  p <- p+theme( panel.background = element_rect(fill = NA))
  p <-  p +theme(plot.background = element_rect(colour = 'black', fill = 'black', size = 1))
  p <- p + theme(legend.position = c(0.9, 0.9))
  return(p)
}


shinyServer(function(input, output) {
  
  cat("Press \"ESC\" to exit...\n")
  
  localFrame <- barplotData
  localFrame_cloud <- clouddata
 
  output$barPlot <- renderPlot(
{ barPlot <- getbarplot(localFrame)
  print(barPlot)
}
  )
  
  output$wordCloud <- renderPlot(
{ 
  wordCloud <- getWordCloud(clouddata)
  print(wordCloud)
})

output$freqplot <- renderPlot(
{ freqplot <- getfreqplot(localFrame)
  print(freqplot)
})

})

