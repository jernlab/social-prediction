Modeling and analysis scripts
-----------------------------

* `analyzeGuesses.R`: Performs the chi-squared tests and computes Cohen's kappas.
* `filterOutliers.R`: Contains 2 functions used to filter data. "Filter" in this context means to remove data points that were outside for 3 standard deviations from the mean of a particular story+level combination (example story+level combination: Cake level 4).
   - ***filterOutliers***: Takes the in a data frame in tidy format and a number correlated to the experiment story data that needs to be filtered (cake = 1, bus = 2, drive = 3, train = 4). Returns a filtered data frame.
   - ***computeAllOutliers*:** Takes a data frame in tidy format. Filters data for every story+level combination in the experiment. Returns filtered data frame  (used before running LME calculations). 
* `makeLMECompatible.r`: Filters and converts experiment data (in tidy format) to format usable by *lme()* function.
* `computeModelPosterior.r`: Computes posterior probability of either Tenenbaum & Griffith model or our augmented model with given parameters: t, t_total, and prior probabilities of t_total [ p(t_total) for all t_total values]. Flag parameter is 1
* `computingMedian.r`: Main script. Generates predictions by computing model posteriors, creates and saves boxplots & scatterplots of data, calculates mean-squared & linear-mixed errors (file will likely be renamed in future to better represent use).
