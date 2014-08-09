
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Let's Make a Deal! What Should You Do?"),
  
  # Sidebar with a slider input for number of bins
  sidebarPanel(
    h1("What's your game strategy?"),
    selectInput("strategy", 
                "Choose a strategy x:",
                choices = c('switch','random','stay'), 
                selected = 'switch'), 
    h2("How many games do you get to play?"),
    sliderInput("games",
                "Number of games:",
                min = 1,
                max = 50000,
                value = 100,
                step = 1,
                animate = T),
    h2("What happens if Monty adds more doors?"),
    selectInput("doors",
                "Number of doors:",
                choices = c(3,4,5,6,7,8,9,10,11,
                            12,13,14,15,20,50,100),
                selected = 3),
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("stratPlot")
  )
))
