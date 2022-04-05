"""
A small set of classes written to more easily programmatically generate FormR spreadsheets.

- Stephen Payne

"""


import pandas as pd

class Question:
    """Interface for representing questions to be added to FormR survey spreadsheet."""
    def __init__(self, q_type, name, label="", value="", showif="", block_order="", item_order="", class_="", choice1 = "", choice2 = ""):
        self.q_type = q_type
        self.name = name
        self.label = label
        self.value = value
        self.showif = showif
        self.block_order = block_order
        self.item_order = item_order
        self.class_ = class_
        self.choice1 = choice1
        self.choice2 = choice2

class QuestionList:
    def __init__(self):
        self.q_types = []
        self.names = []
        self.labels = []
        self.values = []
        self.showifs = []
        self.block_orders = []
        self.item_orders = []
        self.classes = []
        self.choice1s = []
        self.choice2s = []

    def addQuestion(self,question):
        self.q_types.append(question.q_type)
        self.names.append(question.name)
        self.labels.append(question.label)
        self.values.append(question.value)
        self.showifs.append(question.showif)
        self.block_orders.append(question.block_order)
        self.item_orders.append(question.item_order)
        self.classes.append(question.class_)
        self.choice1s.append(question.choice1)
        self.choice2s.append(question.choice2)

    def exportToCSV(self, outputFilename="survey.csv"):
        df = pd.DataFrame()
        df['type'] = self.q_types
        df['name'] = self.names
        df['label'] = self.labels
        df['value'] = self.values
        df['showif'] = self.showifs
        df['block_order'] = self.block_orders
        df['item_order'] = self.item_orders
        df['class'] = self.classes
        df['choice1'] = self.choice1s
        df['choice2'] = self.choice2s
        print(df)
        df.to_csv(outputFilename, index=False)
