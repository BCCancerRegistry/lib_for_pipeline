# This pipeline requires the following documents in order to run
# Model
# Input file
# Regex lookup excel (to perform regex segmentation) - section_regex.csv
# Dx Group lookup file (to match numeric label to Dx group description) - dx_labels_lookup.csv


# The output is a dataframe containing:
# msg_id: The reports unique ID
# message: The original text before any preprocessing is performed
# file_found: A binary variable indicating if a report with the given msg_id was found and loaded
# filtered_message: The text after pre-processing is complete
# predicted_dx_group: The predicted Dx Group
# part_of_report: The portion(s) of the report that were used in the model
# model_score: The model's confidence score in the predicted Dx Group

from transformers import AutoTokenizer, AutoModelForSequenceClassification, pipeline

import pandas as pd
import re
from BCCancer.model.tor_model import Torch_model

def apply_model(data:pd.DataFrame, model_name, model_location, tokenizer_path, model_labels:pd.DataFrame, max_length:int, device:int, task:str ="text-classification", apply_on_column:str = "Prepped_Message"):
    """
    This function applies the model on the Message column of the input Dataframe, from a trained model placed at a particular location.
    :param data:
    :param model_name:
    :param model_location:
    :param tokenizer_path:
    :param model_labels:
    :param max_length:
    :param device:
    :param task:
    :return:
    """
    with Torch_model(model_name, model_location, tokenizer_path, num_labels=model_labels.shape[0],
                     use_fast=True, task=task, max_length=max_length, device=device) as model:
        output_df = model.apply_model(data[apply_on_column])

    output_df['label'] = [int(re.findall(re.compile("[0-9]+"), pred_label)[0]) for pred_label in output_df['label']]
    data[['predicted_label', 'model_score']] = output_df
    return data


