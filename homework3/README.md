Homework [#]: Homework 3
==============================

| **Name**  | Deeksha Chugh  |
|----------:|:-------------|
| **Email** | dchugh@dons.usfca.edu |

## Instructions ##

The following packages must be installed prior to running this code:

`ggplot2`
`shiny`
`GGally`

To run this code, please enter the following commands in R:
```
library(shiny)
shiny::runGitHub('msan622', 'deekshachugh', subdir = 'homework3')
```

## Discussion ##

###Crime Rate Overview###


I was curious to know more about the various U.S states illiteracy rate and its association with Murder rate. I chose bubble plot over Heatmap because the attributes like population and area of the states along with other features can be well shown in the Bubble plot. 
I included Murder rate, Illiteracy rate, State Names, Population and Region to show how illiteracy rate is related to Murder rate for different states of U.S. I chose regions or divisions to color the bubbles and shown state names on top of it.
I tried to increase and decrease the size of the bubbles to see that it is visually appealing. 


Here is the screenshot of the visualization.
![IMAGE](Technique1.png)

There are various ways in which you can interact with this visualization.
First, you can color the bubbles by region or division. Second, the bubbles can be filtered based on the region.
Third, you can zoom into the visualization by selecting the range of x-axis. The bubble size can also be changed by the slider.

You can also show states by checkbox:

![IMAGE](Technique10.png)

 The visualization helps us to see illiteracy rate by murder rate for different regions. The application also provides the state names and the population of the state which can be other factors for murder or illiteracy. Since a few of the bubbles are overlapping, the application provides a framework to zoom, which is helpful in answering particular questions like "What was the illiteracy rate in CA?"


###Social Overview###

I was interested in looking at how few features are interlinked in just one plot. The scatter plot matrix provides a way to look at a lot of features in one visualization.  I included Illiteracy, Life expectancy, Murder rate, and HS graduation because my hypothesis was that these should be highly dependent on each other. I colored the data points with different regions which will provide the holistic view of US and will help in inferences.


The lower part of the matrix provides a view about how the various features are scattered. I changed the diagonal of the matrix to be the density of the features to get a rough idea about its distribution. The upper part of the scatter plot provides the actual correlation numbers which are helpful in making inferences about the data. I tried to color the points by Division as well but since there are 8 divisions it would be hard to see in small plots. I extracted each of the ggplots from the ggpairs to make customization like darkening the axes and changed the background from grey to white.


Here is the screenshot of the visualization.
![IMAGE](Technique2.png)


You can filter the regions and see the distribution of each of the regions for all the features.
I could not prvide the zoom in feature as the different plots in the matrix have different regions.
By looking at the correlation values, we can see that Life expectancy has the highest correlation with Murder rate followed by Illiteracy and Murder and so on.


###Demographical Overview###

I chose this technique because it helps us to find patterns in our data with multiple features. I included Population, Area, Income and Frost level to show demographical overview of the US states. The lines in the plot are colored by regions or division based on what you select. I tried various scaling for the data and found the uniminmax works best for this dataset. I removed the actual values and bounded the data with just the limits. I removed the grid lines and changed the background to black as it is easier to see lines over black background.


Here is the screenshot of the visualization.
![IMAGE](Technique3.png)

Any of the regions and division can be selected by the input box on the left side. The plot shows us the relationship between Population Area, Frost and Income of the state. West region has high frost compared to South. We can see that there are few outliers in the dataset which have very high population and very low area. 




