import re

import pandas as pd
import numpy as np
from BCCancer.logger.pkglogging import get_log_obj

def clean_msg(text):
    """
    Fix line break
    lower the text for model processing
    Extract sections from report
    :param text:
    :return:
    """
    text = fix_line_breaks(text)
    text = text.lower()
    return text

def fix_line_breaks(text):
    text = text.replace('\\X0D\\', "\n")
    text = text.replace("\\.br\\", "\n")
    return (text)


def extract_section(text, regex_dict):
    empty_extractions = ["\n", '\n\n', '\n\n\n', '\n\n\n\n' "\n\n\n\n\n", '\n\n\n\n\n\n', '\n\n\n\n\n\n\n',
                         'Section not found', '']

    for reg in regex_dict.values():
        match = re.search(re.compile(reg, re.IGNORECASE), text)
        if match is not None and match not in empty_extractions:
            return match.group('section')
    return ''

def create_sections(text, section_regex, report_sections:list = ['diagnosis', 'diagnosis_comment', 'addendum', 'micro', 'gross'] ):
    section_dict = {}
    for i in report_sections:
        section_dict[i] = extract_section(text, section_regex[i])
    section_dict = merge_sections(text,section_dict)
    return section_dict


def merge_sections(text: str, section_dict: dict) -> dict:
    if section_dict['diagnosis'] != "" or section_dict['diagnosis_comment'] != "" or section_dict['addendum'] != "":
        combined_text = section_dict['diagnosis'] + '\n' + section_dict['diagnosis_comment'] + '\n' + section_dict['addendum']
        part_of_report = 'diag_or_add'
    elif section_dict["gross"] != "" or section_dict["micro"] != "":
        combined_text = section_dict["gross"] + '\n' + section_dict["micro"]
        part_of_report = 'gross_or_micro'
    else:
        combined_text = text
        part_of_report = 'entire report'
    section_dict["filtered_message"] = combined_text
    section_dict['part_of_report'] = part_of_report
    return section_dict




def create_section_regex(section_df:pd.DataFrame):
    section_df.replace(np.nan, '', regex=True, inplace=True)
    section_regex = {}
    section_keys = {'addendum': 'addendum',
                    'diagnosis': 'diagnosis',
                    'diagnosis comment': 'diagnosis_comment',
                    'microscopic description': 'micro',
                    'gross description': 'gross'}
    sections = section_df.parent_category.to_list()
    ha = section_df.columns[1:]
    for i in sections:
        if i != "":
            section_name = section_keys[i]
            section_regex[section_name] = {}
            for j in ha:
                start = section_df[section_df["parent_category"] == i][j].values[0]
                if start != "":
                    end = \
                        section_df[
                            (section_df['parent_category'] != i) & (section_df[j] != "")][
                            j].values.tolist()
                    section_regex[section_name][j] = r'\n' + start + r"(?P<section>[\s\S]*?)(?:(" + r"\n|".join(
                        end) + r"\n|Electronically signed by|Electronically Signed By:|-------------------------------))"
    return section_regex
""" for health_authority in section_df.columns[1:]:
        headers = section_df[health_authority]
        start = section_df[section_df['parent_category'] == section_of_interest][health_authority].values[0]
        if start != "":
            end = section_df[(section_df['parent_category'] != section_of_interest) & (section_df[health_authority] != "")][
                health_authority].values.tolist()
            regex_dict[health_authority] = r'\n' + start + r"(?P<section>[\s\S]*?)(?:(" + r"\n|".join(end) + r"\n|Electronically signed by|Electronically Signed By:|-------------------------------))"
    return(regex_dict)"""

