#!/usr/bin/python3
"""Module that defines the is_same_class function."""


def is_same_class(obj, a_class):
    """Check whether obj is exactly an instance of a_class.

    Args:
        obj: the object to check.
        a_class: the class to compare against.

    Returns:
        bool: True if obj is exactly an instance of a_class, else False.
    """
    return type(obj) is a_class
