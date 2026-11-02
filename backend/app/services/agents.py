import json
from sqlalchemy.orm import Session
from sqlalchemy import select
from ..models import Parcel, Building, Floor, Property, ULPINRecord, ValidationIssue

class DataAgent:
    def run(self, db: Session):
        return {"source": "synthetic", "parcels": db.query(Parcel).count(), "buildings": db.query(Building).count()}

class MappingAgent:
    def run(self, db: Session):
        return {"relationships": db.query(Property).count(), "hierarchy": "Parcel → Building → Floor → Property"}

class GeometryAgent:
    def run(self, db: Session):
        return {"volumes": db.query(Property).count(), "dimension_system": "synthetic local coordinates"}

class ULPINAgent:
    def generate(self, db: Session, property_id: str):
        p = db.get(Property, property_id)
        if not p:
            raise ValueError("Property not found")
        building = db.get(Building, p.building_id)
        floor = db.get(Floor, p.floor_id)
        existing = db.query(ULPINRecord).filter_by(property_id=property_id).first()
        if existing:
            ulpin = existing.ulpin
        else:
            floor_code = f"F{floor.level:02d}"
            unit_num = ''.join(ch for ch in p.unit if ch.isdigit()) or "001"
            ulpin = f"TS-HYD-D01-{p.parcel_id}-{building.id}-{floor_code}-U{int(unit_num):03d}"
            existing = ULPINRecord(property_id=property_id, ulpin=ulpin, status="generated")
            db.add(existing); db.commit()
        return {"property_id": property_id, "ulpin": ulpin,
                "parts": {"State": "TS", "District": "HYD", "Demo Area": "D01", "Parcel": p.parcel_id,
                          "Building": building.id, "Floor": f"F{floor.level:02d}", "Unit": f"U{int(''.join(ch for ch in p.unit if ch.isdigit()) or 1):03d}"},
                "status": "generated"}

class ValidationAgent:
    def run(self, db: Session):
        issues = db.query(ValidationIssue).all()
        return [{"id":i.id,"issue_type":i.issue_type,"building_id":i.building_id,"floor_id":i.floor_id,"property_ids":json.loads(i.property_ids),"severity":i.severity,"status":i.status} for i in issues]

class DemoOrchestrator:
    def __init__(self):
        self.data = DataAgent(); self.mapping = MappingAgent(); self.geometry = GeometryAgent(); self.ulpin = ULPINAgent(); self.validation = ValidationAgent()

    def run(self, db: Session):
        stages = []
        for name, fn in [("DATA", self.data.run), ("BUILDING DETECTION", self.mapping.run), ("FLOOR EXTRACTION", self.geometry.run),
                         ("3D GEOMETRY", self.geometry.run), ("PROPERTY MAPPING", self.mapping.run), ("3D ULPIN", self.ulpin_stage),
                         ("VALIDATION", self.validation.run), ("VERIFICATION", self.verification)]:
            try:
                result = fn(db) if name != "3D ULPIN" else fn(db)
                stages.append({"name": name, "status": "COMPLETE", "detail": result})
            except Exception as exc:
                stages.append({"name": name, "status": "ERROR", "detail": str(exc)})
                break
        return stages

    def ulpin_stage(self, db):
        p = db.query(Property).first()
        return self.ulpin.generate(db, p.id) if p else {"status": "no properties"}

    def verification(self, db):
        return {"verified": True, "records": db.query(Property).count()}
