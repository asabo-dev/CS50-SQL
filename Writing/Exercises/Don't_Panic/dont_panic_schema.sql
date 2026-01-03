CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS user_logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    type TEXT NOT NULL,
    old_username TEXT,
    new_username TEXT,
    old_password TEXT,
    new_password TEXT
);

CREATE TABLE IF NOT EXISTS items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    price NUMERIC NOT NULL
);

CREATE TABLE IF NOT EXISTS orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    item_id INTEGER,
    quantity INTEGER NOT NULL CHECK(quantity > 0),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (item_id) REFERENCES items(id)
);

CREATE TRIGGER log_user_updates
AFTER UPDATE OF username, password ON users
FOR EACH ROW
BEGIN
    INSERT INTO user_logs (type, old_username, new_username, old_password, new_password)
    VALUES ('update', OLD.username, NEW.username, OLD.password, NEW.password);
END;

CREATE TRIGGER log_user_deletes
AFTER DELETE ON users
FOR EACH ROW
BEGIN
    INSERT INTO user_logs (type, old_username, new_username, old_password, new_password)
    VALUES ('delete', OLD.username, NULL, OLD.password, NULL);
END;

CREATE TRIGGER log_user_inserts
AFTER INSERT ON users
FOR EACH ROW
BEGIN
    INSERT INTO user_logs (type, old_username, new_username, old_password, new_password)
    VALUES ('insert', NULL, NEW.username, NULL, NEW.password);
END;
