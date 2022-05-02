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
  
  startIndex = which(t_total_vals_vec >= t)[1]
  
  likelihood = 1/t_total
  t_total_prior = 0
  t_total_idx <- which(t_total_vals_vec == t)[1]
  if(!is.na(t_total_idx)){
    t_total_prior = t_total_probs_vec[[1]][t_total_idx]
  }

  if(t_total_prior == 0) return (0)
  
  t_totals <- 0
  p_totals <- 0
  
  if(startIndex == 1){
    t_totals <- t_total_vals_vec[[1]]}
  else{
    t_totals <- t_total_vals_vec[[1]][-c(1:startIndex-1)]
  }
  
  p_t_total_rep <- rep(t_total_prior, length(t_totals))
  t_total_rep <- rep(t_total, length(t_totals))
  
  p_t <-  sum(p_t_total_rep/t_total_rep)
  
  #Bayes Rules
  return (likelihood * t_total_prior  / p_t)
  }

generateNonSocialPrediction <- function(t, story=0){
  dataP <-  probs
  maxTtotal <- max(dataP[[1]])
  x_space <- c(t:maxTtotal)
  idx <- 1
  
  allTtotalProbsGivenT <- data.frame(Ttotal = x_space, pTtotalGivenT = rep(maxTtotal-t))
  for(i in x_space){
    probTtotalGivenT <- computeModelPosterior_deriv(i, t, dataP, 5)
    allTtotalProbsGivenT$pTtotalGivenT[idx] <- probTtotalGivenT
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
  
  pred <- allTtotalProbsGivenT$Ttotal[idx-1]
  return(pred)
}

generateMultipleNonSocialPredictions <- function(t, tMax, tMin=NULL){
  tVals <- 0
  if(!is.null(tMin)){
    tVals <- c(tMin:tMax)
  }
  else{
    tVals <- c(t:tMax)
  }
  
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
# ## UNCOMMENT THIS BLOCK TO GENERATE PREDICTIONS INSIDE THIS FILE
# ## ========================================================================================
# # Change this number to match the story you'd like to generate predictions for
# # 1 = Cake
# # 2 = Movie
# # 3 = Podcast
# # Predictions can take as long as 15 minutes to generate depending on your largest value of t you're predicting for.
# storyNum <- 1
# 
# filename <- switch (storyNum, "../Data/cakeProbs.csv", "../Data/movieProbs.csv","../Data/podcastProbs.csv")
# 
# probs <- read.csv(filename)
# 
# startTimestamp <- timestamp()
# df <- generateMultipleNonSocialPredictions(t=10,tMax=110, tMin=1)
# endTimestamp <- timestamp()
# 
# plt <- ggplot(df) + geom_line(mapping = aes(x=t, y=pred), color="blue", size=1.3) + ylab("Prediction") + ggtitle("Non-Social Podcast Duration Predictions") + theme(axis.title.x = element_text(size=20, face="bold"),
#                                                                                                  axis.title.y = element_text(size=20, face="bold"),
#                                                                                                  axis.text.x = element_text(size=16),
#                                                                                                  axis.text.y = element_text(size=16),
#                                                                                                  plot.title = element_text(size=25, face="bold")
#                                                                                                  )+coord_cartesian(xlim=c(0,120))
# plt
# ## ========================================================================================
# ## UNCOMMENT THIS BLOCK TO GENERATE PREDICTIONS INSIDE THIS FILE
