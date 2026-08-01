#!/bin/bash
# Creates every file for the "python-almost_a_circle" project.
# Run this from the ROOT of your alu-higher_level_programming repo.

set -e

DIR="python-almost_a_circle"
mkdir -p "$DIR/models" "$DIR/tests/test_models"
cd "$DIR"

# =========================================================== models/__init__.py
: > models/__init__.py

# ================================================================ models/base.py
cat > models/base.py <<'EOF'
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
EOF

# =========================================================== models/rectangle.py
cat > models/rectangle.py <<'EOF'
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
EOF

# ============================================================== models/square.py
cat > models/square.py <<'EOF'
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
EOF

# ==================================================================== tests
: > tests/__init__.py
: > tests/test_models/__init__.py

cat > tests/test_models/test_base.py <<'EOF'
#!/usr/bin/python3
"""Unit tests for the Base class."""
import unittest
import os
import json
from models.base import Base
from models.rectangle import Rectangle
from models.square import Square


class TestBaseInstantiation(unittest.TestCase):
    """Test how Base assigns the id attribute."""

    def test_id_is_incremented(self):
        """Consecutive instances receive consecutive ids."""
        b1 = Base()
        b2 = Base()
        self.assertEqual(b2.id, b1.id + 1)

    def test_given_id_is_used(self):
        """An explicit id is stored as is."""
        self.assertEqual(Base(12).id, 12)

    def test_given_id_does_not_increment(self):
        """An explicit id does not consume an automatic id."""
        b1 = Base()
        Base(89)
        b2 = Base()
        self.assertEqual(b2.id, b1.id + 1)

    def test_none_id_increments(self):
        """Passing None explicitly behaves like passing nothing."""
        b1 = Base(None)
        b2 = Base(None)
        self.assertEqual(b2.id, b1.id + 1)

    def test_negative_id(self):
        """A negative id is accepted without validation."""
        self.assertEqual(Base(-5).id, -5)

    def test_string_id(self):
        """The id is not type checked."""
        self.assertEqual(Base("hello").id, "hello")

    def test_nb_objects_is_private(self):
        """The counter is a private class attribute."""
        with self.assertRaises(AttributeError):
            print(Base.nb_objects)

    def test_two_args(self):
        """The constructor accepts at most one argument."""
        with self.assertRaises(TypeError):
            Base(1, 2)


class TestBaseToJsonString(unittest.TestCase):
    """Test the to_json_string static method."""

    def test_none_returns_empty_list_string(self):
        """None serializes to the string of an empty list."""
        self.assertEqual(Base.to_json_string(None), "[]")

    def test_empty_list_returns_empty_list_string(self):
        """An empty list serializes to the string of an empty list."""
        self.assertEqual(Base.to_json_string([]), "[]")

    def test_return_type_is_string(self):
        """The result is always a string."""
        self.assertIs(type(Base.to_json_string([{'id': 1}])), str)

    def test_one_dictionary(self):
        """A single dictionary round trips through json."""
        d = {'id': 9, 'width': 5, 'height': 3, 'x': 1, 'y': 2}
        self.assertEqual(json.loads(Base.to_json_string([d])), [d])

    def test_two_dictionaries(self):
        """Several dictionaries are preserved in order."""
        d1 = {'id': 1}
        d2 = {'id': 2}
        self.assertEqual(json.loads(Base.to_json_string([d1, d2])), [d1, d2])

    def test_no_argument(self):
        """The method requires its argument."""
        with self.assertRaises(TypeError):
            Base.to_json_string()


class TestBaseFromJsonString(unittest.TestCase):
    """Test the from_json_string static method."""

    def test_none_returns_empty_list(self):
        """None deserializes to an empty list."""
        self.assertEqual(Base.from_json_string(None), [])

    def test_empty_string_returns_empty_list(self):
        """An empty string deserializes to an empty list."""
        self.assertEqual(Base.from_json_string(""), [])

    def test_return_type_is_list(self):
        """The result is always a list."""
        self.assertIs(type(Base.from_json_string('[{"id": 1}]')), list)

    def test_one_dictionary(self):
        """A single dictionary is restored."""
        s = '[{"id": 89, "width": 10, "height": 4}]'
        self.assertEqual(Base.from_json_string(s),
                         [{'id': 89, 'width': 10, 'height': 4}])

    def test_two_dictionaries(self):
        """Several dictionaries are restored in order."""
        s = '[{"id": 1}, {"id": 2}]'
        self.assertEqual(Base.from_json_string(s), [{'id': 1}, {'id': 2}])

    def test_no_argument(self):
        """The method requires its argument."""
        with self.assertRaises(TypeError):
            Base.from_json_string()


