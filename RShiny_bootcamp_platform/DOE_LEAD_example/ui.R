
library(shiny)
library(shinydashboard)
library(shinyWidgets)

source('overviewUI.R')
source('energy_burden_generate.R')

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem('Overview', tabName='overviewTab')
  )
)

body <- dashboardBody(
  tabItems(
    overviewTab
  )
)

ui <- dashboardPage(
  dashboardHeader(title='Energy Burden Analysis'),
  sidebar,
  body
)