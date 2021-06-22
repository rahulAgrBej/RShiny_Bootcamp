
library(tidyverse)
library(tidyr)
library(ggplot2)
library(shiny)
library(shinydashboard)

source('helpers.R')

barGenerate <- function(data, inputIndicator) {
  
  filteredData <- data %>%
    filter(str_detect(Indicator, inputIndicator))
  
  filteredData <- filteredData %>%
    select(-c(Avg_Energy_Burden_Percent_Income_Total)) %>%
    pivot_longer(cols=3:5,
                 names_to='Energy_Type',
                 values_to='Energy_Burden')
  
  p <- ggplot(filteredData, aes(x=Indicator_Segment, y=Energy_Burden, fill=Energy_Type)) +
    geom_bar(stat='identity')
  return(p)
}

data <- getData('data/lead-tool-chart-data.csv')
test1 <- data[3:5]
test <- barGenerate(data, 'Federal_Poverty_Level')
plot(test)