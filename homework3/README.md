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
library(shiny)
shiny::runGitHub('msan622', 'deekshachugh', subdir = 'homework3')

## Discussion ##

###Bubble Plot###

Why did you chose this technique?
I wanted to know whether California is a safe city and what is its correaltion with illiteracy. I chose bubble plot over Heatmap because the attributes like population and area of the states along with other features can be well shown in the Bubble plot. 

Which columns did you chose to include and why?
I included Murder rate, Illiteracy rate, State Names, Population and Region to show how illiteracy rate is related to Murder rate for different states of U.S.

How you are encoding the data (e.g. which column do you use to determine color)?
I chose regions to color the bubbles and shown state names on top of it.

What customization did you try and why?
I tried to increase and decrease the size of the bubbles to see that it is visually appealing. I also tried features like state area as size of bubble but it was not very interesting to me.

What conclusions does your technique helps you make about the underlying dataset?
It shows us that illiteracy is higly correlated with Murder rate. The higher the illieracy the higher the murder rate.
The South region has high murder rate and high illiteracy

For the interactivity section, include a screenshot of your shiny app and discuss the following:

Here is the screenshot of the visualization.
![IMAGE](Technique1.png)

How do you interact with your visualizations?
There are three different ways in which you can interact with this visulaization.
First, you can color the bubbles by region or division. Second, the bubbles can be filtered based on the region.
Third, you can zoom into the visualization by selecting the range of x-axis.

What approaches (overview + detail, focus + context, etc.) did you implement and why?
I chose this technique because I was curious to know that more about the various U.S states illiteracy rate and its association with Murder rate. The visualization helps us to see illiteracy rate by murder rate for different regions. The application also provides the state name and the population of the state which can be other factors for murder or illiteracy. Since a few of the bubbles are overlapping, the application provides a framework to zoom in which is helful in answering particular questions like "What was the illiteracy rate in CA?"


###Scatterplot Matrix###
Why did you chose this technique?
I was interested in looking at how few features are interlinked in just one plot. The scatter plot matrix provides a way to look at a lot of features together in just one visualization. 

Which columns did you chose to include and why?
I included Illiteracy, Life expectancy, Murder rate, and HS graduation because as per my experience I think these should be highly dependent on each other. 

How you are encoding the data (e.g. which column do you use to determine color)?
I colored the data points with different regions which will provide the holistic view of US adn will help in inferences.

What customization did you try and why?
The lower part of the matrix provides a view about how the various features are scattered. I changed the diagnal of the matrix to be the density of the features to get a rough idea about its distribution. The upper part of the scatter plot provides the actual correlation numbers which are helpful in making inferences about the data. I tried to color the points by Division as well but since there are 8 divisions it would be hard to see in small plots. I extracted each of the ggplots from the ggpairs to make customization like darkening the axes and changed the background from grey to white.

What conclusions does your technique helps you make about the underlying dataset?
By looking at the correlation values, we can see that Life expectancy has the highest correlation with Murder rate followed by Illietracy and Murder. 
Note: Add the legend and write something about region


For the interactivity section, include a screenshot of your shiny app and discuss the following:
![IMAGE](Technique2.png)

How do you interact with your visualizations?
You can filter the regions and see the distribution of each of the regions for all the features.
I could not prvide the zoom in feature as the different plots in the matrix have different regions.
Note: fix the xlimit constant

What approaches (overview + detail, focus + context, etc.) did you implement and why?




###Parallel Coordinates###
Why did you chose this technique?
I chose this technique because it helps us to find patterns in our data with multiple features.

Which columns did you chose to include and why?
I included Population, Area, Income and Frost level to show demographical overview of the US states.

How you are encoding the data (e.g. which column do you use to determine color)?
The lines in the plot are colored by regions or division based on what you select.


What customization did you try and why?
I tried various scaling for the data and found the uniminmax works best for this dataset. I removed the actual values and bounded the data with just the limits.

What conclusions does your technique helps you make about the underlying dataset?
West region has high frost compared to South. Rest of the parameters were all over the place so we were not able to make much conclusion.

For the interactivity section, include a screenshot of your shiny app and discuss the following:
![IMAGE](Technique3.png)

How do you interact with your visualizations?

We can select region or division to filter the lines in the parallel plot

We can filter the data based on different regions or division. I wante d
What approaches (overview + detail, focus + context, etc.) did you implement and why?