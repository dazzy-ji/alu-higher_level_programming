#!/usr/bin/python3
"""Module that defines the BaseGeometry class."""


class BaseGeometry:
    """A base class for geometry objects."""

    def area(self):
        """Raise an Exception because area is not implemented.

        Raises:
            Exception: always, with the message area() is not implemented.
        """
        raise Exception("area() is not implemented")
