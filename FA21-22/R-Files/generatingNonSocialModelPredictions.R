#Non-Social Model Predictions


library(purrr)
library(ggplot2)

computeModelPosterior_deriv<-function(t_total, t, t_total_info, flag){
  #t_total        : The value of t_total in P(t_total | t)
  #t              : The value of t in P(t_total | t)
  #gamma           : gamma parameter (Not used in generating these predictions, leftover from implementation of original model)
  #t_total_info   : a Domain Size x 2 vector, 1st column are t_total values, 
  #                 2nd is P(t_total)
  #flag           : The story (cake, bus, drive, train) we're calculating posterior for
  #                             1     2     3      4
  
  startIndex = 0
  
  #Vector of all t_total values
  t_total_vals_vec = t_total_info[1]
  
  #Vector of all t_total_probs
  t_total_probs_vec = t_total_info[2]
  num_rows = nrow(t_total_vals_vec)
  
  for(i in (1:num_rows)){
    if(t_total_info[i,1] >= t){
      startIndex = i
      break
    }
  }
  
  para = 0.3
  
  #The cake, bus, and drive stories all use the same utility function
  if(flag == 1 || flag == 3 || flag == 2){
    if(t_total - t != 0){
      util = exp(1/(t_total - t))
      util = util / (exp((t_total - t)*para) + util)
    }
    else {
      util = 1
    }
    likelihood = (1/t_total) * util
  }
  # The utitlity function for the train story
  else if(flag == 4){
    util = exp(t_total-t)
    util = util / (exp((1/(t_total - t))*para) + util)
    likelihood = (1/t_total) * util
  }
  
  else likelihood = 1/t_total #Otherwise generate non-social predictions
  
  t_prior = 0
  given_t_total_prior = 0
  
  #P(t) = sum of p(t_total)/t_total
  for(i in (1:num_rows)){
    t_prior = t_prior + (t_total_probs_vec[i,]/t_total_vals_vec[i,])
    #Storing the t_total probability for the t_total passed as the function's parameter
    if(t_total_vals_vec[i,] == t_total) given_t_total_prior = t_total_probs_vec[i,]
  }
  
  #Bayes Rules
  return (likelihood * given_t_total_prior) / t_prior
}

generateNonSocialPrediction <- function(t, story=0){
  dataP <-  probs
  maxTtotal <- max(dataP$runtime)
  x_space <- c(t:maxTtotal)
  idx <- 1
  
  allTtotalProbsGivenT <- data.frame(Ttotal = x_space, pTtotalGivenT = rep(maxTtotal-t))
  for(i in x_space){
    probTtotalGivenT <- computeModelPosterior_deriv(i, t, dataP, 5)
    allTtotalProbsGivenT$pTtotalGivenT[idx] <- probTtotalGivenT
    # print(probTtotalGivenT)
    idx <- idx + 1
  }
  
  #Predict Median
  sum = 0
  pTtotalGivenT <- allTtotalProbsGivenT$pTtotalGivenT
  medi <- sum(pTtotalGivenT)/2
  idx = 1
  lenpTtotal <- length(pTtotalGivenT)
  while (sum < medi && idx < lenpTtotal) {
    sum = sum + pTtotalGivenT[idx]
    idx = idx + 1
  }
  
  #pred <- paste("Prediction for T-total given T = ", t, ": ", allTtotalProbsGivenT$Ttotal[idx-1])
  pred <- allTtotalProbsGivenT$Ttotal[idx-1]
  # print(pred)
  return(pred)
}

generateMultipleNonSocialPredictions <- function(t, tMax, tMin=NULL){
  # t <- 50
  # tMax <- 100
  tVals <- 0
  if(!is.null(tMin)){
    tVals <- c(tMin:tMax)
  }
  else{
    tVals <- c(t:tMax)
  }
  #print(range(tVals))
  df <- data.frame(t=tVals, pred=rep(0, length(tVals)))
  
  ix = 1

  for(tVal in tVals){
    print("Generating for ")
    print(tVal)
    pred = generateNonSocialPrediction(t=tVal)
    df$pred[ix] <- pred
    ix = ix + 1
  }
  

  return(df)
}

#data_file_path <- "C:\\Users\\paynesc\\Documents\\research\\Attempt2\\data\\Podcast\\applePodcastFilteredProbs.RData"
#data <-  read.csv(data_file_path, header = TRUE)
#load(data_file_path)

startTimestamp <- timestamp()
df <- generateMultipleNonSocialPredictions(t=10,tMax=110, tMin=1)
endTimestamp <- timestamp()

plt <- ggplot(df) + geom_line(mapping = aes(x=t, y=pred), color="blue", size=1.3) + ylab("Prediction") + ggtitle("Non-Social Podcast Duration Predictions") + theme(axis.title.x = element_text(size=20, face="bold"),
                                                                                                 axis.title.y = element_text(size=20, face="bold"),
                                                                                                 axis.text.x = element_text(size=16),
                                                                                                 axis.text.y = element_text(size=16),
                                                                                                 plot.title = element_text(size=25, face="bold")
                                                                                                 )+coord_cartesian(xlim=c(0,120))
plt
 