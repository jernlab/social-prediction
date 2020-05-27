import requests
from bs4 import BeautifulSoup
import os, sys

URL = 'https://www.bbc.co.uk/food/search?q=cake'
page = requests.get(URL)

soup = BeautifulSoup(page.content, 'html.parser')

allTimes = soup.find_all('p', class_='gel-long-primer')
# allTimes = soup.find_all('p', string="gel-long-primer")

f = open("cookingTimes.txt", "a")

for time in allTimes:
	cookT = time.text
	if("Cook:" in cookT):
		if("-" in cookT):
			srtIndex = cookT.index("-")
			timeOnly = time.text[srtIndex+1:len(cookT)]
			if("h" in timeOnly):
				endIndex = timeOnly.index("h")
			else:
				endIndex = timeOnly.index("m")

			endIndex -= 1

			f.write(timeOnly[0 : endIndex])
			f.write("\n")
		# print(time.text[5: len(time.text)], "\n")

f.close()
os.open("cookingTimes.txt", os.O_RDONLY)