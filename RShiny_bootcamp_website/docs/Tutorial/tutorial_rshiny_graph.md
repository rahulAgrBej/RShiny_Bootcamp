---
id: tutorial_rshiny_graph
title: 3.1-Returning a Graph with RShiny
sidebar_position: 5
---

In this lesson we will be using the functions we created in test.R to read our data into our web application and return a graph of GDP trends for countries that our user selects.

What we will be doing:
- Read our dataset into our web application
- Send a custom country list from the user to the server
- Have the server receive the custom list and create a custom line graph to send to the UI

Lets copy paste the getData and generate_gdp_timeline functions we defined in test.R at the top of the server.R file, shown below.

[INSERT CODE SNIPPET OF SERVER WITH helper functions included]

Now we will be creating a custom function in the server portion of code that will call our getData function and read in our code. We will be doing with reactive({}), this allows for the most efficient way of uploading data to your application, as it will only upload it as needed and will keep a local copy, that only gets updated if our underlying data changes. This keeps us from having to read in the whole data set each time that we want to create a visual.

[ENTER CODE SNIPPET of dataInput]

Note that dataInput above is a function. This is because while explicitly running our code to load our dataset, it is also checking to see if the value got updated since last uploaded. If not then it returns the local copy which is a lot faster. Therefore every time we want our data on the server side we will have to write it as “dataInput()”, calling the function.

Note that we already have an input that records countries that the user selects: our multiInput selector! This was our code for it:

[CODE SNIPPET OF multiInput selector]

So we can reference a list of user selected countries with input$countries_gdp. We also have a function that returns a line graph of countries and their GDPs per capita based on data and a country list. So in this next step we will combine all of these to have the server generate this graph and return it with and the ID “gdpTimeline”. Find the code below:

[CODE SNIPPET OF gdpTimeline code function server side]

We now have a server that loads our dataset, receives a user selected list of countries and returns a line graph to the UI. Now we just need to tell the UI where to put this graph that the server is sending. Lets go back to our ui.R file (find below):

[CODE SNIPPET OF ui.R]

In our case we want to have our GDP line graph side by side with the country filter options. We currently have a fluidRow (shelf) with one box that contains the country filter options. We want our line graph to be at the same height (on the same shelf/fluidRow) as the filter options, but just to the right in a separate box. For this we will be creating a second box, include a header describing the graph, “GDP per capita (US $)”, and finally include a place for the server to send us our plot, with plotOutput(“gdpTimeline”). Note that we specified the unique ID that we set up for our graph in server.R. Find the code below:

[CODE SNIPPET OF ui.R with plotOutput]

After updating server.R and ui.R, click on your server.R file and then click the “Run App” button to run our web application. Notice how you can insert/remove countries from the line graph easily and without any lag in rendering our new graphs. This is because we aren’t changing the underlying dataset, we are just using the local copy and filtering for a new set of countries.
