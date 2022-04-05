library(dplyr)
library(stringr)

story = "movie"

socialDf <- read.csv("social-tidy-experiment-1-16-22.csv")
nonSocialDf <- read.csv("nonsocial-tidy-experiment-1-16-22.csv")

nonSocialPredictons <- read.csv(paste("./predictions/",story,"Predictions.csv", sep = ""))

socialGroup <- socialDf %>% 
  group_by(Level, Story, Context, T_val) %>% summarise(avg = mean(Prediction))

nonSocialGroup <- nonSocialDf %>% 
  group_by(Level, Story, Context, T_val) %>% summarise(avg = mean(Prediction))

library(ggplot2)

socialGroup <- socialGroup %>% filter(Story == .env$story)
nonSocialGroup <- nonSocialGroup %>% filter(Story == .env$story)

df <- rbind(socialDf,nonSocialDf)

dfGrouped <- df %>% 
  group_by(Level, Story, Context, T_val)

dfZ <- dfGrouped %>% mutate(z_score = abs((Prediction - mean(Prediction))/sd(Prediction)))

dfFiltered <- dfZ %>% filter(z_score <= 3)
outliers <- dfZ %>% filter(z_score > 3)

write.csv(dfFiltered, file="filtered-tidy-data.csv", row.names = FALSE)
write.csv(outliers , file="outliers.csv", row.names=FALSE)