class TestBaseSaveToFile(unittest.TestCase):
    """Test the save_to_file class method."""

    def tearDown(self):
        """Remove any JSON file created by a test."""
        for name in ("Rectangle.json", "Square.json", "Base.json"):
            try:
                os.remove(name)
            except FileNotFoundError:
                pass

    def test_none_writes_empty_list(self):
        """None is stored as an empty list."""
        Rectangle.save_to_file(None)
        with open("Rectangle.json", "r") as f:
            self.assertEqual(f.read(), "[]")

    def test_empty_list_writes_empty_list(self):
        """An empty list is stored as an empty list."""
        Square.save_to_file([])
        with open("Square.json", "r") as f:
            self.assertEqual(f.read(), "[]")

    def test_filename_matches_class(self):
        """The file is named after the class."""
        Square.save_to_file([Square(1)])
        self.assertTrue(os.path.exists("Square.json"))

    def test_one_rectangle(self):
        """A rectangle is stored with all of its attributes."""
        r = Rectangle(10, 7, 2, 8, 1)
        Rectangle.save_to_file([r])
        with open("Rectangle.json", "r") as f:
            self.assertEqual(json.loads(f.read()), [r.to_dictionary()])

    def test_two_rectangles(self):
        """Several instances are stored in order."""
        r1 = Rectangle(10, 7, 2, 8, 1)
        r2 = Rectangle(2, 4, 0, 0, 2)
        Rectangle.save_to_file([r1, r2])
        with open("Rectangle.json", "r") as f:
            self.assertEqual(json.loads(f.read()),
                             [r1.to_dictionary(), r2.to_dictionary()])

    def test_overwrites_existing_file(self):
        """A second save replaces the previous content."""
        Rectangle.save_to_file([Rectangle(10, 7, 2, 8, 1)])
        Rectangle.save_to_file([Rectangle(1, 1, 0, 0, 2)])
        with open("Rectangle.json", "r") as f:
            self.assertEqual(len(json.loads(f.read())), 1)

    def test_no_argument(self):
        """The method requires its argument."""
        with self.assertRaises(TypeError):
            Rectangle.save_to_file()


class TestBaseCreate(unittest.TestCase):
    """Test the create class method."""

    def test_rectangle_is_created(self):
        """A rectangle is rebuilt from its dictionary."""
        r1 = Rectangle(3, 5, 1, 0, 7)
        r2 = Rectangle.create(**r1.to_dictionary())
        self.assertEqual(str(r1), str(r2))

    def test_rectangle_is_a_new_object(self):
        """The created instance is not the original one."""
        r1 = Rectangle(3, 5, 1, 0, 7)
        r2 = Rectangle.create(**r1.to_dictionary())
        self.assertIsNot(r1, r2)

    def test_rectangle_is_not_equal(self):
        """Instances are compared by identity, not by value."""
        r1 = Rectangle(3, 5, 1, 0, 7)
        r2 = Rectangle.create(**r1.to_dictionary())
        self.assertNotEqual(r1, r2)

    def test_square_is_created(self):
        """A square is rebuilt from its dictionary."""
        s1 = Square(5, 2, 1, 9)
        s2 = Square.create(**s1.to_dictionary())
        self.assertEqual(str(s1), str(s2))

    def test_created_type(self):
        """The instance type follows the calling class."""
        self.assertIs(type(Square.create(**{'id': 1, 'size': 3})), Square)


