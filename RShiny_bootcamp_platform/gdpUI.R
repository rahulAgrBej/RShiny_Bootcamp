
library(shiny)
library(shinydashboard)
library(shinyWidgets)

gdpTab <- tabItem(
  tabName='gdp',
  fluidRow(
    uiOutput("countrySelectGDP"),
    textOutput("countryText")
  )
)