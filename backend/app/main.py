import json
from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from sqlalchemy import select
from .database import Base, engine, get_db
from .models import Parcel, Building, Floor, Property, ULPINRecord, ValidationIssue, PipelineRun
from .schemas import *
from .mock_data.seed import seed_demo
from .services.agents import DemoOrchestrator, ULPINAgent

from fastapi.responses import HTMLResponse, FileResponse
import os
from .web_app import HTML_CONTENT

app = FastAPI(
    title="LUNARA 3D Property Intelligence API",
    version="1.0.0",
    description="SIH 2026 PS-26011 demonstration backend. Synthetic data only.",
)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

def initialize_database():
    Base.metadata.create_all(bind=engine)
    db = next(get_db())
    try:
        seed_demo(db)
    finally:
        db.close()

initialize_database()

@app.get("/", response_class=HTMLResponse)
def root_web():
    return HTML_CONTENT

@app.get("/api/video/demo")
def get_demo_video():
    root_video = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "lunara_3d_demonstration_video.mp4"))
    build_video = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "video_build", "lunara_3d_demonstration_video.mp4"))
    target = root_video if os.path.exists(root_video) else build_video
    if not os.path.exists(target):
        raise HTTPException(404, "Prototype demonstration video not found")
    return FileResponse(target, media_type="video/mp4")

@app.get("/api/system/status", response_model=SystemStatusOut)
def system_status(db: Session = Depends(get_db)):
    return {
        "status": "online",
        "mode": "DEMO MODE",
        "database": "SQLite",
        "api_version": "1.0.0",
        "synthetic_data": True,
    }

@app.get("/api/dashboard", response_model=DashboardOut)
def dashboard(db: Session = Depends(get_db)):
    issues = db.query(ValidationIssue).all()
    critical = sum(i.severity.lower() == "critical" for i in issues)
    warnings = sum(i.severity.lower() == "warning" for i in issues)
    total_checks = 28
    passed = total_checks - len(issues)
    return {
        "parcels": db.query(Parcel).count(),
        "buildings": db.query(Building).count(),
        "floors": db.query(Floor).count(),
        "properties": db.query(Property).count(),
        "ulpins": db.query(ULPINRecord).count(),
        "validation_issues": len(issues),
        "validation": {
            "total_checks": total_checks,
            "passed": passed,
            "warnings": warnings,
            "critical": critical,
        },
    }

@app.get("/api/parcels", response_model=list[ParcelOut])
def parcels(db: Session = Depends(get_db)):
    return db.query(Parcel).all()

@app.get("/api/parcels/{parcel_id}")
def parcel(parcel_id: str, db: Session = Depends(get_db)):
    p = db.get(Parcel, parcel_id)
    if not p:
        raise HTTPException(404, "Parcel not found")
    buildings = db.query(Building).filter_by(parcel_id=parcel_id).all()
    return {"parcel": ParcelOut.model_validate(p), "buildings": [BuildingOut.model_validate(b) for b in buildings]}

@app.get("/api/buildings", response_model=list[BuildingOut])
def buildings(db: Session = Depends(get_db)):
    return db.query(Building).all()

@app.get("/api/buildings/{building_id}")
def building(building_id: str, db: Session = Depends(get_db)):
    b = db.get(Building, building_id)
    if not b:
        raise HTTPException(404, "Building not found")
    floors = db.query(Floor).filter_by(building_id=building_id).order_by(Floor.level).all()
    return {
        "building": BuildingOut.model_validate(b),
        "floors": [
            {
                **FloorOut.model_validate(f).model_dump(),
                "properties": [PropertyOut.model_validate(p).model_dump() for p in db.query(Property).filter_by(floor_id=f.id).all()],
            }
            for f in floors
        ],
    }

