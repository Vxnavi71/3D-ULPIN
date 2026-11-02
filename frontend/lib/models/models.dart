class Parcel {
  final String id;
  final String name;
  final double area;
  final double x;
  final double y;
  final double width;
  final double depth;

  Parcel({
    required this.id,
    required this.name,
    required this.area,
    required this.x,
    required this.y,
    required this.width,
    required this.depth,
  });

  factory Parcel.fromJson(Map<String, dynamic> json) => Parcel(
        id: json['id'] as String,
        name: json['name'] as String,
        area: (json['area'] as num).toDouble(),
        x: (json['x'] as num).toDouble(),
        y: (json['y'] as num).toDouble(),
        width: (json['width'] as num).toDouble(),
        depth: (json['depth'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'area': area,
        'x': x,
        'y': y,
        'width': width,
        'depth': depth,
      };
}

class Building {
  final String id;
  final String parcelId;
  final String name;
  final double height;
  final int floors;
  final double x;
  final double y;
  final double width;
  final double depth;

  Building({
    required this.id,
    required this.parcelId,
    required this.name,
    required this.height,
    required this.floors,
    required this.x,
    required this.y,
    required this.width,
    required this.depth,
  });

  factory Building.fromJson(Map<String, dynamic> json) => Building(
        id: json['id'] as String,
        parcelId: json['parcel_id'] as String,
        name: json['name'] as String,
        height: (json['height'] as num).toDouble(),
        floors: json['floors'] as int,
        x: (json['x'] as num).toDouble(),
        y: (json['y'] as num).toDouble(),
        width: (json['width'] as num).toDouble(),
        depth: (json['depth'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'parcel_id': parcelId,
        'name': name,
        'height': height,
        'floors': floors,
        'x': x,
        'y': y,
        'width': width,
        'depth': depth,
      };
}

class Floor {
  final String id;
  final String buildingId;
  final int level;
  final String name;
  final double height;
  final List<PropertyUnit> properties;

  Floor({
    required this.id,
    required this.buildingId,
    required this.level,
    required this.name,
    required this.height,
    this.properties = const [],
  });

  factory Floor.fromJson(Map<String, dynamic> json) => Floor(
        id: json['id'] as String,
        buildingId: json['building_id'] as String,
        level: json['level'] as int,
        name: json['name'] as String,
        height: (json['height'] as num).toDouble(),
        properties: (json['properties'] as List? ?? [])
            .map((e) => PropertyUnit.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'building_id': buildingId,
        'level': level,
        'name': name,
        'height': height,
        'properties': properties.map((e) => e.toJson()).toList(),
      };
}

class PropertyUnit {
  final String id;
  final String parcelId;
  final String buildingId;
  final String floorId;
  final String unit;
  final double area;
  final String usage;
  final double x;
  final double y;
  final double z;
  final double width;
  final double depth;
  final double height;
  final String coordinates;

  PropertyUnit({
    required this.id,
    required this.parcelId,
    required this.buildingId,
    required this.floorId,
    required this.unit,
    required this.area,
    required this.usage,
    required this.x,
    required this.y,
    required this.z,
    required this.width,
    required this.depth,
    required this.height,
    required this.coordinates,
  });

  factory PropertyUnit.fromJson(Map<String, dynamic> json) => PropertyUnit(
        id: json['id'] as String,
        parcelId: json['parcel_id'] as String,
        buildingId: json['building_id'] as String,
        floorId: json['floor_id'] as String,
        unit: json['unit'] as String,
        area: (json['area'] as num).toDouble(),
        usage: json['usage'] as String,
        x: (json['x'] as num).toDouble(),
        y: (json['y'] as num).toDouble(),
        z: (json['z'] as num).toDouble(),
        width: (json['width'] as num).toDouble(),
        depth: (json['depth'] as num).toDouble(),
        height: (json['height'] as num).toDouble(),
        coordinates: json['coordinates'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'parcel_id': parcelId,
        'building_id': buildingId,
        'floor_id': floorId,
        'unit': unit,
        'area': area,
        'usage': usage,
        'x': x,
        'y': y,
        'z': z,
        'width': width,
        'depth': depth,
        'height': height,
        'coordinates': coordinates,
      };
}

class ValidationIssue {
  final String id;
  final String type;
  final String buildingId;
  final String floorId;
  final String severity;
  final String description;
  String status;
  final List<String> propertyIds;

  ValidationIssue({
    required this.id,
    required this.type,
    required this.buildingId,
    required this.floorId,
    required this.severity,
    required this.description,
    required this.status,
    required this.propertyIds,
  });

  factory ValidationIssue.fromJson(Map<String, dynamic> json) => ValidationIssue(
        id: json['id'] as String,
        type: json['issue_type'] as String,
        buildingId: json['building_id'] as String,
        floorId: json['floor_id'] as String,
        severity: json['severity'] as String,
        description: json['description'] as String,
        status: json['status'] as String? ?? 'open',
        propertyIds: List<String>.from(json['property_ids'] as List? ?? []),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'issue_type': type,
        'building_id': buildingId,
        'floor_id': floorId,
        'severity': severity,
        'description': description,
        'status': status,
        'property_ids': propertyIds,
      };
}

class ULPINResult {
  final String propertyId;
  final String ulpin;
  final String status;
  final Map<String, String> parts;

  ULPINResult({
    required this.propertyId,
    required this.ulpin,
    required this.status,
    required this.parts,
  });

  factory ULPINResult.fromJson(Map<String, dynamic> json) => ULPINResult(
        propertyId: json['property_id'] as String,
        ulpin: json['ulpin'] as String,
        status: json['status'] as String,
        parts: Map<String, String>.from(json['parts'] as Map),
      );

  Map<String, dynamic> toJson() => {
        'property_id': propertyId,
        'ulpin': ulpin,
        'status': status,
        'parts': parts,
      };
}
