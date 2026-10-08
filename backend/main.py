# backend/main.py
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from db import get_db

app = FastAPI()

# Needed so the Chrome extension can call your local server. Local dev only.
app.add_middleware(CORSMiddleware, allow_origins=["*"],
                   allow_methods=["*"], allow_headers=["*"])

class ProjectIn(BaseModel):
    name: str
    budget: float | None = None

@app.post("/projects")
def create_project(p: ProjectIn):
    conn = get_db()
    cur = conn.execute("INSERT INTO projects (name, budget) VALUES (?, ?)",
                       (p.name, p.budget))
    conn.commit()
    return {"id": cur.lastrowid, "name": p.name, "budget": p.budget}

@app.get("/projects")
def list_projects():
    rows = get_db().execute("SELECT * FROM projects ORDER BY created_at DESC").fetchall()
    return [dict(r) for r in rows]

@app.get("/projects/{project_id}/parts")
def list_parts(project_id: int):
    rows = get_db().execute("SELECT * FROM parts WHERE project_id = ?",
                            (project_id,)).fetchall()
    return [dict(r) for r in rows]