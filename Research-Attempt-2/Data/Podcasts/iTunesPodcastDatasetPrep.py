#!/usr/bin/env python
# coding: utf-8

# In[6]:


import pandas as pd
import numpy as np
import json


# In[7]:


podcasts = pd.read_csv("df_popular_podcasts.csv")
podcasts.head(3)


# In[8]:


durations = podcasts["Episode Durations"]
durations.head(3)


# In[15]:


np.array(json.loads(durations[0])).round()


# In[27]:


list(map(json.loads, durations))


# In[28]:


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


# In[31]:


durations_np = np.array(flatten_list(list(map(json.loads, durations))))


# In[32]:


durations_np


# In[33]:


rounded_durations = durations_np.round()


# In[34]:


rounded_durations


# In[38]:


myCSV = pd.DataFrame()
myCSV["durations"] = rounded_durations


# In[39]:


myCSV.head(3)


# In[40]:


myCSV.to_csv("podcastDurations.csv")


# In[ ]:




