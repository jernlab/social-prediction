#!/usr/bin/env python
# coding: utf-8

# In[72]:


import pandas as pd
import numpy as np
import json


# In[73]:


podcasts = pd.read_csv("df_popular_podcasts.csv")
podcasts.head(3)


# In[74]:


durations = podcasts["Episode Durations"]
durations.head(3)


# In[75]:


np.array(json.loads(durations[0])).round()


# In[76]:


list(map(json.loads, durations))


# In[77]:


def flatten_list(_2d_list):
    flat_list = []
    # Iterate through the outer list
    for element in _2d_list:
        if type(element) is list:
            # If the element is of type list, iterate through the sublist
            for item in element:
                flat_list.append(item)
        else:
            flat_list.append(element)
    return flat_list


# In[78]:


durations_np = np.array(flatten_list(list(map(json.loads, durations))))


# In[79]:


durations_np


# In[80]:


rounded_durations = durations_np.round()


# In[81]:


rounded_durations


# In[82]:


myCSV = pd.DataFrame()
myCSV["durations"] = rounded_durations


# In[93]:


counts = myCSV.value_counts()
counts = counts.reset_index()
counts.rename(columns={ counts.columns[1]: "Counts" }, inplace = True)
counts = counts.sort_values(by="durations")
counts['durations'] = counts['durations'].astype(int)
counts = counts[ counts['durations'] != 0]
counts = counts[ counts['durations'] <= 400]
probs = counts.copy()
probs['Counts'] = counts['Counts']/counts.Counts.sum()
probs.rename(columns={ probs.columns[1] : "prob", probs.columns[0]: 'duration'}, inplace = True)
probs
# counts
# durs = pd.DataFrame(counts, columns=['Durations', 'Counts'])
# durs


# In[95]:


probs.head(3)


# In[40]:


probs.to_csv("podcastProbs.csv", index=False)


# In[ ]:




