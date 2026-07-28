#!/usr/bin/python3
"""Module that defines the class_to_json function."""


def class_to_json(obj):
    """Return the dictionary description of an object for JSON serialization.

    Args:
        obj: an instance of a class whose attributes are all serializable.

    Returns:
        dict: a copy of the object's attribute dictionary.
    """
    return obj.__dict__.copy()
