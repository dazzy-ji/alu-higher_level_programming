-- Creates the table id_not_null where id defaults to 1 and cannot be null
-- The script does not fail if the table already exists
CREATE TABLE IF NOT EXISTS id_not_null (
    id INT NOT NULL DEFAULT 1,
    name VARCHAR(256)
);
