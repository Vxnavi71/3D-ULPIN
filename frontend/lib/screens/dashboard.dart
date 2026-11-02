import 'package:flutter/material.dart';
import '../providers/app_state.dart';
import '../widgets/common.dart';
import '../theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  final AppState state;
  final VoidCallback startDemo;

  const DashboardScreen({
    super.key,
    required this.state,
    required this.startDemo,
  });

  @override
  Widget build(BuildContext context) {
    final d = state.dashboardData;
    final val = d['validation'] as Map<String, dynamic>? ?? {
      'total_checks': 28,
      'passed': 21,
      'warnings': 5,
      'critical': 2,
    };

    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        // Title & Badges
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: SectionTitle(
                'Command Center',
                subtitle: 'LUNARA • 3D ULPIN Generation & Vertical Property Mapping System (SIH PS-26011)',
              ),
            ),
            const SizedBox(width: 12),
            const StatusBadge('PS-26011', color: AppTheme.blue),
            const SizedBox(width: 8),
            const StatusBadge('TEAM: 168736', color: AppTheme.violet),
            const SizedBox(width: 8),
            const StatusBadge('DEMO MODE • SYNTHETIC DATA', color: AppTheme.amber, dot: true),
          ],
        ),
        const SizedBox(height: 24),

        // 6 KPI Cards
        LayoutBuilder(builder: (context, constraints) {
          final columns = constraints.maxWidth > 1100 ? 6 : (constraints.maxWidth > 700 ? 3 : 2);
          return GridView.count(
            crossAxisCount: columns,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.5,
            children: [
              MetricCard(
                label: 'Parcels',
                value: '${d['parcels'] ?? 7}',
                icon: Icons.map_outlined,
                color: AppTheme.blue,
                subtext: 'Cadastral zones',
              ),
              MetricCard(
                label: 'Buildings',
                value: '${d['buildings'] ?? 7}',
                icon: Icons.apartment_outlined,
                color: AppTheme.violet,
                subtext: 'Extruded volumes',
              ),
              MetricCard(
                label: 'Floors',
                value: '${d['floors'] ?? 21}',
                icon: Icons.layers_outlined,
                color: AppTheme.cyan,
                subtext: 'Vertical strata',
              ),
              MetricCard(
                label: 'Property Units',
                value: '${d['properties'] ?? 42}',
                icon: Icons.home_work_outlined,
                color: AppTheme.blue,
                subtext: 'Spatial records',
              ),
              MetricCard(
                label: '3D ULPINs',
                value: '${d['ulpins'] ?? 42}',
                icon: Icons.pin_drop_outlined,
                color: AppTheme.cyan,
                subtext: '100% indexed',
              ),
              MetricCard(
                label: 'Validation Issues',
                value: '${d['validation_issues'] ?? 7}',
                icon: Icons.rule_folder_outlined,
                color: AppTheme.amber,
                subtext: 'Mock B006 & B007',
              ),
            ],
          );
        }),
        const SizedBox(height: 22),

        // Central 3D City Visualization Panel
        Panel(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '3D Vertical Cadastre Overview',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.text),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Fictional Demonstration Area: LUNARA DEMO CITY (7 Buildings including Mock A & B)',
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          state.navIndex = 1;
                          state.notifyListeners();
                        },
                        icon: const Icon(Icons.view_in_ar, size: 16),
                        label: const Text('EXPLORE 3D MAP'),
                      ),
                      const SizedBox(width: 10),
                      FilledButton.icon(
                        onPressed: startDemo,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.cyan,
                          foregroundColor: const Color(0xFF042F2E),
                        ),
                        icon: const Icon(Icons.play_circle_fill, size: 18),
                        label: const Text('START LIVE DEMO'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                height: 240,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppTheme.bg,
                  border: Border.all(color: AppTheme.line),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: _MiniCityInteractivePainter(),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),

        // Analytics Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Spatial Validation Summary
            Expanded(
              flex: 5,
              child: Panel(
                title: 'Spatial Conflict Validation Health',
                trailing: StatusBadge('${val['passed']}/28 PASS', color: AppTheme.green),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Automated topology checks evaluating 3D overlaps, boundary gaps, footprint encroachment, and vertical alignment.',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SizedBox(
                        height: 12,
                        child: Row(
                          children: [
                            Expanded(
                              flex: val['passed'] as int? ?? 21,
                              child: Container(color: AppTheme.green),
                            ),
                            Expanded(
                              flex: val['warnings'] as int? ?? 5,
                              child: Container(color: AppTheme.amber),
                            ),
                            Expanded(
                              flex: val['critical'] as int? ?? 2,
                              child: Container(color: const Color(0xFFEF4444)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _legendItem('Passed (${val['passed'] ?? 21})', AppTheme.green),
                        _legendItem('Warnings (${val['warnings'] ?? 5})', AppTheme.amber),
                        _legendItem('Critical (${val['critical'] ?? 2})', const Color(0xFFEF4444)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        FilledButton.icon(
                          onPressed: () {
                            state.runValidation();
                            state.navIndex = 3;
                            state.notifyListeners();
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.cyan,
                            foregroundColor: const Color(0xFF042F2E),
                          ),
                          icon: const Icon(Icons.fact_check, size: 15),
                          label: const Text('RUN SPATIAL VALIDATION'),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton.icon(
                          onPressed: () {
                            state.navIndex = 3;
                            state.notifyListeners();
                          },
                          icon: const Icon(Icons.list_alt, size: 15),
                          label: const Text('VIEW ALL ISSUES'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Workflow Pipeline Summary
            Expanded(
              flex: 6,
              child: Panel(
                title: 'Architecture & SIH Workflow',
                trailing: const StatusBadge('8-STAGE PIPELINE', color: AppTheme.violet),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DATA → DETECTION → EXTRACTION → 3D GEOMETRY → MAPPING → ULPIN → VALIDATION → VERIFICATION',
                      style: TextStyle(
                        color: AppTheme.cyan,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Demonstrating the transition from flat 2D land titles toward connected 3D property identities for high-density modern cities.',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.5),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        FilledButton.tonalIcon(
                          onPressed: () {
                            state.runPipeline();
                          },
                          icon: const Icon(Icons.rocket_launch, size: 15),
                          label: const Text('RUN PIPELINE AGENTS'),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton.icon(
                          onPressed: () {
                            state.navIndex = 2;
                            state.notifyListeners();
                          },
                          icon: const Icon(Icons.qr_code, size: 15),
                          label: const Text('ULPIN GENERATOR'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _legendItem(String text, Color color) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.text)),
        ],
      );
}

class _MiniCityInteractivePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2 + 30;

    final linePaint = Paint()
      ..color = const Color(0xFF1E293B).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Ground Grid
    for (int i = -10; i <= 10; i++) {
      final x1 = cx + (i * 35) - 300;
      final y1 = cy + (i * 18) - 150;
      final x2 = cx + (i * 35) + 300;
      final y2 = cy + (i * 18) + 150;
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), linePaint);

      final x3 = cx - (i * 35) + 300;
      final y3 = cy + (i * 18) - 150;
      final x4 = cx - (i * 35) - 300;
      final y4 = cy + (i * 18) + 150;
      canvas.drawLine(Offset(x3, y3), Offset(x4, y4), linePaint);
    }

    // 7 3D Buildings (including B006 Footprint Conflict & B007 Vertical Overlap)
    final buildings = [
      (0.0, 0.0, 48.0, 42.0, 90.0, 'B001', AppTheme.cyan),
      (130.0, -30.0, 40.0, 36.0, 75.0, 'B002', AppTheme.blue),
      (-130.0, -20.0, 42.0, 38.0, 80.0, 'B003', AppTheme.violet),
      (60.0, 70.0, 44.0, 38.0, 65.0, 'B004', AppTheme.blue),
      (-70.0, 60.0, 42.0, 36.0, 70.0, 'B005', AppTheme.green),
      (150.0, 70.0, 52.0, 44.0, 72.0, 'B006 (Mock A)', AppTheme.amber), // Footprint Conflict
      (-150.0, 80.0, 42.0, 36.0, 68.0, 'B007 (Mock B)', AppTheme.amber), // Vertical Conflict
    ];

    for (final b in buildings) {
      final bx = cx + (b.$1 - b.$2) * 0.866;
      final by = cy + (b.$1 + b.$2) * 0.5;
      final bw = b.$3;
      final bd = b.$4;
      final bh = b.$5;
      final c = b.$7;

      final t0 = Offset(bx, by - bh);
      final t1 = Offset(bx + bw * 0.866, by + bw * 0.5 - bh);
      final t2 = Offset(bx + (bw - bd) * 0.866, by + (bw + bd) * 0.5 - bh);
      final t3 = Offset(bx - bd * 0.866, by + bd * 0.5 - bh);

      final b1 = Offset(bx + bw * 0.866, by + bw * 0.5);
      final b2 = Offset(bx + (bw - bd) * 0.866, by + (bw + bd) * 0.5);
      final b3 = Offset(bx - bd * 0.866, by + bd * 0.5);

      final topPath = Path()..moveTo(t0.dx, t0.dy)..lineTo(t1.dx, t1.dy)..lineTo(t2.dx, t2.dy)..lineTo(t3.dx, t3.dy)..close();
      canvas.drawPath(topPath, Paint()..color = c.withOpacity(0.35)..style = PaintingStyle.fill);
      canvas.drawPath(topPath, Paint()..color = c.withOpacity(0.8)..style = PaintingStyle.stroke..strokeWidth = 1.2);

      final leftPath = Path()..moveTo(t3.dx, t3.dy)..lineTo(t2.dx, t2.dy)..lineTo(b2.dx, b2.dy)..lineTo(b3.dx, b3.dy)..close();
      canvas.drawPath(leftPath, Paint()..color = const Color(0xFF0F151F).withOpacity(0.85)..style = PaintingStyle.fill);
      canvas.drawPath(leftPath, Paint()..color = AppTheme.line..style = PaintingStyle.stroke..strokeWidth = 1.0);

      final rightPath = Path()..moveTo(t1.dx, t1.dy)..lineTo(t2.dx, t2.dy)..lineTo(b2.dx, b2.dy)..lineTo(b1.dx, b1.dy)..close();
      canvas.drawPath(rightPath, Paint()..color = const Color(0xFF141C27).withOpacity(0.9)..style = PaintingStyle.fill);
      canvas.drawPath(rightPath, Paint()..color = AppTheme.line..style = PaintingStyle.stroke..strokeWidth = 1.0);

      for (int f = 1; f < 3; f++) {
        final fz = bh * (f / 3);
        final ft1 = Offset(bx + bw * 0.866, by + bw * 0.5 - fz);
        final ft2 = Offset(bx + (bw - bd) * 0.866, by + (bw + bd) * 0.5 - fz);
        final ft3 = Offset(bx - bd * 0.866, by + bd * 0.5 - fz);
        canvas.drawLine(ft3, ft2, Paint()..color = c.withOpacity(0.4)..strokeWidth = 1.0);
        canvas.drawLine(ft1, ft2, Paint()..color = c.withOpacity(0.4)..strokeWidth = 1.0);
      }

      final tp = TextPainter(
        text: TextSpan(text: b.$6, style: TextStyle(color: c, fontSize: 9, fontWeight: FontWeight.w900)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(t0.dx - 16, t0.dy - 16));
    }
  }

  @override
  bool shouldRepaint(_MiniCityInteractivePainter old) => false;
}
