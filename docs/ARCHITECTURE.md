# LUNARA Prototype Architecture

## Frontend screens
1. Dashboard — backend KPI values, command-center overview, Live Demo / Judge Demo.
2. 3D Map — synthetic ground plane, parcel boundary, building floors, property volumes, selection and explode/collapse.
3. ULPIN Generator — prototype identifier, hierarchy breakdown and demo JSON export.
4. Spatial Validation — 24 synthetic checks, passed/warning/critical metrics, overlap/gap/valid issues and affected-property selection.
5. Property Details — digital record fields and Parcel → Building → Floor → Property hierarchy.
6. Demo Pipeline — DATA → BUILDING DETECTION → FLOOR EXTRACTION → 3D GEOMETRY → PROPERTY MAPPING → 3D ULPIN → VALIDATION → VERIFICATION.

## Backend modules
- `database.py` — SQLite engine/session.
- `models.py` — Parcel, Building, Floor, Property, ULPINRecord, ValidationIssue, PipelineRun.
- `schemas.py` — Pydantic response/request contracts.
- `mock_data/seed.py` — one fictional LUNARA DEMO CITY dataset.
- `services/agents.py` — DataAgent, MappingAgent, GeometryAgent, ULPINAgent, ValidationAgent and DemoOrchestrator.
- `main.py` — required FastAPI APIs and Swagger.

## Mandatory APIs
GET `/api/dashboard`
GET `/api/parcels`
GET `/api/parcels/{id}`
GET `/api/buildings`
GET `/api/buildings/{id}`
GET `/api/properties/{id}`
POST `/api/ulpin/generate`
POST `/api/validation/run`
GET `/api/validation/results`
POST `/api/demo/run`
GET `/api/system/status`

## Design choice: controlled 3D
The frontend uses `CustomPainter` to draw a controlled 3D-style vertical model. This follows the prompt's fallback: stable and attractive visualization is preferred over spending the 36-hour prototype budget on a complicated rendering engine.
