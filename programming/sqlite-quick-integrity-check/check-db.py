"""Demonstrate SQLite integrity vs FK checks using an in-memory DB only."""
import sqlite3

with sqlite3.connect(":memory:") as db:
    db.execute("PRAGMA foreign_keys=OFF")
    db.executescript("""
        CREATE TABLE parent (id INTEGER PRIMARY KEY);
        CREATE TABLE child (id INTEGER PRIMARY KEY, parent_id INTEGER
                            REFERENCES parent(id));
        INSERT INTO parent(id) VALUES (1);
        INSERT INTO child(id, parent_id) VALUES (10, 99);
    """)
    db.commit()
    db.execute("PRAGMA foreign_keys=ON")
    for label, sql in [
        ("quick_check", "PRAGMA quick_check"),
        ("integrity_check", "PRAGMA integrity_check"),
        ("foreign_key_check", "PRAGMA foreign_key_check"),
    ]:
        rows = db.execute(sql).fetchall()
        print(f"{label}: {rows}")
