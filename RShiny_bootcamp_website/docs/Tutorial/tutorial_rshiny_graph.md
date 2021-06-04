---
id: tutorial_rshiny_graph
title: 3.1-Returning a Graph with RShiny
sidebar_position: 5
---

In this lesson we will be using the functions we created in test.R to read our data into our web application and return a graph of GDP trends for countries that our user selects.

What we will be doing:
- Read our dataset into our web application
- Send a custom country list from the user to the server
- Have the server receive the custom list and create a custom line graph to send to the UI

## Integrating data retrieval & plotting

Lets copy paste the getData and generate_gdp_timeline functions we defined in test.R at the top of the server.R file, shown below. We will also be eliminating example server sending text example.

```r
library(tidyverse)
library(shiny)

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

server <- function(input, output) {
  
}
```

Now we will be creating a custom function in the server portion of code that will call our getData function and read in our code. We will be doing this with reactive({}), this allows for the most efficient way of uploading data to your application, as it will only upload it as needed and will keep a local copy that only gets updated if our underlying data changes. This keeps us from having to read in the whole data set each time that we want to create a visual.

```r
server <- function(input, output) {
  
  # loads data into our web application
  dataInput <- reactive({
      getData('data/idb_data.csv') # here is where our getData function gets inserted
  })
}
```

Note that dataInput above is a function. This is because while explicitly running our code to load our dataset, it is also checking to see if the value got updated since last uploaded. If not, then it returns the local copy which is a lot faster. Therefore every time we want our data on the server side we will have to write it as “dataInput()”, calling the function.

Note that we already have an input that records countries that the user selects: our multiInput selector! This was our code for it:

```r
multiInput(inputId='countries_gdp', # this is the ID we need to for our server side code
               label='Choose Countries:',
               choices=c('ARGENTINA', 'COLOMBIA', 'MEXICO', 'PANAMA'),
               selected=c())
```

So we can reference a list of user selected countries with input$countries_gdp. We also have a function that returns a line graph of countries and their GDPs per capita based on data and a country list. So in this next step we will combine all of these to have the server generate this graph and return it with the ID “gdpTimeline”. Find the code below:

```r
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

We now have a server that loads our dataset, receives a user selected list of countries and returns a line graph to the UI. Now we just need to tell the UI where to put this graph that the server is sending. Lets go back to our ui.R file, specifically our gdp timeline page because thats where our graph will go (find below):

```r
gdpTab <- tabItem(
  tabName='gdpID',
  fluidRow( # this is our shelf
    width=12,
    box( # this is our first box
        multiInput(inputId='countries_gdp', # this is the ID we need to for our server side code
               label='Choose Countries:',
               choices=c('ARGENTINA', 'COLOMBIA', 'MEXICO', 'PANAMA'),
               selected=c())
    )
  )
)
```

In our case we want to have our GDP line graph side by side with the country filter options. We currently have a fluidRow (shelf) with one box that contains the country filter options. We want our line graph to be at the same height (on the same shelf/fluidRow) as the filter options, but just to the right in a separate box. For this we will be creating a second box, include a header describing the graph, “GDP per capita (US $)”, and finally include a place for the server to send us our plot, with plotOutput(“gdpTimeline”). Note that we specified the unique ID that we set up for our graph in server.R. Find the code below:

```r
gdpTab <- tabItem(
  tabName='gdpID',
  fluidRow( # this is our shelf
    width=12,
    box( # this is our first box
        multiInput(inputId='countries_gdp', # this is the ID we need to for our server side code
               label='Choose Countries:',
               choices=c('ARGENTINA', 'COLOMBIA', 'MEXICO', 'PANAMA'),
               selected=c())
    ),
    box( # this is our second box
        h2('GDP per capita (US dollars)'),
        plotOutput('gdpTimeline') # gdpTimeline = server side ID for line graph
    )
  )
)
```

After updating server.R and ui.R, click on your server.R file and then click the “Run App” button to run our web application. Notice how you can insert/remove countries from the line graph easily and without any lag in rendering our new graphs. This is because we aren’t changing the underlying dataset, we are just using the local copy and filtering for a new set of countries.

## Summary

We now have a fully functioning web application that can:
- Read in and clean our data set
- Let the user decide what data they want to see
- Visualize the data based on user response

But our code files are quite long which can make it difficult to debug and pin point issues as we scale to offer more graphs or more user inputs. Next we will be organizing our files to fix this issue.

## ui.R code
```r
library(shiny)
library(shinydashboard)

# Overview tabItem
overviewTab <- tabItem(
  tabName='overviewID',
  fluidRow(
    width=12,
    box(
      h1('Inter-American Development Bank Overview'),
      'IDB overview content will eventually go here'
    )
  )
)

gdpTab <- tabItem(
  tabName='gdpID',
  fluidRow( # this is our shelf
    width=12,
    box( # this is our first box
        multiInput(inputId='countries_gdp', # this is the ID we need to for our server side code
               label='Choose Countries:',
               choices=c('ARGENTINA', 'COLOMBIA', 'MEXICO', 'PANAMA'),
               selected=c())
    ),
    box( # this is our second box
        h2('GDP per capita (US dollars)'),
        plotOutput('gdpTimeline') # gdpTimeline = server side ID for line graph
    )
  )
)

# Body layout and structure
body <- dashboardBody(
  
  # Tab Items for body
  tabItems(
    overviewTab, # overview tab inserted into the body,
    gdpTab
  )
  
  # end of body
)

# Sidebar layout and structure
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem('Overview', tabName='overviewID'),
    menuItem('GDP Trends', tabName='gdpID')
  )
  
  # end of sidebar
)

# Overall dashboard page
dashboardPage(
  dashboardHeader(title='IDB Data Analysis and Visualization'),
  sidebar,
  body
  
  # end of dashboard page
)
```

## server.R code
```r
library(shiny)
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