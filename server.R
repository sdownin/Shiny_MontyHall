
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)
source('MontyHall.R')  #MontyHallStrat() function

shinyServer(function(input, output) {
  # generate values based on input$____ from ui.R   
  x <- MontyHallStrat(games = input$games, doors = input$doors, strategy = input$strategy, set.seed = 1)
  
  output$stratPlot <- renderPlot({ 
    
    #par(xpd=F) # keep abline inside plot frame
    #par(mfrow=c(1,1))
    plot(x,type='l',main=paste("Mean After",games,"Games :",m),ylab="probability",lwd=2,ylim=c(0,1));abline(h= 2/3, col='red')
    
    
  })
  
})
