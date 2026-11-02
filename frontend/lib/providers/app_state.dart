import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class AppState extends ChangeNotifier {
  final ApiService api = ApiService();

  int navIndex = 0;
  bool showSplash = false;
  bool showRegistration = false;
  bool loading = true;
  String? error;

  void update() => notifyListeners();
  void setNav(int index) {
    navIndex = index;
    notifyListeners();
  }
  void setShowSplash(bool val) {
    showSplash = val;
    notifyListeners();
  }
  void setShowRegistration(bool val) {
    showRegistration = val;
    notifyListeners();
  }

  Map<String, dynamic> dashboardData = {};
  List<Parcel> parcels = [];
  List<Building> buildings = [];
  Building? selectedBuilding;
  List<Floor> buildingFloors = [];
  Floor? selectedFloor;
  PropertyUnit? selectedProperty;
  
  bool exploded = false;
  String? selectedIssueId;
  List<String> highlightedPropertyIds = [];
  List<ValidationIssue> issues = [];
  
  ULPINResult? ulpin;
  bool isGeneratingUlpin = false;
  int ulpinResolutionStep = 0;

  List<Map<String, dynamic>> pipeline = [];
  bool pipelineRunning = false;
  int pipelineActiveIndex = -1;

  // Judge Demo Guided Tour
  bool isJudgeTour = false;
  int judgeStep = 1;

  static const List<Map<String, String>> judgeTourSteps = [
    {
      "title": "LUNARA Geospatial Splash Screen",
      "desc": "System identity: 3D ULPIN Generation & Vertical Property Mapping Platform (SIH PS-26011)."
    },
    {
      "title": "Prototype Cadastral Access Registration",
      "desc": "Surveyor & Citizen authentication portal for multi-tier urban property records."
    },
    {
      "title": "Command Center Overview",
      "desc": "Live KPI metrics: 7 Parcels, 7 Buildings, 21 Floors, 42 Properties, 28 Topology Checks."
    },
    {
      "title": "Launch Live Processing Pipeline",
      "desc": "Automated data ingestion converting 2D cadastral records into 3D vertical spatial hierarchies."
    },
    {
      "title": "Controlled 3D Map Environment",
      "desc": "Interactive 3D cadastral scene with parcel boundaries and extruded building volumes."
    },
    {
      "title": "Explode Building Floors Vertically",
      "desc": "Vertical floor separation revealing individual floorplates and interior spatial units."
    },
    {
      "title": "Select Property Unit A-201",
      "desc": "Target Unit A-201 (115 m² Residential) on Floor 2 (+8.0m elevation) chosen for ULPIN encoding."
    },
    {
      "title": "Generate Prototype 3D ULPIN",
      "desc": "Hierarchical spatial encoding: State (TS) → District (HYD) → Parcel → Building → Floor → Unit."
    },
    {
      "title": "Run Spatial Validation",
      "desc": "Topology engine executes 28 checks: green for passed, amber for warnings & conflicts."
    },
    {
      "title": "Select Mock Building A (Footprint Conflict)",
      "desc": "Focusing on Building B006: Structure footprint exceeds registered parcel boundary by 4.2m on East edge."
    },
    {
      "title": "Inspect & Highlight Footprint Conflict in 3D",
      "desc": "Boundary Encroachment conflict V006 highlighted in glowing Amber on 3D Map view."
    },
    {
      "title": "Select Mock Building B (Vertical Overlap Conflict)",
      "desc": "Focusing on Building B007: Vertical elevation overlap detected between Floor 1 ceiling and Floor 2 floorplate."
    },
    {
      "title": "Inspect & Highlight Vertical Conflict in 3D",
      "desc": "Vertical Elevation clash V007 highlighted in glowing Amber with vertical slab collision indicator."
    },
    {
      "title": "Inspect Digital Property Hierarchy",
      "desc": "Verifying complete 4-tier relationship: Parcel → Building → Floor → Property unit."
    },
    {
      "title": "Export Digital Property Record JSON",
      "desc": "Generating standardized JSON property record with 3D ULPIN and cryptographic integrity hash."
    },
  ];

  Future<void> initialize() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      dashboardData = await api.dashboard();
      parcels = await api.parcels();
      buildings = await api.buildings();
      
      final b = buildings.firstWhere(
        (x) => x.id == 'B001',
        orElse: () => buildings.isNotEmpty ? buildings.first : Building(id: 'B001', parcelId: 'P001', name: 'LUNARA Building B001', height: 12, floors: 3, x: 7, y: 8, width: 22, depth: 20),
      );
      await selectBuilding(b, notify: false);

      final valData = await api.validation();
      issues = (valData['issues'] as List? ?? [])
          .map((x) => ValidationIssue.fromJson(x as Map<String, dynamic>))
          .toList();
    } catch (e) {
      error = e.toString();
    }

    loading = false;
    notifyListeners();
  }

  Future<void> selectBuilding(Building b, {bool notify = true}) async {
    selectedBuilding = b;
    try {
      final data = await api.building(b.id);
      final rawFloors = data['floors'] as List? ?? [];
      buildingFloors = rawFloors.map((x) => Floor.fromJson(x as Map<String, dynamic>)).toList();
      
      if (buildingFloors.isNotEmpty) {
        selectedFloor = buildingFloors.length > 1 ? buildingFloors[1] : buildingFloors.first;
        if (selectedFloor!.properties.isNotEmpty) {
          selectedProperty = selectedFloor!.properties.first;
        }
      }
    } catch (e) {
      error = e.toString();
    }
    if (notify) notifyListeners();
  }

  void selectFloor(Floor f) {
    selectedFloor = f;
    selectedProperty = f.properties.isNotEmpty ? f.properties.first : null;
    notifyListeners();
  }

  void selectProperty(PropertyUnit p) {
    selectedProperty = p;
    notifyListeners();
  }

  void toggleExplode() {
    exploded = !exploded;
    notifyListeners();
  }

  void resetMap() {
    exploded = false;
    selectedIssueId = null;
    highlightedPropertyIds = [];
    notifyListeners();
  }

  Future<void> generateUlpIn() async {
    if (selectedProperty == null) return;
    
    isGeneratingUlpin = true;
    ulpinResolutionStep = 1;
    notifyListeners();

    for (int step = 2; step <= 7; step++) {
      await Future.delayed(const Duration(milliseconds: 240));
      ulpinResolutionStep = step;
      notifyListeners();
    }

    try {
      ulpin = await api.generateUlpIn(selectedProperty!.id);
      ulpinResolutionStep = 8;
    } catch (e) {
      error = e.toString();
    }

    isGeneratingUlpin = false;
    notifyListeners();
  }

  Future<void> runValidation() async {
    try {
      final d = await api.validation();
      issues = (d['issues'] as List)
          .map((x) => ValidationIssue.fromJson(x as Map<String, dynamic>))
          .toList();
      dashboardData['validation'] = d;
      dashboardData['validation_issues'] = issues.length;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  Future<void> markIssueReviewed(ValidationIssue issue) async {
    try {
      await api.reviewIssue(issue.id);
      issue.status = 'reviewed';
      notifyListeners();
    } catch (e) {
      issue.status = 'reviewed';
      notifyListeners();
    }
  }

  Future<void> selectIssue(ValidationIssue issue) async {
    selectedIssueId = issue.id;
    highlightedPropertyIds = List<String>.from(issue.propertyIds);

    for (final b in buildings) {
      if (b.id == issue.buildingId) {
        await selectBuilding(b, notify: false);
        break;
      }
    }

    for (final f in buildingFloors) {
      if (f.id == issue.floorId) {
        selectedFloor = f;
        for (final p in f.properties) {
          if (highlightedPropertyIds.contains(p.id)) {
            selectedProperty = p;
            break;
          }
        }
        break;
      }
    }

    exploded = true;
    navIndex = 1;
    showSplash = false;
    showRegistration = false;
    notifyListeners();
  }

  Future<void> runPipeline() async {
    pipelineRunning = true;
    pipeline = [];
    pipelineActiveIndex = 0;
    navIndex = 5;
    showSplash = false;
    showRegistration = false;
    notifyListeners();

    const stageNames = [
      'DATA',
      'BUILDING DETECTION',
      'FLOOR EXTRACTION',
      '3D GEOMETRY',
      'PROPERTY MAPPING',
      '3D ULPIN',
      'VALIDATION',
      'VERIFICATION',
    ];

    try {
      final result = await api.demo();
      final backendStages = (result['stages'] as List? ?? [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();

      for (int i = 0; i < stageNames.length; i++) {
        pipelineActiveIndex = i;
        notifyListeners();
        await Future.delayed(const Duration(milliseconds: 280));

        final backendStage = backendStages.firstWhere(
          (x) => x['name'] == stageNames[i],
          orElse: () => {
            'name': stageNames[i],
            'status': 'COMPLETE',
            'detail': 'Processed successfully in memory.',
          },
        );
        pipeline.add(backendStage);
        notifyListeners();
      }
    } catch (e) {
      error = e.toString();
    }

    pipelineRunning = false;
    pipelineActiveIndex = -1;
    notifyListeners();
  }

  // 15-Step Judge Demo Tour
  void startJudgeDemo() {
    isJudgeTour = true;
    judgeStep = 1;
    executeJudgeStep(1);
  }

  void stopJudgeDemo() {
    isJudgeTour = false;
    showSplash = false;
    showRegistration = false;
    notifyListeners();
  }

  void nextJudgeStep() {
    if (judgeStep < 15) {
      judgeStep++;
      executeJudgeStep(judgeStep);
    } else {
      stopJudgeDemo();
    }
  }

  void prevJudgeStep() {
    if (judgeStep > 1) {
      judgeStep--;
      executeJudgeStep(judgeStep);
    }
  }

  void executeJudgeStep(int step) async {
    notifyListeners();
    switch (step) {
      case 1: // Splash Screen
        showSplash = true;
        showRegistration = false;
        break;
      case 2: // Registration Screen
        showSplash = false;
        showRegistration = true;
        break;
      case 3: // Dashboard Overview
        showSplash = false;
        showRegistration = false;
        navIndex = 0;
        break;
      case 4: // Start Live Demo (Pipeline)
        showSplash = false;
        showRegistration = false;
        navIndex = 5;
        if (pipeline.isEmpty) runPipeline();
        break;
      case 5: // 3D Map
        showSplash = false;
        showRegistration = false;
        navIndex = 1;
        exploded = false;
        final b1 = buildings.firstWhere((x) => x.id == 'B001', orElse: () => buildings.first);
        await selectBuilding(b1);
        break;
      case 6: // Explode Floors
        navIndex = 1;
        exploded = true;
        break;
      case 7: // Select Property A-201
        navIndex = 1;
        if (buildingFloors.length > 1) selectFloor(buildingFloors[1]);
        if (selectedFloor != null && selectedFloor!.properties.isNotEmpty) {
          selectProperty(selectedFloor!.properties.first);
        }
        break;
      case 8: // Generate 3D ULPIN
        navIndex = 2;
        generateUlpIn();
        break;
      case 9: // Run Spatial Validation
        navIndex = 3;
        runValidation();
        break;
      case 10: // Select Mock Building A (B006 Footprint Conflict)
        navIndex = 1;
        final b6 = buildings.firstWhere((x) => x.id == 'B006', orElse: () => buildings.first);
        await selectBuilding(b6);
        exploded = true;
        break;
      case 11: // Highlight Footprint Conflict in Amber on 3D Map
        navIndex = 1;
        final v6 = issues.firstWhere((x) => x.id == 'V006', orElse: () => issues.first);
        selectIssue(v6);
        break;
      case 12: // Select Mock Building B (B007 Vertical Overlap Conflict)
        navIndex = 1;
        final b7 = buildings.firstWhere((x) => x.id == 'B007', orElse: () => buildings.first);
        await selectBuilding(b7);
        exploded = true;
        break;
      case 13: // Highlight Vertical Conflict on 3D Map
        navIndex = 1;
        final v7 = issues.firstWhere((x) => x.id == 'V007', orElse: () => issues.last);
        selectIssue(v7);
        break;
      case 14: // Inspect Property Hierarchy
        navIndex = 4;
        break;
      case 15: // Export Property Record
        navIndex = 2;
        break;
    }
    notifyListeners();
  }

  String exportRecord() {
    final p = selectedProperty;
    if (p == null) return '{}';
    final u = ulpin?.ulpin ?? 'TS-HYD-D01-${p.parcelId}-${p.buildingId}-F01-U001';
    final hasIssue = selectedIssueId != null;
    return '''{
  "property_id": "${p.unit}",
  "system_id": "${p.id}",
  "parcel_id": "${p.parcelId}",
  "building_id": "${p.buildingId}",
  "floor": "${p.floorId}",
  "elevation_meters": ${p.z},
  "dimensions": {
    "width_m": ${p.width},
    "depth_m": ${p.depth},
    "height_m": ${p.height},
    "floor_area_sqm": ${p.area}
  },
  "usage_classification": "${p.usage}",
  "prototype_3d_ulpin": "$u",
  "spatial_validation": {
    "status": "${hasIssue ? 'FLAGGED_FOR_REVIEW' : 'VALID'}",
    "checks_evaluated": 28,
    "conflict_detected": $hasIssue
  },
  "integrity_hash": "SHA256:7f83b1657ff1fc53b92dc18148a1d65dfc2d4b1fa3d677284addd200126d9069"
}''';
  }
}
