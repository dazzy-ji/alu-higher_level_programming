-- Creates the database hbtn_0d_2 and the user user_0d_2
-- user_0d_2 only receives the SELECT privilege on hbtn_0d_2
-- The script does not fail if the database or the user already exists
CREATE DATABASE IF NOT EXISTS hbtn_0d_2;
CREATE USER IF NOT EXISTS 'user_0d_2'@'localhost' IDENTIFIED BY 'user_0d_2_pwd';
GRANT SELECT ON hbtn_0d_2.* TO 'user_0d_2'@'localhost';
