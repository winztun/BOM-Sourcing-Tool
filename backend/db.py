# backend/db.py
import sqlite3
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent
DB_PATH = BASE_DIR.parent / "bom.db"      # bom.db lives in the bom-tool folder
SCHEMA_PATH = BASE_DIR / "schema.sql"

def get_db():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row          # lets you access columns by name
    conn.execute("PRAGMA foreign_keys = ON")
    return conn

def init_db():
    conn = get_db()
    conn.executescript(SCHEMA_PATH.read_text(encoding="utf-8"))
    conn.commit()
    conn.close()

if __name__ == "__main__":
    init_db()
    print("Database ready at", DB_PATH)