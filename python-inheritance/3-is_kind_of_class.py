#!/usr/bin/python3
"""Module that defines the is_kind_of_class function."""


def is_kind_of_class(obj, a_class):
    """Check whether obj is an instance of a_class or of a subclass of it.

    Args:
        obj: the object to check.
        a_class: the class to compare against.

    Returns:
        bool: True if obj is an instance of a_class or a subclass, else False.
    """
    return isinstance(obj, a_class)
