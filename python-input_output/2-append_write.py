#!/usr/bin/python3
"""Module that defines the append_write function."""


def append_write(filename="", text=""):
    """Append a string at the end of a UTF-8 text file.

    The file is created if it does not exist.

    Args:
        filename (str): the path of the file to append to.
        text (str): the string to append.

    Returns:
        int: the number of characters added.
    """
    with open(filename, 'a', encoding='utf-8') as f:
        return f.write(text)
