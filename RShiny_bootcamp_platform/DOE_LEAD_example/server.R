library(tidyverse)
library(shiny)

source('helpers.R')

server <- function(input, output) {
  
  dataInput <- reactive({
    getData('data/lead-tool-chart-data.csv')
  })
}