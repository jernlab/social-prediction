import numpy as np
import pandas as pd
import FormrClasses as fc

# from FormrClasses import Question

questionPrompt = "<h5>On the following scale, how likely do you think it would be to now {question}</h5>"

listQuestions = {
    "cake": {
        "prompt": "A cake has been baking in an oven for <b>{t_val} minutes</b>.",
        "contexts": [
            "the person who made the cake is leaning against the oven.",
            "someone who didn’t make the cake is leaning against the oven.",
        ],
        "quantity": "see...",
        "t_values": [10, 20, 35, 50, 70],
    },
    "movie": {
        "prompt": "A movie has been playing for <b>{t_val} minutes</b>.",
        # 'the' movie might imply the same movie, using 'a' instead
        "contexts": [
            "exit the movie's showroom.",
            "exit the showroom of a movie next-door.",
        ],
        "quantity": "see 10 people...",
        "t_values": [30, 45, 60, 85, 100],
    },
    "podcast": {
        "prompt": "Someone has been listening to a podcast for <b>{t_val} minutes</b>.",
        "contexts": [
            'the podcast host say "Welp, that\'s all we planned to discuss this week!"',
            # 'the podcast host ask the rest of the panel "Is there anything else you all wanted to discuss?"',
            'someone nearby says "Hey, I like that podcast too. Cool."',
        ],
        "quantity": "hear...",
        "t_values": [15, 30, 55, 75, 105],
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
    storyQuantity = storyInfo["quantity"]
    storyPrompt = storyInfo["prompt"]
    storyTvals = storyInfo["t_values"]
    promptList = []
    quantityStatment = questionPrompt.format(question=storyQuantity)
    for i in range(len(storyTvals)):
        promptList.append(storyPrompt)

    subbedPrompts = list(map(newFormat, promptList, storyTvals))

    levelCounter = 1
    itemCounter = 1
    numContext = len(storyInfo["contexts"])


    # storyNameQ = fc.Question(
    #     q_type="note",
    #     name=f"{storyName}_Header",
    #     block_order=blocks[blockCounter],
    #     label=f"<h3>{storyName.capitalize()}</h3>",
    #     item_order = itemCounter
    #     )
    # itemCounter += 1
    # survey.addQuestion(storyNameQ)
    
    itemCounter+=1

        # Randomization, Calculate Question in FormR
    randomizeCalculateQ = fc.Question(
        q_type="calculate",
        name=f"calculate_{storyName}",
        value=f"randOrder <- c()\n\
numContext <- 2\n\
context <- c(1:{numContext})\n\
randOrder <- sample(context)\n\
jsonlite::toJSON(randOrder)",
    block_order=blocks[blockCounter]
    )

    survey.addQuestion(randomizeCalculateQ)

    for finalPrompt in subbedPrompts:
        randGroup = 1

        for randOrderContextCounter in range(len(storyInfo["contexts"])):
            promptQ = fc.Question(
                q_type="note",
                name=f"{storyName}L{levelCounter}QR{randOrderContextCounter}",
                block_order=blocks[blockCounter],
                label=f"<h4>{finalPrompt} \n {quantityStatment}</h4>"
            )
            itemCounter += 1
            survey.addQuestion(promptQ)
            contextCounter = 1
            for context in storyInfo["contexts"]:
                # Context
                contextQ = fc.Question(
                    q_type="rating_button 1,7,1",
                    label=context,
                    block_order=blocks[blockCounter],
                    name=f"{storyName}L{levelCounter}C{contextCounter}R{randOrderContextCounter}",
                    showif=f"jsonlite::fromJSON(calculate_{storyName})[{randOrderContextCounter+1}] == {contextCounter}",
                    choice1="Not at all",
                    choice2="Very"
                )

                contextCounter += 1

                # Horizontal Line Rule

                hrQ = fc.Question(
                    q_type="note",
                    name=f"hr{storyName}{hrCounter}",
                    block_order=blocks[blockCounter],
                    label="<hr>"
                )
                itemCounter += 1
                survey.addQuestion(contextQ)

            survey.addQuestion(hrQ)
            hrCounter += 1

        levelCounter += 1

        continueQ = fc.Question(
            q_type="submit",
            name=f"continue{continueCount}",
            label="Continue",
            block_order=blocks[blockCounter]
        )

        survey.addQuestion(continueQ)

        continueCount += 1
        randGroup += 1

    blockCounter += 1
    hrCounter += 1

print(finalQuestions)

survey.exportToCSV()
