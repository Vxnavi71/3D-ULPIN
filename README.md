# LUNARA — 3D ULPIN Generation & Vertical Property Mapping System

**Smart India Hackathon (SIH 2026)**  
**Problem Statement:** PS-26011  
**Team:** LUNARA  
**Team ID:** 168736  

---

## 🌟 Executive Summary

**LUNARA** is a prototype 3D property intelligence platform demonstrating vertical property mapping, 3D unique spatial identifier (Prototype 3D ULPIN) generation, automated topology conflict validation, and digital property record management for multi-story urban cadastre.

Core Demonstrated Workflow:
$$\text{Data} \longrightarrow \text{AI Agents} \longrightarrow \text{3D Mapping} \longrightarrow \text{3D ULPIN} \longrightarrow \text{Database} \longrightarrow \text{Validation} \longrightarrow \text{Web App}$$

---

## 🚀 Key Features

1. **Dashboard & Command Center:** Real-time KPI metrics (Parcels, Buildings, Floors, Properties, 3D ULPINs, Spatial Conflicts), central 3D mini-city overview, and health analytics.
2. **3D Cadastre Map:** Isometric 3D rendering with ground planes, parcel boundary polygons, extruded building volumes, and interactive orbit/zoom controls.
3. **Vertical Building Explosion:** Smooth vertical floor separation revealing interior strata levels and spatial property unit distributions.
4. **Prototype 3D ULPIN Generator:** Animated step-by-step resolution sequence ($State \rightarrow District \rightarrow Area \rightarrow Parcel \rightarrow Building \rightarrow Floor \rightarrow Unit$) with 7 decomposition cards.
5. **Spatial Validation Module:** Automated topological checks detecting `OVERLAP`, `GAP`, and `VALID` states with direct **"View in 3D Map"** highlighting (glowing conflict mesh).
6. **Digital Property Record:** 4-tier interactive spatial hierarchy graph ($\text{Parcel} \rightarrow \text{Building} \rightarrow \text{Floor} \rightarrow \text{Property}$) and one-click JSON export.
7. **Live Processing Pipeline:** 8-stage modular orchestrator (`DataAgent`, `MappingAgent`, `GeometryAgent`, `ULPINAgent`, `ValidationAgent`).
8. **Automated 14-Step Judge Demo:** Step-by-step guided walkthrough with auto-play, forward/back stepper, and live interactive execution.

---

## 🛠️ Technology Stack

- **Backend:** Python 3.13, FastAPI, Pydantic v2, SQLAlchemy 2.0, SQLite (in-memory/file).
- **Frontend:** Flutter + Dart, Material 3, Dark GIS Professional Theme (`#0A0E17`, `#00E5C0` Cyan Accent).
- **Web App:** Embedded responsive interactive web dashboard served directly at `http://localhost:8000/`.

---

## 🏃 Quick Start Guide

### 1. Run Backend Server

```bash
cd backend
 python -m pip install -r requirements.txt
python run.py
```
- **Live Web Application:** Open [http://localhost:8000/](http://localhost:8000/) in any web browser.
- **FastAPI Interactive Swagger Docs:** [http://localhost:8000/docs](http://localhost:8000/docs)

### 2. Run Flutter Frontend (Optional / Desktop / Mobile)

```bash
cd frontend
flutter pub get
flutter run -d chrome --web-port 8080
```

### 3. Run Backend Test Suite

```bash
cd backend
python -m pytest
```

---

## 🎯 14-Step Judge Demo Flow

Click the prominent **"JUDGE DEMO"** button in the header bar to launch the guided demonstration:

1. **Step 1:** Command Center KPI Dashboard Overview
2. **Step 2:** Start Live Processing Pipeline
3. **Step 3:** Live 8-Stage Agent Pipeline Execution
4. **Step 4:** 3D Map Environment
5. **Step 5:** Select Target Building `B001`
6. **Step 6:** **EXPLODE FLOORS** vertically
7. **Step 7:** Select Floor 2 (+8.0m elevation)
8. **Step 8:** Select Property Unit `A-201`
9. **Step 9:** Generate Prototype 3D ULPIN (`TS-HYD-D01-P001-B001-F02-U004`)
10. **Step 10:** Run Spatial Validation
11. **Step 11:** Detect Synthetic Overlap Conflict
12. **Step 12:** Highlight Conflicting Volumes in 3D Map (Flashing Red Mesh)
13. **Step 13:** Inspect $\text{Parcel} \rightarrow \text{Building} \rightarrow \text{Floor} \rightarrow \text{Property}$ Relationship
14. **Step 14:** Export Standardized Digital Property Record JSON

---

## ⚠️ Prototype Disclaimer
*This is a demonstration prototype designed for Smart India Hackathon (SIH 2026). All data is synthetic. The prototype 3D ULPIN format demonstrates spatial hierarchy encoding and does not represent an official government algorithm.*
