#!/usr/bin/python3
"""Module that prints a string in uppercase."""


def uppercase(str):
    """Print str in uppercase followed by a new line."""
    for c in str:
        print("{}".format(
            chr(ord(c) - 32) if ord('a') <= ord(c) <= ord('z') else c),
            end="")
    print("")
