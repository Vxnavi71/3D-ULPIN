import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'common.dart';

class Map3D extends StatefulWidget {
  final Building? building;
  final List<Floor> floors;
  final Floor? selectedFloor;
  final PropertyUnit? selectedProperty;
  final String? highlightedIssueId;
  final List<String> highlightedPropertyIds;
  final bool exploded;
  final VoidCallback onExplode;
  final VoidCallback onReset;
  final void Function(Floor) onSelectFloor;
  final void Function(PropertyUnit) onSelectProperty;

  const Map3D({
    super.key,
    this.building,
    this.floors = const [],
    this.selectedFloor,
    this.selectedProperty,
    this.highlightedIssueId,
    this.highlightedPropertyIds = const [],
    required this.exploded,
    required this.onExplode,
    required this.onReset,
    required this.onSelectFloor,
    required this.onSelectProperty,
  });

  @override
  State<Map3D> createState() => _Map3DState();
}

class _Map3DState extends State<Map3D> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _explodeAnimation;

  double _yaw = 0.65;
  double _pitch = 0.55;
  double _zoom = 1.0;
  Offset _panOffset = Offset.zero;

  bool _showWireframe = false;
  bool _showParcels = true;
  bool _showPropertyVolumes = true;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _explodeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    if (widget.exploded) _animController.value = 1.0;
  }

  @override
  void didUpdateWidget(covariant Map3D oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.exploded != oldWidget.exploded) {
      if (widget.exploded) {
        _animController.forward();
      } else {
        _animController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _resetCamera() {
    setState(() {
      _yaw = 0.65;
      _pitch = 0.55;
      _zoom = 1.0;
      _panOffset = Offset.zero;
    });
    widget.onReset();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 480,
      decoration: BoxDecoration(
        color: AppTheme.bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // 3D Canvas
          GestureDetector(
            onScaleUpdate: (details) {
              setState(() {
                if (details.scale != 1.0) {
                  _zoom = (_zoom * details.scale).clamp(0.6, 2.2);
                } else {
                  _yaw += details.focalPointDelta.dx * 0.007;
                  _pitch = (_pitch - details.focalPointDelta.dy * 0.007).clamp(0.2, 1.2);
                }
              });
            },
            child: AnimatedBuilder(
              animation: _explodeAnimation,
              builder: (context, _) => CustomPaint(
                size: Size.infinite,
                painter: _Engine3DPainter(
                  building: widget.building,
                  floors: widget.floors,
                  selectedFloor: widget.selectedFloor,
                  selectedProperty: widget.selectedProperty,
                  highlightedPropertyIds: widget.highlightedPropertyIds,
                  highlightedIssueId: widget.highlightedIssueId,
                  explodeFactor: _explodeAnimation.value,
                  yaw: _yaw,
                  pitch: _pitch,
                  zoom: _zoom,
                  panOffset: _panOffset,
                  showWireframe: _showWireframe,
                  showParcels: _showParcels,
                  showPropertyVolumes: _showPropertyVolumes,
                ),
              ),
            ),
          ),

          // Top Right 3D Controls
          Positioned(
            top: 14,
            right: 14,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _iconBtn(icon: Icons.rotate_left, tooltip: 'Rotate Left', onTap: () => setState(() => _yaw -= 0.2)),
                const SizedBox(width: 6),
                _iconBtn(icon: Icons.rotate_right, tooltip: 'Rotate Right', onTap: () => setState(() => _yaw += 0.2)),
                const SizedBox(width: 6),
                _iconBtn(icon: Icons.zoom_in, tooltip: 'Zoom In', onTap: () => setState(() => _zoom = (_zoom + 0.15).clamp(0.6, 2.2))),
                const SizedBox(width: 6),
                _iconBtn(icon: Icons.zoom_out, tooltip: 'Zoom Out', onTap: () => setState(() => _zoom = (_zoom - 0.15).clamp(0.6, 2.2))),
                const SizedBox(width: 6),
                _iconBtn(icon: Icons.center_focus_strong, tooltip: 'Reset Camera', onTap: _resetCamera),
                const SizedBox(width: 10),
                FilledButton.icon(
                  onPressed: widget.onExplode,
                  style: FilledButton.styleFrom(
                    backgroundColor: widget.exploded ? AppTheme.amber : AppTheme.cyan,
                    foregroundColor: const Color(0xFF042F2E),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  ),
                  icon: Icon(widget.exploded ? Icons.unfold_less : Icons.unfold_more, size: 18),
                  label: Text(
                    widget.exploded ? 'COLLAPSE FLOORS' : 'EXPLODE FLOORS',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          // Top Left Layer Toggles
          Positioned(
            top: 14,
            left: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.panel.withOpacity(0.9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.line),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _layerToggle(label: 'Spatial Parcels', active: _showParcels, color: AppTheme.blue, onTap: () => setState(() => _showParcels = !_showParcels)),
                  const SizedBox(width: 6),
                  _layerToggle(label: '3D Units', active: _showPropertyVolumes, color: AppTheme.cyan, onTap: () => setState(() => _showPropertyVolumes = !_showPropertyVolumes)),
                  const SizedBox(width: 6),
                  _layerToggle(label: 'AI Wireframe', active: _showWireframe, color: AppTheme.violet, onTap: () => setState(() => _showWireframe = !_showWireframe)),
                ],
              ),
            ),
          ),

          // Bottom Left Info Badge
          Positioned(
            left: 16,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.panel.withOpacity(0.95),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: widget.highlightedIssueId != null ? AppTheme.amber : AppTheme.cyan,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.building?.name ?? 'LUNARA 3D SPATIAL CADASTRE',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppTheme.text),
                      ),
                      if (widget.exploded) ...[
                        const SizedBox(width: 8),
                        const StatusBadge('EXPLODED STRATA', color: AppTheme.cyan, fontSize: 9),
                      ],
                      if (widget.highlightedIssueId != null) ...[
                        const SizedBox(width: 8),
                        StatusBadge('CONFLICT ${widget.highlightedIssueId}', color: AppTheme.amber, fontSize: 9),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.selectedProperty != null
                        ? 'Selected: Unit ${widget.selectedProperty!.unit} • ${widget.selectedProperty!.usage} • ${widget.selectedProperty!.area} m² • Elevation: +${widget.selectedProperty!.z}m'
                        : 'Blue: Spatial Boundaries • Cyan: ULPIN Units • Violet: AI Slices • Amber: Conflict Scenarios',
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconBtn({required IconData icon, required String tooltip, required VoidCallback onTap}) =>
      Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.panelElevated,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.line),
            ),
            child: Icon(icon, size: 16, color: AppTheme.text),
          ),
        ),
      );

  Widget _layerToggle({required String label, required bool active, required Color color, required VoidCallback onTap}) =>
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: active ? color.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: active ? color.withOpacity(0.4) : Colors.transparent,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: active ? color : AppTheme.textMuted,
            ),
          ),
        ),
      );
}

