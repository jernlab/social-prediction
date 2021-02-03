source('filterOutliers.r')
source('computeModelPosterior.r')
source('makeLMECompatible.r')

library(ggplot2)
library(lmerTest)
library(ggplot2)
library(gridExtra)
library(tidyverse)

#################################################################################
#################################################################################
#Generating predictions

#The story we would like to plot info for. These are in order of appearance in the Data frame.
# I.e. 1 -> Cake
#      2 -> Bus
#      3 -> Drive
#      4 -> Train
situation<-1
experimentVersion = 1
#The t-values for each situation, each situation's t-values are stored in their own vector
if(experimentVersion == 1){
  allLevels<-list(c(10,20,35,50,70), #Cake
                  c(2,10,20,30,45),  #Bus
                  c(5,28,57,96,125), #Flash Drive
                  c(2,4,8,16,30))    #Train
  #Cake= ,Bus = 0.8, Drives = 3.0 + , Train = 0.2,
  jitterAmts = c(2.0, 0.5, 3.0, 0.8)

  #The maximum y-values for ggplots, dependent on situation/story
#  yLimits<-list(
#    90,       # Cake,adj = 90 raw = 130
#    55,        # Bus, adj = 55  raw = 730
#    510,      # Flash Drive, adj = 510  raw = 1060
#    130        # Train, adj = 130 raw = 210
#  )
}
if(experimentVersion == 2){
  allLevels<-list(c(10,20,35,50,70), #Cake
                  c(2,5,10,15,21),  #Bus
                  c(5,28,57,96,125), #Flash Drive
                  c(1,2,4,6,7))    #Train

  #Cake= ,Bus = 0.8, Drives = 3.0 + , Train = 0.2,
  jitterAmts = c(2.0, 0.8, 3.0, 0.2)

  #The maximum y-values for ggplots, dependent on situation/story
#  yLimits<-list(
#    100,       # Cake,adj = 125 raw = 125
#    43,        # Bus, adj = 50  raw = 65
#    600,      # Flash Drive, adj = 1100  raw = 2050
#    40        # Train, adj = 40 raw = 405
#  )
}

maxY = 0

#The value of t_total we want to generate predictions for
t_total = allLevels[[situation]][[5]] + 1

plotFormatting <- theme(plot.title = element_text(
  size = 25,
  face = "bold"
), axis.title.x = element_text(
  size = 30,
  face = "bold.italic"
),
axis.title.y = element_text(
  size = 30,
  face= "bold.italic"
),
legend.text = element_text(
  size = 12
),
legend.title = element_text(
  size = 15,
  face = "bold"
),
axis.text.x = element_text(
  size = 25,
  face= "bold"
),
axis.text.y = element_text(
  size = 25,
  face= "bold"
)
)


#Reading in the data for the chosen situation
if(situation == 1){
  t_total_info = read.csv("../dataFiles/finalCakeData.csv", header = FALSE)
}
if(situation == 2){
  t_total_info = read.csv("../dataFiles/busData.csv", header = FALSE)
}
if(situation == 3){
  t_total_info = read.csv("../dataFiles/flashDriveData.csv", header = FALSE)
}
if(situation == 4){
  t_total_info = read.csv("../dataFiles/trainsData.csv", header = FALSE)
}

# t_total_info (the data from the csv file) is a 2 column vector.
# The first column ($V1) is a value and the second column ($V2)
# is the probability associated with that value. (i.e t_total and p(t_total))
# Ex:
#=========
# 1  0.1
# 5  0.08
# 12 0.076
# 13 0.00012
# 17 0.304
# 26 0.0052
# ... ...
#

t_total_vals = t_total_info$V1

gamma = 1 #Left over variable from implementation of the non-augmented model. Ignore this (it isn't used in model prediction)
nvals = length(t_total_vals)

#Vector of x-values for plotting
x_vals<-c(1:t_total)

#Vector of y-values for plotting augmented model (social)
y1_vals <- c(1:t_total)

#Vector of y-values for plotting non-augmented model (non-social)
y2_vals <- c(1:t_total)

# A vector to store calculated posterior P(T_total | T) values.
# (all_post for the social condition, all_post2 for the non-social condition)
all_post <- c(1:nvals)
all_post2 <- c(1:nvals)

avg_list = c()
lvl_list = c()

avg_list2 = c()
lvl_list2 = c()

# Algorithm/Prediction Making Explanation:
# Predictions are made by choosing the t_total value at the median of the probability distribution
# for posteriors.

