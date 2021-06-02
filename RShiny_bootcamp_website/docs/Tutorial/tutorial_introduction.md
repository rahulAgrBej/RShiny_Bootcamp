---
id: tutorial_introduction
title: 1-Introduction
sidebar_position: 1
---

# 1.0-Introduction

Hi Everyone! This is the first lesson in our RShiny bootcamp series. The goal of this bootcamp is to provide any and everyone with the basic skills and resources necessary to understand, create and deploy their first data analytics platform. We will be building a web application.

## What is a web application?

A web application is software that is run on an external web server. Now what is a web server? A web server is just a computer that is connected to the internet. At a high level there are two main components for a web application, the frontend, and the backend.

The frontend (client side) is everything that a user can see on a website. The overall layout of the website, colors, fonts, buttons, textboxes, forms, etc and how the user will end up interacting with the application or site. They design the presentation of the website.

The backend or (server side) is everything that is happening underneath that the user doesn’t see or notice. This entails everything from opening connections and includes but is not limited to storing, analyzing, and organizing data.

When you access a web application you are interacting with the front end.

[PICTURE OF USER ARROW TO FRONT END]

The frontend takes your inputs (username, password, filter options, text) and information and passes it onto the backend.

[PICTURE OF FRONT END TO BACKEND]

The backend then takes the information sent to it and responds with the data or analysis that you requested.

[PICTURE OF BACKEND TO FRONTEND]

The front end accepts this information and presents it correctly to you.

[PICTURE FRONTEND TO THE USER]

## What we will be creating

We will be creating a web application with R and the RShiny and tidyverse packages. Our web application with serve to visualize and present data from the Inter-American Development Bank. Here is a link to finished version of the application we will be creating.

- RShiny is an R package that makes it easy to build web applications in R.
    - We will be using RShiny to manage our frontend and backend.
- Tidyverse is a collection of R packages that built to make data science easier in R.
    - We will be using tidyverse to clean, analyze and create our data visualizations.