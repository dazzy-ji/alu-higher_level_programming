#!/bin/bash
# Creates every file for the "SQL_more_queries" project.
# Run this from the ROOT of your alu-higher_level_programming repo.

set -e

DIR="SQL_more_queries"
mkdir -p "$DIR"
cd "$DIR"

# ---------------------------------------------------------- 0. My privileges!
cat > 0-privileges.sql <<'EOF'
-- Lists all privileges of the MySQL users user_0d_1 and user_0d_2 on localhost
SHOW GRANTS FOR 'user_0d_1'@'localhost';
SHOW GRANTS FOR 'user_0d_2'@'localhost';
EOF

# --------------------------------------------------------------- 1. Root user
cat > 1-create_user.sql <<'EOF'
-- Creates the user user_0d_1 with all privileges on the MySQL server
-- The script does not fail if the user already exists
CREATE USER IF NOT EXISTS 'user_0d_1'@'localhost' IDENTIFIED BY 'user_0d_1_pwd';
GRANT ALL PRIVILEGES ON *.* TO 'user_0d_1'@'localhost';
EOF

# --------------------------------------------------------------- 2. Read user
cat > 2-create_read_user.sql <<'EOF'
-- Creates the database hbtn_0d_2 and the user user_0d_2
-- user_0d_2 only receives the SELECT privilege on hbtn_0d_2
-- The script does not fail if the database or the user already exists
CREATE DATABASE IF NOT EXISTS hbtn_0d_2;
CREATE USER IF NOT EXISTS 'user_0d_2'@'localhost' IDENTIFIED BY 'user_0d_2_pwd';
GRANT SELECT ON hbtn_0d_2.* TO 'user_0d_2'@'localhost';
EOF

# ----------------------------------------------------------- 3. Always a name
cat > 3-force_name.sql <<'EOF'
-- Creates the table force_name where the name field can never be null
-- The script does not fail if the table already exists
CREATE TABLE IF NOT EXISTS force_name (
    id INT,
    name VARCHAR(256) NOT NULL
);
EOF

# --------------------------------------------------------- 4. ID can't be null
cat > 4-never_empty.sql <<'EOF'
-- Creates the table id_not_null where id defaults to 1 and cannot be null
-- The script does not fail if the table already exists
CREATE TABLE IF NOT EXISTS id_not_null (
    id INT NOT NULL DEFAULT 1,
    name VARCHAR(256)
);
EOF

# --------------------------------------------------------------- 5. Unique ID
cat > 5-unique_id.sql <<'EOF'
-- Creates the table unique_id where id defaults to 1 and must be unique
-- The script does not fail if the table already exists
CREATE TABLE IF NOT EXISTS unique_id (
    id INT DEFAULT 1,
    name VARCHAR(256),
    UNIQUE (id)
);
EOF

# ------------------------------------------------------------- 6. States table
cat > 6-states.sql <<'EOF'
-- Creates the database hbtn_0d_usa and the table states
-- id is auto generated, unique, not null and the primary key
-- The script does not fail if the database or the table already exists
CREATE DATABASE IF NOT EXISTS hbtn_0d_usa;
USE hbtn_0d_usa;
CREATE TABLE IF NOT EXISTS states (
    id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
    name VARCHAR(256) NOT NULL
);
EOF

# ------------------------------------------------------------- 7. Cities table
cat > 7-cities.sql <<'EOF'
-- Creates the database hbtn_0d_usa and the table cities
-- state_id is a foreign key referencing states.id
-- The script does not fail if the database or the table already exists
CREATE DATABASE IF NOT EXISTS hbtn_0d_usa;
USE hbtn_0d_usa;
CREATE TABLE IF NOT EXISTS cities (
    id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
    state_id INT NOT NULL,
    name VARCHAR(256) NOT NULL,
    FOREIGN KEY (state_id) REFERENCES states(id)
);
EOF

# ------------------------------------------------------ 8. Cities of California
cat > 8-cities_of_california_subquery.sql <<'EOF'
-- Lists all the cities of California without using the JOIN keyword
-- The state id is resolved with a subquery on the states table
SELECT id, name FROM cities
    WHERE state_id = (SELECT id FROM states WHERE name = 'California')
    ORDER BY id ASC;
EOF

