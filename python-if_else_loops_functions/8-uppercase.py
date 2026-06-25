#!/usr/bin/python3
"""Module that prints a string in uppercase."""


def uppercase(str):
    """Print str in uppercase followed by a new line."""
    for c in str:
        if ord('a') <= ord(c) <= ord('z'):
            print("{}".format(chr(ord(c) - 32)), end="")
        else:
            print("{}".format(c), end="")
    print("")
