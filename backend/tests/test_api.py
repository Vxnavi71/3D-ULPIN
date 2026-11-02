from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_status():
    r = client.get('/api/system/status')
    assert r.status_code == 200
    assert r.json()['synthetic_data'] is True
    assert r.json()['mode'] == "DEMO MODE"

def test_dashboard():
    r = client.get('/api/dashboard')
    assert r.status_code == 200
    data = r.json()
    assert data['parcels'] == 7
    assert data['buildings'] == 7
    assert data['floors'] == 21
    assert data['properties'] == 42
    assert data['validation_issues'] == 7
    assert data['validation']['total_checks'] == 28

def test_parcels():
    r = client.get('/api/parcels')
    assert r.status_code == 200
    assert len(r.json()) == 7
    r_detail = client.get('/api/parcels/P001')
    assert r_detail.status_code == 200
    assert r_detail.json()['parcel']['id'] == 'P001'
    assert len(r_detail.json()['buildings']) >= 1

def test_buildings_and_mock_scenarios():
    r = client.get('/api/buildings')
    assert r.status_code == 200
    assert len(r.json()) == 7
    
    # Building B001 standard
    r_b1 = client.get('/api/buildings/B001')
    assert r_b1.status_code == 200
    assert r_b1.json()['building']['id'] == 'B001'
    assert len(r_b1.json()['floors']) == 3

    # Mock Building A: B006 (Footprint conflict)
    r_b6 = client.get('/api/buildings/B006')
    assert r_b6.status_code == 200
    assert 'Footprint Conflict' in r_b6.json()['building']['name']

    # Mock Building B: B007 (Vertical overlap)
    r_b7 = client.get('/api/buildings/B007')
    assert r_b7.status_code == 200
    assert 'Vertical Overlap' in r_b7.json()['building']['name']

def test_property_details():
    r = client.get('/api/properties/B001-U101')
    assert r.status_code == 200
    data = r.json()
    assert data['property']['id'] == 'B001-U101'
    assert data['hierarchy']['parcel'] == 'P001'
    assert data['hierarchy']['building'] == 'B001'

def test_ulpin_and_validation():
    r = client.post('/api/ulpin/generate', json={'property_id': 'B001-U201'})
    assert r.status_code == 200
    data = r.json()
    assert data['ulpin'].startswith('TS-HYD-D01-P001-B001-F01')
    assert 'parts' in data
    assert data['parts']['State'] == 'TS'
    assert data['parts']['District'] == 'HYD'

    v = client.post('/api/validation/run')
    assert v.status_code == 200
    v_data = v.json()
    assert v_data['total_checks'] == 28
    assert len(v_data['issues']) == 7

    # Verify B006 boundary encroachment & B007 vertical overlap issues exist
    issue_types = [i['issue_type'] for i in v_data['issues']]
    assert 'BOUNDARY_ENCROACHMENT' in issue_types
    assert 'VERTICAL_OVERLAP' in issue_types

    res = client.get('/api/validation/results')
    assert res.status_code == 200

def test_validation_review():
    r = client.post('/api/validation/review/V006')
    assert r.status_code == 200
    assert r.json()['status'] == 'reviewed'

def test_search():
    r = client.get('/api/search?q=P006')
    assert r.status_code == 200
    assert r.json()['type'] == 'parcel'

    r = client.get('/api/search?q=B007')
    assert r.status_code == 200
    assert r.json()['type'] == 'building'

def test_demo_run():
    r = client.post('/api/demo/run')
    assert r.status_code == 200
    data = r.json()
    assert data['status'] == 'complete'
    assert len(data['stages']) == 8
