#!/usr/bin/python3
"""Module that defines the write_file function."""


def write_file(filename="", text=""):
    """Write a string to a UTF-8 text file, overwriting existing content.

    The file is created if it does not exist.

    Args:
        filename (str): the path of the file to write to.
        text (str): the string to write.

    Returns:
        int: the number of characters written.
    """
    with open(filename, 'w', encoding='utf-8') as f:
        return f.write(text)
