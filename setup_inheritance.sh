#!/bin/bash
# Creates every file for the "python-inheritance" project.
# Run this from the ROOT of your alu-higher_level_programming repo.

set -e

DIR="python-inheritance"
mkdir -p "$DIR/tests"
cd "$DIR"

# ---------------------------------------------------------------- 0. Lookup
cat > 0-lookup.py <<'EOF'
#!/usr/bin/python3
"""Module that defines the lookup function."""


def lookup(obj):
    """Return the list of available attributes and methods of an object.

    Args:
        obj: the object to inspect.

    Returns:
        list: the attributes and methods of obj.
    """
    return dir(obj)
EOF

# --------------------------------------------------------------- 1. My list
cat > 1-my_list.py <<'EOF'
#!/usr/bin/python3
"""Module that defines the MyList class."""


class MyList(list):
    """A list subclass able to print itself sorted."""

    def print_sorted(self):
        """Print the list in ascending order without modifying it."""
        print(sorted(self))
EOF

cat > tests/1-my_list.txt <<'EOF'
The ``1-my_list`` module
========================

Using ``MyList``
----------------

Import the class:

    >>> MyList = __import__('1-my_list').MyList

``MyList`` inherits from ``list``:

    >>> issubclass(MyList, list)
    True

A new ``MyList`` is empty, and printing it sorted prints an empty list:

    >>> my_list = MyList()
    >>> print(my_list)
    []
    >>> my_list.print_sorted()
    []

It supports every ``list`` method, such as ``append``:

    >>> my_list.append(1)
    >>> my_list.append(4)
    >>> my_list.append(2)
    >>> my_list.append(3)
    >>> my_list.append(5)
    >>> print(my_list)
    [1, 4, 2, 3, 5]

``print_sorted`` prints the sorted list:

    >>> my_list.print_sorted()
    [1, 2, 3, 4, 5]

...and leaves the original list untouched:

    >>> print(my_list)
    [1, 4, 2, 3, 5]

It can be built directly from an existing list:

    >>> my_list = MyList([7, 1, 9])
    >>> my_list.print_sorted()
    [1, 7, 9]

It handles negative numbers:

    >>> my_list = MyList([-3, 10, -7, 0])
    >>> my_list.print_sorted()
    [-7, -3, 0, 10]

It handles a list that is already sorted:

    >>> my_list = MyList([1, 2, 3])
    >>> my_list.print_sorted()
    [1, 2, 3]

It handles a single element:

    >>> my_list = MyList([42])
    >>> my_list.print_sorted()
    [42]

It handles duplicates:

    >>> my_list = MyList([5, 1, 5, 1])
    >>> my_list.print_sorted()
    [1, 1, 5, 5]

``print_sorted`` takes no argument besides self:

    >>> my_list.print_sorted(1)
    Traceback (most recent call last):
    TypeError: MyList.print_sorted() takes 1 positional argument but 2 were given
EOF

# ------------------------------------------------------- 2. Exact same object
cat > 2-is_same_class.py <<'EOF'
#!/usr/bin/python3
"""Module that defines the is_same_class function."""


def is_same_class(obj, a_class):
    """Check whether obj is exactly an instance of a_class.

    Args:
        obj: the object to check.
        a_class: the class to compare against.

    Returns:
        bool: True if obj is exactly an instance of a_class, else False.
    """
    return type(obj) is a_class
EOF

# ------------------------------------------------ 3. Same class or inherit from
cat > 3-is_kind_of_class.py <<'EOF'
#!/usr/bin/python3
"""Module that defines the is_kind_of_class function."""


def is_kind_of_class(obj, a_class):
    """Check whether obj is an instance of a_class or of a subclass of it.

    Args:
        obj: the object to check.
        a_class: the class to compare against.

    Returns:
        bool: True if obj is an instance of a_class or a subclass, else False.
    """
    return isinstance(obj, a_class)
EOF

