#Data Collection Procedure
###Cakes
Data was collected from BBCFoods via use of a web scraper (uploaded to the Github in the folder BBCFoodScraper). Instructions for using web scraper are included in the **bccpagescrape.py** Python script.

------------
###Flash Drives
####Collecting the data from individual websites
- Visited 3 sites
 - Walmart
 - Target
 - Best Buy
- Searched for the term "flash drive" on each site (for specific departments, try "All departments" or "Electronics" if available).
- For each memory capacity amount in the search filters (2GB, 8GB, 16GB, etc...)
 - check the box next to that capacity (and only that box)
 - the page should update. Record the amount of results (often in the top left corner of the page ) in a spreadsheet.

####Obtaining Relative Probabilities
 Once data is collected, total the amount of flash drives for:
  - Record the totals for each drive capacity (sum the results for 2GB, then sum the 4GB, etc...)
  - Get the total number of drives (across all sizes)
  - Divide the sum per size by the total number of drives
