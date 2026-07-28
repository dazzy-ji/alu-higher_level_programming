#!/usr/bin/python3
"""
Unittest for max_integer([..])
"""
import unittest
max_integer = __import__('6-max_integer').max_integer


class TestMaxInteger(unittest.TestCase):
    """Define unittests for max_integer([..])."""

    def test_ordered_list(self):
        """Test an ordered list of integers."""
        self.assertEqual(max_integer([1, 2, 3, 4]), 4)

    def test_unordered_list(self):
        """Test an unordered list of integers."""
        self.assertEqual(max_integer([1, 3, 4, 2]), 4)

    def test_max_at_beginning(self):
        """Test a list with max value at the start."""
        self.assertEqual(max_integer([4, 3, 2, 1]), 4)

    def test_empty_list(self):
        """Test an empty list."""
        self.assertIsNone(max_integer([]))

    def test_single_element(self):
        """Test a list with a single element."""
        self.assertEqual(max_integer([7]), 7)

    def test_floats(self):
        """Test a list of floating points."""
        self.assertEqual(max_integer([1.53, 6.33, -9.12, 4.2]), 6.33)

    def test_ints_and_floats(self):
        """Test a mixed list of ints and floats."""
        self.assertEqual(max_integer([1.53, 6, 9.12, 2]), 9.12)

    def test_string(self):
        """Test a string input."""
        self.assertEqual(max_integer("string"), 't')

    def test_list_of_strings(self):
        """Test a list of strings."""
        self.assertEqual(max_integer(["abc", "xyz", "mno"]), "xyz")

    def test_negative_numbers(self):
        """Test a list of negative numbers."""
        self.assertEqual(max_integer([-1, -5, -10, -2]), -1)


if __name__ == "__main__":
    unittest.main()
