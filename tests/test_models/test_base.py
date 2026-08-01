#!/usr/bin/python3
"""
Unittest module for Base class.
"""
import unittest
import os
from models.base import Base
from models.rectangle import Rectangle


class TestBase(unittest.TestCase):
    """Test suite for Base class."""

    def setUp(self):
        Base._Base__nb_objects = 0

    def test_id_auto_increment(self):
        b1 = Base()
        b2 = Base()
        self.assertEqual(b1.id, 1)
        self.assertEqual(b2.id, 2)

    def test_id_explicit(self):
        b = Base(89)
        self.assertEqual(b.id, 89)

    def test_to_json_string(self):
        self.assertEqual(Base.to_json_string(None), "[]")
        self.assertEqual(Base.to_json_string([]), "[]")
        d = [{'id': 1, 'width': 2}]
        self.assertEqual(Base.to_json_string(d), '[{"id": 1, "width": 2}]')

    def test_from_json_string(self):
        self.assertEqual(Base.from_json_string(None), [])
        self.assertEqual(Base.from_json_string(""), [])
        s = '[{"id": 1, "width": 2}]'
        self.assertEqual(Base.from_json_string(s), [{'id': 1, 'width': 2}])

    def test_save_and_load_file(self):
        r = Rectangle(10, 7, 2, 8, 1)
        Rectangle.save_to_file([r])
        output = Rectangle.load_from_file()
        self.assertEqual(len(output), 1)
        self.assertEqual(output[0].id, 1)
        if os.path.exists("Rectangle.json"):
            os.remove("Rectangle.json")


if __name__ == "__main__":
    unittest.main()
