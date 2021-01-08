myData <- read.csv(file = "C:/Users/paynesc/Documents/research/10_3_2020Tidy.csv")

#Filters out results outside of 3 standard deviations of the mean for each level of each story.
filterOutliers<-function(experimentData, story){
  library(tidyverse)
  averages <- list(c(1:5), c(1:5))
  numGuessesPerLevel <- list(c(1:5), c(1:5))
  storyData <- experimentData %>% pull(3+story)
  groupNumbers <- experimentData %>% pull(3)
  conditions <- experimentData %>% pull(2)
  numTotalGuesses <- length(storyData)
  socialLevelList <- list(list(),list(),list(),list(),list())
  nsocialLevelList<- list(list(),list(),list(),list(),list())
  allLevelsList <- list(socialLevelList, nsocialLevelList)
  
  for(i in (1 : numTotalGuesses)){
    storyLevel <- groupNumbers[i]
    cond <- conditions[[i]]
    isSocial <- 1
    
    if(!identical(as.character(cond), "Social")){
      isSocial <- 2
    }
    
    currentLevelList <- allLevelsList[[isSocial]][[storyLevel]]
    allLevelsList[[isSocial]][[storyLevel]] <- append(currentLevelList, storyData[[i]])
    averages[[isSocial]][[storyLevel]] = averages[[isSocial]][[storyLevel]] + storyData[[i]]
    numGuessesPerLevel[[isSocial]][[storyLevel]] = numGuessesPerLevel[[isSocial]][[storyLevel]] + 1
  }
  
  for(i in (1:5)){
    averages[[1]][[i]] = averages[[1]][[i]] / numGuessesPerLevel[[1]][[i]]
  }
  for(i in (1:5)){
    averages[[2]][[i]] = averages[[2]][[i]] / numGuessesPerLevel[[2]][[i]]
  }
  
  stdDevs <- list(c(1:5), c(1:5))
  
  for(cond in (1:2)){
    for(lvl in 1:5){
      stdDevs[[cond]][[lvl]] = 3 * sd(unlist(allLevelsList[[cond]][[lvl]]))
    }
  }
  
  print(stdDevs)
  
  filData <- experimentData[0,]
  
  for(i in (1: numTotalGuesses)){
    storyLevel <- groupNumbers[i]
    cond <- conditions[[i]]
    isSocial <- 1
    
    if(!identical(as.character(cond), "Social"))isSocial <- 2
    
    guess <- storyData[[i]]
    meanForStory <-averages[[cond]][[storyLevel]]
    stdForStory <- stdDevs[[cond]][[storyLevel]]
    if(abs(guess - meanForStory) <= stdForStory) filData <- rbind(filData,experimentData[i,])
    
  }
  
  return(filData)
}

filterOutliersALL<-function(startExperData){
  
  experimentData <- startExperData
  
  for(story in (1:4)){
    library(tidyverse)
    averages <- list(c(1:5), c(1:5))
    numGuessesPerLevel <- list(c(1:5), c(1:5))
    storyData <- experimentData %>% pull(3+story)
    groupNumbers <- experimentData %>% pull(3)
    conditions <- experimentData %>% pull(2)
    numTotalGuesses <- length(storyData)
    socialLevelList <- list(list(),list(),list(),list(),list())
    nsocialLevelList<- list(list(),list(),list(),list(),list())
    allLevelsList <- list(socialLevelList, nsocialLevelList)
    
    for(i in (1 : numTotalGuesses)){
      storyLevel <- groupNumbers[i]
      cond <- conditions[[i]]
      isSocial <- 1
      
      if(!identical(as.character(cond), "Social")){
        isSocial <- 2
      }
      
      currentLevelList <- allLevelsList[[isSocial]][[storyLevel]]
      allLevelsList[[isSocial]][[storyLevel]] <- append(currentLevelList, storyData[[i]])
      averages[[isSocial]][[storyLevel]] = averages[[isSocial]][[storyLevel]] + storyData[[i]]
      numGuessesPerLevel[[isSocial]][[storyLevel]] = numGuessesPerLevel[[isSocial]][[storyLevel]] + 1
    }
    
    for(i in (1:5)){
      averages[[1]][[i]] = averages[[1]][[i]] / numGuessesPerLevel[[1]][[i]]
    }
    for(i in (1:5)){
      averages[[2]][[i]] = averages[[2]][[i]] / numGuessesPerLevel[[2]][[i]]
    }
    
    stdDevs <- list(c(1:5), c(1:5))
    
    for(cond in (1:2)){
      for(lvl in 1:5){
        stdDevs[[cond]][[lvl]] = 3 * sd(unlist(allLevelsList[[cond]][[lvl]]))
      }
    }
    
    print(stdDevs)
    
    filData <- experimentData[0,]
    
    for(i in (1: numTotalGuesses)){
      storyLevel <- groupNumbers[i]
      cond <- conditions[[i]]
      isSocial <- 1
      
      if(!identical(as.character(cond), "Social"))isSocial <- 2
      
      guess <- storyData[[i]]
      meanForStory <-averages[[cond]][[storyLevel]]
      stdForStory <- stdDevs[[cond]][[storyLevel]]
      if(abs(guess - meanForStory) <= stdForStory) filData <- rbind(filData,experimentData[i,])
      
    }
    experimentData <-filData
  }
  
  
  return(filData)
}