class TestBaseLoadFromFile(unittest.TestCase):
    """Test the load_from_file class method."""

    def tearDown(self):
        """Remove any JSON file created by a test."""
        for name in ("Rectangle.json", "Square.json"):
            try:
                os.remove(name)
            except FileNotFoundError:
                pass

    def test_missing_file_returns_empty_list(self):
        """A missing file yields an empty list."""
        try:
            os.remove("Rectangle.json")
        except FileNotFoundError:
            pass
        self.assertEqual(Rectangle.load_from_file(), [])

    def test_return_type_is_list(self):
        """The result is always a list."""
        Rectangle.save_to_file([Rectangle(1, 1)])
        self.assertIs(type(Rectangle.load_from_file()), list)

    def test_rectangles_are_restored(self):
        """Rectangles keep their string representation."""
        r1 = Rectangle(10, 7, 2, 8, 1)
        r2 = Rectangle(2, 4, 0, 0, 2)
        Rectangle.save_to_file([r1, r2])
        out = Rectangle.load_from_file()
        self.assertEqual([str(r1), str(r2)], [str(o) for o in out])

    def test_loaded_instances_are_rectangles(self):
        """The instance type follows the calling class."""
        Rectangle.save_to_file([Rectangle(1, 1)])
        self.assertIs(type(Rectangle.load_from_file()[0]), Rectangle)

    def test_squares_are_restored(self):
        """Squares keep their string representation."""
        s1 = Square(5, 0, 0, 1)
        s2 = Square(7, 9, 1, 2)
        Square.save_to_file([s1, s2])
        out = Square.load_from_file()
        self.assertEqual([str(s1), str(s2)], [str(o) for o in out])

    def test_loaded_instances_are_new_objects(self):
        """Loading produces fresh instances."""
        r = Rectangle(1, 1)
        Rectangle.save_to_file([r])
        self.assertIsNot(Rectangle.load_from_file()[0], r)


if __name__ == "__main__":
    unittest.main()
EOF

cat > tests/test_models/test_rectangle.py <<'EOF'
#!/usr/bin/python3
"""Unit tests for the Rectangle class."""
import unittest
import io
import sys
from models.base import Base
from models.rectangle import Rectangle


class TestRectangleInstantiation(unittest.TestCase):
    """Test how a Rectangle is built."""

    def test_is_a_base(self):
        """Rectangle inherits from Base."""
        self.assertIsInstance(Rectangle(1, 1), Base)

    def test_two_arguments(self):
        """Width and height are enough to build a rectangle."""
        r = Rectangle(10, 2)
        self.assertEqual((r.width, r.height, r.x, r.y), (10, 2, 0, 0))

    def test_three_arguments(self):
        """The third argument is x."""
        self.assertEqual(Rectangle(10, 2, 3).x, 3)

    def test_four_arguments(self):
        """The fourth argument is y."""
        self.assertEqual(Rectangle(10, 2, 3, 4).y, 4)

    def test_five_arguments(self):
        """The fifth argument is the id."""
        self.assertEqual(Rectangle(10, 2, 3, 4, 89).id, 89)

    def test_id_is_incremented(self):
        """Rectangles share the Base counter."""
        r1 = Rectangle(1, 1)
        r2 = Rectangle(1, 1)
        self.assertEqual(r2.id, r1.id + 1)

    def test_no_arguments(self):
        """Width and height are mandatory."""
        with self.assertRaises(TypeError):
            Rectangle()

    def test_one_argument(self):
        """Height is mandatory."""
        with self.assertRaises(TypeError):
            Rectangle(1)

    def test_width_is_private(self):
        """The width attribute is name mangled."""
        with self.assertRaises(AttributeError):
            print(Rectangle(1, 1).__width)

    def test_height_is_private(self):
        """The height attribute is name mangled."""
        with self.assertRaises(AttributeError):
            print(Rectangle(1, 1).__height)


class TestRectangleWidth(unittest.TestCase):
    """Test the validation of the width attribute."""

    def test_string_width(self):
        """A string width is rejected."""
        with self.assertRaisesRegex(TypeError, "width must be an integer"):
            Rectangle("1", 2)

    def test_float_width(self):
        """A float width is rejected."""
        with self.assertRaisesRegex(TypeError, "width must be an integer"):
            Rectangle(1.5, 2)

    def test_none_width(self):
        """A None width is rejected."""
        with self.assertRaisesRegex(TypeError, "width must be an integer"):
            Rectangle(None, 2)

    def test_list_width(self):
        """A list width is rejected."""
        with self.assertRaisesRegex(TypeError, "width must be an integer"):
            Rectangle([1], 2)

    def test_dict_width(self):
        """A dictionary width is rejected."""
        with self.assertRaisesRegex(TypeError, "width must be an integer"):
            Rectangle({}, 2)

    def test_zero_width(self):
        """A zero width is rejected."""
        with self.assertRaisesRegex(ValueError, "width must be > 0"):
            Rectangle(0, 2)

    def test_negative_width(self):
        """A negative width is rejected."""
        with self.assertRaisesRegex(ValueError, "width must be > 0"):
            Rectangle(-10, 2)

    def test_setter_validates(self):
        """The setter applies the same rules as the constructor."""
        r = Rectangle(10, 2)
        with self.assertRaisesRegex(ValueError, "width must be > 0"):
            r.width = -10

    def test_getter(self):
        """The getter returns the stored value."""
        self.assertEqual(Rectangle(10, 2).width, 10)


