MontyHallStrat <- function(games,             #number of games
                           doors=3,           #number of doors
                           strategy="switch", # {switch, random, stay}
                           set.seed=1,        #for reproducibility
                           plot=F             #logical to plot cumu avg
) {
  set.seed(set.seed)
  # contestant chooses door:
  x1 <- sample(x = 1:doors, size = games, replace = T)
  # car behind door:
  x2 <- sample(x = 1:doors, size = games, replace = T)
  x3 <- rep(NA,games)  # vec to record door contestant switches to
  x4 <- rep(NA,games)  # vec to record if contestant wins
  r <- rep(NA,games)   # vec to record door removed (opened) by Monty Hall
  x <- rbind(x1,x2,x3,x4,r)
  d <- 1:doors  #door list
  
  for (i in 1:dim(x)[2]) {
    if (doors==3) {
      if (x[1,i] == x[2,i]) { 
        #if contestant chose correctly then Monty chooses between other two doors
        #with equal probability to open one
        x["r",i] <- sample(x = d[-x[2,i]],size = 1) 
      } else {
        #if chose incorrectly then Monty has to open door without car
        x["r",i] <- d[-c(x[1,i],x[2,i])]
      } 
    } else {
      #generalize to >3 doors
      if (x[1,i] == x[2,i]) { 
        #if contestant chose correctly then Monty chooses between other doors
        #with equal probability to open one
        x["r",i] <- sample(x = d[-x[2,i]],size = 1) 
      } else {
        #if chose incorrectly then Monty has to open a door without car
        x["r",i] <- sample(x = d[-c(x[1,i],x[2,i])],
                           size=1,
                           prob=rep(1/(doors-2),doors-2) )
      } 
    }
    
    if(strategy == "switch") {
      #1. switch strategy 
      if(doors==3) {
      x[3,i] <- d[-c(x["r",i],x[1,i])]
      } else {
        #generalize to >3 doors
        x[3,i] <- sample(x = d[-c(x["r",i],x[1,i])],size = 1)
      }
      
    }else if (strategy == "random") {
      #2. random strategy to switch or not
      x[3,i] <- sample(x = d[-c(x["r",i])], size = 1)
    } else {
      #3. always stay
      x[3,i] <- x[1,i]
    }
  }
  
  #assign binary response (1=win; 0=lose)
  x[4,which(x[2,]==x[3,])] <- 1  #if car door equals switched-to door
  x[4,which(x[2,]!=x[3,])] <- 0  #if car door not equal switched-to door
  
  m <- mean(x[4,])
  
  # cumulative average over games
  vec <- c()
  for (i in 1:dim(x)[2]){
    vec[i] <- mean(x[4,1:i])
  }
  
  if (plot) {
    par(xpd=F) # keep abline inside plot frame
    par(mfrow=c(1,1))
    plot(vec,type='l',main=paste("Mean After",games,"Games :",m),ylab="probability",lwd=2,ylim=c(0,1));abline(h= 2/3, col='red')
  }
  
  return(list(mean=m,cumu.avg=vec,data.frame=x))
} #end function



