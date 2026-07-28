#!/usr/bin/python3
"""Module that defines the to_json_string function."""
import json


def to_json_string(my_obj):
    """Return the JSON representation of an object as a string.

    Args:
        my_obj: the object to serialize.

    Returns:
        str: the JSON representation of my_obj.
    """
    return json.dumps(my_obj)
