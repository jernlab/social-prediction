library(tidyverse)
library(RColorBrewer)

## Chose the Story to do data analysis on ##
storyNum = 2


## Load the data
tidy <- read.csv("rater-tidy-experiment-12-09-21.csv")
stories <- c('cake','movie','podcast')
story <- stories[storyNum]



## T's used at each level for Cake, Movie, & Podcast respectively
t_s <- list(c(10, 20, 35, 50, 70), c(30, 45, 60, 85, 100), c(15, 30, 55, 75, 105))


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
    print(paste("Context 1 Average: ", mean(context1ratings)))
    print(paste("Context 2 Average: ", mean(context2ratings)))
    print("===========================")
    print(t.test(context1ratings, context2ratings))
  }

## Add each level's T to the Data Frame for easier plotting
storyOnly$Level_T <- storyTs[storyOnly$Level]
storyOnly$Context <- ifelse(storyOnly$Context==1, "Relevant", "Irrelevant")
storyOnly$Context <- as.factor(storyOnly$Context)


storyOnly %>%
  group_by(Level) %>% group_by(Context, .add = TRUE) %>%
  summarise(mean = mean(Rating))


## Plot the data
plt <- ggplot(storyOnly, aes(x=Level_T, y=Rating, colour=Context)) + geom_point()+geom_jitter(height = 0.3,width = 2)+geom_smooth(size=2, se=FALSE)+stat_summary(size=1) #stat_summary()#+geom_line(data=group_means, aes(X=Level_T,y=Avg, colour=Context),size=2)
plt <- plt + scale_color_brewer(palette = "Set1")
plt <- plt + scale_x_continuous(breaks=storyTs) + scale_y_continuous(breaks = c(1:7))
plt <- plt + theme(
                    axis.title = element_text(size=14),
                    axis.text = element_text(size=20),
                    plot.title = element_text(size=25, hjust = 0.5)
                    ) + ggtitle(str_to_title(story)) + xlab('t')
plt