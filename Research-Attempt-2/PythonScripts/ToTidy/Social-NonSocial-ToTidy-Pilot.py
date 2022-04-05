#!/usr/bin/env python
# coding: utf-8

# In[1]:


import numpy as np
import pandas as pd
import math
import json


SOCIAL = 1
NON_SOCIAL = 2

PILOT = 3
EXPERIMENT = 4
## =============================================================
## =============================================================
## CHANGE THIS VARIABLE to tidy the social or non-social results
socialOrNonSocial = NON_SOCIAL 
resultsDate = "1-16-22"
pilotOrExperiment = EXPERIMENT
## =============================================================
## =============================================================


df = {}

## Load the results
if(socialOrNonSocial == SOCIAL):
	df = pd.read_csv("social-experiment-"+resultsDate+".csv")
	print("Tidying social results")
else:
	df = pd.read_csv("nonsocial-experiment-"+resultsDate+".csv")
	print("Tidying non-social results")

df.head(3)


# In[3]:


## Filter out anybody who didn't complete the attention chcek
dfFilter = df[~pd.isnull(df.attentionCheck)]

## Filter out anybody who failed the attention check
dfFilter = dfFilter[dfFilter.attentionCheck == 4]


dfFilter.head()


print("Num valid results: ", dfFilter.shape)



## T values for each level of each story
cake_t_values = [10,20,35,50,70]
movie_t_values = [30, 45, 60, 85, 100]
podcast_t_values = [15, 30, 55, 75, 105]

storyTs = {
	'cake': [10,20,35,50,70],
	'movie': [30, 45, 60, 85, 100],
	'podcast': [15, 30, 55, 75, 105]
}
## Set up tidy dataframe.
column_names = ['Subject','Story','Level','Context','Prediction']
tidyDf = pd.DataFrame(columns = column_names)
tidyDf.head()



## Main logic - go through each story, 
##              iterate through each row of dataframe

stories = ['cake','movie','podcast']
for story in stories:
    print(story)
    for row in range(dfFilter.shape[0]):	
	    for i in range(5):
	    	level = i + 1
	    	predictionColName = f"{story}L{level}Response"
	    	print(f"{predictionColName}: ", dfFilter.iloc[row][predictionColName])
	    	prediction = dfFilter.iloc[row][predictionColName]
	    	tidyDf = tidyDf.append({'Story': story, 'Level': level, 'Context': "Social" if socialOrNonSocial == SOCIAL else "Non-Social", 'Prediction': prediction, 'Subject': row+1, 'T_val': storyTs[story][level-1]}, ignore_index=True)


if(socialOrNonSocial == SOCIAL):
	tidyDf.to_csv('social-tidy-experiment-'+resultsDate+'.csv', index=False)
else:
	tidyDf.to_csv('nonsocial-tidy-experiment-'+resultsDate+'.csv', index=False)

# # In[ ]:




