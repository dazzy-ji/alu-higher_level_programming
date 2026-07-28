#!/usr/bin/python3
"""Defines the Square class, which inherits from Rectangle."""
from models.rectangle import Rectangle


class Square(Rectangle):
    """Represent a square, a rectangle whose width and height are equal."""

    def __init__(self, size, x=0, y=0, id=None):
        """Initialize a new Square.

        Args:
            size (int): the length of a side, used as both width and height.
            x (int): the horizontal offset, must be zero or more.
            y (int): the vertical offset, must be zero or more.
            id (int): the identifier handed to the Base constructor.
        """
        super().__init__(size, size, x, y, id)

    @property
    def size(self):
        """int: the length of a side of the square."""
        return self.width

    @size.setter
    def size(self, value):
        """Set the width and then the height to the same value.

        Validation is inherited from the width setter of Rectangle, so the
        error messages mention width.

        Args:
            value (int): the new side length.
        """
        self.width = value
        self.height = value

    def update(self, *args, **kwargs):
        """Assign arguments to the attributes of the square.

        Args:
            *args: values applied in the order id, size, x, y.
            **kwargs: attribute name and value pairs, skipped entirely when
                args is present and not empty.
        """
        if args and len(args) > 0:
            attributes = ["id", "size", "x", "y"]
            for i, value in enumerate(args):
                if i < len(attributes):
                    setattr(self, attributes[i], value)
        else:
            for key, value in kwargs.items():
                setattr(self, key, value)

    def to_dictionary(self):
        """Return the dictionary representation of the square.

        Returns:
            dict: the id, size, x and y of the instance.
        """
        return {
            'id': self.id,
            'size': self.size,
            'x': self.x,
            'y': self.y
        }

    def __str__(self):
        """Return [Square] (<id>) <x>/<y> - <size>."""
        return "[Square] ({}) {}/{} - {}".format(
            self.id, self.x, self.y, self.width)
