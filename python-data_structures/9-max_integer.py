#!/usr/bin/python3
"""Module that finds the biggest integer of a list."""


def max_integer(my_list=[]):
    """Return the biggest integer in my_list, or None if empty."""
    if not my_list:
        return None
    biggest = my_list[0]
    for item in my_list:
        if item > biggest:
            biggest = item
    return biggest
