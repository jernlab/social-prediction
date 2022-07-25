library(dplyr)
library(stringr)

socialDf <- read.csv("./Tidy/Social/social-tidy-experiment-1-16-22.csv")
nonSocialDf <- read.csv("./Tidy/Non-Social/nonsocial-tidy-experiment-1-16-22.csv")

df <- rbind(socialDf,nonSocialDf)

dfGrouped <- df %>% 
  group_by(Level, Story, Context, T_val)

dfZ <- dfGrouped %>% mutate(z_score = abs((Prediction - mean(Prediction))/sd(Prediction)))

dfFiltered <- dfZ %>% filter(z_score <= 3)
outliers <- dfZ %>% filter(z_score > 3)

write.csv(dfFiltered, file="./Tidy/filtered-tidy-data.csv", row.names = FALSE)
write.csv(outliers , file="outliers.csv", row.names=FALSE)
