import requests
from bs4 import BeautifulSoup
import re
import csv

def doTheScrape(link):
	timeTotal = 0
	print(link)
	URL = link
	page = requests.get(URL)

	soup = BeautifulSoup(page.content, 'html.parser')
	instrList = soup.find_all('li', class_='recipe-method__list-item')

	for inst in instrList:
		# pattern = re.compile('\d')
		whileText = inst.text
		digitIndex = re.search(r"\d",whileText)

		while(digitIndex is not None):

			newStartIndex = digitIndex.start() + 14
			time = whileText[digitIndex.start(): digitIndex.start() + 14]
			newTime = time
			if( "-" in newTime):
				newTime = time[time.index("-")+1 : len(time)]
			elif("–" in newTime):
				newTime = time[time.index("–")+1 : len(time)]
			else: newTime = newTime

			if("hour" in newTime):
				foundTime = newTime[0 : newTime.index("hour")]
				# print(foundTime)
				timeTotal += int(foundTime) * 60

			if ("minute" in newTime):
				foundTime = newTime[0 : newTime.index("minute")]
				timeTotal += int(foundTime)

			whileText = whileText[newStartIndex : len(whileText)]
			digitIndex = re.search(r"\d", whileText)
			
			
	print("Time total: ", timeTotal, "mins")
	return timeTotal	

#Main Scraping Program
for i in range (1,21):	# There were 20 pages of results with the filters
						# in the URL. The second number in the for loop should be
						# the number of total pages + 1
	URL = 'https://www.bbc.co.uk/food/search?q=cake&dishes=wedding_cake,welsh_cakes,victoria_sponge,upside-down_cake,trifle,swiss_roll,confectionery,sponge_cake,simnel_cake,shortbread,rock_cake,royal_icing,quick_desserts,prepare-ahead_desserts,loaf_cake,lemon_cake,icing,fridge_cake,fish_cakes,fairy_cakes,cupcakes,coffee_cake,christmas_cake,chocolate_dessert,chocolate_cake,cheesecake,carrot_cake,cake,almond_cake'
	if(i != 1):
		URL +="&page=" + str(i)	#Cycles through pages	
	
	page = requests.get(URL)

	soup = BeautifulSoup(page.content, 'html.parser')
	print(soup.text)


	#Grabbing all recipe links on the current page
	cakeList = soup.find_all('a', class_='promo promo__cakes_and_baking') 
	cakeLinks = []

	domain = "https://www.bbc.co.uk"


	for cake in cakeList:
		# cakeLinks.append(cake.find('a')['href'])
		cakeLinks.append(domain+cake['href'])

	allTotalTimes = []

	#Do the scraping
	for link in cakeLinks:
		# with open('cakeTimes.csv', mode='w') as w_file:
		w_file = open('cakeTimes.txt', mode='a')
		try:
			timeTotal = doTheScrape(link)
			
			w_file.write(link)
			w_file.write(',')
			w_file.write(str(timeTotal))
			w_file.write('\n')

		except Exception as e:
			continue

	w_file.close()
	print("Finished :]")

			

# instrList = soup.find_all('li', class_='recipe-method__list-item')
# allTimes = soup.find_all('p', string="gel-long-primer")

#f = open("cookingTimes.txt", "a")

	# doTheScrape(link)