class TestRectangleHeight(unittest.TestCase):
    """Test the validation of the height attribute."""

    def test_string_height(self):
        """A string height is rejected."""
        with self.assertRaisesRegex(TypeError, "height must be an integer"):
            Rectangle(10, "2")

    def test_float_height(self):
        """A float height is rejected."""
        with self.assertRaisesRegex(TypeError, "height must be an integer"):
            Rectangle(10, 2.5)

    def test_none_height(self):
        """A None height is rejected."""
        with self.assertRaisesRegex(TypeError, "height must be an integer"):
            Rectangle(10, None)

    def test_zero_height(self):
        """A zero height is rejected."""
        with self.assertRaisesRegex(ValueError, "height must be > 0"):
            Rectangle(10, 0)

    def test_negative_height(self):
        """A negative height is rejected."""
        with self.assertRaisesRegex(ValueError, "height must be > 0"):
            Rectangle(10, -2)

    def test_setter_validates(self):
        """The setter applies the same rules as the constructor."""
        r = Rectangle(10, 2)
        with self.assertRaisesRegex(TypeError, "height must be an integer"):
            r.height = "9"

    def test_getter(self):
        """The getter returns the stored value."""
        self.assertEqual(Rectangle(10, 2).height, 2)


class TestRectangleX(unittest.TestCase):
    """Test the validation of the x attribute."""

    def test_string_x(self):
        """A string x is rejected."""
        with self.assertRaisesRegex(TypeError, "x must be an integer"):
            Rectangle(10, 2, "3")

    def test_dict_x(self):
        """A dictionary x is rejected."""
        with self.assertRaisesRegex(TypeError, "x must be an integer"):
            Rectangle(10, 2, {})

    def test_none_x(self):
        """A None x is rejected."""
        with self.assertRaisesRegex(TypeError, "x must be an integer"):
            Rectangle(10, 2, None)

    def test_negative_x(self):
        """A negative x is rejected."""
        with self.assertRaisesRegex(ValueError, "x must be >= 0"):
            Rectangle(10, 2, -3)

    def test_zero_x_is_valid(self):
        """A zero x is accepted."""
        self.assertEqual(Rectangle(10, 2, 0).x, 0)

    def test_setter_validates(self):
        """The setter applies the same rules as the constructor."""
        r = Rectangle(10, 2)
        with self.assertRaisesRegex(TypeError, "x must be an integer"):
            r.x = {}


class TestRectangleY(unittest.TestCase):
    """Test the validation of the y attribute."""

    def test_string_y(self):
        """A string y is rejected."""
        with self.assertRaisesRegex(TypeError, "y must be an integer"):
            Rectangle(10, 2, 3, "4")

    def test_none_y(self):
        """A None y is rejected."""
        with self.assertRaisesRegex(TypeError, "y must be an integer"):
            Rectangle(10, 2, 3, None)

    def test_negative_y(self):
        """A negative y is rejected."""
        with self.assertRaisesRegex(ValueError, "y must be >= 0"):
            Rectangle(10, 2, 3, -1)

    def test_zero_y_is_valid(self):
        """A zero y is accepted."""
        self.assertEqual(Rectangle(10, 2, 3, 0).y, 0)

    def test_setter_validates(self):
        """The setter applies the same rules as the constructor."""
        r = Rectangle(10, 2)
        with self.assertRaisesRegex(ValueError, "y must be >= 0"):
            r.y = -5


class TestRectangleArea(unittest.TestCase):
    """Test the area method."""

    def test_small_area(self):
        """The area is the product of width and height."""
        self.assertEqual(Rectangle(3, 2).area(), 6)

    def test_another_area(self):
        """The area works for other sizes."""
        self.assertEqual(Rectangle(2, 10).area(), 20)

    def test_area_with_offsets(self):
        """The offsets do not change the area."""
        self.assertEqual(Rectangle(8, 7, 0, 0, 12).area(), 56)

    def test_area_after_update(self):
        """The area follows the current attributes."""
        r = Rectangle(2, 10)
        r.width = 7
        self.assertEqual(r.area(), 70)

    def test_area_takes_no_argument(self):
        """The method takes no argument besides self."""
        with self.assertRaises(TypeError):
            Rectangle(1, 1).area(1)


