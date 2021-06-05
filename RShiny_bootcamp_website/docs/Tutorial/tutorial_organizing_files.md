---
id: tutorial_organizing_files
title: 4.0-Organizing your files
sidebar_position: 6
---

## What we have so far

Right now we have two main files that make our whole web application work:
- ui.R
- server.R

However there is a lot of code in each file which will not only grow as we add more functionality but it also makes it harder to debug and focus. The solution to this is to divide up your codebase into a series of different files that follow some kind of logical order.

Our web application can be thought of as having  3 kinds of parts:
- A central server brain that coordinates UI inputs and server outputs
- A central ui system that organizes the layout of the whole application
- Different pages
    - each of which have a UI component
    - each of which have a server component

## A scalable organization system

Based on this we can start defining an organizational system that can help us remain organize as we scale.
Industry standard is to keep:
- A central server file feeding the UI inputs and sending the corresponding server outputs
- A central UI file that establishes the overall structure/layout of the website
- Two files per page/tab
    - One file that defines the UI, or structure/layout, for the specific page
    - One file that defines the 

## Transfering our system over

Here is how this would apply for our current web application.
- ui.R: keeps the overall structure which includes,
    - dashboard
    - sidebar
    - body
- server.R: calls all relevant functions that create server outputs
    - dataInput
    - output$gdpTimeline
- gdpUI.R: contains the tabItem for GDP page we made
- gdpServer.R: contains the generate_gdp_timeline function
- helpers.R: contains the getData function

Now how does RShiny connect all of our files together? The same way we specify which packages we want to use at the beginning of the page, we have to specify which files we want to use. Instead of using 'library(INSERT LIBRARY NAME)' and specify which files we want to use with 'source(INSERT FILE PATH)'. Note that for our Overview page we only have a ui page, overviewUI.R, associated with it, because it requires no data from the server.

## ui.R
```r
# The libraries we will be using
library(shiny)
library(shinydashboard)
library(shinyWidgets)
# These are the source files we will be using/writing
source('overviewUI.R')
source('gdpUI.R')

# Sidebar layout and structure
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem('Overview', tabName='overview'),
    menuItem('GDP Trends', tabName='gdp')
  )
  
  # end of sidebar
)

# Body layout and structure
body <- dashboardBody(
  
  # Tab Items for body
  tabItems(
    overviewTab,
    gdpTab
  )
  
  # end of body
)

# Overall dashboard page
dashboardPage(
  dashboardHeader(title='IDB Data Analysis and Visualization'),
  sidebar,
  body
  
  # end of dashboard page
)
```

## server.R
```r
library(tidyverse)
library(ggplot2)
library(shiny)
library(shinyWidgets)

source('helpers.R')
source('gdpServer.R')

server <- function(input, output) {
  
  # loads data into our web application
  dataInput <- reactive({
      getData('data/idb_data.csv') # here is where our getData function gets inserted
  })

  # server generates a line graph based on country list and data
  output$gdpTimeline <- renderPlot({
      # this is our line graph generator from test.R
      generate_gdp_timeline(dataInput(), input$countries_gdp)
  })
  
}
```
## gdpUI.R
```r
# libraries we will be using
library(shiny)
library(shinydashboard)
library(shinyWidgets)

# Our GDP Trends Page
gdpTab <- tabItem(
  tabName='gdp',
  fluidRow(
    box(
      # Note we eliminated the previous text inputs and outputs, so we just have our multiInput in our GDP page
      multiInput(inputId='countries_gdp',
               label='Choose Countries:',
               choices=c('ARGENTINA', 'COLOMBIA', 'MEXICO', 'PANAMA'),
               selected=c())
    ),
    box(
      h2('GDP per capita in (US $)'),
      plotOutput("gdpTimeline")
    )
  )
)
```
## gdpServer.R
```r
library(tidyverse)
library(reshape2)

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
```

## helpers.R
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
```
## overviewUI.R
```r
library(shiny)
library(shinydashboard)

overviewTab <- tabItem(
  tabName='overview',
  fluidRow(
    width=12,
    box(
      h1('Inter-American Development Bank Overview'),
      'Over of IDB would go here.'
    )
  )
)
```