import numpy as np
import pandas as pd
import FormrClasses as fc
import re

# from FormrClasses import Question

SOCIAL = 0
NON_SOCIAL = 1

socialOrNonSocial = SOCIAL

questionPrompt = "<h5>What would you predict is the total {question}?</h5>"

listQuestions = {
    "cake": {
        "prompt": "A cake has been baking in an oven for <b>{t_val} minutes</b>.",
        # "contexts": [
        #     "the person who made the cake is leaning against the oven.",
        #     "someone who didn’t make the cake is leaning against the oven.",
        # ],
        "quantityBeingPredicted": "baking time of the cake <em>(in minutes)</em>",
        "socialContext": "The person who made the cake is leaning against the oven.",
        # "quantity": "see...",
        "t_values": [10, 20, 35, 50, 70],
        "maxAllowedTotal": 600,
    },
    "movie": {
        "prompt": "A movie has been playing for <b>{t_val} minutes</b>.",
        # 'the' movie might imply the same movie, using 'a' instead
        # "contexts": [
        #     "exit the movie's showroom.",
        #     "exit the showroom of a movie next-door.",
        # ],
        "quantityBeingPredicted": "duration of the movie <em>(in minutes)</em>",
        "socialContext": "10 people exit the movie's showroom.", ## Is it necessary to specify amount here? Should we just keep it consistent between experiments?
        "t_values": [30, 45, 60, 85, 100],
        "maxAllowedTotal": 240, ## TODO: Verify this is the max duration in our movie dataset
    },
    "podcast": {
        "prompt": "Someone has been listening to a podcast for <b>{t_val} minutes</b>.",
        # "contexts": [
        #     'the podcast host say "Welp, that\'s all we planned to discuss this week!"',
        #     # 'the podcast host ask the rest of the panel "Is there anything else you all wanted to discuss?"',
        #     'someone nearby says "Hey, I like that podcast too. Cool."',
        # ],
        "quantityBeingPredicted": "duration of the podcast <em>(in minutes)</em>",
        "socialContext": 'The podcast\'s host says, "Welp, that\'s all we planned to discuss this week!"',
        "t_values": [15, 30, 55, 75, 105],
        "maxAllowedTotal": 480,
    },
}

survey = fc.QuestionList()
# survey.addQuestion()
# survey.exportToCSV()
# df = pd.DataFrame()
# questions = []
situation = []
type = []
name = []
item_order = []
block_order = []
continueCount = 0

blocks = ["A", "B", "C"]


def newFormat(sentence, t):
    # def insertString(t):
    #     return sentence.format("t_val", t)
    insertString = sentence.format(t_val=t)
    return insertString


finalQuestions = []
blockCounter = 0
itemOrderCounter = 1
hrCounter = 1
for key in listQuestions:
    # print(listQuestions[situation])
    storyName = key
    storyInfo = listQuestions[storyName]
    storyQuantity = storyInfo["quantityBeingPredicted"]
    storyPrompt = storyInfo["prompt"]
    storyTvals = storyInfo["t_values"]
    storySocialContext = storyInfo["socialContext"]
    storyMaxAllowedTotal = storyInfo["maxAllowedTotal"]
    promptList = []
    quantityStatment = questionPrompt.format(question=storyQuantity) ##Change this name to be more accurate
    for i in range(len(storyTvals)):
        promptList.append(storyPrompt)

    ## Create a list of setences for each story with the elapsed time (t).
    ## Ex. Elements: "A cake has been baking in an oven for <b>10 minutes</b>." , "A cake has been baking in an oven for <b>20 minutes</b>", etc
    subbedPrompts = list(map(newFormat, promptList, storyTvals)) 

    levelCounter = 1
    itemCounter = 1
    
    for finalPrompt in subbedPrompts:


    	print(finalPrompt)

    	storyPromptWithElapsedTime = finalPrompt

    	elapsedTimeT = int(re.findall(r'\d+', storyPromptWithElapsedTime)[0])
    	
    	print("Elapsed Time: ", elapsedTimeT)
    	if(socialOrNonSocial == SOCIAL):
    		storyPromptWithElapsedTime = f"{finalPrompt} \n {storySocialContext}"

    	storyPromptQuestion = fc.Question(
    		q_type="note",
    		name=f"{storyName}L{levelCounter}",
    		block_order=blocks[blockCounter],
    		label=f"<h4>{storyPromptWithElapsedTime}</h4>"
    		)

    	predictQuestion = fc.Question(
    		q_type=f"number {elapsedTimeT},{storyMaxAllowedTotal},1",
    		name=f"{storyName}L{levelCounter}Response",
    		block_order=blocks[blockCounter],
    		label=quantityStatment
    		)

    	continueQ = fc.Question(
    		q_type="submit",
    		name=f"continue{continueCount}",
    		label="Continue",
    		block_order=blocks[blockCounter]
    		)

    	survey.addQuestion(storyPromptQuestion)
    	survey.addQuestion(predictQuestion)
    	survey.addQuestion(continueQ)

    	continueCount+=1
    	levelCounter+=1


    blockCounter+=1
    
if(socialOrNonSocial == SOCIAL):
	survey.exportToCSV("./Surveys/socialSurvey.csv")
else:
	survey.exportToCSV("./Surveys/nonSocialSurvey.csv")