#For each t value, we will make a prediction
for (i in (1:t_total)){


  # Within our possible t_total values, we find the index of the first value
  # greater than t (because the minimum predicted value cannot be less than
  # what has already been observed).

  startPoint = 0

  for (j in (1:nvals)){
    if(t_total_vals[j] >i){
      startPoint = j
      break
    }
  }

  # If the startPoint is equal to 0, then we found no values of t_total that we
  # could select within the data set that would allow us to make a prediction;
  # thus we predict t_total to be t, as no evidence supports a higher prediction

  if(startPoint == 0){
    y1_vals[i] = i
    y2_vals[i] = i
    next
  }

  # Otherwise we calculate all posteriors from t_total_vals[startPoint] till the end of our data set,
  # find the median, and use the value at the median as the predicted t_total value.
  sum = 0
  sum2 = 0
  for (k in (startPoint: nvals)){

    #Calculate posterior for augmented (social) model
    post = computeModelPosterior_deriv(t_total_vals[k], i, gamma, t_total_info, situation)

    #This simply makes sure the posteriors always start filling from the beginning of the post array
    all_post[k - startPoint + 1] = post
    sum= sum + post

    #Calculate posterior for the non-augmented (non-social) model
    post2 = computeModelPosterior_deriv(t_total_vals[k], i, gamma, t_total_info, 0)
    all_post2[k - startPoint + 1] = post2
    sum2 = sum2 + post2
  }

  #Calculate the t_total at the median of the posteriors for...


  #...The social prediction
  median_amnt = sum/2.0
  median_sum = 0
  post_index = 1

  while(median_sum < median_amnt){
    median_sum = median_sum + all_post[post_index]
    post_index= post_index + 1
  }


  y1_vals[i] = t_total_vals[startPoint + post_index - 2]

  #...The non-social prediction
  median_amnt = sum2/2.0
  median_sum = 0
  post_index = 1

  while(median_sum < median_amnt){
    median_sum = median_sum + all_post2[post_index]
    post_index= post_index + 1
  }
  y2_vals[i] = t_total_vals[startPoint + post_index - 2]
}
library(ggplot2)
library(gridExtra)

###########################################################################
###########################################################################
#Processing Experimental Info per situation
mean_95CI<-function(x){
  return (mean_se(x, 1.96))
}

# if(experimentVersion == 1){
#   nonFilteredData <- read.csv(file = "C:/Users/paynesc/Documents/research/4_7_2020Tidy.csv")
#   myData <- filterOutliers(nonFilteredData, situation)
# }
# if(experimentVersion == 2){
#   nonFilteredData <- read.csv(file = "C:/Users/paynesc/Documents/research/10_3_2020Tidy.csv")
#   myData <- filterOutliers(nonFilteredData, situation)
# }
if(experimentVersion == 1){
  nonFilteredData <- read.csv(file = "../dataFiles/4_7_2020Tidy.csv")
  myData <- filterOutliers(nonFilteredData, situation)
}
if(experimentVersion == 2){
  nonFilteredData <- read.csv(file = "../dataFiles/10_3_2020Tidy.csv")
  myData <- filterOutliers(nonFilteredData, situation)
}


#myData Data Frame Format Example:
# ID       ExpType    Group    Cake     Bus     Drive    Train
# blahblah Social       1       20      10       120       30
# blahblah Social       4       30      40       220       14
# blahblah Social       3       20      10       120       30
# blahblah nonSocial    5       20      10       120       30
# blahblah nonSocial    2       10      42       300       60
# blahblah nonSocial    1       20      10       120       30

#ID = myData[1], ExpType =myData[2], Group = myData[3], Cake = myData[4], etc...



#The titles of each of the graphs. This was done for convenience.
allLabels<-c("Cake", "Bus", "Drives", "Train")
socialLabels<-c("Social: Cake", "Social: Bus", "Social: Drives", "Social: Train")
nonsocialLabels<-c("Non-Social: Cake", "Non-Social: Bus", "Non-Social: Drives", "Non-Social: Train")

#Declaring variables needed to calculate the average/predicted value for each t-value (level) of the story in the experiment
avg <- 0
count <- 0
levelsVec <- allLevels[[situation]]
levelAvg <- c(1:5) #Aka socPred. This is the vector of predicted values for the social context.
nonSocPred<-c(1:5) #Vector of predicted values for the non-social context.
lvl<-0             #The current level of situation we are calculating the average for.






# for(lvl in 1:5){
#   avg = 0
#   count = 0
#
#   for (i in 1:53) {
#     if(myData[i,3] == lvl){
#       avg = avg + myData[i,3+situation] # The columns in the data frame are
#       count = count + 1
#       avg_list = append(avg_list, myData[i,3 + situation])
#       lvl_list = append(lvl_list, allLevels[[situation]][lvl])
#
#     }
#
#     avg = avg/count
#     levelAvg[lvl] = avg
#
#   }}

