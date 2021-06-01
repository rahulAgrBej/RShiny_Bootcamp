
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
      h2('GDP per capita in (US $)'),
      plotOutput("gdpTimeline")
    )
  )
)