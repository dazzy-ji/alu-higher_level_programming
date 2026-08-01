#!/usr/bin/python3
"""
Unittest module for Square class.
"""
import unittest
from models.square import Square


class TestSquare(unittest.TestCase):
    """Test suite for Square class."""

    def test_creation(self):
        s = Square(5, 1, 2, 10)
        self.assertEqual(s.size, 5)
        self.assertEqual(s.x, 1)
        self.assertEqual(s.y, 2)
        self.assertEqual(s.id, 10)

    def test_size_setter(self):
        s = Square(5)
        s.size = 10
        self.assertEqual(s.width, 10)
        self.assertEqual(s.height, 10)
        with self.assertRaises(TypeError):
            s.size = "invalid"

    def test_str(self):
        s = Square(5, 2, 1, 3)
        self.assertEqual(str(s), "[Square] (3) 2/1 - 5")


if __name__ == "__main__":
    unittest.main()
