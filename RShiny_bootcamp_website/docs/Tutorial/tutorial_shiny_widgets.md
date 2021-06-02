---
id: tutorial_rshiny_widgets
title: 2.1-RShiny Widgets
sidebar_position: 3
---

Text Inputs and output are just one example of the ways a user can interact with a web application. Here is a list of official RShiny widgets, and here is a list of customizable RShiny widgets (Note that if you are using any from the second list to use include “library(shinyWidgets)” at the top of your code file.

Today we will be updating our “GDP Trends”, page creating a multiInput widget like the one below, from a custom list of countries.
[ENTER IMAGE OF MULTI INPUT SELECTOR FOR COUNTRIES]

Like most selector type inputs, our multiInput will require 4 key attributes: an inputId, label, choices, selected).
- inputId: A unique identifier that the server can use to pull the value selected
- label: this will be the text displayed right above out input widget, something like “Choose countries below:”
- choices: this will be a list of available inputs that the user could select, in our example this will be a list of countries
- selected: this is a list of default selected choices that you can set if you would like, in our case this will be empty, since we don’t have a preference for which input the user looks at first.

Below is the code for our multiInput selector. It’s inputId is “countries_gdp”, its label is “Choose countries:”, and the choices is a list of countries which includes: Argentina, Colombia, MEXICO, PANAMA., our selected list is empty.

```R
library(shiny)
library(shinydashboard)
library(shinyWidget) # NOTE THIS EXTRA LIBRARY

gdpTab <- tabItem(
  tabName='gdpID',
  fluidRow(
    width=12,
    box(
      # Note we eliminated the previous text inputs and outputs, so we just have our multiInput in our GDP page
      multiInput(inputId='countries_gdp',
               label='Choose Countries:',
               choices=c('ARGENTINA', 'COLOMBIA', 'MEXICO', 'PANAMA'),
               selected=c())
    )
  )
)
```

Now re run your web application with your new multiselector and see how a user would interact with it. Notice however that selecting a country hasn’t caused any action to occur. Our goal is to eventually show a graph of a country’s GDP per capita from 2008 to 2017. We will be exploring how to clean and display our graphs in the next lesson.
