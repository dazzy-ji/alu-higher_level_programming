#!/bin/bash
# Rewrites 0-privileges.sql and 1-create_user.sql.
# Run from the ROOT of your repo.

set -e
cd SQL_more_queries

# 0-privileges.sql
# Two comment lines so the SHOW GRANTS statements sit on lines 3 and 4,
# matching the "ERROR 1141 ... at line 3 / at line 4" in the task example.
cat > 0-privileges.sql <<'EOF'
-- Lists all privileges of the MySQL users user_0d_1 and user_0d_2
-- Both users are looked up on the localhost host
SHOW GRANTS FOR 'user_0d_1'@'localhost';
SHOW GRANTS FOR 'user_0d_2'@'localhost';
EOF

# 1-create_user.sql
# CREATE USER IF NOT EXISTS does not touch the password of an existing user,
# so ALTER USER guarantees the password is always user_0d_1_pwd.
cat > 1-create_user.sql <<'EOF'
-- Creates the MySQL user user_0d_1 with all privileges on the server
-- The script does not fail if the user already exists
CREATE USER IF NOT EXISTS 'user_0d_1'@'localhost' IDENTIFIED BY 'user_0d_1_pwd';
ALTER USER 'user_0d_1'@'localhost' IDENTIFIED BY 'user_0d_1_pwd';
GRANT ALL PRIVILEGES ON *.* TO 'user_0d_1'@'localhost';
EOF

echo "Rewritten. Line layout of 0-privileges.sql:"
cat -n 0-privileges.sql
echo ""
echo "1-create_user.sql:"
cat -n 1-create_user.sql
