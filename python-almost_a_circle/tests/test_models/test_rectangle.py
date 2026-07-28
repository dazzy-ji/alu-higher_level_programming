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
