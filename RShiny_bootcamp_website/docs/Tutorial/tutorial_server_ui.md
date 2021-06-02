---
id: tutorial_server_ui
title: 2.0-RShiny Server and UI
sidebar_position: 2
---

RShiny web applications are controlled by two main files: server.R and ui.R.

- server.R will be the way we control our backend.
- ui.R will be the way we control and format our frontend.

(In addition to RShiny we will be using the shinydashboard and shinyWidget packages. We will be using shinydashboard to make our main formatting and layout for our website. We will be using shinyWidget for all our dropdown menus, checkboxes, and filtering options that the user will interact with.)

## The ui.R file

Lets start with ui.R file and creating a dashboard. A dashboard page or website contains three main components: the header, sidebar, and body. Think of the header as the title of the dashboard, the sidebar as the side menu where you can go to different parts of the web application and the body as the contents for each page. Below is an example of what our dashboard object will look like:

Notice how we have inserted a sidebar and a body object in the dashboard. These need to be defined.

```R
library(shiny)
library(shinydashboard)

# Overall dashboard page
dashboardPage(
  dashboardHeader(title='IDB Data Analysis and Visualization'),
  sidebar,
  body
  
  # end of dashboard page
)
```

The sidebar in RShiny dashboards needs to have a sidebar menu object. This sidebarMenu object contains menuItems. Each menuItem represents a different tab on the sidebar that will take you to a different page. A menuItem has two required components: a name and a tabName. The menuItem’s name like, “Overview” or “GDP Trends”, is what will be visible in the to the user in the web application. The tabName, like ”overviewID” or “gdpID”, is a unique identifier that will refer to a tabItem that will actually end up being one of our pages later on. So you can think of menuItem’s as links to other pages in your web application, they need a descriptive name to let your user know where they will be going and a unique identifier for RShiny to know where to take them.

```R
# Sidebar layout and structure
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem('Overview', tabName='overviewID')
  )
  
  # end of sidebar
)

# Overall dashboard page
dashboardPage(
  dashboardHeader(title='IDB Data Analysis and Visualization'),
  sidebar,
  body
  
  # end of dashboard page
)
```

The body in RShiny dashboards will have the main contents to each page of your application. tabItems are can be structured in a lot of different ways, however each tabItem is required to contain a tabName, and this tabName needs to be the same as the tabName that you wrote in your sidebar menuItem. This is how RShiny knows where to send the user when they click on a particular tab.
```R
# Overview tabItem
overviewTab <- tabItem(
  tabName='overviewID' # This is the same ID as in sidebar
)

# Body layout and structure
body <- dashboardBody(
  
  # Tab Items for body
  tabItems(
    overviewTab # overview tab inserted into the body
  )
  
  # end of body
)

# Sidebar layout and structure
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem('Overview', tabName='overviewID')
  )
  
  # end of sidebar
)
```

For our web application we want to have an Overview page describing the project in some more detail. For structure we will be dividing our Overview page into different horizontal rows called fluidRows. Think of layout our page as set of shelves. Each fluidRow is one shelf and everything in one shelf exists at the same height. On the first fluidRow (or shelf) we will be putting in a box, think of this as an organizational box dividing up the current shelf. IN this box we will put an h1 header, that will contain the title, “Inter-American Development Bank Overview”, and a placeholder description, “IDB overview content will eventually go here”.

```R
overviewTab <- tabItem(
  tabName='overviewID',
  fluidRow(
    width=12,
    box(
      h1('Inter-American Development Bank Overview'),
      'IDB overview content will eventually go here'
    )
  )
)
```

This is the simplest version of what a tabItem or page could be. It has a tabName that is the same ID as our tabName in our sidebar, and it contains a row with a box that has some text.

Lets create another page. This page will be our gdpTab and will eventually contain a graph with the GDP for different countries in Latin America.  First, we need to add it to the sidebar as another menuItem. We’ll give it a name, “GDP Trends”, and a unique identifier to link to later, lets call it “gdpID”. 

```R
# Sidebar layout and structure
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem('Overview', tabName='overviewID'),
    menuItem('GDP Trends', tabName='gdpID')
  )
  
  # end of sidebar
)
```

