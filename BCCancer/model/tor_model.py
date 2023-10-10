import os.path
import pandas as pd
import torch
from transformers import AutoTokenizer, AutoModelForSequenceClassification, pipeline
from logger.pkglogging import get_log_obj
import gc

logger = get_log_obj(__name__)
class Torch_model:
    def __init__(self, model_name: str, model_location: str, tokenizer_path: str, num_labels: int = 2,
                 use_fast: bool = True, task: str = "text-classification", max_length: int = 512, device:int = -1):
        self.model_name = model_name
        self.model_loc = model_location
        self.tokenizer_path = tokenizer_path
        self.num_labels = num_labels
        self.use_fast = use_fast
        self.task = task
        self.max_len = max_length
        self.model = self.load_model()
        logger.info(f"Model: {model_name} successfully loaded from: {model_location} ")
        tok = Torch_tokenizer(tokenizer_path,num_labels,use_fast,max_length)
        self.tok = tok.load_tokenizer()
        if device == -1:
            if torch.cuda.is_available():
                self.device = torch.cuda.current_device()
        else:
            if not torch.cuda.is_available():
                logger.warning("No GPU's available running the model with no GPU's")
                device = -1
            self.device = device
        logger.info(f"GPU allocated: {self.device}")

    def load_model(self):
        model_path = os.path.join(self.model_loc,self.model_name)
        if not (os.path.exists(model_path)):
            logger.error(f"Torch Model path is not exist on the path {model_path}. Please check the path. ")
            raise ValueError(f"Torch Model path is not exist on the path {model_path}. Please check the path.")
        return AutoModelForSequenceClassification.from_pretrained(model_path,
                                                                  num_labels=self.num_labels,
                                                                  max_length=self.max_len)

    def create_pipeline(self):
        logger.info(f"Created pipeline to perform {self.task}")
        return pipeline(self.task, model=self.model, tokenizer=self.tok, device=self.device)

    def apply_model(self, data_column:pd.Series) -> pd.DataFrame:
        pipe = self.create_pipeline()
        data_input = data_column.to_list()
        output = pipe(data_input, truncation=True)
        output_df = pd.DataFrame.from_records(output)
        return output_df

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        gc.collect()
        torch.cuda.empty_cache()
        logger.info("Clearing the GPU Cache")



class Torch_tokenizer:
    def __init__(self, tokenizer_path: str, num_labels: int = 2,
                 use_fast: bool = True,  max_length: int = 512):
        self.tokenizer_path = tokenizer_path

        self.num_labels = num_labels
        self.use_fast = use_fast
        self.max_len = max_length
        self.model = self.load_tokenizer()
        logger.info(f"Tokenizer loaded successfully from {tokenizer_path}")

    def load_tokenizer(self):
        if os.path.exists(self.tokenizer_path):
            logger.ERROR(f"Tokenizer path does not exist {self.tokenizer_path}. Please check the path and re-run")
            raise ValueError("Tokenizer path does not exist. Please check the path and re-run")
        return AutoTokenizer.from_pretrained(self.tokenizer_path,use_fast=True, model_max_len=512)