class TestRectangleDisplay(unittest.TestCase):
    """Test the display method."""

    def capture(self, rectangle):
        """Return what display writes to stdout."""
        buffer = io.StringIO()
        sys.stdout = buffer
        rectangle.display()
        sys.stdout = sys.__stdout__
        return buffer.getvalue()

    def test_simple_rectangle(self):
        """A rectangle without offsets prints as a block."""
        self.assertEqual(self.capture(Rectangle(2, 2)), "##\n##\n")

    def test_one_by_one(self):
        """The smallest rectangle prints one character."""
        self.assertEqual(self.capture(Rectangle(1, 1)), "#\n")

    def test_wide_rectangle(self):
        """Each row is as wide as the width."""
        self.assertEqual(self.capture(Rectangle(4, 1)), "####\n")

    def test_x_offset(self):
        """The x offset indents every row."""
        self.assertEqual(self.capture(Rectangle(3, 2, 1, 0)),
                         " ###\n ###\n")

    def test_y_offset(self):
        """The y offset adds blank lines above the shape."""
        self.assertEqual(self.capture(Rectangle(2, 1, 0, 2)), "\n\n##\n")

    def test_both_offsets(self):
        """Both offsets are applied together."""
        self.assertEqual(self.capture(Rectangle(2, 3, 2, 2)),
                         "\n\n  ##\n  ##\n  ##\n")


class TestRectangleStr(unittest.TestCase):
    """Test the string representation."""

    def test_full_format(self):
        """All attributes appear in the expected order."""
        r = Rectangle(4, 6, 2, 1, 12)
        self.assertEqual(str(r), "[Rectangle] (12) 2/1 - 4/6")

    def test_default_offsets(self):
        """Default offsets are shown as zeros."""
        r = Rectangle(5, 5, 1, 0, 7)
        self.assertEqual(str(r), "[Rectangle] (7) 1/0 - 5/5")

    def test_str_after_update(self):
        """The representation follows the current attributes."""
        r = Rectangle(4, 6, 2, 1, 12)
        r.width = 9
        self.assertEqual(str(r), "[Rectangle] (12) 2/1 - 9/6")


class TestRectangleUpdateArgs(unittest.TestCase):
    """Test update with no-keyword arguments."""

    def test_no_arguments_changes_nothing(self):
        """Calling update without arguments is a no-op."""
        r = Rectangle(10, 10, 10, 10, 1)
        r.update()
        self.assertEqual(str(r), "[Rectangle] (1) 10/10 - 10/10")

    def test_id_only(self):
        """The first argument is the id."""
        r = Rectangle(10, 10, 10, 10, 1)
        r.update(89)
        self.assertEqual(str(r), "[Rectangle] (89) 10/10 - 10/10")

    def test_id_and_width(self):
        """The second argument is the width."""
        r = Rectangle(10, 10, 10, 10, 1)
        r.update(89, 2)
        self.assertEqual(str(r), "[Rectangle] (89) 10/10 - 2/10")

    def test_up_to_height(self):
        """The third argument is the height."""
        r = Rectangle(10, 10, 10, 10, 1)
        r.update(89, 2, 3)
        self.assertEqual(str(r), "[Rectangle] (89) 10/10 - 2/3")

    def test_up_to_x(self):
        """The fourth argument is x."""
        r = Rectangle(10, 10, 10, 10, 1)
        r.update(89, 2, 3, 4)
        self.assertEqual(str(r), "[Rectangle] (89) 4/10 - 2/3")

    def test_all_arguments(self):
        """The fifth argument is y."""
        r = Rectangle(10, 10, 10, 10, 1)
        r.update(89, 2, 3, 4, 5)
        self.assertEqual(str(r), "[Rectangle] (89) 4/5 - 2/3")

    def test_extra_arguments_ignored(self):
        """Arguments beyond the fifth are ignored."""
        r = Rectangle(10, 10, 10, 10, 1)
        r.update(89, 2, 3, 4, 5, 6)
        self.assertEqual(str(r), "[Rectangle] (89) 4/5 - 2/3")

    def test_validation_still_applies(self):
        """Values passed to update are validated."""
        r = Rectangle(10, 10, 10, 10, 1)
        with self.assertRaisesRegex(ValueError, "width must be > 0"):
            r.update(89, -2)


