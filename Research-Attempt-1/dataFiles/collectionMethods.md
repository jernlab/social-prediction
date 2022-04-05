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

...should appear. The latter two fields are irrelevant. Type in the name of a city which met the criteria of the **Finding a location** section and click the *Alright, Let's Wanderu!* button to search.

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
  
###### The number of unique trains recorded for all newly opened tabs is the number of trains to arrive at a station in a day.
------------

### Buses

***GTFS*** (General Transit Feed Specification) is a format for public transportation services (most commonly buses) to post information and statistics about their bus routes, stop times, stop locations, etc. One file that is required to be included in every GTFS dataset is *stop_times.txt*, which contains the stop times for a particular bus throughout some allotted period of time.

Data from 3 different bus services were used: IndyGo, Massachusetts Bay Transportation Authority (MBTA), and NYC Bus Company. Archives of GTFS data for each of these of these services were downloaded from   **https://transitfeeds.com/**

Once the data was downloaded, the stop_times.txt file was opened in Excel for each service. 

**Note**: Despite being a .txt file, the file is formatted like a .csv file. This is why Excel was used as opposed to some other software. Use the Text-to-Columns feature in Excel to delimit the file.

Calculating the average bus waiting time was done by
- Calculating the time of a loop (the time it takes or one bus to reach the same stop again)
- Dividing this loop time by the average number of buses on any particular route.

#### Calculating Time of a Loop
This is a rather simple process. In *stop_times.txt*, there are 3 columns (technically 4, but this will be explained) relevant columns: trip_id, arrival_time, departure_time, stop_id.

Explanations of what these columns mean can be found here: . For the purposes our data collection, just  know that arrival_time and departure_time were the same across data from all 3 bus companies, thus arrival_time was used in calculation of the loop times.

Now, to calculate the loop time
- The first stop (or row) will have a stop_id. Find the next occurrence of this stop_id (for the data we used, the next occurrence was always in another trip). 
- Subtract the arrival_time at the next occurrence (of the stop_id) from the arrival_time at the previous occurrence. This is the loop time.
- Convert this time to minutes.
- Repeat this going down the list of stops until the desired number of loop times is acquired.


#### Determining the average number of buses per route

This can be done with a variety of sites, but  we used the MBTA's website as stops and the number of buses that arrived/departed at a particular stop were easily found. For our example, lets use stop 411, available here https://www.mbta.com/schedules/411/line .

Directly under the name of each stop in this table, there is 1 or more yellow boxes with a number inside. These are bus numbers that go through this stop. Record the number of buses that appear here. Average the number of buses for all stops on this page. This is the average number of buses per route, which from this point on, I will refer to as ***y***.

#### Calculating Average Time
Now, in the file which has the loop times, divide each loop time by ***y***. This is  the average waiting time for the bus.

One important piece of info is that because we used cities of noticeably different sizes (Indianapolis vs Boston and NYC), we assumed ***y*** would change depending on the city of the calculated loop times (i.e. we expected Indianapolis, a smaller city than Boston or NYC, to have a smaller a number ***y*** than the other two cities, since less buses and people to accommodate are present). 

In our data, the value of ***y*** was for each city was:
- Boston/NYC = 5.65 (this is the value calculated from the method described in the previous section)
- Indianapolis = 4 (this was arbitrarily chosen based on the intuition about ***y*** being smaller for smaller cities).

