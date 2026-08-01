#!/bin/bash
# Creates every file for the "python-input_output" project.
# Run this from the ROOT of your alu-higher_level_programming repo.

set -e

DIR="python-input_output"
mkdir -p "$DIR"
cd "$DIR"

# --------------------------------------------------------------- 0. Read file
cat > 0-read_file.py <<'EOF'
#!/usr/bin/python3
"""Module that defines the read_file function."""


def read_file(filename=""):
    """Read a UTF-8 text file and print its content to stdout.

    Args:
        filename (str): the path of the file to read.
    """
    with open(filename, 'r', encoding='utf-8') as f:
        print(f.read(), end="")
EOF

# ---------------------------------------------------------- 1. Write to a file
cat > 1-write_file.py <<'EOF'
#!/usr/bin/python3
"""Module that defines the write_file function."""


def write_file(filename="", text=""):
    """Write a string to a UTF-8 text file, overwriting existing content.

    The file is created if it does not exist.

    Args:
        filename (str): the path of the file to write to.
        text (str): the string to write.

    Returns:
        int: the number of characters written.
    """
    with open(filename, 'w', encoding='utf-8') as f:
        return f.write(text)
EOF

# --------------------------------------------------------- 2. Append to a file
cat > 2-append_write.py <<'EOF'
#!/usr/bin/python3
"""Module that defines the append_write function."""


def append_write(filename="", text=""):
    """Append a string at the end of a UTF-8 text file.

    The file is created if it does not exist.

    Args:
        filename (str): the path of the file to append to.
        text (str): the string to append.

    Returns:
        int: the number of characters added.
    """
    with open(filename, 'a', encoding='utf-8') as f:
        return f.write(text)
EOF

# ------------------------------------------------------------ 3. To JSON string
cat > 3-to_json_string.py <<'EOF'
#!/usr/bin/python3
"""Module that defines the to_json_string function."""
import json


def to_json_string(my_obj):
    """Return the JSON representation of an object as a string.

    Args:
        my_obj: the object to serialize.

    Returns:
        str: the JSON representation of my_obj.
    """
    return json.dumps(my_obj)
EOF

# ------------------------------------------------- 4. From JSON string to Object
cat > 4-from_json_string.py <<'EOF'
#!/usr/bin/python3
"""Module that defines the from_json_string function."""
import json


def from_json_string(my_str):
    """Return the Python object represented by a JSON string.

    Args:
        my_str (str): the JSON string to deserialize.

    Returns:
        The Python data structure represented by my_str.
    """
    return json.loads(my_str)
EOF

# ---------------------------------------------------- 5. Save Object to a file
cat > 5-save_to_json_file.py <<'EOF'
#!/usr/bin/python3
"""Module that defines the save_to_json_file function."""
import json


def save_to_json_file(my_obj, filename):
    """Write an object to a text file using its JSON representation.

    Args:
        my_obj: the object to serialize.
        filename (str): the path of the file to write to.
    """
    with open(filename, 'w', encoding='utf-8') as f:
        json.dump(my_obj, f)
EOF

# --------------------------------------------- 6. Create object from a JSON file
cat > 6-load_from_json_file.py <<'EOF'
#!/usr/bin/python3
"""Module that defines the load_from_json_file function."""
import json


def load_from_json_file(filename):
    """Create a Python object from a JSON file.

    Args:
        filename (str): the path of the JSON file to read.

    Returns:
        The Python data structure stored in the file.
    """
    with open(filename, 'r', encoding='utf-8') as f:
        return json.load(f)
EOF

# ------------------------------------------------------------ 7. Load, add, save
cat > 7-add_item.py <<'EOF'
#!/usr/bin/python3
"""Script that adds all command line arguments to a list saved as JSON."""
import sys
save_to_json_file = __import__('5-save_to_json_file').save_to_json_file
load_from_json_file = __import__('6-load_from_json_file').load_from_json_file

filename = "add_item.json"

try:
    items = load_from_json_file(filename)
except FileNotFoundError:
    items = []

items.extend(sys.argv[1:])
save_to_json_file(items, filename)
EOF