@app.get("/api/properties/{property_id}")
def property_details(property_id: str, db: Session = Depends(get_db)):
    p = db.get(Property, property_id)
    if not p:
        raise HTTPException(404, "Property not found")
    b = db.get(Building, p.building_id)
    f = db.get(Floor, p.floor_id)
    parcel = db.get(Parcel, p.parcel_id)
    u = db.query(ULPINRecord).filter_by(property_id=p.id).first()
    return {"property": PropertyOut.model_validate(p), "hierarchy": {"parcel": parcel.id, "building": b.id, "floor": f.id, "property": p.id}, "ulpin": u.ulpin if u else None}

@app.post("/api/ulpin/generate", response_model=ULPINOut)
def generate_ulpin(req: ULPINRequest, db: Session = Depends(get_db)):
    try:
        return ULPINAgent().generate(db, req.property_id)
    except ValueError as e:
        raise HTTPException(404, str(e))

@app.post("/api/validation/run", response_model=ValidationRunOut)
def run_validation(db: Session = Depends(get_db)):
    issues = db.query(ValidationIssue).all()
    critical = sum(i.severity.lower() == "critical" for i in issues)
    warnings = sum(i.severity.lower() == "warning" for i in issues)
    total_checks = 28
    passed = total_checks - len(issues)
    return {
        "total_checks": total_checks,
        "passed": passed,
        "warnings": warnings,
        "critical": critical,
        "issues": [
            {
                **{k: getattr(i, k) for k in ["id", "issue_type", "building_id", "floor_id", "severity", "description", "status"]},
                "property_ids": json.loads(i.property_ids),
            }
            for i in issues
        ],
    }

@app.get("/api/validation/results",response_model=ValidationRunOut)
def validation_results(db:Session=Depends(get_db)):
    return run_validation(db)

@app.post("/api/validation/review/{issue_id}")
def review_issue(issue_id: str, db: Session = Depends(get_db)):
    issue = db.get(ValidationIssue, issue_id)
    if not issue:
        raise HTTPException(404, "Issue not found")
    issue.status = "reviewed"
    db.commit()
    return {"id": issue.id, "status": "reviewed"}

@app.get("/api/search")
def search(q: str, db: Session = Depends(get_db)):
    query = q.strip().upper()
    if not query:
        return {"type": "none", "results": []}
    
    # Check parcel
    parcel = db.query(Parcel).filter((Parcel.id == query) | (Parcel.name.ilike(f"%{query}%"))).first()
    if parcel:
        b = db.query(Building).filter_by(parcel_id=parcel.id).first()
        return {"type": "parcel", "parcel_id": parcel.id, "building_id": b.id if b else None, "name": parcel.name}
    
    # Check building
    bld = db.query(Building).filter((Building.id == query) | (Building.name.ilike(f"%{query}%"))).first()
    if bld:
        return {"type": "building", "building_id": bld.id, "parcel_id": bld.parcel_id, "name": bld.name}
    
    # Check property or ULPIN
    prop = db.query(Property).filter((Property.id == query) | (Property.unit == query)).first()
    if prop:
        return {"type": "property", "property_id": prop.id, "building_id": prop.building_id, "floor_id": prop.floor_id, "parcel_id": prop.parcel_id, "unit": prop.unit}
    
    ulpin_rec = db.query(ULPINRecord).filter(ULPINRecord.ulpin == query).first()
    if ulpin_rec:
        prop = db.get(Property, ulpin_rec.property_id)
        if prop:
            return {"type": "ulpin", "property_id": prop.id, "building_id": prop.building_id, "floor_id": prop.floor_id, "parcel_id": prop.parcel_id, "unit": prop.unit, "ulpin": ulpin_rec.ulpin}

    return {"type": "none", "results": []}

@app.post("/api/demo/run", response_model=DemoRunOut)
def demo_run(db: Session = Depends(get_db)):
    run = PipelineRun(status="running", completed_stage="WAITING")
    db.add(run)
    db.commit()
    db.refresh(run)
    stages = DemoOrchestrator().run(db)
    run.status = "complete"
    run.completed_stage = stages[-1]["name"] if stages else "WAITING"
    db.commit()
    return {"run_id": run.id, "status": "complete", "stages": stages}

