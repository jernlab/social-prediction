Raw data
--------

Contains raw data files in a more human-readable format. Each experiment's data is spread across two files, one for each condition:
* `*_social.xlsx`: Data from the social condition.
* `*_nonsocial.xlsx`: Data from the non-social condition.

Each spreadsheet contains the following sheets:
* *Full data*: All the raw data collected by the experiment.
* *Bus*, *Cake*, etc: Cleaned up data sorted by story.
* *Guess ratings*: Collected ratings of guesses from all stories (1 = guess, 0 = no guess). This sheet is used by the `analyzeGuesses.R` script to compute degree of agreement between the two coders.

Additionally, `explanationCoding.md` describes the criteria we used to classify subjects' responses as guesses.
