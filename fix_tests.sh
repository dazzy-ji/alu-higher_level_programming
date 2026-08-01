#!/bin/bash
# Fixes tests/7-base_geometry.txt and tests/1-my_list.txt so the doctests pass
# on ANY Python 3 version. Run from the ROOT of your repo.

set -e
cd python-inheritance

cat > tests/7-base_geometry.txt <<'EOF'
The ``7-base_geometry`` module
==============================

Using ``BaseGeometry``
----------------------

Import the class and create an instance:

    >>> BaseGeometry = __import__('7-base_geometry').BaseGeometry
    >>> bg = BaseGeometry()

Check instantiation
-------------------

    >>> type(bg) is BaseGeometry
    True
    >>> bg.__init__() is None
    True

``area()``
----------

``area()`` always raises an ``Exception``:

    >>> bg.area()
    Traceback (most recent call last):
    Exception: area() is not implemented

It takes no argument besides self:

    >>> bg.area(1)  # doctest: +IGNORE_EXCEPTION_DETAIL
    Traceback (most recent call last):
    TypeError

``integer_validator()`` with no argument
----------------------------------------

Both arguments are required:

    >>> bg.integer_validator()  # doctest: +IGNORE_EXCEPTION_DETAIL
    Traceback (most recent call last):
    TypeError

``integer_validator("age")``
-----------------------------

The value argument is required too:

    >>> bg.integer_validator("age")  # doctest: +IGNORE_EXCEPTION_DETAIL
    Traceback (most recent call last):
    TypeError

``integer_validator("age", 1)``
--------------------------------

A positive integer passes silently and returns ``None``:

    >>> bg.integer_validator("age", 1)
    >>> print(bg.integer_validator("width", 89))
    None

``integer_validator("age", 0)``
--------------------------------

Zero raises a ``ValueError``:

    >>> bg.integer_validator("age", 0)
    Traceback (most recent call last):
    ValueError: age must be greater than 0

``integer_validator("age", -4)``
---------------------------------

Negative integers raise a ``ValueError``:

    >>> bg.integer_validator("age", -4)
    Traceback (most recent call last):
    ValueError: age must be greater than 0

``integer_validator("age", "4")``
----------------------------------

Strings raise a ``TypeError``, even when they look like numbers:

    >>> bg.integer_validator("age", "4")
    Traceback (most recent call last):
    TypeError: age must be an integer

    >>> bg.integer_validator("name", "John")
    Traceback (most recent call last):
    TypeError: name must be an integer

``integer_validator("age", (4,))``
-----------------------------------

Tuples raise a ``TypeError``:

    >>> bg.integer_validator("age", (4,))
    Traceback (most recent call last):
    TypeError: age must be an integer

``integer_validator("age", [3])``
----------------------------------

Lists raise a ``TypeError``:

    >>> bg.integer_validator("age", [3])
    Traceback (most recent call last):
    TypeError: age must be an integer

``integer_validator("age", True)``
-----------------------------------

Booleans are rejected, even though ``bool`` subclasses ``int``:

    >>> bg.integer_validator("age", True)
    Traceback (most recent call last):
    TypeError: age must be an integer

    >>> bg.integer_validator("age", False)
    Traceback (most recent call last):
    TypeError: age must be an integer

``integer_validator("age", {3, 4})``
-------------------------------------

Sets raise a ``TypeError``:

    >>> bg.integer_validator("age", {3, 4})
    Traceback (most recent call last):
    TypeError: age must be an integer

Dictionaries too:

    >>> bg.integer_validator("age", {"key": 1})
    Traceback (most recent call last):
    TypeError: age must be an integer

``integer_validator("age", None)``
-----------------------------------

``None`` raises a ``TypeError``:

    >>> bg.integer_validator("age", None)
    Traceback (most recent call last):
    TypeError: age must be an integer

Floats are rejected as well, even whole ones:

    >>> bg.integer_validator("age", 4.0)
    Traceback (most recent call last):
    TypeError: age must be an integer

The type check runs before the value check:

    >>> bg.integer_validator("age", "-4")
    Traceback (most recent call last):
    TypeError: age must be an integer
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

It returns ``None``:

    >>> print(my_list.print_sorted())
    [1, 2, 3, 4, 5]
    None

It can be built directly from an existing list:

    >>> my_list = MyList([7, 1, 9])
    >>> my_list.print_sorted()
    [1, 7, 9]

It handles negative numbers:

    >>> my_list = MyList([-3, 10, -7, 0])
    >>> my_list.print_sorted()
    [-7, -3, 0, 10]

It handles an already sorted list:

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

    >>> my_list.print_sorted(1)  # doctest: +IGNORE_EXCEPTION_DETAIL
    Traceback (most recent call last):
    TypeError
EOF

echo "Fixed. Verifying..."
python3 -m doctest ./tests/1-my_list.txt && echo "  1-my_list.txt PASS"
python3 -m doctest ./tests/7-base_geometry.txt && echo "  7-base_geometry.txt PASS"
