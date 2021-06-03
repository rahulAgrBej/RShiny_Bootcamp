---
id: tutorial_cleaning_displaying_data
title: 3.0-Cleaning and Displaying Data
sidebar_position: 4
---

## Goals
- Read in data file
- Clean data to R readable format
- Create a preliminary data visualiation
- Create a custom data visualization

## Exploring Data
For this lesson we will be using a separate test.R file. As you clean and test different data visualizations, you will start noticing that it is actually much faster to do this in a separate file and then connect the frontend and backend to it later on.

For this lesson we will be using the tidyverse, which is a collection of R packages specifically meant for data science in R. Additionally we will be using a small subset of the IDB database, with information for Argentina, Colombia, Mexico and Panama. A compressed version of this file can be found here. For in our case we will be placing our CSV file called idb_data.csv into a folder called data. Therefore the path the data file will be “data/idb_data.csv”

Below is a code snippet that will read in our data file:

```r
library(tidyverse)

getData <- function(filePath) {
    data <- read_csv(filePath)
    
    return(data)
}

dataPath <- 'data/idb_data.csv'
data <- getData(dataPath)
```

Now that we have it available read in lets explore what it looks like. We have the following columns:
- Country: states the country that this particular data record belongs to, ie “ARGENTINA” or “COLOMBIA”.
- Indicator Name: states the particular metric being measure for this data record
- 2009-2018: the value for the metric being measure for a particular year

## Cleaning our data

However not all data is R friendly. This means that it currently might have spaces, forward or back slashes, colons, dollar signs etc. This has the potential to cause R to get confused when referencing the different values. So we will need to “clean” the data to get it to an R friendly format.

Here is a code snippet, explaining each line, that cleans this particular dataset, but sets a framework for how to do so for others as well:

[CODE CLEANING SNIPPET]

Code cleaning while tedious can save hours of looking for a bug later on that ends up being R getting confused with how your data is formatted!

One common recommendation is to substitute troublesome symbols or formatting with underscores or words explaining the symbol replaced - ie “GDP per capita US$” would become “GDP_per_capita_US_dollar”

Here is a list of common formatting issues that can occur in any raw data set:
- Spaces!
- Forward slashes
- Backward slashes
- Quotation marks
- Apostrophes
- Extra commas in sentences
- Currency symbols
- Double underscores
- Dashes
- Parentheses
- Non English characters

## Visualizing the data

Now that we have cleaned our data lets start visualizing our results – tidyverse can do this for us too! Tidyverse can visualize your data with the ggplot2 package.

In our case we want a line graph with the X axis representing years, and the Y axis representing the GDP per capita in US dollars for each country.

Here is a code snippet explaining line for line how this is being accomplished:

[enter line graph CODE SNIPPET]

## Customizing Data Visualization

Now that we have a preliminary line graph that displays all countries GDP per capita. Lets create a customize it a little so that we can select which countries we will displaying. (hint tidyverse can do this too!)

Instead of just passing in our dataset, this time we will also be passing in a list of countries we want to display lets call this countryList.

Similarly to how we can filtered for the correct indicator we wanted, now we will also filter for the countries we want. Run the code snippet below and take a look at the difference between our unfiltered and our filtered dataset. You will notice that our filtered dataset contains the GDP per capita for all countries, while the filtered dataset only contains the GDP per capita for the countries we have selected.
[CODE SNIPPET ABOUT FILTERING AND VISUALIZING DATASET]

## Summary
We have created a function that will read and clean our data set and another that will generate a line graph of the data we want. We have even found a way to customize which countries will get displayed. We will be adding this functionality to our web application in the next lesson. 