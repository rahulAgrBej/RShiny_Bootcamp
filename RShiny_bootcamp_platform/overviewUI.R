
library(shiny)
library(shinydashboard)
library(shinyWidgets)

overviewTab <- tabItem(
  tabName='overview',
  fluidRow(
    width=12,
    box(
      h1('Inter-American Development Bank Overview'),
      'Over of IDB would go here.'
    )
  )
)