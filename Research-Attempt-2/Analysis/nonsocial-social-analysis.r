library(dplyr)
library(stringr)
library(patchwork)
library(ggfx)

plotStory <- function(story){
  nonSocialPredictons <- read.csv(paste("../GeneratedPredictions/NonSocial/",story,"Predictions.csv", sep = ""))
  
  
  library(ggplot2)
  
  df <- read.csv("../Results/Social-NonSocial/Tidy/filtered-tidy-data.csv")
  
  dfGrouped <- df %>% group_by(Level, Story, Context, T_val) %>% filter(Story == .env$story) 
  
  socialGroup <- dfGrouped %>% summarise(avg = mean(Prediction))
  
  
  write.table(socialGroup[c(3:5)],file=paste(story, "Means.csv", sep = ""), row.names = FALSE, sep=",")
  
  plt <- ggplot(nonSocialPredictons, aes(x=t, y=pred)) + geom_line(size=1.5, color="black")
  plt <- plt+ geom_jitter(dfGrouped, mapping=aes(x=T_val, y=Prediction, color=Context),size=2,alpha=0.4, width=1.2, height=3)
  plt <- plt + with_shadow(stat_summary(dfGrouped, mapping=aes(x=T_val, y=Prediction, color=Context), size=2, fun.data = "mean_cl_boot"), sigma = 3, x_offset = 2, y_offset = 2)
  plt <- plt + scale_color_manual(values = c("darkorange", "dodgerblue"))+ xlab('t') +ggtitle(str_to_title(story)) + scale_x_continuous(breaks=socialGroup$T_val)
  plt <- plt + ylab('Prediction') + theme(plot.title = element_text(hjust = 0.5))
  plt <- plt + theme(
    axis.title = element_text(size=14),
    axis.text = element_text(size=20),
    plot.title = element_text(size=25, hjust = 0.5)
  ) + ggtitle(str_to_title(story)) + xlab('t')
  if(story != "podcast") plt <- plt + theme(legend.position = "none")
  if(story != "cake") plt <- plt + ylab("")
  
  return(plt)
}




cakePlt = 0
moviePlt = 0
podcastPlt = 0

for(i in c("cake","movie","podcast")){
  storyPlot = plotStory(i)
  
  if(i == "cake") cakePlt = storyPlot
  if(i == "movie") moviePlt = storyPlot
  if(i == "podcast") podcastPlt = storyPlot
}

cakePlt + moviePlt + podcastPlt

