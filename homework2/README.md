Homework 2: Interactivity
==============================

| **Name**  | Deeksha Chugh |
|----------:|:-------------|
| **Email** | dchugh@dons.usfca.edu |

## Instructions ##
The following packages must be installed prior to running this code:

- `ggplot2`
- `shiny`
- 'scales'

To run this code, please enter the following commands in R:

```
library(shiny)
library(ggplot2)
library(scales)
shiny::runGitHub('msan622', 'deekshachugh', subdir = 'homework2')
```
Here is the app which I made:

![IMAGE](shinyapp.png)

## Discussion ##

###User Interface ###
The above application includes MPAA ratings of the movies along with the budget. The first thing which I thought was a big problem was overlapping points if we plot everything on the same plot. Therefore, I made multiplots representing different MPAA rating to increase readability. The size and color of the multilots heading was modified too. To provide some extra information, an extra radio button was added which shows the year of the movies. This radio button will help user to answer particular questions like "On average what is the budget of an action movie which was made after 1980's. This also helps us to tell that NC-17 rating did not exist prior to year 2000 in the data.

With respect to the user interface, the buttons were rearranged in a fashion using fluidrows where the user does not have to scroll down to select any attribute. The layout made is helpful for small screens as well. The headings of each of the buttons were arranged out of the box with a bold heading. I also added the stepsize to slider for the transparency.

###Plot###
The y-axis in the plot were changed to millions with labels as dollors which increases readibility. I removed the legend as the title of the mppa rating is sufficent to make the distinction. The title was also removed as it is redundant. I also increased the size of the axis and made it black. I used strip.text.x feature to increase the size and color of the mpaa rating titles. The grey background was replaced with white background. The panel.grid.major lines were chosen to be grey so that its easier to distinguish which rating lies in which coordinate.