
library(shiny)
library(shinydashboard)
library(shinyWidgets)

source('overviewUI.R')
source('gdpUI.R')

# Sidebar layout and structure
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem('Overview', tabName='overview'),
    menuItem('GDP Trends', tabName='gdp')
  )
  
  # end of sidebar
)

# Body layout and structure
body <- dashboardBody(
  
  # Tab Items for body
  tabItems(
    overviewTab,
    gdpTab
  )
  
  # end of body
)

# Overall dashboard page
dashboardPage(
  dashboardHeader(title='IDB Data Analysis and Visualization'),
  sidebar,
  body
  
  # end of dashboard page
)