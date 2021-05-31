
library(tidyverse)

dataPath <- 'RShiny_bootcamp_platform/idb_data.csv'
data <- read_csv(dataPath)

names(data) <- gsub(' ', '_', names(data))
data$Indicator_Name <- gsub(' ', '_', data$Indicator_Name)
data$Indicator_Name <- gsub(',', '', data$Indicator_Name)
data$Indicator_Name <- gsub('\\(', '', data$Indicator_Name)
data$Indicator_Name <- gsub('\\)', '', data$Indicator_Name)
data$Indicator_Name <- gsub('w/_', '', data$Indicator_Name)
data$Indicator_Name <- gsub('-', '_', data$Indicator_Name)
data$Indicator_Name <- gsub('__', '_', data$Indicator_Name)



indicators <- data %>%
  distinct(Indicator_Name)