# ------------------------------------------------------- 4. Only sub class of
cat > 4-inherits_from.py <<'EOF'
#!/usr/bin/python3
"""Module that defines the inherits_from function."""


def inherits_from(obj, a_class):
    """Check whether obj is an instance of a class that inherited a_class.

    The inheritance may be direct or indirect. Objects that are exactly
    instances of a_class return False.

    Args:
        obj: the object to check.
        a_class: the class to compare against.

    Returns:
        bool: True if obj's class is a strict subclass of a_class, else False.
    """
    return isinstance(obj, a_class) and type(obj) is not a_class
EOF

# ------------------------------------------------------- 5. Geometry module
cat > 5-base_geometry.py <<'EOF'
#!/usr/bin/python3
"""Module that defines the empty BaseGeometry class."""


class BaseGeometry:
    """An empty base class for geometry objects."""

    pass
EOF

# ------------------------------------------------------ 6. Improve Geometry
cat > 6-base_geometry.py <<'EOF'
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
EOF

# ------------------------------------------------------ 7. Integer validator
cat > 7-base_geometry.py <<'EOF'
#!/usr/bin/python3
"""Module that defines the BaseGeometry class with a validator."""


class BaseGeometry:
    """A base class for geometry objects."""

    def area(self):
        """Raise an Exception because area is not implemented.

        Raises:
            Exception: always, with the message area() is not implemented.
        """
        raise Exception("area() is not implemented")

    def integer_validator(self, name, value):
        """Validate that value is a positive integer.

        Args:
            name (str): the name of the value, used in error messages.
            value: the value to validate.

        Raises:
            TypeError: if value is not an integer.
            ValueError: if value is less than or equal to 0.
        """
        if type(value) is not int:
            raise TypeError("{} must be an integer".format(name))
        if value <= 0:
            raise ValueError("{} must be greater than 0".format(name))
EOF

cat > tests/7-base_geometry.txt <<'EOF'
The ``7-base_geometry`` module
==============================

Using ``BaseGeometry``
----------------------

Import the class and create an instance:

    >>> BaseGeometry = __import__('7-base_geometry').BaseGeometry
    >>> bg = BaseGeometry()

``area``
--------

``area()`` always raises an ``Exception``:

    >>> bg.area()
    Traceback (most recent call last):
    Exception: area() is not implemented

It takes no argument besides self:

    >>> bg.area(1)
    Traceback (most recent call last):
    TypeError: BaseGeometry.area() takes 1 positional argument but 2 were given

``integer_validator``
---------------------

A positive integer passes silently and returns ``None``:

    >>> bg.integer_validator("my_int", 12)
    >>> print(bg.integer_validator("width", 89))
    None

The smallest valid value is 1:

    >>> bg.integer_validator("size", 1)

A string raises a ``TypeError``:

    >>> bg.integer_validator("name", "John")
    Traceback (most recent call last):
    TypeError: name must be an integer

So do floats, even whole ones:

    >>> bg.integer_validator("width", 3.5)
    Traceback (most recent call last):
    TypeError: width must be an integer

    >>> bg.integer_validator("width", 4.0)
    Traceback (most recent call last):
    TypeError: width must be an integer

Booleans are rejected too, even though ``bool`` subclasses ``int``:

    >>> bg.integer_validator("age", True)
    Traceback (most recent call last):
    TypeError: age must be an integer

So are lists, tuples, dicts, sets and ``None``:

    >>> bg.integer_validator("age", [3])
    Traceback (most recent call last):
    TypeError: age must be an integer

    >>> bg.integer_validator("age", (4,))
    Traceback (most recent call last):
    TypeError: age must be an integer

    >>> bg.integer_validator("age", {3, 4})
    Traceback (most recent call last):
    TypeError: age must be an integer

    >>> bg.integer_validator("age", {"key": 1})
    Traceback (most recent call last):
    TypeError: age must be an integer

    >>> bg.integer_validator("age", None)
    Traceback (most recent call last):
    TypeError: age must be an integer

