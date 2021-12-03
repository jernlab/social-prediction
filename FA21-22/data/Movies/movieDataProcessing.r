library(dplyr)
data_file_path <- "C:\\Users\\paynesc\\Documents\\research\\Attempt2\\data\\Movies\\tmdb_5000_movies.csv"
movie <- read.csv(data_file_path, header = TRUE)
movie$runtime <- as.numeric(movie$runtime)
movieWLen <- movie %>% filter(runtime > 0)
runtimes <- as.data.frame(table(movieWLen$runtime))
colnames(runtimes)[1] <- "runtime"
summary(movieWLen$runtime)
movieProb <- data.frame(runtime=runtimes$runtime, prob=runtimes$Freq/sum(runtimes$Freq))
write.csv(movieProb, "movieProbs.csv")

library(ggplot2)

plt <- ggplot(runtimes) + geom_col(aes(x=runtime, y=Freq)) + scale_x_discrete(breaks=seq(0, 350, 30))
plt
