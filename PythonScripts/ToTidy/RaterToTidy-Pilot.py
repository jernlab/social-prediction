#!/usr/bin/env python
# coding: utf-8

# In[1]:


import numpy as np
import pandas as pd
import math
import json


# In[2]:


df = pd.read_csv("Rater-Pilot-11-17-21.csv")
df.head(3)


# In[3]:


dfFilter = df[~pd.isnull(df.attentionCheck)]


# In[4]:


dfFilter.head(3)


# In[5]:


dfFilter.shape


# In[6]:


cake_t_values = [10,20,35,50,70]
movie_t_values = [30, 45, 60, 85, 100]
podcast_t_values = [15, 30, 55, 75, 105]


# In[7]:


column_names = ['Subject','Story','Level','Context','Rating']
tidyDf = pd.DataFrame(columns = column_names)
tidyDf.head()


# In[8]:


stories = ['cake','movie','podcast']
for story in stories:
    print(story)
    story_orders = dfFilter[f'calculate_{story}'].values
    orders = []
    for order in story_orders:
        orders.append(json.loads(order))

    story_ratings = {}
    for level in range(1,6):
        print("Level ",level)
        context_1_ratings = []
        context_2_ratings = []

        for row in range(dfFilter.shape[0]):
            firstContext = orders[row]
            subject = dfFilter.iloc[row]['pPROLIFIC_PID']
            
            if(story == 'podcast'):
                context1 = dfFilter.iloc[row][f"podcastL{level}C1R{firstContext.index(1)}"]
                context2 = dfFilter.iloc[row][f"podcastL{level}C2R{firstContext.index(2)}"]
                context3 = dfFilter.iloc[row][f"podcastL{level}C3R{firstContext.index(3)}"]
                

                tidyDf = tidyDf.append({'Story': story, 'Level': level, 'Context': 1, 'Rating': context1, 'Subject': subject}, ignore_index=True)
                tidyDf = tidyDf.append({'Story': story, 'Level': level, 'Context': 2, 'Rating': context2, 'Subject': subject}, ignore_index=True)
                tidyDf = tidyDf.append({'Story': story, 'Level': level, 'Context': 3, 'Rating': context3, 'Subject': subject}, ignore_index=True)
                
                print("Row " ,row)
                print("=========")
                print("Context 1: ", context1)
                print("Context 2: ", context2)
                print("Context 3: ", context3)
            else:
                context1 = dfFilter.iloc[row][f"{story}L{level}C1R{firstContext.index(1)}"]
                context2 = dfFilter.iloc[row][f"{story}L{level}C2R{firstContext.index(2)}"]

                tidyDf = tidyDf.append({'Story': story, 'Level': level, 'Context': 1, 'Rating': context1, 'Subject': subject}, ignore_index=True)
                tidyDf = tidyDf.append({'Story': story, 'Level': level, 'Context': 2, 'Rating': context2, 'Subject': subject}, ignore_index=True)

                print("Row " ,row)
                print("=========")
                print("Context 1: ", context1)
                print("Context 2: ", context2)


# In[9]:


np.unique(tidyDf['Story'].values)


# In[10]:


tidyDf


# In[11]:


tidyDf.to_csv('rater-tidy-pilot-11-17-21.csv', index=False)


# In[ ]:




