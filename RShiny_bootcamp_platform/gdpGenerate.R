
library(tidyverse)
library(shiny)
library(shinydashboard)
library(shinyWidgets)

getText <- function(countryList) {
  print("HERE")
  print(countryList)
  return(countryList[1])
}