Zero raises a ``ValueError``:

    >>> bg.integer_validator("age", 0)
    Traceback (most recent call last):
    ValueError: age must be greater than 0

So does any negative integer:

    >>> bg.integer_validator("distance", -4)
    Traceback (most recent call last):
    ValueError: distance must be greater than 0

The type check happens before the value check:

    >>> bg.integer_validator("distance", "-4")
    Traceback (most recent call last):
    TypeError: distance must be an integer

Both arguments are required:

    >>> bg.integer_validator("age")
    Traceback (most recent call last):
    TypeError: BaseGeometry.integer_validator() missing 1 required positional argument: 'value'

    >>> bg.integer_validator()
    Traceback (most recent call last):
    TypeError: BaseGeometry.integer_validator() missing 2 required positional arguments: 'name' and 'value'
EOF

# ------------------------------------------------------------- 8. Rectangle
cat > 8-rectangle.py <<'EOF'
#!/usr/bin/python3
"""Module that defines the Rectangle class."""
BaseGeometry = __import__('7-base_geometry').BaseGeometry


class Rectangle(BaseGeometry):
    """A rectangle defined by a width and a height."""

    def __init__(self, width, height):
        """Initialize a new Rectangle.

        Args:
            width (int): the width, must be a positive integer.
            height (int): the height, must be a positive integer.
        """
        self.integer_validator("width", width)
        self.integer_validator("height", height)
        self.__width = width
        self.__height = height
EOF

# -------------------------------------------------------- 9. Full rectangle
cat > 9-rectangle.py <<'EOF'
#!/usr/bin/python3
"""Module that defines the Rectangle class."""
BaseGeometry = __import__('7-base_geometry').BaseGeometry


class Rectangle(BaseGeometry):
    """A rectangle defined by a width and a height."""

    def __init__(self, width, height):
        """Initialize a new Rectangle.

        Args:
            width (int): the width, must be a positive integer.
            height (int): the height, must be a positive integer.
        """
        self.integer_validator("width", width)
        self.integer_validator("height", height)
        self.__width = width
        self.__height = height

    def area(self):
        """Return the area of the rectangle."""
        return self.__width * self.__height

    def __str__(self):
        """Return the rectangle description: [Rectangle] <width>/<height>."""
        return "[Rectangle] {}/{}".format(self.__width, self.__height)
EOF

# ------------------------------------------------------------- 10. Square #1
cat > 10-square.py <<'EOF'
#!/usr/bin/python3
"""Module that defines the Square class."""
Rectangle = __import__('9-rectangle').Rectangle


class Square(Rectangle):
    """A square, which is a rectangle with equal sides."""

    def __init__(self, size):
        """Initialize a new Square.

        Args:
            size (int): the length of a side, must be a positive integer.
        """
        self.integer_validator("size", size)
        self.__size = size
        super().__init__(size, size)

    def area(self):
        """Return the area of the square."""
        return self.__size * self.__size
EOF

# ------------------------------------------------------------- 11. Square #2
cat > 11-square.py <<'EOF'
#!/usr/bin/python3
"""Module that defines the Square class."""
Rectangle = __import__('9-rectangle').Rectangle


class Square(Rectangle):
    """A square, which is a rectangle with equal sides."""

    def __init__(self, size):
        """Initialize a new Square.

        Args:
            size (int): the length of a side, must be a positive integer.
        """
        self.integer_validator("size", size)
        self.__size = size
        super().__init__(size, size)

    def area(self):
        """Return the area of the square."""
        return self.__size * self.__size

    def __str__(self):
        """Return the square description: [Square] <width>/<height>."""
        return "[Square] {}/{}".format(self.__size, self.__size)
EOF

# ----------------------------------------------------------------- README
cat > README.md <<'EOF'
# Python - Inheritance

Classes, subclasses, `super()`, attribute lookup, and the difference between
`type()`, `isinstance()` and strict subclass checks.
EOF

chmod u+x ./*.py

echo "Done. Files created in $(pwd):"
ls -1
ls -1 tests