Now that we have this tab registered in our sidebar lets go ahead and create a tabItem with the same tabName and place it in our body. Remember body is where we keep the contents of all our pages.

```R
# GDP tabItem
gdpTab <- tabItem(
  tabName='gdpID'
)

# Body layout and structure
body <- dashboardBody(
  
  # Tab Items for body
  tabItems(
    overviewTab, # overview tab inserted into the body
    gdpTab
  )
  
  # end of body
)
```

Now we will go ahead and give our gdpTab a fluidRow (a shelf), and a box within it. Now this page will be a little bit more complicated because it will take in data that our server will be sending us. Remember the backend is responsible for sending the frontend all the information we need to display. Our frontend of UI (user interface) needs to know where and how to display the information it will be sent.

As an example lets send the server some text from the user, and have it return “the server says, [USER TEXT] was sent to it by the user.” First we’ll have to create a text box for the user to input their message. This can be done with textInput. textInput takes in a unique inputId like “userTextID”, that the server will reference later, and a label for the textbox, in our case “Please enter your text below:”. Then we need to tell RShiny where to display the text that comes in from the server. This is done with textOutput, textOutput only needs a server outputID to be written in between quotation marks that references the text that the server is sending, like “serverTextID”.

```R
gdpTab <- tabItem(
  tabName='gdpID',
  fluidRow(
    width=12,
    box(
      textInput(inputId='userTextID', "Enter you text below:"),
      textOutput("serverTextID")
    )
  )
)
```

## The server.R file
The server.R file will be responsible for storing, organizing, analyzing and visualizing our data. The server needs to be structured like this:

```R
library(tidyverse)
library(shiny)

server <- function(input, output) {

}
```

Think of the server as a function that takes in two variables: input and output. Input is a collection of all input id’s and the variables associated with them, and a collection of all output id’s and the variables associated with them.

Anything that the ui or frontend sends the server will be in the variable input. Similarly everything that the server wants to send to the ui or frontend needs to be put in output.

We know that our GDP Trends page is sending user text with the id “userTextID”. On the server side we can reference user inputs like this "input$uniqueInputID", in our case input$userTextID. Similarly output variables can be stored or updated by using output$uniqueOutputID. In our front end we said we would display text from the server that had a unique id of “serverTextID”, so we would reference it as output$serverTextID.

The snippet of code below will take the user generated text associated with “userTextID”, and place it in the middle of the string “The server was sent: [USER GENERATED TEXT], by the user!” and finally return it to the UI with the id serverTextID.

````R
server <- function(input, output) {
  # note the output server ID here
  output$serverTextID <- renderText({
    # note the user ID here
    paste("The server was sent: [", input$userTextID, '], by the user!')
  })
}
````

Below is the code we have for ui.R so far. Try creating a file ui.R and server.R in the same folder and opening them with RStudio. Copy paste our code into your files. Then click on the server.R file and try press the button “Run App” see what appears and what we have created. It should look like this:

## ui.R code
```R
library(shiny)
library(shinydashboard)

# Overview tabItem
overviewTab <- tabItem(
  tabName='overviewID',
  fluidRow(
    width=12,
    box(
      h1('Inter-American Development Bank Overview'),
      'IDB overview content will eventually go here'
    )
  )
)

gdpTab <- tabItem(
  tabName='gdpID',
  fluidRow(
    width=12,
    box(
      textInput(inputId='userTextID', "Enter you text below:"),
      textOutput("serverTextID")
    )
  )
)

# Body layout and structure
body <- dashboardBody(
  
  # Tab Items for body
  tabItems(
    overviewTab, # overview tab inserted into the body,
    gdpTab
  )
  
  # end of body
)

# Sidebar layout and structure
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem('Overview', tabName='overviewID'),
    menuItem('GDP Trends', tabName='gdpID')
  )
  
  # end of sidebar
)

# Overall dashboard page
dashboardPage(
  dashboardHeader(title='IDB Data Analysis and Visualization'),
  sidebar,
  body
  
  # end of dashboard page
)
```

## server.R code
```R
library(tidyverse)
library(shiny)

server <- function(input, output) {
  # note the output server ID here
  output$serverTextID <- renderText({
    # note the user ID here
    paste("The server was sent: [", input$userTextID, '], by the user!')
  })
}
```
