from typing import Any, Optional
from pydantic import BaseModel, ConfigDict

class ParcelOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    id: str; name: str; area: float; x: float; y: float; width: float; depth: float

class BuildingOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    id: str; parcel_id: str; name: str; height: float; floors: int; x: float; y: float; width: float; depth: float

class FloorOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    id: str; building_id: str; level: int; name: str; height: float

class PropertyOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    id: str; parcel_id: str; building_id: str; floor_id: str; unit: str; area: float; usage: str
    x: float; y: float; z: float; width: float; depth: float; height: float; coordinates: str

class ULPINRequest(BaseModel):
    property_id: str

class ULPINOut(BaseModel):
    property_id: str; ulpin: str; parts: dict[str, str]; status: str

class ValidationIssueOut(BaseModel):
    id: str; issue_type: str; building_id: str; floor_id: str; property_ids: list[str]
    severity: str; description: str; status: str

class DemoRunOut(BaseModel):
    run_id: int; status: str; stages: list[dict[str, Any]]

class ValidationRunOut(BaseModel):
    total_checks: int; passed: int; warnings: int; critical: int; issues: list[ValidationIssueOut]

class DashboardOut(BaseModel):
    parcels: int; buildings: int; floors: int; properties: int; ulpins: int; validation_issues: int
    validation: dict[str, int]

class SystemStatusOut(BaseModel):
    status: str; mode: str; database: str; api_version: str; synthetic_data: bool
