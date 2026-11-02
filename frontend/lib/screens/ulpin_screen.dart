import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../providers/app_state.dart';
import '../widgets/common.dart';
import '../theme/app_theme.dart';

class UlpinScreen extends StatelessWidget {
  final AppState state;
  const UlpinScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final p = state.selectedProperty;
    final b = state.selectedBuilding;
    final f = state.selectedFloor;

    const resolutionSteps = [
      'IDLE',
      'SELECTED PROPERTY',
      'RESOLVING PARCEL',
      'RESOLVING BUILDING',
      'RESOLVING FLOOR',
      'RESOLVING UNIT',
      'GENERATING SPATIAL ID',
      'VALIDATING BOUNDARY',
      'COMPLETE',
    ];

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Title
        const SectionTitle(
          'Prototype 3D ULPIN Generator',
          subtitle: 'Generates standardized 3D unique property identifiers encoding vertical spatial relationships.',
        ),
        const SizedBox(height: 18),

        if (p == null)
          Panel(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.pin_drop_outlined, size: 48, color: AppTheme.dim),
                    const SizedBox(height: 14),
                    const Text(
                      'No Property Unit Selected',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Select a property unit from the 3D Map to generate its vertical 3D ULPIN.',
                      style: TextStyle(color: AppTheme.muted, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () {
                        state.navIndex = 1;
                        state.notifyListeners();
                      },
                      icon: const Icon(Icons.view_in_ar, size: 16),
                      label: const Text('OPEN 3D MAP'),
                    ),
                  ],
                ),
              ),
            ),
          )
        else ...[
          // Selected Property Summary Card
          Panel(
            title: 'Selected Target Entity',
            trailing: StatusBadge('UNIT ${p.unit}', color: AppTheme.cyan),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Unit ${p.unit}',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.text,
                            ),
                          ),
                          const SizedBox(height: 6),
                          HierarchyBreadcrumb(
                            parcelId: p.parcelId,
                            buildingId: p.buildingId,
                            floorId: p.floorId,
                            unitId: p.unit,
                            onStepTap: (level) {
                              if (level <= 1) state.navIndex = 1;
                              if (level == 3) state.navIndex = 4;
                              state.notifyListeners();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.panel2,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.line),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _statRow('Floor Area', '${p.area.toStringAsFixed(0)} m²'),
                            _statRow('Usage Type', p.usage),
                            _statRow('Elevation (Z)', '+${p.z.toStringAsFixed(1)} m'),
                            _statRow('3D Bounding Box', '${p.width}m × ${p.depth}m × ${p.height}m'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: state.isGeneratingUlpin ? null : state.generateUlpIn,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                  icon: state.isGeneratingUlpin
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF042F2E)),
                        )
                      : const Icon(Icons.auto_awesome, size: 18),
                  label: Text(
                    state.isGeneratingUlpin ? 'GENERATING 3D ULPIN…' : 'GENERATE 3D ULPIN',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Animated Step Resolution Pipeline
          if (state.isGeneratingUlpin || state.ulpinResolutionStep > 0) ...[
            Panel(
              title: '3D Spatial Encoding Resolution Sequence',
              trailing: StatusBadge(
                state.ulpinResolutionStep == 8 ? 'COMPLETED' : 'PROCESSING',
                color: state.ulpinResolutionStep == 8 ? AppTheme.green : AppTheme.cyan,
                dot: true,
              ),
              child: Column(
                children: [
                  LayoutBuilder(builder: (context, constraints) {
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(resolutionSteps.length - 1, (i) {
                        final stepIndex = i + 1;
                        final isPassed = state.ulpinResolutionStep >= stepIndex;
                        final isCurrent = state.ulpinResolutionStep == stepIndex;

                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isPassed
                                ? AppTheme.cyan.withOpacity(0.15)
                                : AppTheme.panelElevated,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isCurrent
                                  ? AppTheme.cyan
                                  : isPassed
                                      ? AppTheme.cyan.withOpacity(0.4)
                                      : AppTheme.line,
                              width: isCurrent ? 2.0 : 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isPassed
                                    ? (stepIndex == 8 ? Icons.check_circle : Icons.check)
                                    : Icons.hourglass_empty,
                                size: 13,
                                color: isPassed ? AppTheme.cyan : AppTheme.textMuted,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                resolutionSteps[stepIndex],
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: isPassed ? FontWeight.w800 : FontWeight.w500,
                                  color: isPassed ? AppTheme.text : AppTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 18),
          ],

          // Generated Prototype 3D ULPIN Display
          if (state.ulpin != null) ...[
            Panel(
              title: 'Assigned Prototype 3D ULPIN',
              trailing: const StatusBadge('ACTIVE RECORD', color: AppTheme.green),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.panelElevated,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.cyan.withOpacity(0.4), width: 1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SelectableText(
                            state.ulpin!.ulpin,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.cyan,
                              letterSpacing: 1.5,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Copy ULPIN',
                          icon: const Icon(Icons.copy, color: AppTheme.cyan, size: 20),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: state.ulpin!.ulpin));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('3D ULPIN copied to clipboard!')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '⚠️ Prototype identifier — not an official ULPIN algorithm or government standard. Demonstrates the concept of vertical spatial encoding.',
                    style: TextStyle(color: AppTheme.muted, fontSize: 11, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 22),

                  // 7 Breakdown Cards: State | District | Demo Area | Parcel | Building | Floor | Unit
                  const Text(
                    'IDENTIFIER HIERARCHY DECOMPOSITION',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.muted),
                  ),
                  const SizedBox(height: 10),
                  LayoutBuilder(builder: (context, constraints) {
                    final cols = constraints.maxWidth > 900 ? 7 : (constraints.maxWidth > 500 ? 4 : 2);
                    final entries = state.ulpin!.parts.entries.toList();
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1.6,
                      ),
                      itemCount: entries.length,
                      itemBuilder: (context, i) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.panel2,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.line),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              entries[i].key.toUpperCase(),
                              style: const TextStyle(color: AppTheme.dim, fontSize: 9, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              entries[i].value,
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: AppTheme.cyan),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 22),

                  // Action Buttons: Export Demo Record & Inspect in 3D
                  Row(
                    children: [
                      FilledButton.icon(
                        onPressed: () => _showExportDialog(context, state),
                        icon: const Icon(Icons.download, size: 16),
                        label: const Text('EXPORT DEMO RECORD'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          state.navIndex = 4; // Property Details screen
                          state.notifyListeners();
                        },
                        icon: const Icon(Icons.account_tree_outlined, size: 16),
                        label: const Text('VIEW PROPERTY RELATIONSHIP'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ],
    );
  }

  Widget _statRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: AppTheme.muted, fontSize: 11)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: AppTheme.text)),
          ],
        ),
      );

  void _showExportDialog(BuildContext context, AppState appState) {
    final recordJson = appState.exportRecord();
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppTheme.panel,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppTheme.line),
        ),
        title: const Row(
          children: [
            Icon(Icons.inventory_2_outlined, color: AppTheme.cyan),
            SizedBox(width: 10),
            Text('Digital Property Record Export', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          ],
        ),
        content: SizedBox(
          width: 540,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Standardized JSON property record encoding 3D bounding geometry, prototype ULPIN, and validation integrity hash.',
                style: TextStyle(color: AppTheme.muted, fontSize: 12),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF090D14),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.line),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    recordJson,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: AppTheme.cyan,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: recordJson));
              Navigator.pop(dialogCtx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Digital Property Record JSON copied to clipboard!')),
              );
            },
            icon: const Icon(Icons.copy, size: 16),
            label: const Text('COPY JSON'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('DONE'),
          ),
        ],
      ),
    );
  }
}
