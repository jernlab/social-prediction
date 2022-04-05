library(tidyverse)
library(RColorBrewer)
library(patchwork)
library(ggfx)
## Chose the Story to do data analysis on ##
# storyNum = 3

## Load the data
tidy <- read.csv("rater-tidy-experiment-12-09-21.csv")
stories <- c('cake','movie','podcast')

## T's used at each level for Cake, Movie, & Podcast respectively
t_s <- list(c(10, 20, 35, 50, 70), c(30, 45, 60, 85, 100), c(15, 30, 55, 75, 105))

plotStory <- function(story){
  storyNum <- switch (story,
    "cake" = 1,
    "movie" = 2,
    "podcast" = 3
  )
  storyOnly <- tidy %>% filter(Story == story)
  storyTs <- t_s[[storyNum]]
  print(paste("Story: ", story))
  print("=======================")
  print("=======================")
  
  
  for (i in c(1:5)) {
    context1ratings <- storyOnly %>% filter(Level == i) %>% filter(Context == 1)
    context2ratings <- storyOnly %>% filter(Level == i) %>% filter(Context == 2)
    
    context1ratings <- context1ratings$Rating
    context2ratings <- context2ratings$Rating
    
    print(paste("Level ", i))
    # print(paste("Context 1 Average: ", mean(context1ratings)))
    # print(paste("Context 2 Average: ", mean(context2ratings)))
    print(mean(context1ratings) - mean(context2ratings))
    print("===========================")
    # print(t.test(context1ratings, context2ratings))
  }
  
  ## Add each level's T to the Data Frame for easier plotting
  storyOnly$Level_T <- storyTs[storyOnly$Level]
  storyOnly$Context <- ifelse(storyOnly$Context==1, "Relevant", "Irrelevant")
  storyOnly$Context <- as.factor(storyOnly$Context)
  
  
  storyOnly %>%
    group_by(Level) %>% group_by(Context, .add = TRUE) %>%
    summarise(mean = mean(Rating))
  
  # relevantContextAverageRatings = storyOnly %>%
  #   group_by(Level) %>% group_by(Context, .add = TRUE) %>%
  #   summarise(mean = mean(Rating)) %>% filter(Context =="Relevant")
  
  #write.csv(relevantContextAverageRatings, file=paste(story,"ContextRatings.csv",sep = ""), row.names = FALSE)
  
  ## Plot the data
  plt <- ggplot(storyOnly, aes(x=Level_T, y=Rating, colour=Context)) + geom_point()+geom_jitter(height = 0.3,width = 2, alpha=0.5)+ with_shadow(stat_summary(size=2), x_offset = 1, y_offset = 1)
  plt <- plt + scale_color_manual(values = c("dodgerblue", "darkorange"))
  plt <- plt + scale_x_continuous(breaks=storyTs) + scale_y_continuous(breaks = c(1:7))
  plt <- plt + theme(
    axis.title = element_text(size=14),
    axis.text = element_text(size=20),
    plot.title = element_text(size=25, hjust = 0.5)
  ) + ggtitle(str_to_title(story)) + xlab('t')
  plt <- plt + guides(colour=guide_legend(title="Observation"))
  if(story != "podcast") plt <- plt + theme(legend.position = "none")
  if(story != "cake") plt <- plt + ylab("")
  return(plt)
}

cakePlot <- plotStory("cake")
moviePlot <- plotStory("movie")
podcastPlot <- plotStory("podcast")

cakePlot + moviePlot + podcastPlot
