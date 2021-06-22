
library(tidyverse)

# function that will read in and clean data at a specific path
getData <- function(filePath) {
  
  # read in data
  data <- read_csv(filePath)
  
  # initial data cleaning
  names(data) <- gsub(' ', '_', names(data))
  data <- data %>%
    rename(Indicator=Indicator_Name)
  
  data$Indicator <- gsub(': ', '_', data$Indicator)
  data$Indicator <- gsub('\\$', '', data$Indicator)
  data$Indicator <- gsub(' ', '_', data$Indicator)
  data$Indicator <- gsub(',', '', data$Indicator)
  data$Indicator <- gsub('\\(', '', data$Indicator)
  data$Indicator <- gsub('\\)', '', data$Indicator)
  data$Indicator <- gsub('w/_', '', data$Indicator)
  data$Indicator <- gsub('-', '_', data$Indicator)
  data$Indicator <- gsub('__', '_', data$Indicator)
  
  return(data)
}

getCountryList <- function(data) {
  
  countryList <- data %>%
    distinct(Country)
  
  countryList <- c("Select All") %>%
    rbind(countryList)
  return(countryList)
}