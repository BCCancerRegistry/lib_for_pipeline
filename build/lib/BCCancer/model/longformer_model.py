import torch
import numpy as np
import re
from transformers import LongformerForQuestionAnswering, AutoTokenizer

question_lookup = {
    "Comment": "Can you extract the section which immediately follows a subheading containing 'comment' and exclude sections that occur after the next subheading?",
    "Addendum": "Can you extract the section which immediately follows a subheading containing 'addendum' and exclude sections that occur after the next subheading?",
    "Gross description": "Can you extract the section which immediately follows a subheading containing 'gross description' and exclude sections that occur after the next subheading?",
    "Diagnosis": "Can you extract only the section that describes the diagnosis and not a section that appears before or after the diagnosis?",
    "Clinical History": "Can you extract the section which immediately follows subheadings related to 'clinical history' or 'clinical information' and exclude sections that occur after the next subheading",
    "Microscopic": "Can you extract the section which immediately follows a subheading related to 'microscopic' and exclude sections that occur after the next subheading?",
    "Overall report": "Can you extract the overall report without metadata?",
}


# Load model & Trainer from saved checkpoint
model_checkpoint = "valhalla/longformer-base-4096-finetuned-squadv1"
model_dir = r"\\svmonc02\registry_data_science\prostate_surveillance\Data Science files\Final Pipeline\Trained Models\v2.1_longformer-base-4096-finetuned-squadv1"
model = LongformerForQuestionAnswering.from_pretrained(model_dir)
tokenizer = AutoTokenizer.from_pretrained(model_checkpoint)

class LongformerModel:
    def __init__(self, model_location, tokenizer_location):
        self.model = LongformerForQuestionAnswering.from_pretrained(model_location)
        self.tokenizer = LongformerTokenizer(tokenizer_location)

    def answer_questions(self, question, text, add_special_tokens=True, return_tensors="pt", truncation=True, return_offsets_mapping=True, return_indices=False):
        tokenized_input = self.tokenizer.tokenize(
            question,
            text,
            add_special_tokens,
            return_tensors,
            truncation,
            return_offsets_mapping,
        )
        tokenized_input.to("cuda:0")
        offset_mapping = tokenized_input.pop("offset_mapping")

        outputs = model(**tokenized_input)

        start_scores = outputs.start_logits
        end_scores = outputs.end_logits

        start_token_index = torch.argmax(start_scores)
        end_token_index = torch.argmax(end_scores)

        answer_tokens = tokenized_input["input_ids"][0][start_token_index: end_token_index + 1]
        answer = tokenizer.decode(answer_tokens)

        # Setting default start and end character index
        start_character_index = -1
        end_character_index = -1
        if (
                answer == "<s>"
                or answer == ""
                or bool(re.search(question, answer))
        ):
            answer = "Section not found"


        if return_indices:
            #Calculating character index
            # Use default value if section is not found else Calculate the indexes
            start_character_index = start_character_index if answer == "Section not found" else int(offset_mapping[0][start_token_index][0].cpu())
            end_character_index = end_character_index if answer == "Section not found" else int(offset_mapping[0][end_token_index][1].cpu())

            return [answer, start_character_index, end_character_index]

        return answer


class LongformerTokenizer:
    def __init__(self, tokenizer_location):
        self.tokenizer = AutoTokenizer.from_pretrained(tokenizer_location)

    def tokenize(self,question, text, add_special_tokens=True, return_tensors="pt", truncation=True, return_offsets_mapping=True):
        return self.tokenizer(question, text, add_special_tokens, return_tensors, truncation, return_offsets_mapping)

