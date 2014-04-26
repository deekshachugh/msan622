Homework [5]: Time Series Visualization
==============================

| **Name**  | Deeksha Chugh  |
|----------:|:-------------|
| **Email** | dchugh@dons.usfca.edu |

## Instructions ##
The following packages must be installed prior to running this code:
```

library(reshape) 
library(scales) 
library(ggplot2)
library(shiny)
library(grid)       
```
To run this code, please enter the following commands in R:
```
library(shiny)
shiny::runGitHub('msan622', 'deekshachugh', subdir = 'homework5')
```
## Discussion ##

###Deaths###
Here is the screenshot:
![IMAGE](Overview.png)

The above plot shows the number of total driver deaths, front-seat passengers killed or seriously injured and rear-seat passengers killed or seriously injured. The plot shows the decline in number of deaths of front seat passengers after the law was introduced whereas the it has not much effect on back seat passengers.

The plot has two components. The upper part of the graph is the zoom in version of the overview plot below. The overview plot is a multiline plot showing the number of deaths. It also has an arrow which points to the time period when the seat belt law in UK was introduced. I changed the axes color to black and increased its size to increase readibility. The legend of the plot is moved on to the top of the plot to save space.  

Interactivity
On the left side of the panel, you can play the starting point slider to show animated view. You could also select the amount of months you want a view in a particular given time.

###Car Drivers Killed###
Here is the screenshot:
![IMAGE](heatmap.png)

The heatmap shows the car drivers killed in each of the years and months. A divergent color scheme is used to represent the number of deaths of car drivers. We can see a lot of reds after 1983 showing a decline in number of car drivers deaths.  I changed the axes color to black and increased its size to increase readibility. The legend of the plot is moved on to the bottom of the plot and its direction is changed to horizontal.

The plot also shows a lot dark grey in decemeber month representing high number of deaths. We can also see in the year 1977, during feb and march the number of deaths drastically declined. This plot helps in identification of unusual trends in the data.

###Van Drivers Killed###
Here is the screenshot:
![IMAGE](starplot.png)

The above plot shows the number of van drivers killed during all these years. I made a star plot because its easier to see the area between the star getting decreased in the latter years. If we make a line plot then the inference is difficult to make as its all over the place. I changed the axes color to black and increased its size to increase readibility. The legend of the plot is removed as it is redundant. The x axes title is also removed as its pretty obvious in the graph.
