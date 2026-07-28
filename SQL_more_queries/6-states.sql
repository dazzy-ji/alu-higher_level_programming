-- Creates the database hbtn_0d_usa and the table states
-- id is auto generated, unique, not null and the primary key
-- The script does not fail if the database or the table already exists
CREATE DATABASE IF NOT EXISTS hbtn_0d_usa;
USE hbtn_0d_usa;
CREATE TABLE IF NOT EXISTS states (
    id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
    name VARCHAR(256) NOT NULL
);
