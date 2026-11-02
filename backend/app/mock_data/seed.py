import json
from sqlalchemy.orm import Session
from ..models import Parcel, Building, Floor, Property, ValidationIssue

def seed_demo(db: Session):
    if db.query(Parcel).count() > 0:
        return

    parcels = []
    buildings = []
    floors = []
    props = []

    # 7 Synthetic demo parcels and buildings (B001 to B005 standard, B006 Footprint Conflict, B007 Vertical Conflict)
    for pi in range(1, 8):
        pid = f"P{pi:03d}"
        x = ((pi - 1) % 3) * 36.0 + 4
        y = ((pi - 1) // 3) * 38.0 + 5
        
        # B006 has parcel width 26, but building width 32 (Footprint boundary encroachment!)
        p_width = 26.0 if pi == 6 else 28.0
        p_depth = 24.0 if pi == 6 else 26.0

        parcel = Parcel(
            id=pid,
            name=f"Demo Parcel {pid}",
            area=980 + pi * 55,
            x=x,
            y=y,
            width=p_width,
            depth=p_depth,
        )
        db.add(parcel)
        parcels.append(parcel)

        bid = f"B{pi:03d}"
        b_width = 31.0 if pi == 6 else 22.0  # Encroachment for B006
        b_depth = 28.0 if pi == 6 else 20.0
        b_name = "LUNARA Mock Building A (Footprint Conflict)" if pi == 6 else (
            "LUNARA Mock Building B (Vertical Overlap)" if pi == 7 else f"LUNARA Building {bid}"
        )

        b = Building(
            id=bid,
            parcel_id=pid,
            name=b_name,
            height=12.0,
            floors=3,
            x=x + 2,
            y=y + 2,
            width=b_width,
            depth=b_depth,
        )
        db.add(b)
        buildings.append(b)

        for level in range(3):
            fid = f"{bid}-F{level:02d}"
            # For B007, level 1 has a vertical elevation clash
            f_height = 4.0
            floor_name = "Ground" if level == 0 else f"Floor {level}"
            f = Floor(id=fid, building_id=bid, level=level, name=floor_name, height=f_height)
            db.add(f)
            floors.append(f)

            for unit_idx in range(2):
                unit = f"A-{level + 1}{unit_idx + 1:02d}"
                propid = f"{bid}-U{level + 1}{unit_idx + 1:02d}"
                px = x + 4 + unit_idx * 10
                py = y + 4
                # B007 Floor 1 has elevation collision (+3.2m instead of 4.0m)
                pz = (level * 3.2 if (pi == 7 and level > 0) else level * 4.0)

                p = Property(
                    id=propid,
                    parcel_id=pid,
                    building_id=bid,
                    floor_id=fid,
                    unit=unit,
                    area=110 + level * 5 + unit_idx * 4,
                    usage="Residential" if unit_idx == 0 else "Commercial",
                    x=px,
                    y=py,
                    z=pz,
                    width=9.0,
                    depth=15.0,
                    height=3.5,
                    coordinates=json.dumps({"x": px, "y": py, "z": pz}),
                )
                db.add(p)
                props.append(p)

    db.commit()

    issues = [
        ValidationIssue(
            id="V001",
            issue_type="OVERLAP",
            building_id="B001",
            floor_id="B001-F01",
            property_ids=json.dumps(["B001-U201", "B001-U202"]),
            severity="Warning",
            description="Synthetic volume overlap between adjacent interior property units.",
            status="open",
        ),
        ValidationIssue(
            id="V002",
            issue_type="GAP",
            building_id="B002",
            floor_id="B002-F02",
            property_ids=json.dumps(["B002-U301", "B002-U302"]),
            severity="Warning",
            description="Synthetic gap detected between floor property boundaries.",
            status="open",
        ),
        ValidationIssue(
            id="V003",
            issue_type="VALID",
            building_id="B003",
            floor_id="B003-F00",
            property_ids=json.dumps(["B003-U101"]),
            severity="Pass",
            description="No spatial conflict detected. 3D geometry consistent.",
            status="open",
        ),
        ValidationIssue(
            id="V004",
            issue_type="OVERLAP",
            building_id="B004",
            floor_id="B004-F01",
            property_ids=json.dumps(["B004-U201", "B004-U202"]),
            severity="Critical",
            description="Synthetic critical overlap requiring spatial review.",
            status="open",
        ),
        ValidationIssue(
            id="V005",
            issue_type="VALID",
            building_id="B005",
            floor_id="B005-F02",
            property_ids=json.dumps(["B005-U301", "B005-U302"]),
            severity="Pass",
            description="No spatial conflict detected.",
            status="open",
        ),
        # Mock Building A: Parcel boundary / Footprint conflict
        ValidationIssue(
            id="V006",
            issue_type="BOUNDARY_ENCROACHMENT",
            building_id="B006",
            floor_id="B006-F00",
            property_ids=json.dumps(["B006-U101", "B006-U102"]),
            severity="Warning",
            description="Mock Building A: Structure footprint encroaches 4.2m past cadastral parcel boundary.",
            status="open",
        ),
        # Mock Building B: Vertical property overlap / elevation conflict
        ValidationIssue(
            id="V007",
            issue_type="VERTICAL_OVERLAP",
            building_id="B007",
            floor_id="B007-F01",
            property_ids=json.dumps(["B007-U201", "B007-U202"]),
            severity="Warning",
            description="Mock Building B: Vertical elevation clash between floor slabs (+0.8m volume intersection).",
            status="open",
        ),
    ]

    db.add_all(issues)
    db.commit()
