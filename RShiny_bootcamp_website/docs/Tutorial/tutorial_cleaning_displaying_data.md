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

Now that we have it available lets explore what it looks like. We have the following columns:
- Country: states the country that this particular data record belongs to, ie “ARGENTINA” or “COLOMBIA”.
- Indicator Name: states the particular metric being measure for this data record
- 2009-2018: the value for the metric being measure for a particular year

## Cleaning our data

However not all data is R friendly. This means that it currently might have spaces, forward or back slashes, colons, dollar signs etc. This has the potential to cause R to get confused when referencing the different values. So we will need to “clean” the data to get it to an R friendly format.

Here is a code snippet, explaining each line, that cleans this particular dataset, but sets a framework for how to do so for others as well:

```r
# function that will read in and clean data at a specific path
getData <- function(filePath) {
  
  # read in data
  data <- read_csv(filePath)

  # DATA CLEANING STARTS HERE
  
  # replaces spaces in the column names with underscores
  names(data) <- gsub(' ', '_', names(data))
  # for ease of access changes the column named "Indicator_Name" to be called "Indicator"
  data <- data %>%
    rename(Indicator=Indicator_Name)
  
  # This is the data cleaning code
  data$Indicator <- gsub(': ', '_', data$Indicator) # subsitutes ': ' with '_'
  data$Indicator <- gsub('\\$', '', data$Indicator) # eliminates dollar signs
  data$Indicator <- gsub(' ', '_', data$Indicator) # substitutes spaces with underscores
  data$Indicator <- gsub(',', '', data$Indicator) # eliminates commas
  data$Indicator <- gsub('\\(', '', data$Indicator) # eliminates opening parenthesis
  data$Indicator <- gsub('\\)', '', data$Indicator) # eliminates closing parenthesis
  data$Indicator <- gsub('w/_', '', data$Indicator) # eliminates the any occurence of 'w/_' in the dataset
  data$Indicator <- gsub('-', '_', data$Indicator) # substitutes dashes with underscores
  data$Indicator <- gsub('__', '_', data$Indicator) # substitutes double underscores for single underscores
  
  return(data)
}
```

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

In our case we want a line graph with the X axis representing years, and the Y axis representing the GDP per capita in US dollars for each country. Our function will be take our cleaned dataset and return a line graph plot.

Here is a code snippet explaining line for line how this is being accomplished:

```r
# this is our function that will take data and return our plot
 generate_gdp_timeline <- function(data) {
  
  filteredData <- data %>%
    filter(str_detect(Indicator, 'GDP_US_per_capita')) %>% # filters our data to only include our GDP per capita indicator
    melt() %>% # this transforms our table to have three columns, one for country, one for year, and another for GDP per capita for a given country and year
    rename(YEAR=variable, GDP_per_capita_US=value) # renames the columns appropriately
  
  # We will now use the tidyverse package to create a line graph
  # this first line defines what will be our x-axis and y-axis variables
  # group lets us define what the different lines will be - in our case one line per country
  p <- ggplot(data=filteredData, aes(x=YEAR, y=GDP_per_capita_US, group=Country)) +
    geom_line(aes(color=Country)) + # adds each line to the plot and changes color by country
    geom_point(aes(shape=Country, color=Country)) + # adds points to the plot and changes their color by country
    theme(legend.position="top") # adds a legend to the plot and tells it to 
  
  return(p)
}

linePlot <- generate_gdp_timeline(data)
plot(data)
```

## Customizing Data Visualization

Now that we have a preliminary line graph that displays all countries GDP per capita. Lets create a customize it a little so that we can select which countries we will displaying. (hint tidyverse can do this too!)

Instead of just passing in our dataset, this time we will also be passing in a list of countries we want to display lets call this countryList. We will only need one extra line of code to filter for our countryList.

Similarly to how we can filtered for the correct indicator we wanted, now we will also filter for the countries we want. Run the code snippet below and take a look at the difference between our unfiltered and our filtered dataset. You will notice that our unfiltered dataset contains the GDP per capita for all countries, while the filtered dataset only contains the GDP per capita for the countries we have selected.

```r
# NOTE: we added an input variable for the countries we want to plot
generate_gdp_timeline <- function(data, countryList) {
  
  filteredData <- data %>%
    filter(str_detect(Indicator, 'GDP_US_per_capita')) %>%
    filter(Country %in% countryList) %>% # NOTE: we are filtering for all countries in our countryList
    melt() %>%
    rename(YEAR=variable, GDP_per_capita_US=value)

  p <- ggplot(data=filteredData, aes(x=YEAR, y=GDP_per_capita_US, group=Country)) +
    geom_line(aes(color=Country)) +
    geom_point(aes(shape=Country, color=Country)) +
    theme(legend.position="top")
  
  return(p)
}

customCountryList <- c('ARGENTINA', 'PANAMA')
newLinePlot <- generate_gdp_timeline(data, customCountryList)
plot(newLinePlot)
```

## Summary
We have created a function that will read and clean our data set and another that will generate a line graph of the data we want. We have even found a way to customize which countries will get displayed. We will be adding this functionality to our web application in the next lesson.

## test.R code
```r
library(tidyverse)

# function that reads and cleans our data
getData <- function(filePath) {
  
  # read in data
  data <- read_csv(filePath)

  # DATA CLEANING STARTS HERE
  
  # replaces spaces in the column names with underscores
  names(data) <- gsub(' ', '_', names(data))
  # for ease of access changes the column named "Indicator_Name" to be called "Indicator"
  data <- data %>%
    rename(Indicator=Indicator_Name)
  
  # This is the data cleaning code
  data$Indicator <- gsub(': ', '_', data$Indicator) # subsitutes ': ' with '_'
  data$Indicator <- gsub('\\$', '', data$Indicator) # eliminates dollar signs
  data$Indicator <- gsub(' ', '_', data$Indicator) # substitutes spaces with underscores
  data$Indicator <- gsub(',', '', data$Indicator) # eliminates commas
  data$Indicator <- gsub('\\(', '', data$Indicator) # eliminates opening parenthesis
  data$Indicator <- gsub('\\)', '', data$Indicator) # eliminates closing parenthesis
  data$Indicator <- gsub('w/_', '', data$Indicator) # eliminates the any occurence of 'w/_' in the dataset
  data$Indicator <- gsub('-', '_', data$Indicator) # substitutes dashes with underscores
  data$Indicator <- gsub('__', '_', data$Indicator) # substitutes double underscores for single underscores
  
  return(data)
}

# function that generates a line plot based on data and countryList
generate_gdp_timeline <- function(data, countryList) {
  
  filteredData <- data %>%
    filter(str_detect(Indicator, 'GDP_US_per_capita')) %>%
    filter(Country %in% countryList) %>%
    melt() %>%
    rename(YEAR=variable, GDP_per_capita_US=value)

  p <- ggplot(data=filteredData, aes(x=YEAR, y=GDP_per_capita_US, group=Country)) +
    geom_line(aes(color=Country)) +
    geom_point(aes(shape=Country, color=Country)) +
    theme(legend.position="top")
  
  return(p)
}

data <- getData('data/idb_data.csv')
customCountryList <- c('ARGENTINA', 'PANAMA')
newLinePlot <- generate_gdp_timeline(data, customCountryList)
plot(newLinePlot)
```