class TestRectangleUpdateKwargs(unittest.TestCase):
    """Test update with keyworded arguments."""

    def test_single_keyword(self):
        """One keyword changes one attribute."""
        r = Rectangle(10, 10, 10, 10, 1)
        r.update(height=1)
        self.assertEqual(str(r), "[Rectangle] (1) 10/10 - 10/1")

    def test_two_keywords(self):
        """Several keywords are all applied."""
        r = Rectangle(10, 10, 10, 10, 1)
        r.update(width=1, x=2)
        self.assertEqual(str(r), "[Rectangle] (1) 2/10 - 1/10")

    def test_order_does_not_matter(self):
        """Keyword order has no effect on the result."""
        r = Rectangle(10, 10, 10, 10, 1)
        r.update(y=1, width=2, x=3, id=89)
        self.assertEqual(str(r), "[Rectangle] (89) 3/1 - 2/10")

    def test_args_win_over_kwargs(self):
        """Keywords are skipped when args is not empty."""
        r = Rectangle(10, 10, 10, 10, 1)
        r.update(89, 2, height=99)
        self.assertEqual(str(r), "[Rectangle] (89) 10/10 - 2/10")

    def test_unknown_keyword_is_set(self):
        """An unknown key simply becomes a new attribute."""
        r = Rectangle(10, 10, 10, 10, 1)
        r.update(colour="red")
        self.assertEqual(r.colour, "red")

    def test_validation_still_applies(self):
        """Values passed as keywords are validated."""
        r = Rectangle(10, 10, 10, 10, 1)
        with self.assertRaisesRegex(TypeError, "height must be an integer"):
            r.update(height="9")


class TestRectangleToDictionary(unittest.TestCase):
    """Test the to_dictionary method."""

    def test_return_type(self):
        """The result is a dictionary."""
        self.assertIs(type(Rectangle(10, 2, 1, 9).to_dictionary()), dict)

    def test_keys(self):
        """All five attributes are present."""
        d = Rectangle(10, 2, 1, 9, 1).to_dictionary()
        self.assertEqual(sorted(d.keys()),
                         ['height', 'id', 'width', 'x', 'y'])

    def test_values(self):
        """The values match the instance."""
        d = Rectangle(10, 2, 1, 9, 1).to_dictionary()
        self.assertEqual(
            d, {'id': 1, 'width': 10, 'height': 2, 'x': 1, 'y': 9})

    def test_dictionary_feeds_update(self):
        """The dictionary can be splatted into update."""
        r1 = Rectangle(10, 2, 1, 9, 1)
        r2 = Rectangle(1, 1)
        r2.update(**r1.to_dictionary())
        self.assertEqual(str(r1), str(r2))

    def test_instances_stay_distinct(self):
        """Copying the values does not merge the objects."""
        r1 = Rectangle(10, 2, 1, 9, 1)
        r2 = Rectangle(1, 1)
        r2.update(**r1.to_dictionary())
        self.assertIsNot(r1, r2)

    def test_takes_no_argument(self):
        """The method takes no argument besides self."""
        with self.assertRaises(TypeError):
            Rectangle(1, 1).to_dictionary(1)


if __name__ == "__main__":
    unittest.main()
EOF

cat > tests/test_models/test_square.py <<'EOF'
#!/usr/bin/python3
"""Unit tests for the Square class."""
import unittest
import io
import sys
from models.base import Base
from models.rectangle import Rectangle
from models.square import Square


class TestSquareInstantiation(unittest.TestCase):
    """Test how a Square is built."""

    def test_is_a_rectangle(self):
        """Square inherits from Rectangle."""
        self.assertIsInstance(Square(1), Rectangle)

    def test_is_a_base(self):
        """Square inherits from Base through Rectangle."""
        self.assertIsInstance(Square(1), Base)

    def test_size_sets_both_sides(self):
        """Width and height both take the size value."""
        s = Square(5)
        self.assertEqual((s.width, s.height), (5, 5))

    def test_default_offsets(self):
        """The offsets default to zero."""
        s = Square(5)
        self.assertEqual((s.x, s.y), (0, 0))

    def test_two_arguments(self):
        """The second argument is x."""
        self.assertEqual(Square(2, 2).x, 2)

    def test_three_arguments(self):
        """The third argument is y."""
        self.assertEqual(Square(3, 1, 3).y, 3)

    def test_four_arguments(self):
        """The fourth argument is the id."""
        self.assertEqual(Square(3, 1, 3, 89).id, 89)

    def test_id_is_incremented(self):
        """Squares share the Base counter."""
        s1 = Square(1)
        s2 = Square(1)
        self.assertEqual(s2.id, s1.id + 1)

    def test_no_arguments(self):
        """The size is mandatory."""
        with self.assertRaises(TypeError):
            Square()

    def test_no_new_attributes(self):
        """A square stores nothing beyond the rectangle attributes."""
        self.assertEqual(
            sorted(Square(1).__dict__.keys()),
            ['_Rectangle__height', '_Rectangle__width',
             '_Rectangle__x', '_Rectangle__y', 'id'])


