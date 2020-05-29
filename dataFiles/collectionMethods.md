# Data Collection Procedure
### Cakes
Data was collected from BBCFoods via use of a web scraper (uploaded to the Github in the folder BBCFoodScraper). Instructions for using web scraper are included in the **bccpagescrape.py** Python script. Relative probabilities for each scraped baking times were then calculated.

------------
### Flash Drives
#### Collecting the data from individual websites
- Visited 3 sites
 - Walmart
 - Target
 - Best Buy
- Searched for the term "flash drive" on each site (for specific departments, try "All departments" or "Electronics" if available).
- For each memory capacity amount in the search filters (2GB, 8GB, 16GB, etc...)
 - check the box next to that capacity (and only that box)
 - the page should update. Record the amount of results (often in the top left corner of the page ) in a spreadsheet.

#### Obtaining Relative Probabilities
 Once data is collected, total the amount of flash drives for:
  - Record the totals for each drive capacity (sum the results for 2GB, then sum the 4GB, etc...) across all 3 websites.
  - Get the total number of drives (across all sizes) and websites.
  - Divide the sum per size by the total number of drives.

------------
### Trains
#### Finding a location
Amtrak provides a map of their train and bus routes across the United States. At first, cities and stations to use in the dataset were randomly chosen assuming they met the following criteria:
  - a train route according to the Amtrak map goes through that city
  - the population of that city was <=10,000 residents (according to the latest national census available via Google search).
  - More than 0 trains are recording stop in the city (according to the method in the next section).
  
Eventually, after using the method of data collection described in the next section, the second requirement in the list above was loosened to include cities with populations <=100,000.

#### Obtaining the number of trains at a station
We used the site Wanderu.com and navigated to the explore page at the top of the website. From there, a screen asking for 
 - Your Location
 - Day
 - Price
should appear. The latter two fields are irrelevant. Type in the name of a city which met the criteria of the **Finding a location** section and click the *Alright, Let's Wanderu!* button to search.

A list of trips and cities should appear. Open each of these trips in a new tab by 1) clicking on the trip and 2) opening the *See All Trips* link in another tab.

Now for each the newly opened tabs...
 - Navigate to the "Travel Mode" filters on the left side of the screen.
 - Untick all filters except "Trains" and "Mixed modes".
 - For each of the remaining trips on this page, click the "details" button.
 - Now:
  - If the trip you've clicked on is a mixed mode trip (has the icon for both a train and a bus)
   - If the first vehicle in the route is not a train, **skip/discard this trip**
   - Else continue reading.
  - Record the train number (You should see something along the lines of *Amtrak Saluki (Train #839)*, 839 would be the train number)
  - Do this for all trips making sure
  - Make sure not to record duplicates. Duplicates are trains that
   - Have the same departure time and location
   - Have the same train number.

The number of unique trains recorded for all newly opened tabs is the number of trains to arrive at a station in a day.
------------


