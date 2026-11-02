import 'package:flutter/material.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class SettingsScreen extends StatefulWidget {
  final AppState state;
  final VoidCallback onShowSplash;
  final VoidCallback onShowRegister;

  const SettingsScreen({
    super.key,
    required this.state,
    required this.onShowSplash,
    required this.onShowRegister,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _crs = 'EPSG:7755 (India National Grid)';
  String _units = 'Metric (Meters, m²)';
  bool _wireframe = false;
  double _explosionGap = 52.0;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        // Title
        const SectionTitle(
          'System Settings & Preferences',
          subtitle: 'Configure geospatial reference systems, 3D display parameters, and prototype demonstration profiles.',
        ),
        const SizedBox(height: 24),

        // Section 1: Application Preferences
        Panel(
          title: 'Geospatial & Cadastral Configuration',
          child: Column(
            children: [
              _settingRow(
                title: 'Coordinate Reference System (CRS)',
                desc: 'National cadastral datum projection for geometric calculations.',
                child: DropdownButton<String>(
                  value: _crs,
                  dropdownColor: AppTheme.panelElevated,
                  underline: const SizedBox(),
                  items: [
                    'EPSG:7755 (India National Grid)',
                    'EPSG:4326 (WGS84 Lat/Lon)',
                    'EPSG:32644 (UTM Zone 44N)',
                  ].map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12)))).toList(),
                  onChanged: (v) => setState(() => _crs = v ?? _crs),
                ),
              ),
              const Divider(),
              _settingRow(
                title: 'Measurement System',
                desc: 'Unit conventions for 3D volumetric surfaces and land parcel areas.',
                child: DropdownButton<String>(
                  value: _units,
                  dropdownColor: AppTheme.panelElevated,
                  underline: const SizedBox(),
                  items: [
                    'Metric (Meters, m²)',
                    'Imperial (Feet, sq ft)',
                  ].map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12)))).toList(),
                  onChanged: (v) => setState(() => _units = v ?? _units),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Section 2: Display & Theme Color Semantics
        Panel(
          title: 'UI/UX Visual Language & Semantic Color System',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'LUNARA functional color semantics (Dark neutral foundation 75%, functional 25%):',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _colorTag('CYAN (#22D3EE)', 'Primary Actions / 3D ULPIN / Active Navigation', AppTheme.cyan),
                  _colorTag('BLUE (#3B82F6)', 'Spatial & Cadastral Map Elements / Boundaries', AppTheme.blue),
                  _colorTag('VIOLET (#8B5CF6)', 'AI & 3D Volumetric Intelligence Analysis', AppTheme.violet),
                  _colorTag('GREEN (#22C55E)', 'Validated & Verified Topology States', AppTheme.green),
                  _colorTag('AMBER (#F59E0B)', 'Spatial Conflicts & Warnings (B006, B007)', AppTheme.amber),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 14),
              _settingRow(
                title: '3D Floor Explosion Distance',
                desc: 'Vertical gap between extruded slabs during explosion.',
                child: SizedBox(
                  width: 180,
                  child: Slider(
                    value: _explosionGap,
                    min: 20,
                    max: 100,
                    activeColor: AppTheme.cyan,
                    onChanged: (v) => setState(() => _explosionGap = v),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _settingRow(
                title: '3D Wireframe Overlay Mode',
                desc: 'Render transparent volume edges with high-contrast guide lines.',
                child: Switch(
                  value: _wireframe,
                  activeColor: AppTheme.cyan,
                  onChanged: (v) => setState(() => _wireframe = v),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Section 3: Demo & Prototype Information
        Panel(
          title: 'Smart India Hackathon 2026 Prototype Identity',
          trailing: const StatusBadge('DEMO MODE • SYNTHETIC DATA', color: AppTheme.amber, dot: true),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoRow('Problem Statement', 'PS-26011: 3D ULPIN Generation & Vertical Property Mapping'),
              _infoRow('Team Name / ID', 'LUNARA (Team ID: 168736)'),
              _infoRow('Cadastral Inventory', '7 Parcels • 7 Buildings • 21 Floors • 42 Property Units'),
              _infoRow('Mock Conflict Scenarios', 'B006 Footprint Boundary Encroachment • B007 Vertical Elevation Overlap'),
              _infoRow('Engine Architecture', 'Python 3.13 FastAPI Backend • Flutter Material 3 GIS Frontend'),
              const SizedBox(height: 20),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: widget.onShowSplash,
                    icon: const Icon(Icons.fullscreen, size: 16),
                    label: const Text('VIEW SPLASH SCREEN'),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton.icon(
                    onPressed: widget.onShowRegister,
                    icon: const Icon(Icons.person_add_outlined, size: 16),
                    label: const Text('PROTOTYPE REGISTRATION'),
                  ),
                  const SizedBox(width: 10),
                  FilledButton.icon(
                    onPressed: widget.state.startJudgeDemo,
                    icon: const Icon(Icons.play_circle_fill, size: 16),
                    label: const Text('START JUDGE DEMO'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _settingRow({required String title, required String desc, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppTheme.text)),
                const SizedBox(height: 2),
                Text(desc, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 200,
            child: Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppTheme.text)),
          ),
        ],
      ),
    );
  }

  Widget _colorTag(String title, String desc, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.panelElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: color)),
              Text(desc, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}
