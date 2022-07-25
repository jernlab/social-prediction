# Data

The three CSV files in this directory:
- `cakeProbs.csv`
- `movieProbs.csv`
- `podcastProbs.csv`

are all relative probability distributions used in generating *P(t)*, i.e. empirical prior probabilities, used in the original G&T prediction model.

The empirical data these probabilities were extracted from, as well as the scripts used for extraction, are in the 3 folders in this directory `/Cake`, `/Movie`, and `/Podcast`. **Note:** While the Movie & Podcast datasets were found and verified online, the Cake dataset was web-scraped using a Python script. This scraper can be found in `/Cake/BBCFoodScraper`.