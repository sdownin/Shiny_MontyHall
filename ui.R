
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)
source('MontyHall.R')

shinyUI(fluidPage(responsive = T,
  
  # Application title
  #   headerPanel("Monty Hall Simulation"),
  titlePanel("Let's Make a Deal!"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    
    sidebarPanel(
      
      p("What would you do if you had a chance to stand next to Monty Hall on Let's Make a Deal! and choose which door has the car, and then--after Monty opens one door revealing a goat (ZONK!)--finally choose to stay with your original choice or switch doors? Which strategy would you choose:",style="color:green"),
      p(strong("1. Switch doors")),
      p(strong("2. Randomly choose")),
      p(strong("3. Stay with 1st Choice")),
      p("Hint: The correct decision--and there is a right and wrong here--can be empirically supported with simulation showing which strategy has the highest expected probability of success in the long run.", style="color:green"),
      
      selectInput("strategy",
                  em("Choose a strategy:",style="color:red"),
                  c("switch" = "switch",
                    "random" = "random",
                    "stay" = "stay"),
                  selected="random"),
      p('Want to understand why? This lecture explains it all:', style="color:gray"),
      a("Harvard Stat 110: Probability - Lec.6",href="https://www.youtube.com/watch?v=fDcjhAKuhqQ",target="_blank"),
      
#       submitButton("Choose a Door!"),
      
      h4("How many games do you get to play?"),
      
      sliderInput("games",
                  "Number of games:",
                  min = 100,
                  max = 2000,
                  value = 100,
                  step = 100)
      
    ),  #end sidePanel
    
    # Show a plot of the generated distribution
    mainPanel(
      h3("What are your chances of success?"),
      h5("(3-Door Game)")
      ,
      plotOutput("stratPlot")
      ,
      h3("But what if Monty added more doors?")
      ,
      #       plotOutput("histPlot"),
      plotOutput("doorsPlot")
      
    ) #end mainPanel
    
  )  #end sidebarLayout
))