class TestSquareSize(unittest.TestCase):
    """Test the size property."""

    def test_getter(self):
        """The getter returns the side length."""
        self.assertEqual(Square(5).size, 5)

    def test_setter_changes_both_sides(self):
        """Setting the size updates width and height."""
        s = Square(5)
        s.size = 10
        self.assertEqual((s.width, s.height), (10, 10))

    def test_setter_string(self):
        """A string size is rejected with the width message."""
        s = Square(5)
        with self.assertRaisesRegex(TypeError, "width must be an integer"):
            s.size = "9"

    def test_setter_float(self):
        """A float size is rejected with the width message."""
        s = Square(5)
        with self.assertRaisesRegex(TypeError, "width must be an integer"):
            s.size = 5.5

    def test_setter_zero(self):
        """A zero size is rejected with the width message."""
        s = Square(5)
        with self.assertRaisesRegex(ValueError, "width must be > 0"):
            s.size = 0

    def test_setter_negative(self):
        """A negative size is rejected with the width message."""
        s = Square(5)
        with self.assertRaisesRegex(ValueError, "width must be > 0"):
            s.size = -3

    def test_constructor_validates(self):
        """The constructor uses the same validation."""
        with self.assertRaisesRegex(TypeError, "width must be an integer"):
            Square("5")

    def test_negative_x(self):
        """The x validation is inherited unchanged."""
        with self.assertRaisesRegex(ValueError, "x must be >= 0"):
            Square(5, -1)

    def test_negative_y(self):
        """The y validation is inherited unchanged."""
        with self.assertRaisesRegex(ValueError, "y must be >= 0"):
            Square(5, 1, -1)


class TestSquareArea(unittest.TestCase):
    """Test the inherited area method."""

    def test_area(self):
        """The area is the square of the size."""
        self.assertEqual(Square(5).area(), 25)

    def test_small_area(self):
        """The area works for small squares."""
        self.assertEqual(Square(2, 2).area(), 4)

    def test_area_after_resize(self):
        """The area follows the current size."""
        s = Square(3)
        s.size = 9
        self.assertEqual(s.area(), 81)


class TestSquareDisplay(unittest.TestCase):
    """Test the inherited display method."""

    def capture(self, square):
        """Return what display writes to stdout."""
        buffer = io.StringIO()
        sys.stdout = buffer
        square.display()
        sys.stdout = sys.__stdout__
        return buffer.getvalue()

    def test_simple_square(self):
        """A square without offsets prints as a block."""
        self.assertEqual(self.capture(Square(2)), "##\n##\n")

    def test_x_offset(self):
        """The x offset indents every row."""
        self.assertEqual(self.capture(Square(2, 2)), "  ##\n  ##\n")

    def test_both_offsets(self):
        """Both offsets are applied together."""
        self.assertEqual(self.capture(Square(3, 1, 3)),
                         "\n\n\n ###\n ###\n ###\n")


class TestSquareStr(unittest.TestCase):
    """Test the string representation."""

    def test_format(self):
        """The size is shown once, not as width and height."""
        self.assertEqual(str(Square(5, 0, 0, 1)), "[Square] (1) 0/0 - 5")

    def test_with_offsets(self):
        """The offsets appear before the size."""
        self.assertEqual(str(Square(2, 2, 0, 2)), "[Square] (2) 2/0 - 2")

    def test_after_resize(self):
        """The representation follows the current size."""
        s = Square(5, 0, 0, 1)
        s.size = 10
        self.assertEqual(str(s), "[Square] (1) 0/0 - 10")


