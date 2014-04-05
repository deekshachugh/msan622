Homework 2: Interactivity
==============================

| **Name**  | Deeksha Chugh |
|----------:|:-------------|
| **Email** | dchugh@dons.usfca.edu |

## Instructions ##
The following packages must be installed prior to running this code:

- `ggplot2`
- `shiny`
- `scales`

To run this code, please enter the following commands in R:

```
library(shiny)
library(ggplot2)
library(scales)
shiny::runGitHub('msan622', 'deekshachugh', subdir = 'homework2')
```
Here is a screenshot of the app:

![IMAGE](myshinyapp.png)

## Discussion ##

###User Interface ###
The above application plots the MPAA ratings of movies by budget.
I first plotted all the movies on a single plot, but there were too many overlapping points representing movies in it. To avoid that problem, I used multiple plots, one for each of the MPAA ratings.
The size and color of the heading of each of the multiplots was modified to increase readability.
To provide extra information, I added an extra radio button to show the year of the movie's release. This radio button helps the user to answer questions such as, "On average what is the budget of an action movie which was made after 1980's?". This also tells that NC-17 rating did not exist prior to year 2000 in the data.

The page has been laid out using `fluidrows` so that the user doesn't need to scroll to select any attribute. The layout made reflows for small screens as well. The headings of each of the components have been arranged outside the box and uses strong typeface. I also added step-size to the slider for `transparency`.

###Plot###
The y-axis in the plot were changed to millions with labels as dollors which increases readibility. I removed the legend as the title of the mppa rating is sufficent to make the distinction. The title was also removed as it is redundant. I also increased the size of the axis and made it black. I used strip.text.x feature to increase the size and color of the mpaa rating titles. The grey background was replaced with white background. The panel.grid.major lines were chosen to be grey so that its easier to distinguish which rating lies in which coordinate.