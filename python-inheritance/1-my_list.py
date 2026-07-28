#!/usr/bin/python3
"""Module that defines the MyList class."""


class MyList(list):
    """A list subclass able to print itself sorted."""

    def print_sorted(self):
        """Print the list in ascending order without modifying it."""
        print(sorted(self))
