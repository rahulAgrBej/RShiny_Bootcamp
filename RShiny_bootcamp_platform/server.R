
library(tidyverse)
library(ggplot2)
library(shiny)
library(shinyWidgets)

source('helpers.R')
source('gdpGenerate.R')

server <- function(input, output) {
  
  # reads in data only once to the web application
  dataInput <- reactive({
    getData('data/idb_data.csv')
  })
  
  # creates and sends updated GDP plot
  output$gdpTimeline <- renderPlot({
    generate_gdp_timeline(dataInput(), input$countries_gdp)
  })
  
  # generates a list of countries from data sample
  output$countryList <- reactive({
    getCountryList(dataInput())
  })
  
  # Dynamically creates a country multi selector for GDP page
  output$countrySelectGDP <- renderUI({
    countryList <- getCountryList(dataInput())
    multiInput(inputId='countries_gdp',
               label='Choose Countries:',
               choices=countryList$Country,
               selected=c())
  })
  
}