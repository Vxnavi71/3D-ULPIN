from datetime import datetime, timezone
from sqlalchemy import String, Integer, Float, Text, DateTime, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column
from .database import Base

class Parcel(Base):
    __tablename__ = "parcels"
    id: Mapped[str] = mapped_column(String, primary_key=True)
    name: Mapped[str] = mapped_column(String)
    area: Mapped[float] = mapped_column(Float)
    x: Mapped[float] = mapped_column(Float)
    y: Mapped[float] = mapped_column(Float)
    width: Mapped[float] = mapped_column(Float)
    depth: Mapped[float] = mapped_column(Float)

class Building(Base):
    __tablename__ = "buildings"
    id: Mapped[str] = mapped_column(String, primary_key=True)
    parcel_id: Mapped[str] = mapped_column(ForeignKey("parcels.id"))
    name: Mapped[str] = mapped_column(String)
    height: Mapped[float] = mapped_column(Float)
    floors: Mapped[int] = mapped_column(Integer)
    x: Mapped[float] = mapped_column(Float)
    y: Mapped[float] = mapped_column(Float)
    width: Mapped[float] = mapped_column(Float)
    depth: Mapped[float] = mapped_column(Float)

class Floor(Base):
    __tablename__ = "floors"
    id: Mapped[str] = mapped_column(String, primary_key=True)
    building_id: Mapped[str] = mapped_column(ForeignKey("buildings.id"))
    level: Mapped[int] = mapped_column(Integer)
    name: Mapped[str] = mapped_column(String)
    height: Mapped[float] = mapped_column(Float)

class Property(Base):
    __tablename__ = "properties"
    id: Mapped[str] = mapped_column(String, primary_key=True)
    parcel_id: Mapped[str] = mapped_column(ForeignKey("parcels.id"))
    building_id: Mapped[str] = mapped_column(ForeignKey("buildings.id"))
    floor_id: Mapped[str] = mapped_column(ForeignKey("floors.id"))
    unit: Mapped[str] = mapped_column(String)
    area: Mapped[float] = mapped_column(Float)
    usage: Mapped[str] = mapped_column(String)
    x: Mapped[float] = mapped_column(Float)
    y: Mapped[float] = mapped_column(Float)
    z: Mapped[float] = mapped_column(Float)
    width: Mapped[float] = mapped_column(Float)
    depth: Mapped[float] = mapped_column(Float)
    height: Mapped[float] = mapped_column(Float)
    coordinates: Mapped[str] = mapped_column(Text)

class ULPINRecord(Base):
    __tablename__ = "ulpin_records"
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    property_id: Mapped[str] = mapped_column(ForeignKey("properties.id"))
    ulpin: Mapped[str] = mapped_column(String, unique=True)
    status: Mapped[str] = mapped_column(String, default="generated")
    created_at: Mapped[datetime] = mapped_column(DateTime, default=lambda: datetime.now(timezone.utc))

class ValidationIssue(Base):
    __tablename__ = "validation_issues"
    id: Mapped[str] = mapped_column(String, primary_key=True)
    issue_type: Mapped[str] = mapped_column(String)
    building_id: Mapped[str] = mapped_column(String)
    floor_id: Mapped[str] = mapped_column(String)
    property_ids: Mapped[str] = mapped_column(Text)
    severity: Mapped[str] = mapped_column(String)
    description: Mapped[str] = mapped_column(Text)
    status: Mapped[str] = mapped_column(String, default="open")

class PipelineRun(Base):
    __tablename__ = "pipeline_runs"
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    status: Mapped[str] = mapped_column(String)
    completed_stage: Mapped[str] = mapped_column(String, default="WAITING")
    created_at: Mapped[datetime] = mapped_column(DateTime, default=lambda: datetime.now(timezone.utc))
