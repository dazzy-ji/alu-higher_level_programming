#!/usr/bin/python3
"""Module that defines the load_from_json_file function."""
import json


def load_from_json_file(filename):
    """Create a Python object from a JSON file.

    Args:
        filename (str): the path of the JSON file to read.

    Returns:
        The Python data structure stored in the file.
    """
    with open(filename, 'r', encoding='utf-8') as f:
        return json.load(f)
