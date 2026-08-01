#!/bin/bash
# Creates every file for the "SQL_introduction" project.
# Run this from the ROOT of your alu-higher_level_programming repo.

set -e

DIR="SQL_introduction"
mkdir -p "$DIR"
cd "$DIR"

# ----------------------------------------------------------- 0. List databases
cat > 0-list_databases.sql <<'EOF'
-- Lists all databases of the MySQL server
SHOW DATABASES;
EOF

# --------------------------------------------------------- 1. Create a database
cat > 1-create_database_if_missing.sql <<'EOF'
-- Creates the database hbtn_0c_0 if it does not already exist
CREATE DATABASE IF NOT EXISTS hbtn_0c_0;
EOF

# --------------------------------------------------------- 2. Delete a database
cat > 2-remove_database.sql <<'EOF'
-- Deletes the database hbtn_0c_0 if it exists
DROP DATABASE IF EXISTS hbtn_0c_0;
EOF

# -------------------------------------------------------------- 3. List tables
cat > 3-list_tables.sql <<'EOF'
-- Lists all the tables of the database passed as argument
SHOW TABLES;
EOF

# -------------------------------------------------------------- 4. First table
cat > 4-first_table.sql <<'EOF'
-- Creates the table first_table in the current database
-- The table is not recreated if it already exists
CREATE TABLE IF NOT EXISTS first_table (
    id INT,
    name VARCHAR(256)
);
EOF

# ---------------------------------------------------------- 5. Full description
cat > 5-full_table.sql <<'EOF'
-- Prints the full description of the table first_table
SHOW CREATE TABLE first_table;
EOF

# ---------------------------------------------------------- 6. List all in table
cat > 6-list_values.sql <<'EOF'
-- Lists all rows and all fields of the table first_table
SELECT * FROM first_table;
EOF

# ----------------------------------------------------------------- 7. First add
cat > 7-insert_value.sql <<'EOF'
-- Inserts a new row in the table first_table
INSERT INTO first_table (id, name) VALUES (89, 'Best School');
EOF

# ------------------------------------------------------------------ 8. Count 89
cat > 8-count_89.sql <<'EOF'
-- Displays the number of records with id = 89 in the table first_table
SELECT COUNT(id) FROM first_table WHERE id = 89;
EOF

# ------------------------------------------------------------- 9. Full creation
cat > 9-full_creation.sql <<'EOF'
-- Creates the table second_table and adds multiple rows
-- The table is not recreated if it already exists
CREATE TABLE IF NOT EXISTS second_table (
    id INT,
    name VARCHAR(256),
    score INT
);
INSERT INTO second_table (id, name, score) VALUES (1, 'John', 10);
INSERT INTO second_table (id, name, score) VALUES (2, 'Alex', 3);
INSERT INTO second_table (id, name, score) VALUES (3, 'Bob', 14);
INSERT INTO second_table (id, name, score) VALUES (4, 'George', 8);
EOF

# -------------------------------------------------------------- 10. List by best
cat > 10-top_score.sql <<'EOF'
-- Lists all records of second_table, best score first
SELECT score, name FROM second_table ORDER BY score DESC;
EOF

# ----------------------------------------------------------- 11. Select the best
cat > 11-best_score.sql <<'EOF'
-- Lists all records of second_table with a score of 10 or more
SELECT score, name FROM second_table WHERE score >= 10 ORDER BY score DESC;
EOF

# ---------------------------------------------------------- 12. Cheating is bad
cat > 12-no_cheating.sql <<'EOF'
-- Updates the score of Bob to 10, matching on the name only
UPDATE second_table SET score = 10 WHERE name = 'Bob';
EOF

# ------------------------------------------------------------- 13. Score too low
cat > 13-change_class.sql <<'EOF'
-- Removes all records with a score of 5 or less from second_table
DELETE FROM second_table WHERE score <= 5;
EOF

# ------------------------------------------------------------------- 14. Average
cat > 14-average.sql <<'EOF'
-- Computes the score average of all records in second_table
SELECT AVG(score) AS average FROM second_table;
EOF

# ----------------------------------------------------------- 15. Number by score
cat > 15-groups.sql <<'EOF'
-- Lists the number of records sharing each score, most common first
SELECT score, COUNT(*) AS number FROM second_table
    GROUP BY score
    ORDER BY number DESC;
EOF

# --------------------------------------------------------------- 16. Say my name
cat > 16-no_link.sql <<'EOF'
-- Lists all records of second_table that have a name, best score first
SELECT score, name FROM second_table
    WHERE name IS NOT NULL
    ORDER BY score DESC;
EOF

# ---------------------------------------------------------------------- README
cat > README.md <<'EOF'
# SQL - Introduction

Creating and deleting databases and tables, inserting, selecting, updating and
deleting rows, and aggregating with `COUNT`, `AVG` and `GROUP BY` in MySQL 8.0.
EOF

echo "Done. Files created in $(pwd):"
ls -1
echo ""
echo "Line counts (wc -l):"
wc -l ./*.sql
