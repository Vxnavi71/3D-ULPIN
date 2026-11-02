# LUNARA Backend

FastAPI + SQLAlchemy + SQLite synthetic demonstration backend for SIH 2026 PS-26011.

## Run

```bash
python -m venv .venv
# Windows: .venv\Scripts\activate
# Linux/macOS: source .venv/bin/activate
pip install -r requirements.txt
python run.py
```

Swagger: http://localhost:8000/docs

The database is created and seeded automatically with 5 parcels, 5 buildings, 15 floors, 30 property units and 5 validation issues.