# # run function
# x <- MontyHallStrat(games = 50000,strategy="switch", set.seed = 1, plot=F)
# 
# # plot segments cumu avg and density
# png("MontyHall.png",width = 12,height = 8,units = "in",res = 500)
# par(mfrow=c(2,3))
# plot(x[[2]][1:1000],type='l',main=paste("Mean After 1000 Games: ",x[[2]][1000]),ylab="probability",lwd=2,ylim=c(0,1));abline(h= 2/3, col='red')
# plot(x[[2]][1:10000],type='l',main=paste("Mean After 10,000 Games: ",x[[2]][10000]),ylab="probability",lwd=2,ylim=c(0,1));abline(h= 2/3, col='red')
# plot(x[[2]],type='l',main=paste("Mean After 50,000 Games: ",x[[1]]),ylab="probability",lwd=2,ylim=c(0,1));abline(h= 2/3, col='red')
# plot(density(x[[2]][1:1000]),xlim=c(.5,.9),main="Density of Cumulative Avgs \nThrough 1000 Games");abline(v = 2/3,col="red")
# plot(density(x[[2]][1:10000]),xlim=c(.6,.75),main="Density of Cumulative Avgs \nThrough 10,000 Games");abline(v = 2/3,col="red")
# plot(density(x[[2]]),xlim=c(.6,.75),main="Density of Cumulative Avgs \nThrough 50,000 Games");abline(v = 2/3,col="red")
# dev.off()
# 
# # Comparison of three strategies
# xswitch <- MontyHallStrat(games = 20000,strategy = "switch",set.seed = 1,plot = T)
# xrand <- MontyHallStrat(games = 20000,strategy = "random",set.seed = 1,plot = T)
# xstay <- MontyHallStrat(games = 20000,strategy = "stay",set.seed = 1,plot = T)
# 
# xcomb <- rbind(xswitch[[2]],xrand[[2]],xstay[[2]])
# 
# png("MontyHall3Strat.png",width = 10,height = 6,units = "in",res = 500)
# par(mfrow=c(1,2))
# matplot(x = 1:200,y = t(xcomb)[1:200,], type=c('l'),lty=c(1,1,1),lwd=2, col=c('green','blue','red'),main=paste("Mean After 200 Games:\n","P(Switch)=",xswitch[[2]][1000],", P(Random)=",xrand[[2]][1000],",\nP(Stay)=",xstay[[2]][1000],sep=""),ylab="probability",xlab="Index");legend(x = 110,y = 1,legend = c('switch','random','stay'),lty=1, col=c('green','blue','red'));abline(h = 2/3);abline(h = .5);abline(h = 1/3)
# matplot(x = 1:20000,y = t(xcomb), type=c('l'),lty=c(1,1,1),lwd=2, col=c('green','blue','red'),main=paste("Mean After 20,000 Games:\n","P(Switch)=",xswitch[[1]],", P(Random)=",xrand[[1]],",\nP(Stay)=",xstay[[1]],sep=""),ylab="probability",xlab="Index");legend(x = 13000,y = 1,legend = c('switch','random','stay'),lty=1, col=c('green','blue','red'));abline(h = 2/3);abline(h = .5);abline(h = 1/3)
# dev.off()
# 
# # More than 3 doors ##################################
# swi <- numeric(15)
# ran <- numeric(15)
# sta <- numeric(15)
# for (i in 1:length(swi)) {
#   x1 <- MontyHallStrat(games = 10000,doors = 2+i,strategy = "switch",
#                            set.seed = 1,plot=F)
#   swi[i] <- x1$mean
#   x2 <- MontyHallStrat(games = 10000,doors = 2+i,strategy = "random",
#                         set.seed = 1,plot=F)
#   ran[i] <- x2$mean
#   x3 <- MontyHallStrat(games = 10000,doors = 2+i,strategy = "stay",
#                         set.seed = 1,plot=F)
#   sta[i] <- x3$mean
# }
# # # 
# png("MontyHallprobstratbydoors.png",width = 10,height = 8,units = 'in',res = 400)
# plot(x = 3:17,y=swi, type='o',xlab="Doors",ylab='Probability', main='Empirical Probabilities of Success (10,000 Games) \nfor Strategies by Number of Doors \n(dotted black lines show curves of analytical solutions)',col='green',pch=20);legend(x = 12,y=.6,legend = c('switch','random','stay'),col = c('green','blue','red'),lty=1)
# text(x = 3:17,y = swi,labels = round(swi,3),pos = c(4),col='green')
# lines(x = 3:17,y=ran, type='o',col='blue',pch=20)
# text(x=3:7,y=ran[1:5],labels=round(ran[1:5],3),pos=c(1),col='blue')
# lines(x = 3:17,y=sta, type='o',col='red',pch=20)
# text(x=3:22,y=sta,labels=round(sta,3),pos=c(1),col='red')
# x <- seq(from = 3,to = 17, length.out = 1000)
# y1 <- (x-1)/(x*(x-2))
# y2 <- 1/(x-1)
# y3 <- 1/x
# lines(x,y1,type='l',col='black',lty=2)
# lines(x,y2,type='l',col='black',lty=2)
# lines(x,y3,type='l',col='black',lty=2)
# dev.off()

