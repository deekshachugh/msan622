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


#assigning global value to data
barplotData <- loadData1()

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
  p <- p + theme(plot.background = element_rect(colour = 'black', fill = 'black', size = 1))
  p <- p + theme(legend.position = c(0.9, 0.9))
  return(p)
}


getWordCloud <- function(localFrame_cloud)
{ 
  source("data.R")
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
  p <- p + theme(panel.background = element_rect(fill = NA))
  p <- p + theme(plot.background = element_rect(colour = 'black', fill = 'black'))
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
  output$barPlot <- renderPlot(
{ barPlot <- getbarplot(localFrame)
  print(barPlot)
}
  )

output$wordCloud <- renderPlot(
{ 
  wordCloud <- getWordCloud(localFrame)
  print(wordCloud)
  
})

output$freqplot <- renderPlot(
{ freqplot <- getfreqplot(localFrame)
  print(freqplot)
})

})