# --------------------------------------------------------- 9. Cities by States
cat > 9-cities_by_state_join.sql <<'EOF'
-- Lists all cities with the name of the state they belong to
SELECT cities.id, cities.name, states.name FROM cities
    JOIN states ON cities.state_id = states.id
    ORDER BY cities.id ASC;
EOF

# -------------------------------------------------------- 10. Genre ID by show
cat > 10-genre_id_by_show.sql <<'EOF'
-- Lists all shows that have at least one genre linked, with the genre id
SELECT tv_shows.title, tv_show_genres.genre_id FROM tv_shows
    INNER JOIN tv_show_genres ON tv_shows.id = tv_show_genres.show_id
    ORDER BY tv_shows.title ASC, tv_show_genres.genre_id ASC;
EOF

# --------------------------------------------------- 11. Genre ID for all shows
cat > 11-genre_id_all_shows.sql <<'EOF'
-- Lists all shows with their genre id, showing NULL when there is no genre
SELECT tv_shows.title, tv_show_genres.genre_id FROM tv_shows
    LEFT JOIN tv_show_genres ON tv_shows.id = tv_show_genres.show_id
    ORDER BY tv_shows.title ASC, tv_show_genres.genre_id ASC;
EOF

# ---------------------------------------------------------------- 12. No genre
cat > 12-no_genre.sql <<'EOF'
-- Lists all shows that do not have a single genre linked
SELECT tv_shows.title, tv_show_genres.genre_id FROM tv_shows
    LEFT JOIN tv_show_genres ON tv_shows.id = tv_show_genres.show_id
    WHERE tv_show_genres.genre_id IS NULL
    ORDER BY tv_shows.title ASC, tv_show_genres.genre_id ASC;
EOF

# ------------------------------------------------- 13. Number of shows by genre
cat > 13-count_shows_by_genre.sql <<'EOF'
-- Lists each genre with the number of shows linked to it
-- Genres without any linked show are not displayed
SELECT tv_genres.name AS genre, COUNT(*) AS number_of_shows FROM tv_genres
    INNER JOIN tv_show_genres ON tv_genres.id = tv_show_genres.genre_id
    GROUP BY tv_genres.name
    ORDER BY number_of_shows DESC;
EOF

# --------------------------------------------------------------- 14. My genres
cat > 14-my_genres.sql <<'EOF'
-- Lists all genres of the show Dexter
SELECT tv_genres.name FROM tv_genres
    INNER JOIN tv_show_genres ON tv_genres.id = tv_show_genres.genre_id
    INNER JOIN tv_shows ON tv_show_genres.show_id = tv_shows.id
    WHERE tv_shows.title = 'Dexter'
    ORDER BY tv_genres.name ASC;
EOF

# ------------------------------------------------------------- 15. Only Comedy
cat > 15-comedy_only.sql <<'EOF'
-- Lists all shows linked to the Comedy genre
SELECT tv_shows.title FROM tv_shows
    INNER JOIN tv_show_genres ON tv_shows.id = tv_show_genres.show_id
    INNER JOIN tv_genres ON tv_show_genres.genre_id = tv_genres.id
    WHERE tv_genres.name = 'Comedy'
    ORDER BY tv_shows.title ASC;
EOF

# ------------------------------------------------------ 16. List shows and genres
cat > 16-shows_by_genre.sql <<'EOF'
-- Lists all shows with each genre linked to them
-- Shows without a genre display NULL in the genre column
SELECT tv_shows.title, tv_genres.name FROM tv_shows
    LEFT JOIN tv_show_genres ON tv_shows.id = tv_show_genres.show_id
    LEFT JOIN tv_genres ON tv_show_genres.genre_id = tv_genres.id
    ORDER BY tv_shows.title ASC, tv_genres.name ASC;
EOF

# ---------------------------------------------------------------------- README
cat > README.md <<'EOF'
# SQL - More queries

User creation and privileges, constraints (`NOT NULL`, `DEFAULT`, `UNIQUE`,
`PRIMARY KEY`, `FOREIGN KEY`), subqueries, and `INNER`/`LEFT JOIN` in MySQL 8.0.
EOF

echo "Done. Files created in $(pwd):"
ls -1
echo ""
echo "Sanity check:"
for f in ./*.sql; do
    head -c2 "$f" | grep -q '^--' || echo "  MISSING COMMENT: $f"
    [ "$(tail -c1 "$f" | wc -l)" -eq 1 ] || echo "  NO TRAILING NEWLINE: $f"
done
echo "  headers and newlines OK"
