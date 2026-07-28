#!/usr/bin/python3
"""
This module provides a function that prints a square with character '#'.
"""


def print_square(size):
    """Prints a square with the '#' character.

    Args:
        size: The side length of the square.

    Raises:
        TypeError: If size is not an integer.
        ValueError: If size is less than 0.
    """
    if isinstance(size, float) and size < 0:
        raise TypeError("size must be an integer")
    if not isinstance(size, int):
        raise TypeError("size must be an integer")
    if size < 0:
        raise ValueError("size must be >= 0")

    for _ in range(size):
        print("#" * size)
