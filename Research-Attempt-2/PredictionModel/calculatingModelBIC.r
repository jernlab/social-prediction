source("./generatingSocialModelPredictions.R")
source("./generatingNonSocialModelPredictions.R")

library(dplyr)

#' Calculates BIC for either prediction model & single story in used in the experiment.
#' @param story String: Must be 'cake', 'movie', or 'podcast'
#' @param social Boolean: TRUE to calculate BIC of social model, FALSE for non-social (Original Griffith's & Tenenbaum model)
#' 

calculateBIC <- function (story, social=TRUE){
  
    #Load Correct data based on story
    expResults <- read.csv("../Results/Social-NonSocial/Tidy/filtered-tidy-data.csv")
    
    filename <- switch (story, 
                        cake = "../Data/cakeProbs.csv", 
                        movie = "../Data/movieProbs.csv",
                        podcast = "../Data/podcastProbs.csv")
    
    # Determined via grid search in usingModels.rmd
    bestParams <- switch (story, 
                            cake = c(-4, 40), 
                            movie =  c(-8, 400),
                            podcast =  c(-6.5, 50))
    
    pTtotalDistribution <- read.csv(filename)
    
    # Filter Experiment Data to only social/non-social condition
    storyOnly <- expResults %>% filter(Story == story)
    storyOnly <- if(social){
      storyOnly <- storyOnly %>% filter(Context == "Social")
    }else{
      storyOnly <- storyOnly %>% filter(Context == "Non-Social")
    }
    
    #storing experiment predicted t_total & their associated t
    subjectPredictions <- storyOnly$Prediction
    predictionTs <- storyOnly$T_val
    
    # Getting t's used for each level (ex: in cake case, tsInStory = [10,20,35,50,70])
    tsInStory <- unique(sort(predictionTs))
    
    # Bounds to only calculate only the t_total posteriors
    minBound <- min(subjectPredictions)
    maxBound <- max(subjectPredictions)
    
    tTotalSpace <- c(minBound:maxBound)
    posts <- c(1:2)
    
    # Calculate posteriors for space of t_total values for each t using best fit parameters
    if(social){
      posts <- sapply(tsInStory, function(t) {
        return(sapply(tTotalSpace, function(t_total) 
          computeModelPosterior_social(t_total, t, pTtotalDistribution, bestParams[1], bestParams[2]))
        )
      })
    } else {
      posts <- sapply(tsInStory, function(t) {
        return(sapply(tTotalSpace, function(t_total) 
          computeModelPosterior_deriv(t_total, t, pTtotalDistribution))
        )
      })
    }

    # Storing posteriors in DataFrame for easier lookup
    postDistributions <- as.data.frame(posts)
    postDistributions$t <- tTotalSpace
    colnames(postDistributions) <- c("T1", "T2", "T3", "T4", "T5", "t_total")
    
    ## Lookup likelihood of prediction in the posterior distribution of the corresponding t
    L <- mapply(function(t, prediction){
      whichDistribution <- which(tsInStory == t)[1]
      tTotalRow <- which(postDistributions$t_total == prediction)[1]
      return(postDistributions[[whichDistribution]][tTotalRow])
    }, predictionTs, subjectPredictions)
    
    L_log <- log(L)
    
    # Logs that are VERY small come up as negative infinity. These are converted to 0s before the sum
    
    print(paste("Reduce Amount for",story))
    reduceAmnt <- sum(is.infinite(L_log))
    if(social){
      print(paste('[SOCIAL]' , reduceAmnt))
    }
    else{
      print(paste('[NON-SOCIAL]' , reduceAmnt))
    }
    print(paste("Total Before Reduction:", length(subjectPredictions)))
    print("==============")
    
    L_log <- ifelse(is.finite(L_log), L_log, 0)
    L_hat <- sum(L_log)
    N <- length(subjectPredictions) - reduceAmnt
    k <- ifelse(social, 2, 0)
    
    return (k*log(N) - 2*L_hat)
}

calculateBIC_All <- function(){
  BICS <- list(
    Cake = c(calculateBIC("cake"), calculateBIC("cake",FALSE)),
    Movie = c(calculateBIC("movie"),calculateBIC("movie",FALSE)),
    Podcast = c(calculateBIC("podcast"),calculateBIC("podcast",FALSE))
  )
  
  return(as.data.frame(BICS))
}

BICS <- calculateBIC_All()
BICS <-`row.names<-`(BICS, c("Social", "Non-Social"))





#Generating individual BICS
## Choose story to generate BIC for, 1=Cake, 2=Movie, 3=Podcast ##
# storyNum <- 3
## ================================ ##
# 
# storyName <- switch(storyNum, "cake", "movie", "podcast")
# calculateBIC(storyName)
# calculateBIC(storyName, social = FALSE)