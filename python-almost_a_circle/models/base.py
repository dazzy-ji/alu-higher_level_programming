#!/usr/bin/python3
"""Defines the Base class, the foundation of every other class here."""
import json


class Base:
    """Manage the id attribute of all derived classes.

    Keeping the id logic in one place avoids duplicating the same code,
    and by extension the same bugs, in every subclass.
    """

    __nb_objects = 0

    def __init__(self, id=None):
        """Initialize a new Base instance.

        Args:
            id (int): the identifier to assign. When None, an automatically
                incremented value is used instead.
        """
        if id is not None:
            self.id = id
        else:
            Base.__nb_objects += 1
            self.id = Base.__nb_objects

    @staticmethod
    def to_json_string(list_dictionaries):
        """Return the JSON string representation of a list of dictionaries.

        Args:
            list_dictionaries (list): the list of dictionaries to serialize.

        Returns:
            str: the JSON representation, or "[]" if the list is empty or None.
        """
        if list_dictionaries is None or len(list_dictionaries) == 0:
            return "[]"
        return json.dumps(list_dictionaries)

    @classmethod
    def save_to_file(cls, list_objs):
        """Write the JSON representation of a list of instances to a file.

        The file is named after the class, for example Rectangle.json, and is
        overwritten if it already exists.

        Args:
            list_objs (list): the instances to serialize. None saves an
                empty list.
        """
        filename = "{}.json".format(cls.__name__)
        if list_objs is None:
            list_objs = []
        list_dicts = [obj.to_dictionary() for obj in list_objs]
        with open(filename, 'w', encoding='utf-8') as f:
            f.write(cls.to_json_string(list_dicts))

    @staticmethod
    def from_json_string(json_string):
        """Return the list of dictionaries represented by a JSON string.

        Args:
            json_string (str): a string representing a list of dictionaries.

        Returns:
            list: the deserialized list, or an empty list if the string is
                empty or None.
        """
        if json_string is None or len(json_string) == 0:
            return []
        return json.loads(json_string)

    @classmethod
    def create(cls, **dictionary):
        """Return an instance with all of its attributes already set.

        A dummy instance is built first, then updated with the real values.

        Args:
            **dictionary: the attribute names and values to apply.

        Returns:
            An instance of cls with the given attributes.
        """
        if cls.__name__ == "Square":
            dummy = cls(1)
        elif cls.__name__ == "Rectangle":
            dummy = cls(1, 1)
        else:
            dummy = cls()
        dummy.update(**dictionary)
        return dummy

    @classmethod
    def load_from_file(cls):
        """Return a list of instances loaded from the class JSON file.

        Returns:
            list: the instances stored in <Class name>.json, or an empty list
                if the file does not exist.
        """
        filename = "{}.json".format(cls.__name__)
        try:
            with open(filename, 'r', encoding='utf-8') as f:
                list_dicts = cls.from_json_string(f.read())
                return [cls.create(**d) for d in list_dicts]
        except FileNotFoundError:
            return []
