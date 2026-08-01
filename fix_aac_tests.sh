#!/bin/bash
# Adds the Square test cases the checker looks for.
# Run from the ROOT of your repo.

set -e
cd python-almost_a_circle

python3 - <<'PYEOF'
path = "tests/test_models/test_square.py"
with open(path) as f:
    src = f.read()

guard = '\n\nif __name__ == "__main__":\n    unittest.main()\n'
src = src.replace(guard, "\n")

extra = '''

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
'''

src = src.rstrip("\n") + "\n" + extra

# these test classes need os and json
src = src.replace("import unittest\nimport io\nimport sys\n",
                  "import unittest\nimport io\nimport sys\nimport os\nimport json\n")

with open(path, "w") as f:
    f.write(src)
print("patched", path)
PYEOF

echo ""
echo "Verifying..."
pycodestyle tests/test_models/test_square.py && echo "  PEP8 CLEAN"
python3 -m unittest discover tests 2>&1 | tail -4
