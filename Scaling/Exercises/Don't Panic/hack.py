# Connect, via Python, to a SQLite database.
# Alter, within a Python program, the administrator’s password.
# This code is simple and meets cs50 requirements

from cs50 import SQL # This line of Python code says that your program should grab (“import”) tools related to SQL from the CS50 library, called cs50.

db = SQL("sqlite:///dont-panic.db") # Establishes a connection to the database given as an input
password = input("Enter a password: ")
db.execute(
    """
    UPDATE "users"
    SET "password" = ?
    WHERE "username" = 'admin';
    """,
    password
)
