import numpy as np
import pandas as pd
import FormrClasses as fc

# from FormrClasses import Question

questionPrompt = "<h5>On a 1-7 scale, rate how confidently you'd make a prediction on {question} given that the following statement is true:</h5>"

listQuestions = {
    "cake": {
        "prompt": "A cake has been baking in an oven for {t_val} minutes.",
        "contexts": [
            "The cake's baker is leaning against the stove.",
            "A visitor, who is not baking the cake, is leaning against the oven",
        ],
        "quantity": "total baking time of the cake",
        "t_values": [10, 20, 35, 50, 70],
    },
    "movie": {
        "prompt": "A movie has been playing in a theatre and is currently {t_val} minutes.",
        # 'the' movie might imply the same movie, using 'a' instead
        "contexts": [
            "People begin to file out of the movie's showroom.",
            "People are filing out of the showroom of a movie next-door",
        ],
        "quantity": "total duration of the movie",
        "t_values": [30, 45, 60, 85, 100],
    },
    "podcast": {
        "prompt": "A guy has been listening to a podcast for the past {t_val} minutes.",
        "contexts": [
            'The podcast host states "Welp, that\'s all we planned to discuss this week!"',
            'The podcast cast host asks the rest of the panel "Is there anything else you all wanted to discuss?"',
            "One of the guy's friends hears the podcast and states 'Hey, I like that podcast too. Cool.'",
        ],
        "quantity": "total duration of the podcast",
        "t_values": [30, 60, 80, 95, 110],
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


    storyNameQ = fc.Question(
        q_type="note",
        name=f"{storyName}_Header",
        block_order=blocks[blockCounter],
        label=f"<h3>{storyName.capitalize()}</h3>",
        item_order = itemCounter
        )
    itemCounter += 1
    survey.addQuestion(storyNameQ)
    
    # Randomization, Calculate Question in FormR
    randomizeCalculateQ = fc.Question(
        q_type="calculate",
        name=f"calculate_{storyName}",
        value=f"randOrder <- c()\n\
numContext <- 2\n\
context <- c(1:{numContext})\n\
n<-c(1:5)\n\
for(val in n){{randOrder <- append(randOrder, list(sample(context)))}}\n\
jsonlite::toJSON(randOrder)",
    block_order=blocks[blockCounter],
    item_order=itemCounter
    )

    itemCounter+=1
    survey.addQuestion(randomizeCalculateQ)

    for finalPrompt in subbedPrompts:
        randGroup = 1

        for randOrderContextCounter in range(len(storyInfo["contexts"])):
            promptQ = fc.Question(
                q_type="note",
                name=f"{storyName}L{levelCounter}QR{randOrderContextCounter}",
                block_order=blocks[blockCounter],
                label=f"<h4>{finalPrompt} \n {quantityStatment}</h4>",
                item_order = itemCounter
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
                    showif=f"jsonlite::fromJSON(calculate_{storyName})[{levelCounter},{randOrderContextCounter+1}] == {contextCounter}",
                    item_order = itemCounter
                )
                itemCounter += 1

                contextCounter += 1

                # Horizontal Line Rule

                hrQ = fc.Question(
                    q_type="note",
                    name=f"hr{storyName}{hrCounter}",
                    block_order=blocks[blockCounter],
                    label="<hr>",
                    item_order = itemCounter
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
            block_order=blocks[blockCounter],
            item_order=itemCounter
        )
        itemCounter += 1

        survey.addQuestion(continueQ)

        continueCount += 1
        randGroup += 1

    blockCounter += 1
    hrCounter = 1

print(finalQuestions)

survey.exportToCSV()