#Calculate the averages for each level of the story for the non-social case.
for(lvl in 1:5){
  avg = 0
  count = 0
  i = 1
  while(!identical(as.character(myData[i,2]), "Non-Social")){
    i = i + 1
  }
  socialVsNonsocial = as.character(myData[i,2]) #Stores whether current row is a non-social or social experiment result
  while(identical(socialVsNonsocial,"Non-Social")){
    if(myData[i,3] == lvl){
      currentGuess = myData[i,3 + situation]
      if(currentGuess >= maxY) maxY = currentGuess
      avg = avg + currentGuess # The columns in the data frame are
      count = count + 1
      avg_list2 = append(avg_list2, myData[i,3 + situation])
      lvl_list2 = append(lvl_list2, allLevels[[situation]][lvl])
    }
    i = i + 1
    socialVsNonsocial = as.character(myData[i, 2])
  }
  avg = avg/count
  nonSocPred[lvl] = avg
}

#Calculate the averages for each level of the story for the social case.
for(lvl in 1:5){
  avg = 0
  count = 0
  i = 1
  while(!identical(as.character(myData[i,2]), "Social")){
    i = i + 1
  }
  socialVsNonsocial = as.character(myData[i,2]) #Stores whether current row is a non-social or social experiment result
  while(identical(socialVsNonsocial,"Social")){
    if(myData[i,3] == lvl){
      currentGuess = myData[i,3 + situation]
      if(currentGuess >= maxY) maxY = currentGuess
      avg = avg + currentGuess # The columns in the data frame are
      count = count + 1
      avg_list = append(avg_list, myData[i,3 + situation])
      lvl_list = append(lvl_list, allLevels[[situation]][lvl])
    }
    i = i + 1
    socialVsNonsocial = as.character(myData[i, 2])
  }
  avg = avg/count
  levelAvg[lvl] = avg
}

#Plot the graphs

# predictionPlot = ggplot(mapping = aes(lvl_list, avg_list)) +xlab("t")+stat_summary(fun = mean, geom="point")+stat_summary(fun.data = mean_95CI, geom="errorbar")+ylab("Predicted t_total")+ggtitle(socialLabels[situation])+xlim(0, t_total)+coord_cartesian(ylim=c(0, yLimits[[situation]]))
# predictionPlot = predictionPlot + geom_line(mapping = aes(x = x_vals,y =y1_vals), color="brown")
#
# nonSocPlot = ggplot(mapping=aes(lvl_list2, avg_list2))+stat_summary(fun = mean, geom="point")+stat_summary(fun.data = mean_95CI, geom="errorbar") +xlab("t")+ylab("Predicted t_total")+ggtitle(nonsocialLabels[situation])+xlim(0, t_total)+coord_cartesian(ylim=c(0, yLimits[[situation]]))
# nonSocPlot = nonSocPlot + geom_line(mapping = aes(x=x_vals, y=y2_vals), color="blue")
#
# grid.arrange(predictionPlot, nonSocPlot)

#Generating Experiment (box) vs Prediction (line) plots
#=======================================================
                        #Social
#=======================================================

socTibble = tibble(lvl_list, avg_list)
socPlot = ggplot(socTibble, aes(x = factor(lvl_list), y = avg_list))+ xlab("t") +ylab("Predicted t-total") + ggtitle(socialLabels[situation])
socPlot = socPlot + geom_boxplot()+coord_cartesian(ylim=c(0,maxY))
socPlot = socPlot + geom_line(inherit.aes = FALSE, size = 1.3, colour="#0000FF", data = tibble(x_vals, y1_vals), aes(x_vals, y1_vals)) + scale_x_discrete(limits=1:allLevels[[situation]][[5]], breaks=allLevels[[situation]])
socPlot = socPlot + plotFormatting+ scale_color_manual(values=c("#0000FF"))
#=======================================================
                      #Non-Social
#=======================================================
nonSocTibble = tibble(lvl_list2, avg_list2)
nonSocPlot = ggplot(nonSocTibble, aes(x = factor(lvl_list2), y = avg_list2)) + ggtitle(nonsocialLabels[situation])
nonSocPlot = nonSocPlot + geom_boxplot()+ xlab("t") +ylab("Predicted t-total")+coord_cartesian(ylim=c(0,maxY))
nonSocPlot = nonSocPlot + geom_line(inherit.aes = FALSE, size = 1.3, colour="#FF0000", data = data.frame(x_vals, y2_vals), aes(x_vals, y2_vals)) + scale_x_discrete(limits=1:allLevels[[situation]][[5]], breaks=allLevels[[situation]])
nonSocPlot = nonSocPlot + plotFormatting + scale_color_manual(values=c("#FF0000"))

