CREATE TABLE IF NOT EXISTS projects (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  name        TEXT NOT NULL,
  description TEXT,
  budget      REAL,
  created_at  TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS parts (
  id           INTEGER PRIMARY KEY AUTOINCREMENT,
  project_id   INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  name         TEXT NOT NULL,
  spec_text    TEXT,                 -- "M5 x 20mm socket head cap screw, 316 stainless"
  quantity     INTEGER NOT NULL DEFAULT 1,
  target_price REAL,
  status       TEXT DEFAULT 'needed', -- needed / sourced / ordered / received
  created_at   TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sources (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  part_id       INTEGER NOT NULL REFERENCES parts(id) ON DELETE CASCADE,
  supplier      TEXT NOT NULL,
  supplier_sku  TEXT,
  url           TEXT,
  title         TEXT,
  unit_price    REAL,
  in_stock      INTEGER,             -- 1 / 0 / NULL if unknown
  lead_time_days INTEGER,
  capture_method TEXT,               -- 'manual_extension' or 'api'
  fit_score     REAL,                -- 0 to 1, from the AI layer
  fit_notes     TEXT,
  fetched_at    TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS price_history (
  id         INTEGER PRIMARY KEY AUTOINCREMENT,
  source_id  INTEGER NOT NULL REFERENCES sources(id) ON DELETE CASCADE,
  unit_price REAL,
  fetched_at TEXT DEFAULT CURRENT_TIMESTAMP
);