#!/usr/bin/python3
"""Module that defines the save_to_json_file function."""
import json


def save_to_json_file(my_obj, filename):
    """Write an object to a text file using its JSON representation.

    Args:
        my_obj: the object to serialize.
        filename (str): the path of the file to write to.
    """
    with open(filename, 'w', encoding='utf-8') as f:
        json.dump(my_obj, f)