# ------------------------------------------------------------- 8. Class to JSON
cat > 8-class_to_json.py <<'EOF'
#!/usr/bin/python3
"""Module that defines the class_to_json function."""


def class_to_json(obj):
    """Return the dictionary description of an object for JSON serialization.

    Args:
        obj: an instance of a class whose attributes are all serializable.

    Returns:
        dict: a copy of the object's attribute dictionary.
    """
    return obj.__dict__.copy()
EOF

# ----------------------------------------------------------- 9. Student to JSON
cat > 9-student.py <<'EOF'
#!/usr/bin/python3
"""Module that defines the Student class."""


class Student:
    """A student defined by a first name, a last name and an age."""

    def __init__(self, first_name, last_name, age):
        """Initialize a new Student.

        Args:
            first_name (str): the student's first name.
            last_name (str): the student's last name.
            age (int): the student's age.
        """
        self.first_name = first_name
        self.last_name = last_name
        self.age = age

    def to_json(self):
        """Return the dictionary representation of the Student."""
        return self.__dict__.copy()
EOF

# ----------------------------------------------- 10. Student to JSON with filter
cat > 10-student.py <<'EOF'
#!/usr/bin/python3
"""Module that defines the Student class."""


class Student:
    """A student defined by a first name, a last name and an age."""

    def __init__(self, first_name, last_name, age):
        """Initialize a new Student.

        Args:
            first_name (str): the student's first name.
            last_name (str): the student's last name.
            age (int): the student's age.
        """
        self.first_name = first_name
        self.last_name = last_name
        self.age = age

    def to_json(self, attrs=None):
        """Return the dictionary representation of the Student.

        Args:
            attrs (list): if a list of strings, only those attribute names
                are retrieved. Otherwise every attribute is retrieved.

        Returns:
            dict: the filtered attribute dictionary.
        """
        if type(attrs) is list and all(type(a) is str for a in attrs):
            return {k: v for k, v in self.__dict__.items() if k in attrs}
        return self.__dict__.copy()
EOF

# ------------------------------------------------ 11. Student to disk and reload
cat > 11-student.py <<'EOF'
#!/usr/bin/python3
"""Module that defines the Student class."""


class Student:
    """A student defined by a first name, a last name and an age."""

    def __init__(self, first_name, last_name, age):
        """Initialize a new Student.

        Args:
            first_name (str): the student's first name.
            last_name (str): the student's last name.
            age (int): the student's age.
        """
        self.first_name = first_name
        self.last_name = last_name
        self.age = age

    def to_json(self, attrs=None):
        """Return the dictionary representation of the Student.

        Args:
            attrs (list): if a list of strings, only those attribute names
                are retrieved. Otherwise every attribute is retrieved.

        Returns:
            dict: the filtered attribute dictionary.
        """
        if type(attrs) is list and all(type(a) is str for a in attrs):
            return {k: v for k, v in self.__dict__.items() if k in attrs}
        return self.__dict__.copy()

    def reload_from_json(self, json):
        """Replace all attributes of the Student from a dictionary.

        Args:
            json (dict): keys are public attribute names, values are the
                values to assign.
        """
        for key, value in json.items():
            setattr(self, key, value)
EOF

# --------------------------------------------------------- 12. Pascal's Triangle
cat > 12-pascal_triangle.py <<'EOF'
#!/usr/bin/python3
"""Module that defines the pascal_triangle function."""


def pascal_triangle(n):
    """Return Pascal's triangle of n as a list of lists of integers.

    Args:
        n (int): the number of rows.

    Returns:
        list: the triangle, or an empty list if n <= 0.
    """
    triangle = []
    if n <= 0:
        return triangle
    for i in range(n):
        row = [1] * (i + 1)
        for j in range(1, i):
            row[j] = triangle[i - 1][j - 1] + triangle[i - 1][j]
        triangle.append(row)
    return triangle
EOF

# ------------------------------------------------------------------- README
cat > README.md <<'EOF'
# Python - Input/Output

Reading and writing files with the `with` statement, JSON serialization and
deserialization, and a simple object save/reload mechanism.
EOF

chmod u+x ./*.py

echo "Done. Files created in $(pwd):"
ls -1
