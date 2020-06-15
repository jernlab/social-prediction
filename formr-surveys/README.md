# Survey Explanation

## Formatting and Updating Spreadsheets
Column labels are all used according to the specs of the Formr Documentation here: https://formr.org/documentation#sample_survey_sheet 

------------------------------
## Prolific Checking
Our experiments/surveys were hosted distributed via Prolific https://www.prolific.co/ . To verify participants did indeed come from the survey links on Prolific, rows 2-6 of both experiment will get the specific fields of Prolific particpant's URL (PROLIFIC_PID, STUDY_ID, SESSION_ID) and block the survey (row 7) if any of the three is missing.

**Note: For updating the experiment spreadsheets for your own questions, we suggest using a testing spreadsheet which does not contain the code for Prolific checking. We have provided one in this repo.**

------------------------------
## Randomization
Randomization is done by duplicating the set of questions (i.e. the stories and the "what would predict" question), with a question that is an attention check in the middle of these two groups (the groups being the original and duplicated questions). I'll refer to the first group of questions as ***G1*** and the duplicated group as ***G2*** . 

The *stim_list* calculate block (row 12 of the NonSocial spreadsheet) exports the letters a,b,c, and d to a JSON file in a random order. 

**Note: toJSON and fromJSON are R functions used in this explanation. Documentation on their specifics can be found here: https://www.rdocumentation.org/packages/jsonlite/versions/1.6.1/topics/toJSON%2C%20fromJSON . Understanding their inner workings is not necessary for understanding the rest of the code used here.**

Before the first question in each story of ***G1*** and ***G2*** (i.e before the first question of the cakes, of the bus, etc), there is a calculate block which has a name along the lines of "up_half_A" (this specific name is row 13 in the NonSocial survey), "low_half_B", etc.  

If this calculate block (up_half_A, low_half_B, etc.), is in ***G1***, it will read the first 2 letters of the JSON file used earlier (via row 12/the stim_list calculate block). If the block is in ***G2***, it will read the last 2 letters of the JSON. Now, we move one row below this calculate block to see a story, which is the description and answer block for the story of each level of the experiment. 

In the *show_if* column :

  - shuffle$group==<a number 1-5> (replace <a number 1-5> with a a number 1-5) will determine which level of the question to showcase when the question is shown.
  - "<a letter>%in%up_half_A" (row 14, column G), will show the question if <a letter> is one of the 2 letters read from the JSON file.
  
This all allows us to randomize questions across an attention check.
