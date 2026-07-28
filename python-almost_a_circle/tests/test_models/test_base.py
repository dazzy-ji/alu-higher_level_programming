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
