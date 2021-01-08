makeLMECompatible<-function(dataFr){
  stories = c("Cake", "Bus", "Drive", "Train") #These stories will be coded in the new data as 1 - 4 respectively
  
  len = length(dataFr$Group)
  lmeDataFr = data.frame("subject"=numeric(0), "context"=numeric(0),"domain"=numeric(0), "level"=numeric(0), "guess"=numeric(0))
  for(i in (1:len)){
    curRow = dataFr[i,]
    context = ifelse(identical(as.character(curRow$ExpType), "Non-Social"), 1, 2) #Non-Social will be coded as 1, Social will be coded as 2  
    guesses = curRow[4:7]
    level = curRow$Group
    subject = curRow[[1]]
    for(j in (1:4)){
      lmeDataFr <- rbind(lmeDataFr, data.frame("Subject"=subject, "Context" = context, "Domain" = j, 
                                               "Level" = level, "Guess" = guesses[[j]]))
    }
    
  }
  
  return(lmeDataFr)
}

