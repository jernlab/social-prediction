library(tidyverse)

tidy <- read.csv("rater-tidy-pilot-11-17-21.csv")
stories <- c('cake','movie','podcast')
story <- stories[3]

storyOnly <- tidy %>% filter(Story == story)

print(paste("Story: ", story))
print("=======================")
print("=======================")

if(story == "podcast"){
  
  for(i in c(1:5)){
    context1ratings <- storyOnly %>% filter(Level == i) %>% filter(Context == 1)
    context2ratings <- storyOnly %>% filter(Level == i) %>% filter(Context == 2)
    context3ratings <- storyOnly %>% filter(Level == i) %>% filter(Context == 3)
    
    context1ratings <- context1ratings$Rating
    context2ratings <- context2ratings$Rating
    context3ratings <- context3ratings$Rating
    
    print(paste("Level ", i))
    print(paste("Context 1 Average: ", mean(context1ratings)))
    print(paste("Context 2 Average: ", mean(context2ratings)))
    print(paste("Context 3 Average: ", mean(context3ratings)))
    print("===========================")
   # print(t.test(context1ratings, context2ratings, context3ratings))
  }

}

if(story != "podcast"){
  for (i in c(1:5)) {
    context1ratings <- storyOnly %>% filter(Level == i) %>% filter(Context == 1)
    context2ratings <- storyOnly %>% filter(Level == i) %>% filter(Context == 2)
    
    context1ratings <- context1ratings$Rating
    context2ratings <- context2ratings$Rating
    
    print(paste("Level ", i))
    print(paste("Context 1 Average: ", mean(context1ratings)))
    print(paste("Context 2 Average: ", mean(context2ratings)))
    print("===========================")
    #print(t.test(context1ratings, context2ratings))
  }
}
