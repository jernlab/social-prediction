# Analyze the proportion of "guesses" in subjects' responses in both experiments
# and compute degree of rater agreement in coding guesses

library(irr)
library(tidyverse)
library(readxl)

# Clear workspace
rm(list=ls())

# Specify which experiment to run the analysis on
expt <- 1

if (expt == 1) {
  # Totals
  bus.social.n <- 53
  bus.social.explain <- 52
  bus.social.guess <- 2
  bus.social.disagree <- 0

  bus.nonsocial.n <- 49
  bus.nonsocial.explain <- 45
  bus.nonsocial.guess <- 3
  bus.nonsocial.disagree <- 1

  cake.social.n <- 53
  cake.social.explain <- 51
  cake.social.guess <- 4
  cake.social.disagree <- 1

  cake.nonsocial.n <- 49
  cake.nonsocial.explain <- 47
  cake.nonsocial.guess <- 5
  cake.nonsocial.disagree <- 1

  drive.social.n <- 53
  drive.social.explain <- 51
  drive.social.guess <- 2
  drive.social.disagree <- 0

  drive.nonsocial.n <- 49
  drive.nonsocial.explain <- 48
  drive.nonsocial.guess <- 2
  drive.nonsocial.disagree <- 0

  train.social.n <- 53
  train.social.explain <- 51
  train.social.guess <- 9
  train.social.disagree <- 1

  train.nonsocial.n <- 49
  train.nonsocial.explain <- 46
  train.nonsocial.guess <- 7
  train.nonsocial.disagree <- 1
}
if (expt == 2) {
  # Totals
  bus.social.n <- 102
  bus.social.explain <- 95
  bus.social.guess <- 5
  bus.social.disagree <- 2

  bus.nonsocial.n <- 108
  bus.nonsocial.explain <- 102
  bus.nonsocial.guess <- 10
  bus.nonsocial.disagree <- 7

  cake.social.n <- 102
  cake.social.explain <- 94
  cake.social.guess <- 3
  cake.social.disagree <- 2

  cake.nonsocial.n <- 108
  cake.nonsocial.explain <- 103
  cake.nonsocial.guess <- 13
  cake.nonsocial.disagree <- 10

  drive.social.n <- 102
  drive.social.explain <- 95
  drive.social.guess <- 4
  drive.social.disagree <- 3

  drive.nonsocial.n <- 108
  drive.nonsocial.explain <- 101
  drive.nonsocial.guess <- 16
  drive.nonsocial.disagree <- 5

  train.social.n <- 102
  train.social.explain <- 97
  train.social.guess <- 2
  train.social.disagree <- 5

  train.nonsocial.n <- 108
  train.nonsocial.explain <- 104
  train.nonsocial.guess <- 11
  train.nonsocial.disagree <- 8
}


# Compute the overall totals for the test
trainGuess <- train.social.guess + train.nonsocial.guess
trainNonGuess <- train.social.explain + train.nonsocial.explain -
                 trainGuess

otherGuess <- bus.social.guess + bus.nonsocial.guess +
              cake.social.guess + cake.nonsocial.guess +
			  drive.social.guess + drive.nonsocial.guess
otherNonGuess <- bus.social.explain + bus.nonsocial.explain +
                 cake.social.explain + cake.nonsocial.explain +
				 drive.social.explain + drive.nonsocial.explain -
				 otherGuess

# Compute total number of disagreements
totalDisagreements <- cake.social.disagree + cake.nonsocial.disagree +
                      bus.social.disagree + bus.nonsocial.disagree +
                      drive.social.disagree + drive.nonsocial.disagree +
                      train.social.disagree + train.nonsocial.disagree
totalResponses <- trainGuess + trainNonGuess + otherGuess + otherNonGuess

print("Total number of explanations: ")
print(totalResponses)
print("Total number of guesses: ")
print(trainGuess + otherGuess)
print("Total number of disagreements: ")
print(totalDisagreements)

# Put results into a 2x2 matrix (contingency table)
#
#         guess   non-guess
# train
# other
ctable <- matrix( c(trainGuess, otherGuess, trainNonGuess, otherNonGuess),
                  nrow=2, ncol=2)
# Run the test
chitest <- chisq.test(ctable)
print(chitest)

# Compute Cohen's kappa

# Read in data
if (expt == 1) {
  nonSocialRatings <- read_excel("../dataFiles/Raw data/Experiment 1/nonsocial.xlsx","Guess ratings")
  socialRatings <- read_excel("../dataFiles/Raw data/Experiment 1/social.xlsx","Guess ratings")
}
if (expt == 2) {
  nonSocialRatings <- read_excel("../dataFiles/Raw data/Experiment 2/nonsocial.xlsx","Guess ratings")
  socialRatings <- read_excel("../dataFiles/Raw data/Experiment 2/social.xlsx","Guess ratings")
}

print(kappa2(nonSocialRatings %>% bind_rows(socialRatings)))
