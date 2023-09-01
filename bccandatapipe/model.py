# -*- coding: utf-8 -*-
"""
Created on Wed Aug 16 14:08:34 2023

@author: lovedeep.gondara
"""


from transformers import AutoTokenizer,  AutoModelForSequenceClassification
from transformers import TrainingArguments, Trainer, pipeline
import pandas as pd
import re
from sklearn.metrics import accuracy_score, confusion_matrix

model_checkpoint = "tsantos/PathologyBERT"
model_dir = "H:\Data Integrity\Scientist\Cancer vs not cancer"
model_name = 'pathologyBERT_canvsnoncan'

"""test_df = pd.read_csv(r"H:\Data Integrity\Scientist\Cancer vs not cancer\test_df.csv")
train_df = pd.read_csv(r"H:\Data Integrity\Scientist\Cancer vs not cancer\train_df.csv")

num_labels = 2

# Import model, tokenizer
model = AutoModelForSequenceClassification.from_pretrained(model_checkpoint, num_labels=num_labels)
tokenizer = AutoTokenizer.from_pretrained(model_checkpoint, use_fast=True, model_max_len = 512)


train_dataset = Dataset.from_pandas(train_df[['label', 'message']]) 
val_dataset = test_df.sample(n=500)
val_dataset = Dataset.from_pandas(val_dataset[['label', 'message']]) 


def preprocess_function(df):
    return tokenizer(df['message'], truncation=True, max_length = 512)

train_dataset = train_dataset.map(preprocess_function)
val_dataset = val_dataset.map(preprocess_function)


batch_size = 16

args = TrainingArguments(
    f"{model_name}",
    evaluation_strategy = "epoch",
    learning_rate=2e-5,
    per_device_train_batch_size=batch_size,
    per_device_eval_batch_size=batch_size,
    num_train_epochs=3,
    weight_decay=0.01,
    push_to_hub=False,
)

trainer = Trainer(
    model,
    args,
    train_dataset= train_dataset,
    eval_dataset= val_dataset,
    tokenizer= tokenizer,
)

trainer.train()


trainer.save_model(model_dir + model_name)
"""


def class_model_inference(text, class_pipe, logger = None):
    query = class_pipe(text, truncation = True, max_length=512)
    return([query[0]['label'], query[0]['score']])

def apply_model(model_loc, data, logger = None):

    log(f"Loading trained Model from {model_loc}", logger)
    mod_load = AutoModelForSequenceClassification.from_pretrained(model_loc, num_labels=2, max_length=512)
    log(f"Successfully loaded", logger)
    tokenizer = AutoTokenizer.from_pretrained(model_loc, use_fast=True, model_max_len=512)

    class_pipe = pipeline('text-classification', model=mod_load, tokenizer=tokenizer)
    data[['predicted_label', 'model_score']] = data.apply(lambda x: pd.Series(class_model_inference(text = x['message'], class_pipe=class_pipe)), axis = 1)
    log("Prediction complete", logger)
    data['predicted_label'] = [int(re.findall(re.compile("[0-9]+"), pred_label)[0]) for pred_label in
                                  data['predicted_label']]

    return data

# Convert "Label_[number]" to "[number]"
def model_accuracy(pred_data, logger = None):
    accuracy = accuracy_score(pred_data['label'], pred_data['predicted_label'])
    log(f"Accuracy Score = {accuracy}",logger)
    matrix = confusion_matrix(pred_data['label'], pred_data['predicted_label'])
    log(f"Confusion Matrix: {matrix}", logger)
    log(f"Matrix diagonal / matrix sum :{matrix.diagonal()/matrix.sum(axis=1)}",logger)


def log(msg,logger= None):
    if logger is None:
        print(msg)
    else:
        logger.log.info(msg)


