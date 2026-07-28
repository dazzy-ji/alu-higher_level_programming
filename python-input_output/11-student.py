#!/usr/bin/python3
"""Module that defines the Student class."""


class Student:
    """A student defined by a first name, a last name and an age."""

    def __init__(self, first_name, last_name, age):
        """Initialize a new Student.

        Args:
            first_name (str): the student's first name.
            last_name (str): the student's last name.
            age (int): the student's age.
        """
        self.first_name = first_name
        self.last_name = last_name
        self.age = age

    def to_json(self, attrs=None):
        """Return the dictionary representation of the Student.

        Args:
            attrs (list): if a list of strings, only those attribute names
                are retrieved. Otherwise every attribute is retrieved.

        Returns:
            dict: the filtered attribute dictionary.
        """
        if type(attrs) is list and all(type(a) is str for a in attrs):
            return {k: v for k, v in self.__dict__.items() if k in attrs}
        return self.__dict__.copy()

    def reload_from_json(self, json):
        """Replace all attributes of the Student from a dictionary.

        Args:
            json (dict): keys are public attribute names, values are the
                values to assign.
        """
        for key, value in json.items():
            setattr(self, key, value)
