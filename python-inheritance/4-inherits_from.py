#!/usr/bin/python3
"""Module that defines the inherits_from function."""


def inherits_from(obj, a_class):
    """Check whether obj is an instance of a class that inherited a_class.

    The inheritance may be direct or indirect. Objects that are exactly
    instances of a_class return False.

    Args:
        obj: the object to check.
        a_class: the class to compare against.

    Returns:
        bool: True if obj's class is a strict subclass of a_class, else False.
    """
    return isinstance(obj, a_class) and type(obj) is not a_class
