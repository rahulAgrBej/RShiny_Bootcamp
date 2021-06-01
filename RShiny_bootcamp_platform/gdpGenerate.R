
library(tidyverse)
library(ggplot2)
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(reshape2)

source('helpers.R')

generate_gdp_timeline <- function(data, countryList) {
  
  filteredData <- data %>%
    filter(str_detect(Indicator, 'GDP_US_per_capita')) %>%
    filter(Country %in% countryList) %>%
    melt() %>%
    rename(YEAR=variable, GDP_per_capita_US=value)
  
  print(filteredData)
  
  p <- ggplot(data=filteredData, aes(x=YEAR, y=GDP_per_capita_US, group=Country)) +
    geom_line(aes(color=Country)) +
    geom_point(aes(shape=Country, color=Country)) +
    theme(legend.position="top")
  
    
  return(p)
}

fp <- 'data/idb_data.csv'
test <- getData(fp)
filtered <- generate_gdp_timeline(test, c('ARGENTINA', 'COLOMBIA'))
plot(filtered)

