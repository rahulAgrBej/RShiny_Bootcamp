---
id: tutorial_organizing_files
title: 4.0-Organizing your files
sidebar_position: 6
---

## What we have so far

Right now we have two main files that make our whole web application work:
- ui.R
- server.R

However there is a lot of code in each file which will not only grow as we add more functionality but it also makes it harder to debug and focus. The solution to this is to divide up your codebase into a series of different files that follow some kind of logical order.

Our web application can be thought of as having  3 kinds of parts:
- A central server brain that coordinates UI inputs and server outputs
- A central ui system that organizes the layout of the whole application
- Different pages
    - each of which have a UI component
    - each of which have a server component

## A scalable organization system

Based on this we can start defining an organizational system that can help us remain organize as we scale.
Industry standard is to keep:
- A central server file feeding the UI inputs and sending the corresponding server outputs
- A central UI file that establishes the overall structure/layout of the website
- Two files per page/tab
    - One file that defines the UI, or structure/layout, for the specific page
    - One file that defines the 

## Transfering our system over

Here is how this would apply for our current web application.
- ui.R: keeps the overall structure which includes,
    - dashboard
    - sidebar
    - body
- server.R: calls all relevant functions that create server outputs
    - dataInput
    - output$gdpTimeline
- gdpUI.R: contains the tabItem for GDP page we made
- gdpServer.R: contains the generate_gdp_timeline function
- helpers.R: contains the getData function

## ui.R

## server.R

## gdpUI.R

## gdpServer.R

## helpers.R