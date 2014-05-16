Project: Final
==============================


| **Name**  | Deeksha Chugh  |
|----------:|:-------------|
| **Email** | dchugh@dons.usfca.edu |

## Instructions ##
The following packages must be installed prior to running this code:
```
library(ggplot2)
library(ggmap)
library(maps)
library(randomForest)
library(RCurl)
library(GGally)
```
To run this code, please enter the following commands in R:
```
library(shiny)
shiny::runGitHub('msan622', 'deekshachugh', subdir = 'final-project')
```
Please note that the data is fetched from online server so you need to have internet connected when you run this application.

## Discussion ##

###Data Preparation ###

In order to do this analysis, I scraped weather data from Wunderground.com. The website provides weather information on the basis of airport code.
I mapped the airport codes to get the city name and latitude-longitude information. I also created a season column by using the months in the data.

###Project Prototype###
I demonstrated a time series line chart of temperature and dew point temperature with zoomed-in version and an overview across three years.
Spencer and Prateek suggested using selectize input option in the UI becuase I have 54 cities in my data.
I impelemented that and it was really useful because one doesn't need to scroll to the city name to see the visualization.
Instead, one can type the city name (which autocompletes) and generate the visualization.
Jeremey, Manoj and Trevor suggested to do some heat map visulaization by showing the geography and I was able to implement that my mapping the latitude and longitude of the cities.

Trevor also suggested showing seasonal information about the data.
I added a parallel coordinate plot which shows various seasonal patterns in temperature and other weather variables.

I did not implement the outlier analysis suggested by Manoj because I wanted to focus on graphs that can give a bigger picture of weather, rather than a drilled-down approach.



###Challenges###

The biggest challenge for me was to implement brushing in my parallel coordinate plot.
I fixed the colors of each season to make it consistent. The problem was that when I de-selected any season in my plot, the grey lines appear on top of the solid lines that I want to show. I tried to set the alpha level also for the de-selected lines but it was not helpful. I was still not able to implement it. To reduce the effect of grey lines on my solid lines I reduced the alpha level for all the lines and made the grey lines more white in color.

I wanted to implement animation to show how temperature is changing but realized that the Shiny interface doesn't have very good support for this. I tried it but the changes are not very smooth.

Another challenge was to get the city names mapping. My dataset had airport codes but I wanted to add city names instead of airport codes.
This information is not available easily but I somehow managed to do it and added in my dataset.

The wind speed extracted from the wunderground.com had some really abnormal values like -1000 and so on which was really difficult to interpret.
I made a lot of visulaizations with wind speed but those outliers were showing a telling a hard-to-believe, odd story.
To circumvent that, I dropped that variable from my analysis because I believe it's better to show less but accurate information.

