library(shiny)
library(shinydashboard)
library(shinyWidgets)

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem('Overview', tabName='overviewTab'),
    menuItem('Variable Analysis', tabName='variableAnalysisID')
  )
)

overviewTab <- tabItem(
  tabName='overviewTab',
  fluidRow(
    box(
      h1('Energy Burden & the DOE LEAD tool'),
      'Overview content will go here.'
    )
  )
)

variableAnalysisTab <- tabItem(
  tabName='variableAnalysisID',
  fluidRow(
    box(
      h1('Energy Burden Variables'),
      'There are many variables that can affect a household\'s energy burden. Use the drop down menu below to explore the impact of some of these variables.',
      pickerInput(
        inputId='variableChoiceID',
        label='Select a variable below:',
        choices=c('Federal Poverty Level', 'Building Age', 'Heating Fuel', 'Building Type', 'Rent/Own'),
        selected=c('Federal Poverty Level')
      )
    ),
    box(
      h1('Energy Burden Chart'),
      plotOutput('energyBurdenBarChartID')
    )
  )
)

body <- dashboardBody(
  tabItems(
    overviewTab, # overview tab inserted into the body
    variableAnalysisTab
  )
)

ui <- dashboardPage(
  dashboardHeader(title='Energy Burden Analysis'),
  sidebar,
  body
)