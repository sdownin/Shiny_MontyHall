
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)
source('MontyHall.R')

shinyServer(function(input, output) {
  
  output$stratPlot <- renderPlot({
  
    g <- input$games
    #     d <- as.numeric(input$doors)
    d <- 3  # address number or doors here
    x    <- MontyHallStrat(games = g,doors = d,strategy = input$strategy,set.seed = 1) 
    
    # draw the histogram with the specified number of bins
    par(mfrow=c(1,2))
    if (input$strategy=='switch') {
      
      plot(x, type='l',main=paste("You Chose Wisely!\nMean After ",g," Games: ",round(mean(x),4)),
           xlab='Number of Games',
           ylab = "Probability",
           lwd=2,ylim=c(0,1), col='dark green');
      abline(h=2/3,col='red')
      # draw the histogram with the specified number of bins
      plot(density(x), main="Density of Cumulative Probability Avg.s",xlim=c(.1,.9)); abline(v=2/3,col='red')
      
    } else if (input$strategy=='random') {
      
      plot(x, type='l',main=paste("Make a Call...Switch or Stay\nRandom Mean After ",g," Games: ",round(mean(x),2)),
           xlab='Number of Games',
           ylab = "Probability",
           lwd=2,ylim=c(0,1) );
      abline(h=1/2,col='red')
      # draw the histogram with the specified number of bins
      plot(density(x), main="Density of Cumulative Probability Avg.s",xlim=c(.1,.9)); abline(v=1/2,col='red')
      
    } else {   #if strategy == 'stay'
      
      plot(x, type='l',main=paste("You Chose Poorly :(\nMean After ",g," Games: ",round(mean(x),4)),
           xlab='Number of Games',
           ylab = "Probability",
           lwd=2,ylim=c(0,1), col='dark gray');
      abline(h=1/3,col='red')
      # draw the histogram with the specified number of bins
      plot(density(x), main="Density of Cumulative Probability Avg.s",xlim=c(.1,.9)); abline(v=1/3,col='red')
      
    }
    
  })  #end renderPlot
  ###################################################################
  
  output$doorsPlot <- renderPlot({
    
    g <- input$games
    d <- 3:17
    
    swi <- numeric(15)
    ran <- numeric(15)
    sta <- numeric(15)
    for (i in 1:15) {
      swi[i] <- mean(MontyHallStrat(games = g,doors = 2+i,strategy = "switch",set.seed = 1))
      ran[i] <- mean(MontyHallStrat(games = g,doors = 2+i,strategy = "random",set.seed = 1))
      sta[i] <- mean(MontyHallStrat(games = g,doors = 2+i,strategy = "stay",set.seed = 1))
    }
    
    plot(x = 3:17,y=swi, type='o',xlab="Doors",ylab='Probability', 
         main=paste('Empirical Probabilities of Success by Strategy for ',
                    g,
                    ' Games\n(dotted black lines show curves of analytical solutions)'),
         col='green',pch=20)
    legend(x = 12,y=.6,legend = c('switch','random','stay'),col = c('green','blue','red'),lty=1)
    text(x = 3:17,y = swi,labels = round(swi,3),pos = c(4),col='green')
    lines(x = 3:17,y=ran, type='o',col='blue',pch=20)
    text(x=3:7,y=ran[1:5],labels=round(ran[1:5],3),pos=c(1),col='blue')
    lines(x = 3:17,y=sta, type='o',col='red',pch=20)
    text(x=3:22,y=sta,labels=round(sta,3),pos=c(1),col='red')
    x <- seq(from = 3,to = 17, length.out = 200)
    y1 <- (x-1)/(x*(x-2))
    y2 <- 1/(x-1)
    y3 <- 1/x
    lines(x,y1,type='l',col='black',lty=2)
    lines(x,y2,type='l',col='black',lty=2)
    lines(x,y3,type='l',col='black',lty=2)
 
    
    })

  
})  #end shinyServer function
