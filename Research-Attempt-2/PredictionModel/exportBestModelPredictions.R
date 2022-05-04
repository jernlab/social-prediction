# T values to predict for
# We chose to only generate predictions up to the biggest T used in each story
# in the experiments
ts <-list(
  Cake = c(1:75),
  Movie = c(1:100),
  Podcast = c(1:105)
) 

tLevels <-list(
  Cake = c(10,20,35,50,70),
  Movie = c(30,45,60,85, 100),
  Podcast = c(15, 30, 55, 75,105)
) 

# Vectors for the params used in the best fitting social model for each story.
# These were determined by grid search minimizing MSE found in the `usingModels.rmd`
# file in this folder
params <- list(
  Cake = c(-3.5,30),
  Movie = c(-8, 350),
  Podcast = c(-4.5, 28)
)

paramsDf <- as.data.frame(params)
source("./generatingSocialModelPredictions.R")
source("./generatingNonSocialModelPredictions.R")

cakeModel <- createSocialModel(params$Cake[1], params$Cake[2])
movieModel <- createSocialModel(params$Movie[1], params$Movie[2])
podcastModel <- createSocialModel(params$Podcast[1], params$Podcast[2])

probs <- read.csv("../Data/cakeProbs.csv")
Cake = sapply(ts$Cake,cakeModel)

probs <- read.csv("../Data/movieProbs.csv")
Movie = sapply(ts$Movie, movieModel)

probs <- read.csv("../Data/podcastProbs.csv")
Podcast = sapply(ts$Podcast, podcastModel)


library(ggplot2)
library(patchwork)
CakePreds <- data.frame(Ts = ts$Cake, P=Cake)
CakePlot <- ggplot(CakePreds, aes(x=Ts, y=P)) + geom_line(size=1.5) + ggtitle("Cake")+ scale_x_continuous(breaks = tLevels$Cake)+ ylab("Prediction") +xlab("t")

MoviePreds <- data.frame(Ts = ts$Movie, P=Movie)
MoviePlot <- ggplot(MoviePreds, aes(x=Ts, y=P)) + geom_line(size=1.5) + ggtitle("Movie")+ scale_x_continuous(breaks = tLevels$Movie)+ ylab("Prediction")+xlab("t")

PodcastPreds <- data.frame(Ts = ts$Podcast, P=Podcast)
PodcastPlot <- ggplot(PodcastPreds, aes(x=Ts, y=P)) + geom_line(size=1.5)+ ggtitle("Podcast")+ scale_x_continuous(breaks = tLevels$Podcast)+ ylab("Prediction")+xlab("t")

CakePlot + MoviePlot + PodcastPlot