#Generating Social vs Non-Social Scatter plot
numNonSocialGuesses = length(lvl_list2)
numSocialGuesses = length(lvl_list)

#Best widths for jitter
#Cake= ,Bus = 0.8, Drives = 3.0 + , Train = 0.2,
scatterData = data.frame("Levels" = append(lvl_list2, lvl_list), "Guesses" = append(avg_list2, avg_list), "Condition" = append(rep("Non-Social", numNonSocialGuesses), rep("Social", numSocialGuesses)))
scatter = ggplot(data = scatterData)+geom_jitter(aes(x=Levels, y=Guesses, shape=Condition, colour=Condition),width=jitterAmts[[situation]],height=0, alpha=0.55, size=4)
scatter = scatter + ggtitle(paste("Predictions against Level -", allLabels[[situation]] ) ) + ylab("Predicted t-total") + xlab("t")
scatter = scatter + scale_x_discrete(limits=1:((allLevels[[situation]][[5]])+ceiling(allLevels[[situation]][[5]]/25)), breaks=allLevels[[situation]])
scatter = scatter + plotFormatting+ scale_color_manual(values=c("#FF0000", "#0000FF"))
grid.arrange(socPlot, nonSocPlot, scatter)


if(experimentVersion == 1){
  ggsave(paste(allLabels[[situation]], "_nonsocial.pdf", sep=""),plot= egg::set_panel_size(p=nonSocPlot, width = unit(15, "cm"), height=unit(8, "cm")), path=paste("Plots/Experiment1/", allLabels[[situation]], sep=""))
  ggsave(paste(allLabels[[situation]], "_social.pdf", sep=""),plot=egg::set_panel_size(p=socPlot, width = unit(15, "cm"), height=unit(8, "cm")),path=paste("Plots/Experiment1/", allLabels[[situation]], sep=""))
  ggsave(paste(allLabels[[situation]], "_scatter.pdf", sep=""),plot=egg::set_panel_size(p=scatter, width = unit(15, "cm"), height=unit(8, "cm")),path=paste("Plots/Experiment1/", allLabels[[situation]], sep=""))
}

if(experimentVersion == 2){
  ggsave(paste(allLabels[[situation]], "_nonsocial.pdf", sep=""),plot= egg::set_panel_size(p=nonSocPlot, width = unit(15, "cm"), height=unit(8, "cm")),path=paste("Plots/Experiment1/", allLabels[[situation]], sep=""))
  ggsave(paste(allLabels[[situation]], "_social.pdf", sep=""),plot= egg::set_panel_size(p=socPlot, width = unit(15, "cm"), height=unit(8, "cm")),path=paste("Plots/Experiment1/", allLabels[[situation]], sep=""))
  ggsave(paste(allLabels[[situation]], "_scatter.pdf", sep=""),plot= egg::set_panel_size(p=scatter, width = unit(15, "cm"), height=unit(8, "cm")),path=paste("Plots/Experiment1/", allLabels[[situation]], sep=""))
}

#Calculating Errors
#=======================================================
                  #Mean-Squared Error
#=======================================================
meanSquaredErrorSocial = 0
meanSquaredErrorNonSocial = 0

predictionsPerContext <- matrix(nrow=2, ncol=5)
for(i in 1:5){
  lvl = levelsVec[i]
  predictedValue = y1_vals[lvl]
  experimentValue = levelAvg[i]
  predictionsPerContext[1,i] = predictedValue
  meanSquaredErrorSocial = meanSquaredErrorSocial + ((1/5) * ((experimentValue - predictedValue)^2))
}
print(meanSquaredErrorSocial)

for(i in 1:5){
  lvl = levelsVec[i]
  predictedValue = y2_vals[lvl]
  experimentValue = nonSocPred[i]
  predictionsPerContext[2,i] = predictedValue
  meanSquaredErrorNonSocial = meanSquaredErrorNonSocial + ((1/5) * ((experimentValue - predictedValue)^2))
}
print(meanSquaredErrorNonSocial)
#=======================================================
                #Linear-Mixed Modeling
#=======================================================
lmeDf <- makeLMECompatible(nonFilteredData)
m <- lmer(Guess ~ Context + Domain + Level + (1+Domain|Subject), data=lmeDf)
print(summary(m))
print(confint(m,method="Wald"))