class TestSquareUpdateArgs(unittest.TestCase):
    """Test update with no-keyword arguments."""

    def test_no_arguments_changes_nothing(self):
        """Calling update without arguments is a no-op."""
        s = Square(5, 0, 0, 1)
        s.update()
        self.assertEqual(str(s), "[Square] (1) 0/0 - 5")

    def test_id_only(self):
        """The first argument is the id."""
        s = Square(5, 0, 0, 1)
        s.update(10)
        self.assertEqual(str(s), "[Square] (10) 0/0 - 5")

    def test_id_and_size(self):
        """The second argument is the size."""
        s = Square(5, 0, 0, 1)
        s.update(1, 2)
        self.assertEqual(str(s), "[Square] (1) 0/0 - 2")

    def test_up_to_x(self):
        """The third argument is x."""
        s = Square(5, 0, 0, 1)
        s.update(1, 2, 3)
        self.assertEqual(str(s), "[Square] (1) 3/0 - 2")

    def test_all_arguments(self):
        """The fourth argument is y."""
        s = Square(5, 0, 0, 1)
        s.update(1, 2, 3, 4)
        self.assertEqual(str(s), "[Square] (1) 3/4 - 2")

    def test_extra_arguments_ignored(self):
        """Arguments beyond the fourth are ignored."""
        s = Square(5, 0, 0, 1)
        s.update(1, 2, 3, 4, 5)
        self.assertEqual(str(s), "[Square] (1) 3/4 - 2")

    def test_validation_still_applies(self):
        """Values passed to update are validated."""
        s = Square(5, 0, 0, 1)
        with self.assertRaisesRegex(ValueError, "width must be > 0"):
            s.update(1, 0)


class TestSquareUpdateKwargs(unittest.TestCase):
    """Test update with keyworded arguments."""

    def test_single_keyword(self):
        """One keyword changes one attribute."""
        s = Square(5, 0, 0, 1)
        s.update(x=12)
        self.assertEqual(str(s), "[Square] (1) 12/0 - 5")

    def test_two_keywords(self):
        """Several keywords are all applied."""
        s = Square(5, 0, 0, 1)
        s.update(size=7, y=1)
        self.assertEqual(str(s), "[Square] (1) 0/1 - 7")

    def test_three_keywords(self):
        """The id can be changed by keyword too."""
        s = Square(5, 0, 0, 1)
        s.update(size=7, id=89, y=1)
        self.assertEqual(str(s), "[Square] (89) 0/1 - 7")

    def test_args_win_over_kwargs(self):
        """Keywords are skipped when args is not empty."""
        s = Square(5, 0, 0, 1)
        s.update(89, size=99)
        self.assertEqual(str(s), "[Square] (89) 0/0 - 5")

    def test_validation_still_applies(self):
        """Values passed as keywords are validated."""
        s = Square(5, 0, 0, 1)
        with self.assertRaisesRegex(TypeError, "width must be an integer"):
            s.update(size="9")


class TestSquareToDictionary(unittest.TestCase):
    """Test the to_dictionary method."""

    def test_return_type(self):
        """The result is a dictionary."""
        self.assertIs(type(Square(10, 2, 1).to_dictionary()), dict)

    def test_keys(self):
        """The four expected keys are present."""
        d = Square(10, 2, 1, 1).to_dictionary()
        self.assertEqual(sorted(d.keys()), ['id', 'size', 'x', 'y'])

    def test_values(self):
        """The values match the instance."""
        d = Square(10, 2, 1, 1).to_dictionary()
        self.assertEqual(d, {'id': 1, 'size': 10, 'x': 2, 'y': 1})

    def test_no_width_or_height(self):
        """Width and height are not exposed, only size."""
        d = Square(10, 2, 1, 1).to_dictionary()
        self.assertNotIn('width', d)

    def test_dictionary_feeds_update(self):
        """The dictionary can be splatted into update."""
        s1 = Square(10, 2, 1, 1)
        s2 = Square(1, 1)
        s2.update(**s1.to_dictionary())
        self.assertEqual(str(s1), str(s2))

    def test_instances_stay_distinct(self):
        """Copying the values does not merge the objects."""
        s1 = Square(10, 2, 1, 1)
        s2 = Square(1, 1)
        s2.update(**s1.to_dictionary())
        self.assertIsNot(s1, s2)


if __name__ == "__main__":
    unittest.main()
EOF

# ---------------------------------------------------------------------- README
cat > README.md <<'EOF'
# Python - Almost a circle

A `Base` class that manages ids and JSON serialization, a `Rectangle` class
with validated private attributes, and a `Square` class built on top of it.
The whole package is covered by unit tests in `tests/`.

Run the test suite with:

```
python3 -m unittest discover tests
```
EOF

chmod u+x models/*.py tests/test_models/*.py

echo "Done. Files created in $(pwd):"
find . -type f | sort
