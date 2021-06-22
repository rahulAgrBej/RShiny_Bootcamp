
library(tidyverse)
library(ggplot2)
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(reshape2)
library(dplyr)

source('helpers.R')

generate_gdp_timeline <- function(data, countryList) {
  

  # if select all not selected then filter by rest of countries
  if ("Select All" %in% countryList) {
    countryList <- getCountryList(data) %>%
      filter(!str_detect(Country, 'Select All'))
    
    # turns column data structure to a vector
    countryList <- dplyr::pull(countryList, Country)
  }
  
  # filters for specific countries and only looking at GDP as the variable
  filteredData <- data %>%
    filter(str_detect(Indicator, 'GDP_US_per_capita')) %>%
    filter(Country %in% countryList) %>%
    melt() %>%
    rename(YEAR=variable, GDP_per_capita_US=value)

  # creates the line graph for GDP of different countries
  p <- ggplot(data=filteredData, aes(x=YEAR, y=GDP_per_capita_US, group=Country)) +
    geom_line(aes(color=Country)) +
    geom_point(aes(shape=Country, color=Country)) +
    theme(legend.position="top")
  
    
  return(p)
}
