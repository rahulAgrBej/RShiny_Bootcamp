
library(tidyverse)
library(ggplot2)
library(shiny)
library(shinyWidgets)

source('helpers.R')
source('gdpGenerate.R')

server <- function(input, output) {
  
  dataInput <- reactive({
    getData('data/idb_data.csv')
  })
  
  output$countryList <- reactive({
    getCountryList(dataInput())
    print(getCountryList(dataInput()))
  })
  
  output$countryText <- renderText({
    print("testing here")
    print(input$test)
    getText(input$test)
  })
  
  
  # Dynamically creates a country multi selector for GDP page
  output$countrySelectGDP <- renderUI({
    countryList <- getCountryList(dataInput())
    print(countryList)
    multiInput(inputId='countries_gdp',
               label='Choose Countries:',
               choices=countryList$Country,
               selected=c())
  })
  
}