#!/usr/bin/python3
"""
This module provides a function for integer addition.
"""


def add_integer(a, b=98):
    """Adds two integers or floats after casting them to integers.

    Args:
        a: The first number.
        b: The second number (default 98).

    Returns:
        The sum of a and b as an integer.

    Raises:
        TypeError: If either a or b is not an integer or float.
    """
    if type(a) not in (int, float):
        raise TypeError("a must be an integer")
    if type(b) not in (int, float):
        raise TypeError("b must be an integer")
    return int(a) + int(b)
