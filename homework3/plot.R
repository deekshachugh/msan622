df <- data.frame(state.x77,
                 State = state.name,
                 Abbrev = state.abb,
                 Region = state.region,
                 Division = state.division
)
head(df)

#Technique 1: Heatmap -or- Bubble Plot


df <- df[order(df$Population, decreasing = TRUE),]

# Create bubble plot
p <- ggplot(df, aes(x = Illiteracy, y = Murder, color = Region, size = Population))
p <- p + geom_point(alpha = 0.6, position = "jitter")
p <- p + scale_size_area(max_size = 20, guide = "none")
p <- p + theme(legend.title = element_blank())
p <- p + theme(legend.direction = "horizontal")
p <- p + theme(legend.position = c(0.4, 0))
p <- p + theme(legend.justification = c(0, 0))
p <- p + theme(legend.background = element_blank())
p <- p + theme(legend.key = element_blank())
p <- p + theme(legend.text = element_text(size = 12))
p<-p+theme(panel.grid.major = element_line(color = "grey90"),
             panel.background = element_rect(fill = NA))  

p<-p+theme(plot.background = element_rect(colour = 'black', 
                                          fill = 'white', size = 1))

p <- p + guides(colour = guide_legend(override.aes = list(size = 8)))
p <- p + ggtitle("Murder Rate by Illiteracy")
p <- p + labs(size = "Population",x = "Illiteracy", y = "Murder rate")
p <- p + theme(axis.text = element_text(colour="black",size=12))
p <- p +theme(axis.title = element_text(colour="black",size=14))

p
#Technique 2: Scatterplot Matrix -or- Small Multiples
library(scales)
localFrame <- df
p1 <-ggplot(localFrame,aes(Population, Murder))+geom_point(aes(colour=factor(Region)),alpha=0.5,size=2)
p1<-p1+theme(strip.text.x = element_text(size = 14, colour = "black",face="bold"),title=element_text(size=15))
#p1<-p1+theme(axis.text = element_text(colour="black",size=15))+aes(shape = factor(mpaa))
p1<-p1+theme(axis.text = element_text(colour="black",size=15))
p1
p1<-p1+xlab("Population") + ylab("Murder Rate")
p1<-p1+theme(title=element_text(size=15),
             #legend.title=element_text("Division"),
             legend.text=element_text(size=16),
             axis.title= element_text(size=15,face="bold"),
             axis.text = element_text(colour="black",size=14))


p1<-p1+theme(panel.grid.major = element_line(color = "grey90"),
                                         panel.background = element_rect(fill = NA)
)  

p1<-p1+theme(plot.background = element_rect(colour = 'black', fill = 'white', size = 1))
p1<-p1+theme(axis.line = element_line(color = "black"))
palette <- brewer_pal(type = "qual", palette = "Set1")(9)   
p1 <- p1 + scale_color_manual(values = palette, name ="Division")
p1
#Technique 3: Parallel Coordinates Plot
require(GGally)
head(df)
p <- ggparcoord(data = localFrame, 
                
                # Which columns to use in the plot
                columns = c(3,5,2),
                groupColumn =11,
                order = "anyClass",showPoints = FALSE, alphaLines = 0.6,shadeBox = NULL,scale = "uniminmax")

p <- p + theme_minimal()
p <- p + scale_y_continuous(expand = c(0.02, 0.02))
p <- p + scale_x_discrete(expand = c(0.02, 0.02))

# Remove axis ticks and labels
p <- p + theme(axis.ticks = element_blank())
p <- p + theme(axis.title = element_blank())
p <- p + theme(axis.text.y = element_blank(),axis.text.x = element_text(colour="black",size=14))

# Clear axis lines
p <- p + theme(panel.grid.minor = element_blank())
p <- p + theme(panel.grid.major.y = element_blank())

# Darken vertical lines
p <- p + theme(panel.grid.major.x = element_line(color = "#bbbbbb"))

# Move label to bottom
p <- p + theme(legend.position = "bottom", legend.text=element_text(size=14),legend.title=element_blank())
p
head(df)