If I had more time, I would have implemented it in [D3.js](https://github.com/mbostock/d3) with nice interactivity.
For instance, D3.js allows adding tooltips which I would have used to show which city is at what temperature or humitdity in all my plots.
I think that would have been very useful for the user.
I could also have added more data like weekly flu trends or any product sales data and done some analysis on how temperature is related to those variables.

---

### Technique 1 ###
###US Weather Overview - 54 cities (2011-2013)###

![IMAGE](US-Overview-temperature.png)


The above plot shows the heatmap of temperature across 54 cities in US. Each dot represents a city.
The idea of the plot is to display holistic view of the data across US.
The color gradient is chosen to be yellow to red to depict low to high temperatures, respectively.
The dew point temperature also has the same gradient color.
I changed the legend position and direction to have better data-ink ratio. The plot title and the legend title are in bold with increased size so that it is easier to read. The alpha level of the dot is reduced to 0.8 to see the overlapping cities.
I thought of adding the value of temperature over the dots but it was not providing any extra information.

I removed the background panel and made it white so that it merges with the whole application. I tried different sizes for the dots but settled on 9.
The lie factor is close to one for this plot. The data density is high on the right side of the plot becuase I have more cities from the eastern part of the country.
I think data-ink ratio is superb in this graph and it's amazing to see so many cities in just one plot and be able to make inferences about their weather.

The latitude and longitude information of cities was required to generate this plot.
It is easy to find that information for states, but it was difficult to find airport code mapping of latitude-longitude. In the end, I was somehow able to find it.

I used melt from reshape library to covert this data into long format. The dates values were available as a string so I converted them to date class to be able to show appropriate dates.
To show different city I am subsetting my data to use the city specific data of 3 years.
This visualization excels at showing the comparison of Temperature or Humidity or Percentage Cloud Cover across the various cities on any particular day of the year.
The plot helps in detecting outliers in terms of city. It can answers question such as: "Which city was hottest or coldest on any day?".
Given more time, I would have shown the same plot for different seasons, months, and weeks.

![IMAGE](US-Overview-Cloud.png)

The above plot shows the heatmap of Percentage Cloud Cover across 54 cities in US.
The color gradient is chosen to be light blue to blue as a depiction of the clouds.
All the customizations applied on the above plot are also applied here.

#####Interactivity#####

I implemented filtering for date as well as type of variable user is interested in.
On the left side of the panel, you can type any date within the three years of date range to see the temperature across all cities for any particular day of the year.
The radio button is added for user to select the variable they want to view. The variables included are Temperature, Dew Point Temperature, Humidity and Percent Cloud Cover.

This kind of interactivity is important so that the user can explore what he/she is looking for, for any particular day of the year.
The user can fix the date and see how the humidity, temperature or other variables are different for each city.

![IMAGE](Interface1.png)

The above plot shows the interface of my shiny application.

---

### Technique 2 ###
###City Temperature Overview ###

![IMAGE](DailyTempOverview.png)

The data manipulation part for this plot was to subset the data for each of the cities.
The multiline plot shows the temperature and dew point temperature over the range of 3 years for each city.
I chose this technique becuase it is the best way to visualize the time series. The previous plot shows the holistic view.
This plot is focussed more on what is happening in each city over the entire period for which the data is available.
This graph conveys a lot of information for determining trends in each city. For example, which are the hottest and coldest months in each city.
I chose red color for Temperature and orange for Dew Point Temperature as they belong to same family of colors. Dew Point Temperature always is lower than Temperature so I wanted to show a lower gradient of red.
I added the legend on the top of the plot to increase data-ink ratio. The lie factor is little becuase a lot of variation can be seen in temperature.

I have also added the major grid lines so that it's easier for the user to get a rough idea of temperature.
I colored these markers grey so that they are not distracting. I set the y-axis title to specify the unit of temperature.

#####Interactivity#####

I have implemented filtering and zooming for this plot. The user can select any city from the list of cities by typing the city in the panel.
I have used selectizeInput which allows the user to type and search in the list to find the city of interest.
The date range is also provided for the user to zoom-in and see a particular month or date within the specified time period.

This filtering technique allows the user to see different cities, therefore, it is really important to have this interactivity.
Zooming is important to reduce the data density as there is high amount of variation in the temperature and dew point temperature.
Also, if the user wants really specific numbers for a particular week or month, they can easily zoom in and see the actual values.

Below is the graph showing the zoomed in version of the plot above.
![IMAGE](zoomedTemp.png)

---

### Technique 3 ###
###City Rainfall Overview ###

![IMAGE](Rainfall.png)

I created a month column from the date and then used aggregate function to combine the data for various months to get average rainfall for all the cities.
I aggregated city level data also to sum the precipitation over all months.

This plot displays the average rainfall of all the 54 cities along with the rainfall of a particular city for all the months in 2013.
The light blue color depicts the city rainfall and dark blue color depicts the average rainfall.
I reasearched on the best way to visualize rainfall in a city and found that bar plots are an apporpriate way to show total rainfall.
To make the graph interesting, I added the city and average side by side so that it is easier to compare which city has high rainfall and in which months.
To improve the data-ink ratio, I removed all the gridlines.
The lie factor in this graph could be that since this average rainfall is only for 54 cities of US, it's not very appropriate to compare city's precipitation with the average precipitation.
The data density of the plot is also very good as it is conveying a lot of useful information.

I also learnt from this graph that the rainfall in San Francisco is really low compared to the other cities and the average.
The maximum rainfall is in December of 2013. I also learnt that Seattle has highest rainfall in the month of September.
This plot helps in making such inferences by changing the city.

#####Interactivity#####
I have implemented filtering for this plot because it would be interesting for the user to see different cities' rainfall level for various months.
For instance, Seattle has high rainfall in summers whereas San Francisco has very little rainfall during the same period.
We are able to make comparisons because of this interactivity available to the user.

---

### Technique 4 ###
### Seasonal Trend ###
![IMAGE](SeasonalTrend.png)

I selected the data for the year 2013 and created a column of season using the month column created before. I have assigned season using the below commmand in R.
```
data$season <- ifelse(year_data$month %in% c("Mar", "Apr", "May"), "Spring",
               ifelse(year_data$month %in% c("Jun", "Jul", "Aug"), "Summer",
               ifelse(year_data$month %in% c("Sep", "Oct", "Nov"), "Autumn",
               ifelse(year_data$month %in% c("Dec", "Jan", "Feb"), "Winter", ""))))
```

I used the Parallel Coordinate Plot to see seasonal trend in the data for each city.
I removed the background color and changed the coordinate lines to grey so that it is easier to see the highest and lowest values of each of the variables.
The data density and data-ink ratio is really high for this plot.

The qualitative color scheme has been chosen for this plot.
I fixed the color for each of the seasons and used a light grey color to draw the de-selected lines.
There is a little lie factor in this plot as I have fixed the months for each season. But, different cities can have different season in different months.

A very interesting statistic about Minneapolis stood out which we could not have seen had I not plotted parallel coordinate plot.
In Minneapolis, summers have high temperature with relatively low humidity and winters have low temperature with high humidty.
It is so easy to compare the season and its patterns using this plot.

I learnt that for Detroit, and Cincinati, Humidity is high throughout the year, compared to other cities such as San Francisco.
In Los Angeles, during summers, the dew point temperature is much higher than temperature with high humidity, whereas, most of the cities' temperature have lower or similar dew point temperature.

#####Interactivity#####
I implemented brushing and filtering for this technique.
The user can select any season and have the rest of the seasons in background to provde context about the data.
There are four seasons and the color is fixed for each of the seasons. If the user wants to see a particular season, she/he can de-select the other seasons.
The user can also search for a city from the city list to see the variation in trends across the various cities.

---

### Technique 5 ###
### Temperature Prediction  ###
![IMAGE](prediction.png)

For this plot, I created a column with lagged one year temperature because for time series, last period is usually highly significant. Using the library ```randomForest```, I created a model and used ```predict``` function to get the predicted values.

I implemented line chart to show the actual temperature and the predicted temperature of the model designed by me. I think the multi-line chart is a very appropriate way to show temperature and its predicted value.

I learnt from this graph that random forest is able to predict temperature of cities quite accurately. However, for cities like San Francisco, the model does not work as well as for other cities. This could be becuase I have not included wind speed, which may be really important in predicting the temperature.
For almost all the the cities, temperature prediction was not very accurate when there is a high peak in temperature.

#####Interactivity#####
I used filtering and zooming for this plot because the data has 54 cities and it is easier to search for a city of interest for the user. Since the data density is very high and there is a lot of overplotting, zooming feature helps to see the predictions for each month clearly.