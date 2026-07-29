#!/usr/bin/python3
"""Displays all values in states matching argument safe from SQL injection."""
import MySQLdb
import sys


if __name__ == "__main__":
    db = MySQLdb.connect(
        host="localhost",
        port=3306,
        user=sys.argv[1],
        passwd=sys.argv[2],
        db=sys.argv[3]
    )
    cursor = db.cursor()
    cursor.execute("SELECT * FROM states WHERE name = %s ORDER BY id ASC",
                   (sys.argv[4],))
    rows = cursor.fetchall()
    for row in rows:
        print(row)
    cursor.close()
    db.close()
