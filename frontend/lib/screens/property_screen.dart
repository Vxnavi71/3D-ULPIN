import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../providers/app_state.dart';
import '../widgets/common.dart';
import '../theme/app_theme.dart';

class PropertyScreen extends StatelessWidget {
  final AppState state;
  const PropertyScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final p = state.selectedProperty;
    final b = state.selectedBuilding;
    final f = state.selectedFloor;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Title
        const SectionTitle(
          'Digital Property Record & Spatial Hierarchy',
          subtitle: 'Interactive cadastral tree showing Parcel → Building → Floor → Property vertical mapping.',
        ),
        const SizedBox(height: 20),

        if (p == null)
          Panel(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.account_tree_outlined, size: 48, color: AppTheme.dim),
                    const SizedBox(height: 14),
                    const Text('No Property Selected', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    const Text('Please select a property unit from the 3D Map.', style: TextStyle(color: AppTheme.muted, fontSize: 12)),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () {
                        state.navIndex = 1;
                        state.notifyListeners();
                      },
                      child: const Text('GO TO 3D MAP'),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: Property Digital Record Card
              Expanded(
                flex: 6,
                child: Panel(
                  title: 'Digital Property Registry Card',
                  trailing: StatusBadge('UNIT ${p.unit}', color: AppTheme.cyan),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Unit ${p.unit}',
                                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: AppTheme.text),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${p.usage} • ${p.area.toStringAsFixed(0)} m² Living Space',
                                style: const TextStyle(color: AppTheme.muted, fontSize: 13),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppTheme.panel2,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppTheme.line),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('ELEVATION', style: TextStyle(color: AppTheme.dim, fontSize: 9, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 2),
                                Text('+${p.z.toStringAsFixed(1)} m', style: const TextStyle(color: AppTheme.cyan, fontSize: 16, fontWeight: FontWeight.w900)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 16),

                      // Attributes Grid
                      _attrRow('System ID', p.id, Icons.tag),
                      _attrRow('Cadastral Parcel', p.parcelId, Icons.map_outlined),
                      _attrRow('Building Volume', '${p.buildingId} (${b?.name ?? "LUNARA Structure"})', Icons.apartment_outlined),
                      _attrRow('Floor Level', '${p.floorId} (${f?.name ?? "Floor Level"})', Icons.layers_outlined),
                      _attrRow('3D Coordinates [X, Y, Z]', '(${p.x}, ${p.y}, ${p.z}) meters', Icons.straighten),
                      _attrRow('Dimensions [W × D × H]', '${p.width}m × ${p.depth}m × ${p.height}m', Icons.crop_free),
                      _attrRow('Prototype 3D ULPIN', state.ulpin?.ulpin ?? 'TS-HYD-D01-${p.parcelId}-${p.buildingId}-F01-U001', Icons.pin_drop_outlined, isHighlight: true),
                      _attrRow('Spatial Validation Status', state.selectedIssueId == null ? 'VALID (Passed all 24 checks)' : 'FLAGGED (Review Required)', Icons.fact_check_outlined, isStatus: true),

                      const SizedBox(height: 22),
                      Row(
                        children: [
                          FilledButton.icon(
                            onPressed: () {
                              state.navIndex = 2; // ULPIN generator
                              state.notifyListeners();
                            },
                            icon: const Icon(Icons.qr_code, size: 16),
                            label: const Text('VIEW / GENERATE ULPIN'),
                          ),
                          const SizedBox(width: 10),
                          OutlinedButton.icon(
                            onPressed: () => _showExport(context, state),
                            icon: const Icon(Icons.file_download_outlined, size: 16),
                            label: const Text('EXPORT RECORD JSON'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 18),

              // Right Column: Interactive Spatial Hierarchy Graph
              Expanded(
                flex: 5,
                child: Panel(
                  title: 'Spatial Hierarchy Tree',
                  trailing: const StatusBadge('4-TIER MODEL', color: AppTheme.teal),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Click any level below to navigate to its 3D spatial layer.',
                        style: TextStyle(color: AppTheme.muted, fontSize: 11),
                      ),
                      const SizedBox(height: 20),

                      _treeNode(
                        icon: Icons.map_outlined,
                        tag: 'TIER 1: 2D PARCEL',
                        title: p.parcelId,
                        subtitle: 'Area: 1,035 m² • Cadastral Zone D01',
                        color: AppTheme.blue,
                        onTap: () {
                          state.setNav(1);
                        },
                      ),
                      _treeConnector(),

                      _treeNode(
                        icon: Icons.apartment_outlined,
                        tag: 'TIER 2: 3D BUILDING',
                        title: p.buildingId,
                        subtitle: '${b?.name ?? "LUNARA Building"} • 3 Floors • Height: 12m',
                        color: AppTheme.violet,
                        onTap: () {
                          state.setNav(1);
                        },
                      ),
                      _treeConnector(),

                      _treeNode(
                        icon: Icons.layers_outlined,
                        tag: 'TIER 3: FLOOR STRATA',
                        title: p.floorId,
                        subtitle: '${f?.name ?? "Floor 2"} • Elevation: +${p.z}m',
                        color: AppTheme.cyan,
                        onTap: () {
                          state.exploded = true;
                          state.setNav(1);
                        },
                      ),
                      _treeConnector(),

                      _treeNode(
                        icon: Icons.home_work_outlined,
                        tag: 'TIER 4: PROPERTY UNIT',
                        title: 'Unit ${p.unit} (${p.id})',
                        subtitle: '${p.usage} • ${p.area} m² • 3D Bounding Box',
                        color: AppTheme.green,
                        isTarget: true,
                        onTap: () {},
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

  Widget _attrRow(String label, String value, IconData icon, {bool isHighlight = false, bool isStatus = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16, color: AppTheme.textMuted),
            const SizedBox(width: 10),
            SizedBox(
              width: 170,
              child: Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: isHighlight
                      ? AppTheme.cyan
                      : isStatus
                          ? (value.startsWith('VALID') ? AppTheme.green : AppTheme.amber)
                          : AppTheme.text,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _treeNode({
    required IconData icon,
    required String tag,
    required String title,
    required String subtitle,
    required Color color,
    bool isTarget = false,
    required VoidCallback onTap,
  }) =>
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isTarget ? color.withValues(alpha: 0.15) : AppTheme.panel2,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isTarget ? color : AppTheme.line,
              width: isTarget ? 2.0 : 1.0,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tag, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppTheme.text)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(color: AppTheme.muted, fontSize: 11)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward, size: 14, color: AppTheme.dim),
            ],
          ),
        ),
      );

  Widget _treeConnector() => Container(
        height: 20,
        margin: const EdgeInsets.only(left: 30),
        decoration: const BoxDecoration(
          border: Border(left: BorderSide(color: AppTheme.lineHighlight, width: 2)),
        ),
      );

  void _showExport(BuildContext context, AppState appState) {
    final data = appState.exportRecord();
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppTheme.panel,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: AppTheme.line)),
        title: const Text('Export Digital Property Record'),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: SelectableText(
              data,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: AppTheme.cyan),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: data));
              Navigator.pop(dialogCtx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('JSON copied to clipboard!')));
            },
            child: const Text('COPY JSON'),
          ),
          FilledButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('CLOSE')),
        ],
      ),
    );
  }
}