class _Engine3DPainter extends CustomPainter {
  final Building? building;
  final List<Floor> floors;
  final Floor? selectedFloor;
  final PropertyUnit? selectedProperty;
  final List<String> highlightedPropertyIds;
  final String? highlightedIssueId;
  final double explodeFactor;
  final double yaw;
  final double pitch;
  final double zoom;
  final Offset panOffset;
  final bool showWireframe;
  final bool showParcels;
  final bool showPropertyVolumes;

  _Engine3DPainter({
    this.building,
    this.floors = const [],
    this.selectedFloor,
    this.selectedProperty,
    this.highlightedPropertyIds = const [],
    this.highlightedIssueId,
    required this.explodeFactor,
    required this.yaw,
    required this.pitch,
    required this.zoom,
    required this.panOffset,
    required this.showWireframe,
    required this.showParcels,
    required this.showPropertyVolumes,
  });

  Offset _project(double x, double y, double z, Size size) {
    final cx = size.width * 0.5 + panOffset.dx;
    final cy = size.height * 0.58 + panOffset.dy;

    final cosY = math.cos(yaw);
    final sinY = math.sin(yaw);
    final rx = x * cosY - y * sinY;
    final ry = x * sinY + y * cosY;

    final cosP = math.cos(pitch);
    final sinP = math.sin(pitch);

    final screenX = cx + rx * zoom;
    final screenY = cy + (ry * sinP - z * cosP) * zoom;

    return Offset(screenX, screenY);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawGroundGrid(canvas, size);

    if (showParcels) {
      _drawParcels(canvas, size);
    }

    if (building != null) {
      _drawBuildingAndFloors(canvas, size);
    }
  }

