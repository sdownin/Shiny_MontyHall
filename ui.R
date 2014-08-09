
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Let's Make a Deal!\nWhat Should You Do?"),
  
  # Sidebar with a slider input for number of bins
  sidebarPanel(
    sliderInput("doors",
                "Number of Doors:",
                min = 3,
                max = 20,
                value = 3)
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("distPlot")
  )
))
