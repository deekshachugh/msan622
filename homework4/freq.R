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
head(freq_df)
# Plot frequencies
p <- ggplot(freq_df, aes(sotu2013, sotu2014))

p <- p + geom_text(
  label = rownames(freq_df),
  position = position_jitter(
    width = 2,
    height = 2),color="red")

p <- p + xlab("Year 2013") + ylab("Year 2014")
p <- p + ggtitle("State of the Union")
p <- p + theme(axis.line = element_line(colour = "white"),
  panel.grid.major = element_blank(), panel.grid.minor = element_blank())



p <- p + coord_fixed(
  ratio = 5/6, 
  xlim = c(0, 50),
  ylim = c(0, 50))

p <- p+theme(title=element_text(size=15),
             legend.title=element_blank(),
             #legend.text=element_text(size=16),
             axis.title= element_text(size=15,face="bold"),
             text = element_text(colour="white",size=14,face="bold"))

p <- p + theme(legend.background = element_blank())
p <- p+theme( panel.background = element_rect(fill = NA))
p <-  p +theme(plot.background = element_rect(colour = 'black', fill = 'black', size = 1))
p <- p + theme(legend.position = c(0.9, 0.9))
print(p)
