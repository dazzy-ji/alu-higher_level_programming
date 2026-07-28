-- Creates the table unique_id where id defaults to 1 and must be unique
-- The script does not fail if the table already exists
CREATE TABLE IF NOT EXISTS unique_id (
    id INT DEFAULT 1,
    name VARCHAR(256),
    UNIQUE (id)
);