  void _drawGroundGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFF161F2B).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const gridSize = 12;
    const step = 26.0;
    const extent = gridSize * step;

    for (int i = -gridSize; i <= gridSize; i++) {
      final p1 = _project(i * step, -extent, 0, size);
      final p2 = _project(i * step, extent, 0, size);
      canvas.drawLine(p1, p2, gridPaint);

      final p3 = _project(-extent, i * step, 0, size);
      final p4 = _project(extent, i * step, 0, size);
      canvas.drawLine(p3, p4, gridPaint);
    }
  }

  void _drawParcels(Canvas canvas, Size size) {
    final parcelBorder = Paint()
      ..color = AppTheme.blue.withOpacity(0.8) // BLUE for spatial / parcel visualization
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final parcelFill = Paint()
      ..color = const Color(0xFF0F172A).withOpacity(0.4)
      ..style = PaintingStyle.fill;

    // 7 Synthetic demo parcels
    final parcelLayouts = [
      (0.0, 0.0, 180.0, 150.0, 'P001'),
      (210.0, 0.0, 160.0, 150.0, 'P002'),
      (-210.0, 0.0, 160.0, 150.0, 'P003'),
      (0.0, 180.0, 180.0, 140.0, 'P004'),
      (0.0, -180.0, 180.0, 140.0, 'P005'),
      (210.0, 180.0, 140.0, 130.0, 'P006'), // Mock Building A parcel (encroached!)
      (-210.0, 180.0, 160.0, 140.0, 'P007'), // Mock Building B parcel
    ];

    for (final p in parcelLayouts) {
      final x = p.$1 - p.$3 / 2;
      final y = p.$2 - p.$4 / 2;
      final w = p.$3;
      final d = p.$4;

      final p1 = _project(x, y, 0, size);
      final p2 = _project(x + w, y, 0, size);
      final p3 = _project(x + w, y + d, 0, size);
      final p4 = _project(x, y + d, 0, size);

      final path = Path()
        ..moveTo(p1.dx, p1.dy)
        ..lineTo(p2.dx, p2.dy)
        ..lineTo(p3.dx, p3.dy)
        ..lineTo(p4.dx, p4.dy)
        ..close();

      canvas.drawPath(path, parcelFill);
      canvas.drawPath(path, parcelBorder);

      final tp = TextPainter(
        text: TextSpan(
          text: 'PARCEL ${p.$5}',
          style: TextStyle(
            color: AppTheme.blue.withOpacity(0.9),
            fontSize: 9,
            fontWeight: FontWeight.w800,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(p1.dx + 6, p1.dy - 14));
    }
  }

  void _drawBuildingAndFloors(Canvas canvas, Size size) {
    final isB6 = building?.id == 'B006'; // Mock Building A with footprint conflict
    final isB7 = building?.id == 'B007'; // Mock Building B with vertical overlap conflict

    final bw = isB6 ? 170.0 : 130.0;
    final bd = isB6 ? 140.0 : 110.0;
    const floorH = 28.0;
    final totalFloors = building?.floors ?? 3;
    final explodeSpacing = explodeFactor * 52.0;

    // AI Volumetric Guide Rails in VIOLET (#8B5CF6)
    if (explodeFactor > 0.05) {
      final guidePaint = Paint()
        ..color = AppTheme.violet.withOpacity(0.4 * explodeFactor)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      final corners = [
        (-bw / 2, -bd / 2),
        (bw / 2, -bd / 2),
        (bw / 2, bd / 2),
        (-bw / 2, bd / 2),
      ];

      for (final c in corners) {
        final bottom = _project(c.$1, c.$2, 0, size);
        final topZ = (totalFloors - 1) * (floorH + explodeSpacing) + floorH;
        final top = _project(c.$1, c.$2, topZ, size);
        canvas.drawLine(bottom, top, guidePaint);
      }
    }

    // Footprint encroachment conflict marker for B006 in AMBER
    if (isB6) {
      final ep1 = _project(bw / 2 - 20, -bd / 2, 0, size);
      final ep2 = _project(bw / 2 + 10, -bd / 2, 0, size);
      final ep3 = _project(bw / 2 + 10, bd / 2, 0, size);
      final ep4 = _project(bw / 2 - 20, bd / 2, 0, size);

      final encPath = Path()..moveTo(ep1.dx, ep1.dy)..lineTo(ep2.dx, ep2.dy)..lineTo(ep3.dx, ep3.dy)..lineTo(ep4.dx, ep4.dy)..close();
      canvas.drawPath(encPath, Paint()..color = AppTheme.amber.withOpacity(0.35)..style = PaintingStyle.fill);
      canvas.drawPath(encPath, Paint()..color = AppTheme.amber..style = PaintingStyle.stroke..strokeWidth = 2);

      final encLabel = TextPainter(
        text: const TextSpan(
          text: '⚠️ FOOTPRINT ENCROACHMENT (+4.2m)',
          style: TextStyle(color: AppTheme.amber, fontSize: 9, fontWeight: FontWeight.w900),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      encLabel.paint(canvas, Offset(ep3.dx + 4, ep3.dy - 10));
    }

    // Render floor slabs
    for (int lvl = 0; lvl < totalFloors; lvl++) {
      // In B007, level 1 has vertical elevation collision
      final floorZ = (isB7 && lvl == 1 && explodeFactor < 0.2)
          ? (lvl * (floorH + explodeSpacing) - 8.0)
          : lvl * (floorH + explodeSpacing);

      final isFloorSelected = selectedFloor?.level == lvl;

      _drawFloorSlab(
        canvas: canvas,
        size: size,
        level: lvl,
        floorZ: floorZ,
        slabW: bw,
        slabD: bd,
        slabH: floorH,
        isSelected: isFloorSelected,
      );

      if (showPropertyVolumes) {
        _drawPropertyUnits(
          canvas: canvas,
          size: size,
          level: lvl,
          floorZ: floorZ,
          slabW: bw,
          slabD: bd,
          isB7: isB7,
        );
      }
    }
  }

  void _drawFloorSlab({
    required Canvas canvas,
    required Size size,
    required int level,
    required double floorZ,
    required double slabW,
    required double slabD,
    required double slabH,
    required bool isSelected,
  }) {
    final x = -slabW / 2;
    final y = -slabD / 2;

    final b10 = _project(x + slabW, y, floorZ, size);
    final b11 = _project(x + slabW, y + slabD, floorZ, size);
    final b01 = _project(x, y + slabD, floorZ, size);

    final t00 = _project(x, y, floorZ + 5, size);
    final t10 = _project(x + slabW, y, floorZ + 5, size);
    final t11 = _project(x + slabW, y + slabD, floorZ + 5, size);
    final t01 = _project(x, y + slabD, floorZ + 5, size);

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = isSelected ? 2.0 : 1.0
      ..color = isSelected ? AppTheme.cyan : AppTheme.lineHighlight;

    final topPath = Path()
      ..moveTo(t00.dx, t00.dy)
      ..lineTo(t10.dx, t10.dy)
      ..lineTo(t11.dx, t11.dy)
      ..lineTo(t01.dx, t01.dy)
      ..close();

    final topFill = Paint()
      ..style = PaintingStyle.fill
      ..color = isSelected
          ? AppTheme.cyan.withOpacity(0.24)
          : const Color(0xFF141C27).withOpacity(0.85);

    canvas.drawPath(topPath, topFill);
    canvas.drawPath(topPath, strokePaint);

    final frontPath = Path()
      ..moveTo(b01.dx, b01.dy)
      ..lineTo(b11.dx, b11.dy)
      ..lineTo(t11.dx, t11.dy)
      ..lineTo(t01.dx, t01.dy)
      ..close();

    final frontFill = Paint()
      ..style = PaintingStyle.fill
      ..color = isSelected
          ? AppTheme.cyan.withOpacity(0.18)
          : const Color(0xFF0F151F).withOpacity(0.9);

    canvas.drawPath(frontPath, frontFill);
    canvas.drawPath(frontPath, strokePaint);

    final sidePath = Path()
      ..moveTo(b10.dx, b10.dy)
      ..lineTo(b11.dx, b11.dy)
      ..lineTo(t11.dx, t11.dy)
      ..lineTo(t10.dx, t10.dy)
      ..close();

    final sideFill = Paint()
      ..style = PaintingStyle.fill
      ..color = isSelected
          ? AppTheme.cyan.withOpacity(0.20)
          : const Color(0xFF111822).withOpacity(0.88);

    canvas.drawPath(sidePath, sideFill);
    canvas.drawPath(sidePath, strokePaint);

    final labelText = level == 0 ? 'GROUND (+0.0m)' : 'FLOOR $level (+${level * 4}m)';
    final labelPainter = TextPainter(
      text: TextSpan(
        text: labelText,
        style: TextStyle(
          color: isSelected ? AppTheme.cyan : AppTheme.textSecondary,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    labelPainter.paint(canvas, Offset(t01.dx - 4, t01.dy + 4));
  }

  void _drawPropertyUnits({
    required Canvas canvas,
    required Size size,
    required int level,
    required double floorZ,
    required double slabW,
    required double slabD,
    required bool isB7,
  }) {
    const unitCount = 2;
    final unitW = (slabW - 24) / unitCount;
    final unitD = slabD - 20;
    const unitH = 20.0;
    final elevation = floorZ + 5.0;

    for (int u = 0; u < unitCount; u++) {
      final ux = -slabW / 2 + 12 + u * unitW + (u > 0 ? 4 : 0);
      final uy = -slabD / 2 + 10;
      final uw = unitW - 4;
      final ud = unitD;

      final unitCode = 'A-${level + 1}0${u + 1}';
      final propId = '${building?.id ?? "B001"}-U${level + 1}0${u + 1}';

      final isSelected = selectedProperty != null &&
          (selectedProperty!.id == propId || selectedProperty!.unit == unitCode);

      final isHighlightedIssue = highlightedPropertyIds.contains(propId);
      final isOverlap = (isHighlightedIssue && highlightedIssueId == 'V001') ||
          (isHighlightedIssue && highlightedIssueId == 'V004') ||
          (isHighlightedIssue && highlightedIssueId == 'V006') ||
          (isHighlightedIssue && highlightedIssueId == 'V007') ||
          (isB7 && level == 1);

      // Color mapping following strict specification:
      // Conflict: AMBER (#F59E0B)
      // Selected/ULPIN: CYAN (#22D3EE)
      // Validated/Normal: BLUE (#3B82F6) / GREEN (#22C55E)
      Color unitColor;
      if (isOverlap) {
        unitColor = AppTheme.amber; // AMBER for warnings / conflicts
      } else if (isSelected) {
        unitColor = AppTheme.cyan;  // CYAN for selected / active ULPIN
      } else if (u == 0) {
        unitColor = AppTheme.blue;  // BLUE for spatial property unit
      } else {
        unitColor = AppTheme.violet;// VIOLET for commercial / AI classified
      }

      final ut00 = _project(ux, uy, elevation + unitH, size);
      final ut10 = _project(ux + uw, uy, elevation + unitH, size);
      final ut11 = _project(ux + uw, uy + ud, elevation + unitH, size);
      final ut01 = _project(ux, uy + ud, elevation + unitH, size);

      final topPath = Path()
        ..moveTo(ut00.dx, ut00.dy)
        ..lineTo(ut10.dx, ut10.dy)
        ..lineTo(ut11.dx, ut11.dy)
        ..lineTo(ut01.dx, ut01.dy)
        ..close();

      final topPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = unitColor.withOpacity(isSelected || isHighlightedIssue ? 0.85 : 0.65);

      final borderPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected || isHighlightedIssue ? 2.5 : 1.0
        ..color = isSelected
            ? Colors.white
            : isHighlightedIssue
                ? AppTheme.amber
                : unitColor.withOpacity(0.9);

      canvas.drawPath(topPath, topPaint);
      canvas.drawPath(topPath, borderPaint);

      final unitPainter = TextPainter(
        text: TextSpan(
          text: unitCode,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.text,
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      unitPainter.paint(canvas, Offset(ut01.dx + 4, ut01.dy - 16));

      if (isOverlap) {
        final conflictText = (highlightedIssueId == 'V006' || building?.id == 'B006')
            ? '⚠️ BOUNDARY CONFLICT'
            : (highlightedIssueId == 'V007' || building?.id == 'B007'
                ? '⚠️ VERTICAL OVERLAP'
                : '⚠️ SPATIAL OVERLAP');
        final conflictPainter = TextPainter(
          text: TextSpan(
            text: conflictText,
            style: const TextStyle(
              color: AppTheme.amber,
              fontSize: 9,
              fontWeight: FontWeight.w900,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        conflictPainter.paint(canvas, Offset(ut01.dx + 4, ut01.dy - 28));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _Engine3DPainter old) => true;
}
