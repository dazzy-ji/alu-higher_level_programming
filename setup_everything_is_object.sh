#!/bin/bash
# Creates every file for the "python-everything_is_object" project.
# Run this from the ROOT of your alu-higher_level_programming repo.

set -e

DIR="python-everything_is_object"
mkdir -p "$DIR"
cd "$DIR"

# --- 0-2: identity & type ---------------------------------------------------
echo "type"  > 0-answer.txt
echo "id"    > 1-answer.txt
echo "No"    > 2-answer.txt   # 89 vs 100 -> different objects

# --- 3-5: small int caching -------------------------------------------------
echo "Yes"   > 3-answer.txt   # both 89, cached in range -5..256
echo "Yes"   > 4-answer.txt   # b = a
echo "No"    > 5-answer.txt   # b = 90

# --- 6-9: strings -----------------------------------------------------------
echo "True"  > 6-answer.txt   # == compares value
echo "True"  > 7-answer.txt   # s2 = s1, same object
echo "True"  > 8-answer.txt   # == compares value
echo "False" > 9-answer.txt   # "Best School" has a space -> not auto-interned

# --- 10-13: lists -----------------------------------------------------------
echo "True"  > 10-answer.txt  # equal contents
echo "False" > 11-answer.txt  # two separate list objects
echo "True"  > 12-answer.txt
echo "True"  > 13-answer.txt  # l2 = l1, same object

# --- 14-18: mutability & function arguments ---------------------------------
echo "[1, 2, 3, 4]" > 14-answer.txt  # append mutates in place
echo "[1, 2, 3]"    > 15-answer.txt  # + creates a new list, rebinds l1 only
echo "1"            > 16-answer.txt  # ints are immutable
echo "[1, 2, 3, 4]" > 17-answer.txt  # append mutates the caller's list
echo "[1, 2, 3]"    > 18-answer.txt  # rebinding a parameter doesn't escape

# --- 19: copy_list (max 3 lines, no imports) --------------------------------
cat > 19-copy_list.py <<'EOF'
#!/usr/bin/python3
def copy_list(l):
    return l[:]
EOF
chmod u+x 19-copy_list.py

# --- 20-23: tuples ----------------------------------------------------------
echo "Yes"   > 20-answer.txt   # () is an empty tuple
echo "Yes"   > 21-answer.txt   # (1, 2)
echo "No"    > 22-answer.txt   # (1) is just int 1
echo "Yes"   > 23-answer.txt   # (1,) trailing comma makes it a tuple

# --- 24-26: tuple identity --------------------------------------------------
echo "True"  > 24-answer.txt   # both are int 1 -> cached
echo "False" > 25-answer.txt   # two distinct tuple objects
echo "True"  > 26-answer.txt   # () is a singleton in CPython

# --- 27-28: id after concatenation vs += ------------------------------------
echo "No"    > 27-answer.txt   # a + [5] builds a new list
echo "Yes"   > 28-answer.txt   # += extends in place

# --- README -----------------------------------------------------------------
cat > README.md <<'EOF'
# Python - Everything is object

Answers and code for the ALU "Everything is object" project, covering
mutability, object identity (`is` vs `==`), `id()`, `type()`, small-integer
caching, string interning, tuple literals, and how arguments are passed to
functions in Python.
EOF

echo "Done. Files created in $(pwd):"
ls -1
