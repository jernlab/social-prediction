#Computing Posterior Probability
computeModelPosterior_deriv<-function(t_total, t, gamma, t_total_info, flag){
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
    if(t_total_vals[i] >= t){
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


#################################################################################
#################################################################################
#Generating predictions

#The story we would like to plot info for. These are in order of appearance in the Data frame.
# I.e. 1 -> Cake
#      2 -> Bus
#      3 -> Drive
#      4 -> Train
situation<-1

#The value of t_total we want to generate predictions for
t_total = 140

#Reading in the data for the chosen situation
if(situation == 1){
  t_total_info = read.csv("C:/Users/paynesc/Documents/research/finalCakeData.csv", header = FALSE)
}
if(situation == 2){
  t_total_info = read.csv("C:/Users/paynesc/Documents/research/busData.csv", header = FALSE)
}
if(situation == 3){
  t_total_info = read.csv("C:/Users/paynesc/Documents/research/flashDriveData.csv", header = FALSE)
}
if(situation == 4){
  t_total_info = read.csv("C:/Users/paynesc/Documents/research/trainsData.csv", header = FALSE)
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

myData <- read.csv(file = "C:/Users/paynesc/Documents/research/4_7_2020Tidy.csv")
#myData Data Frame Format Example:
# ID       ExpType    Group    Cake     Bus     Drive    Train
# blahblah Social       1       20      10       120       30
# blahblah Social       4       30      40       220       14
# blahblah Social       3       20      10       120       30
# blahblah nonSocial    5       20      10       120       30
# blahblah nonSocial    2       10      42       300       60
# blahblah nonSocial    1       20      10       120       30

#ID = myData[1], ExpType =myData[2], Group = myData[3], Cake = myData[4], etc...

#The t-values for each situation, each situation's t-values are stored in their own vector
allLevels<-list(c(10,20,35,50,70), #Cake
                c(2,10,20,30,45),  #Bus
                c(5,28,57,96,125), #Flash Drive
                c(2,4,8,16,30))    #Train

#The titles of each of the graphs. This was done for convenience.
allLabels<-c("Cake", "Bus", "Drives", "Train")
socialLabels<-c("Social - Cake", "Social - Bus", "Social - Drives", "Social - Train")
nonsocialLabels<-c("Non-Social - Cake", "NonSocial - Bus", "NonSocial - Drives", "NonSocial - Train")

#Declaring variables needed to calculate the average/predicted value for each t-value (level) of the story in the experiment
avg <- 0
count <- 0
levelsVec <- allLevels[[situation]]
levelAvg <- c(1:5) #Aka socPred. This is the vector of predicted values for the social context.
nonSocPred<-c(1:5) #Vector of predicted values for the non-social context.
lvl<-0             #The current level of situation we are calculating the average for.




#Calculate the averages for each level of the story for the social case.
for(lvl in 1:5){
  avg = 0
  count = 0
  for (i in 1:53) {
    if(myData[i,3] == lvl){
      avg = avg + myData[i,3+situation] # The columns in the data frame are 
      count = count + 1
      avg_list = append(avg_list, myData[i,3 + situation])
      lvl_list = append(lvl_list, allLevels[[situation]][lvl])
            
    }
  }
  avg = avg/count
  levelAvg[lvl] = avg
  
}

#Calculate the averages for each level of the story for the non-social case.
for(lvl in 1:5){
  avg = 0
  count = 0
  for (i in 54:101) {
    if(i == 70) next;
    if(myData[i,3] == lvl){
      # avg = avg + myData[i,3+situation]
      # count = count + 1
      # 
      avg_list2 = append(avg_list2, myData[i,3 + situation])
      lvl_list2 = append(lvl_list2, allLevels[[situation]][lvl])
    }
  }
  avg = avg/count
  nonSocPred[lvl] = avg
}


#Plot the graphs

predictionPlot = ggplot(mapping = aes(lvl_list, avg_list)) +xlab("t")+stat_summary(fun = mean, geom="point")+stat_summary(fun.data = mean_95CI, geom="errorbar")+ylab("Predicted t_total")+ggtitle(socialLabels[situation])+xlim(0, t_total)
predictionPlot = predictionPlot + geom_line(mapping = aes(x = x_vals,y =y1_vals), color="brown")

nonSocPlot = ggplot(mapping=aes(lvl_list2, avg_list2))+stat_summary(fun = mean, geom="point")+stat_summary(fun.data = mean_95CI, geom="errorbar") +xlab("t")+ylab("Predicted t_total")+ggtitle(nonsocialLabels[situation])+xlim(0, t_total)
nonSocPlot = nonSocPlot + geom_line(mapping = aes(x=x_vals, y=y2_vals), color="blue")

grid.arrange(predictionPlot, nonSocPlot)
