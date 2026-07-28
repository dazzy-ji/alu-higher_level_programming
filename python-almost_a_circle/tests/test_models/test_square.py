#!/usr/bin/python3
"""Unit tests for the Square class."""
import unittest
import io
import sys
import os
import json
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


class TestSquareConstructorValidation(unittest.TestCase):
    """Test validation performed by the Square constructor itself."""

    def test_size_zero(self):
        """A size of zero is rejected."""
        with self.assertRaisesRegex(ValueError, "width must be > 0"):
            Square(0)

    def test_size_negative(self):
        """A negative size is rejected."""
        with self.assertRaisesRegex(ValueError, "width must be > 0"):
            Square(-1)

    def test_size_negative_large(self):
        """Any negative size is rejected."""
        with self.assertRaisesRegex(ValueError, "width must be > 0"):
            Square(-89)

    def test_size_string(self):
        """A string size is rejected."""
        with self.assertRaisesRegex(TypeError, "width must be an integer"):
            Square("1")

    def test_size_float(self):
        """A float size is rejected."""
        with self.assertRaisesRegex(TypeError, "width must be an integer"):
            Square(1.5)

    def test_size_none(self):
        """A None size is rejected."""
        with self.assertRaisesRegex(TypeError, "width must be an integer"):
            Square(None)

    def test_size_list(self):
        """A list size is rejected."""
        with self.assertRaisesRegex(TypeError, "width must be an integer"):
            Square([1])

    def test_size_dict(self):
        """A dictionary size is rejected."""
        with self.assertRaisesRegex(TypeError, "width must be an integer"):
            Square({})

    def test_x_string(self):
        """A string x is rejected."""
        with self.assertRaisesRegex(TypeError, "x must be an integer"):
            Square(1, "2")

    def test_x_float(self):
        """A float x is rejected."""
        with self.assertRaisesRegex(TypeError, "x must be an integer"):
            Square(1, 2.5)

    def test_x_none(self):
        """A None x is rejected."""
        with self.assertRaisesRegex(TypeError, "x must be an integer"):
            Square(1, None)

    def test_x_list(self):
        """A list x is rejected."""
        with self.assertRaisesRegex(TypeError, "x must be an integer"):
            Square(1, [2])

    def test_x_negative(self):
        """A negative x is rejected."""
        with self.assertRaisesRegex(ValueError, "x must be >= 0"):
            Square(1, -2)

    def test_y_string(self):
        """A string y is rejected."""
        with self.assertRaisesRegex(TypeError, "y must be an integer"):
            Square(1, 2, "3")

    def test_y_float(self):
        """A float y is rejected."""
        with self.assertRaisesRegex(TypeError, "y must be an integer"):
            Square(1, 2, 3.5)

    def test_y_none(self):
        """A None y is rejected."""
        with self.assertRaisesRegex(TypeError, "y must be an integer"):
            Square(1, 2, None)

    def test_y_dict(self):
        """A dictionary y is rejected."""
        with self.assertRaisesRegex(TypeError, "y must be an integer"):
            Square(1, 2, {})

    def test_y_negative(self):
        """A negative y is rejected."""
        with self.assertRaisesRegex(ValueError, "y must be >= 0"):
            Square(1, 2, -3)

    def test_all_valid(self):
        """Four valid arguments build a square."""
        s = Square(1, 2, 3, 4)
        self.assertEqual((s.size, s.x, s.y, s.id), (1, 2, 3, 4))

    def test_size_checked_before_x(self):
        """The size is validated before the offsets."""
        with self.assertRaisesRegex(ValueError, "width must be > 0"):
            Square(-1, -1)


class TestSquareFileMethods(unittest.TestCase):
    """Test the file methods when called on Square."""

    def tearDown(self):
        """Remove the Square JSON file between tests."""
        try:
            os.remove("Square.json")
        except FileNotFoundError:
            pass

    def test_save_to_file_none(self):
        """None is stored as an empty list."""
        Square.save_to_file(None)
        with open("Square.json", "r") as f:
            self.assertEqual(f.read(), "[]")

    def test_save_to_file_none_creates_file(self):
        """None still creates the file."""
        Square.save_to_file(None)
        self.assertTrue(os.path.exists("Square.json"))

    def test_save_to_file_empty_list(self):
        """An empty list is stored as an empty list."""
        Square.save_to_file([])
        with open("Square.json", "r") as f:
            self.assertEqual(f.read(), "[]")

    def test_save_to_file_one_square(self):
        """A square is stored with all of its attributes."""
        s = Square(10, 7, 2, 8)
        Square.save_to_file([s])
        with open("Square.json", "r") as f:
            self.assertEqual(json.loads(f.read()), [s.to_dictionary()])

    def test_save_to_file_two_squares(self):
        """Several squares are stored in order."""
        s1 = Square(10, 7, 2, 8)
        s2 = Square(2, 4, 0, 9)
        Square.save_to_file([s1, s2])
        with open("Square.json", "r") as f:
            self.assertEqual(json.loads(f.read()),
                             [s1.to_dictionary(), s2.to_dictionary()])

    def test_save_to_file_overwrites(self):
        """A second save replaces the previous content."""
        Square.save_to_file([Square(10, 7, 2, 8), Square(1, 0, 0, 9)])
        Square.save_to_file([Square(1, 0, 0, 3)])
        with open("Square.json", "r") as f:
            self.assertEqual(len(json.loads(f.read())), 1)

    def test_save_to_file_filename(self):
        """The file is named after the class."""
        Square.save_to_file([Square(1)])
        self.assertTrue(os.path.exists("Square.json"))

    def test_load_from_file_missing(self):
        """A missing file yields an empty list."""
        try:
            os.remove("Square.json")
        except FileNotFoundError:
            pass
        self.assertEqual(Square.load_from_file(), [])

    def test_load_from_file_after_none(self):
        """Saving None then loading yields an empty list."""
        Square.save_to_file(None)
        self.assertEqual(Square.load_from_file(), [])

    def test_load_from_file_restores(self):
        """Squares keep their string representation."""
        s1 = Square(5, 0, 0, 41)
        s2 = Square(7, 9, 1, 42)
        Square.save_to_file([s1, s2])
        out = Square.load_from_file()
        self.assertEqual([str(s1), str(s2)], [str(o) for o in out])

    def test_load_from_file_type(self):
        """The loaded instances are squares."""
        Square.save_to_file([Square(1)])
        self.assertIs(type(Square.load_from_file()[0]), Square)

    def test_create_square(self):
        """A square is rebuilt from a dictionary."""
        s = Square.create(**{'id': 89, 'size': 1, 'x': 2, 'y': 3})
        self.assertEqual(str(s), "[Square] (89) 2/3 - 1")

    def test_create_returns_new_object(self):
        """The created instance is not the original one."""
        s1 = Square(1, 2, 3, 89)
        s2 = Square.create(**s1.to_dictionary())
        self.assertIsNot(s1, s2)


if __name__ == "__main__":
    unittest.main()
