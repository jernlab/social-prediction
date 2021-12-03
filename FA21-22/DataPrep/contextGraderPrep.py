import numpy as np
import pandas as pd
import FormrClasses as fc

# from FormrClasses import Question

questionPrompt = "<h5>On the following scale, how likely do you think it would be to now {question}</h5>"

listQuestions = {
    "cake": {
        "prompt": "A cake has been baking in an oven for {t_val} minutes.",
        "contexts": [
            "The cake's baker is leaning against the stove.",
            "A visitor, who is not baking the cake, is leaning against the oven",
        ],
        "quantity": "see...",
        "t_values": [10, 20, 35, 50, 70],
    },
    "movie": {
        "prompt": "A movie has been playing in a theatre and is currently {t_val} minutes.",
        # 'the' movie might imply the same movie, using 'a' instead
        "contexts": [
            "exit the movie's showroom.",
            "exit the showroom of a movie next-door",
        ],
        "quantity": "see 10 people...",
        "t_values": [30, 45, 60, 85, 100],
    },
    "podcast": {
        "prompt": "Someone has been listening to a podcast for {t_val} minutes.",
        "contexts": [
            'the podcast host say "Welp, that\'s all we planned to discuss this week!"',
            # 'the podcast host ask the rest of the panel "Is there anything else you all wanted to discuss?"',
            "a nearby pedestrian say 'Hey, I like that podcast too. Cool.'",
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

survey.addQuestion(fc.Question(q_type="note", name="startScreen", label="You are being invited to participate in a research study about human reasoning. This study is being conducted by Alan Jern, Ph.D., from the Department of Humanities, Social Sciences, and the Arts at Rose-Hulman Institute of Technology. There are no known risks or costs if you decide to participate in this research study. In this study, you will be asked to answer a few questions or make some judgments. There are no right or wrong answers. We are only interested in whether people tend to give similar answers. The information collected may not benefit you directly, but the information learned in this study could help us to better understand how people think and reason. The data from this study will be shared publicly, but your responses will be anonymized so that they cannot be linked to your identity. Your participation in this study is voluntary and you may leave at any time. By completing the survey, you are voluntarily agreeing to participate. If you have any questions about the study, please contact Alan Jern at jern@rose-hulman.edu. If you have any questions about your rights as a research subject or if you feel you’ve been placed at risk, you may contact the Institutional Reviewer, Daniel Morris, by phone at (812) 877-8314, or by e-mail at morris@rose-hulman.edu."))
survey.addQuestion(fc.Question(q_type="submit", name="startButton", label="Start"))


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


    for finalPrompt in subbedPrompts:
        randGroup = 1

        contextCounter = 1
        for context in storyInfo["contexts"]:
            promptQ = fc.Question(
            q_type="note",
            name=f"{storyName}L{levelCounter}QC{contextCounter}",
            block_order=blocks[blockCounter],
            label=f"<h4>{finalPrompt} \n {quantityStatment}</h4>")

            itemCounter += 1
            survey.addQuestion(promptQ)

            # Context
            contextQ = fc.Question(
                q_type="rating_button 1,7,1",
                label=context,
                block_order=blocks[blockCounter],
                name=f"{storyName}L{levelCounter}C{contextCounter}",
                choice1="Not at all",
                choice2="Very"
            )
            itemCounter += 1

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
    hrCounter = 1

survey.addQuestion(fc.Question(q_type="text", name="attentionCheck", label="This is an attention check"))

print(finalQuestions)

survey.exportToCSV()

# add attention check as multiple choice question about topics in/not in experiment
# add instruction page at beginning
# randomize at the beginning of a block, hold constant
