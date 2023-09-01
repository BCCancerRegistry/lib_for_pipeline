

import pandas as pd
import re



def load_data_from_db(connection_string,table, schema,date_to, date_from):
    pass

def save_to_table(connection_string,table,schema,data):
    pass

# some regular regex to remove weird things
def basic_reg(text):
    text = re.sub('[^A-Za-z0-9]+', ' ', text)
    text = text.lower()
    text = str(text).split("diagnoses",1)
    text2 = str(text).split("diagnosis",1)
    if len(text) > len(text2):
        textuse = text
    else:
        textuse = text2
    if len(textuse)>1:
        text = textuse[1].split()[-512:]
        text = ' '.join(text)
    else:
        text = textuse[0].split()[-512:]
        text = ' '.join(text) 
    return(text)
