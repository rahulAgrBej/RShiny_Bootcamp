
library(tidyverse)

# function that will read in and clean data at a specific path
getData <- function(filePath) {
  
  # read in data
  data <- read_csv(filePath)
  
  # initial data cleaning
  names(data) <- gsub(' ', '_', names(data))
  names(data) <- gsub('\\.', '', names(data))
  names(data) <- gsub('%', 'Percent', names(data))
  names(data) <- gsub('\\(', '', names(data))
  names(data) <- gsub('\\)', '', names(data))
  
  # cleans data indicators
  data$Indicator <- gsub(' ', '_', data$Indicator)
  data$Indicator <- gsub('\\/', '_', data$Indicator)
  
  # cleans indicator segments
  data$Indicator_Segment <- gsub('%', '', data$Indicator_Segment)
  data$Indicator_Segment <- gsub(' - ', ' to ', data$Indicator_Segment)
  data$Indicator_Segment <- gsub('\\+', '_more', data$Indicator_Segment)
  data$Indicator_Segment <- gsub(' ', '_', data$Indicator_Segment)
  data$Indicator_Segment <- gsub('-', '_', data$Indicator_Segment)
  data$Indicator_Segment <- gsub('\\/', '_', data$Indicator_Segment)
  
  return(data)
}

fp <- 'data/lead-tool-chart-data.csv'
data <- getData(fp)