
library(shiny)
library(shinydashboard)
library(shinyWidgets)

gdpTab <- tabItem(
  tabName='gdp',
  fluidRow(
    box(
      uiOutput("countrySelectGDP")
    ),
    box(
      plotOutput("gdpTimeline")
    )
  )
)