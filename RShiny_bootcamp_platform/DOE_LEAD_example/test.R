library(tidyverse)
library(tidyr)
library(ggplot2)

# function that retrieves data based on a file path
getData <- function(filePath) {
  
  # reads in the data
  data <- read_csv(filePath)
  
  # Cleaning column headers
  names(data) <- gsub(' ', '_', names(data)) # replaces spaces with underscores
  names(data) <- gsub('\\.', '', names(data)) # eliminates full spots or dots
  names(data) <- gsub('%', 'Percent', names(data)) # replaces percentage signs with the word "Percent"
  names(data) <- gsub('\\(', '', names(data)) # eliminates opening parenthesis
  names(data) <- gsub('\\)', '', names(data)) # eliminates closing parenthesis
  
  # Cleaning Indicator values
  data$Indicator <- gsub(' ', '_', data$Indicator) # replaces spaces with underscores
  data$Indicator <- gsub('\\/', '_', data$Indicator) # replaces forward slash with underscore
  
  # Cleaning Indicator_Segment values
  data$Indicator_Segment <- gsub('%', '', data$Indicator_Segment) # eliminates percent signs
  data$Indicator_Segment <- gsub(' - ', ' to ', data$Indicator_Segment) # replaces pattern " - " with " to "
  data$Indicator_Segment <- gsub('\\+', '_more', data$Indicator_Segment) # replace plus signs with "_more"
  data$Indicator_Segment <- gsub(' ', '_', data$Indicator_Segment) # replaces spaces with underscores
  data$Indicator_Segment <- gsub('-', '_', data$Indicator_Segment) # replaces dashes with underscores
  data$Indicator_Segment <- gsub('\\/', '_', data$Indicator_Segment) # replaces forward slashes with underscores
  
  return(data)
}

# returns a plot of energy burden based on user selected variable
energyBurdenBarChart <- function(data, userSelectedVariable) {
  
  # replaces spaces with underscores to match dataset format
  userSelectedVariable <- gsub(' ', '_', userSelectedVariable)
  userSelectedVariable <- gsub('\\/', '_', userSelectedVariable)
  
  # filter the data to only include points for a particular variable
  filteredData <- data %>%
    filter(str_detect(Indicator, userSelectedVariable))
  
  # transform the data for a stacked bar chart
  filteredData <- filteredData %>%
    select(-c(Avg_Energy_Burden_Percent_Income_Total)) %>%
    pivot_longer(cols=3:5,
                 names_to='Energy_Type',
                 values_to='Energy_Burden')
  
  # color palette for our bar chart
  colorPalette <- c('#22577A', '#38A3A5', '#57CC99', '#80ED99', '#C7F9CC')
  
  # Making the final stacked bar chart
  p <- ggplot(filteredData, aes(x=Indicator_Segment, y=Energy_Burden, fill=Energy_Type)) + # defines X and Y axis
    geom_bar(stat='identity') + # creates bar chart
    theme(legend.position='bottom') + # legend on the bottom
    scale_fill_manual(values=colorPalette) # specifying our color palette
  
  return(p)
}

fp <- 'data/lead-tool-chart-data.csv'
data <- getData(fp)
p <- energyBurdenBarChart(data, 'Federal Poverty Level')
plot(p)