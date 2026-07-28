#!/usr/bin/python3
"""Defines the Rectangle class, which inherits from Base."""
from models.base import Base


class Rectangle(Base):
    """Represent a rectangle defined by a width, a height and a position."""

    def __init__(self, width, height, x=0, y=0, id=None):
        """Initialize a new Rectangle.

        Args:
            width (int): the width, must be a positive integer.
            height (int): the height, must be a positive integer.
            x (int): the horizontal offset, must be zero or more.
            y (int): the vertical offset, must be zero or more.
            id (int): the identifier handed to the Base constructor.
        """
        super().__init__(id)
        self.width = width
        self.height = height
        self.x = x
        self.y = y

    @property
    def width(self):
        """int: the width of the rectangle."""
        return self.__width

    @width.setter
    def width(self, value):
        """Validate and set the width.

        Args:
            value (int): the new width.

        Raises:
            TypeError: if value is not an integer.
            ValueError: if value is zero or less.
        """
        if type(value) is not int:
            raise TypeError("width must be an integer")
        if value <= 0:
            raise ValueError("width must be > 0")
        self.__width = value

    @property
    def height(self):
        """int: the height of the rectangle."""
        return self.__height

    @height.setter
    def height(self, value):
        """Validate and set the height.

        Args:
            value (int): the new height.

        Raises:
            TypeError: if value is not an integer.
            ValueError: if value is zero or less.
        """
        if type(value) is not int:
            raise TypeError("height must be an integer")
        if value <= 0:
            raise ValueError("height must be > 0")
        self.__height = value

    @property
    def x(self):
        """int: the horizontal offset of the rectangle."""
        return self.__x

    @x.setter
    def x(self, value):
        """Validate and set the horizontal offset.

        Args:
            value (int): the new offset.

        Raises:
            TypeError: if value is not an integer.
            ValueError: if value is negative.
        """
        if type(value) is not int:
            raise TypeError("x must be an integer")
        if value < 0:
            raise ValueError("x must be >= 0")
        self.__x = value

    @property
    def y(self):
        """int: the vertical offset of the rectangle."""
        return self.__y

    @y.setter
    def y(self, value):
        """Validate and set the vertical offset.

        Args:
            value (int): the new offset.

        Raises:
            TypeError: if value is not an integer.
            ValueError: if value is negative.
        """
        if type(value) is not int:
            raise TypeError("y must be an integer")
        if value < 0:
            raise ValueError("y must be >= 0")
        self.__y = value

    def area(self):
        """Return the area of the rectangle."""
        return self.__width * self.__height

    def display(self):
        """Print the rectangle to stdout with the # character.

        The x and y offsets are honoured: y produces blank lines above the
        shape and x indents every row.
        """
        print("\n" * self.__y, end="")
        for _ in range(self.__height):
            print(" " * self.__x + "#" * self.__width)

    def update(self, *args, **kwargs):
        """Assign arguments to the attributes of the rectangle.

        Args:
            *args: values applied in the order id, width, height, x, y.
            **kwargs: attribute name and value pairs, skipped entirely when
                args is present and not empty.
        """
        if args and len(args) > 0:
            attributes = ["id", "width", "height", "x", "y"]
            for i, value in enumerate(args):
                if i < len(attributes):
                    setattr(self, attributes[i], value)
        else:
            for key, value in kwargs.items():
                setattr(self, key, value)

    def to_dictionary(self):
        """Return the dictionary representation of the rectangle.

        Returns:
            dict: the id, width, height, x and y of the instance.
        """
        return {
            'id': self.id,
            'width': self.width,
            'height': self.height,
            'x': self.x,
            'y': self.y
        }

    def __str__(self):
        """Return [Rectangle] (<id>) <x>/<y> - <width>/<height>."""
        return "[Rectangle] ({}) {}/{} - {}/{}".format(
            self.id, self.__x, self.__y, self.__width, self.__height)
