import 'package:flutter/material.dart';
import '../providers/app_state.dart';
import '../widgets/common.dart';
import '../widgets/map_3d.dart';
import '../theme/app_theme.dart';

class MapScreen extends StatelessWidget {
  final AppState state;
  const MapScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final building = state.selectedBuilding;
    final floors = state.buildingFloors;
    final selectedFloor = state.selectedFloor;
    final selectedProp = state.selectedProperty;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Title & Active Mode
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: SectionTitle(
                '3D Map Cadastre',
                subtitle: 'Controlled 3D environment for vertical property mapping and spatial hierarchy resolution.',
              ),
            ),
            if (state.selectedIssueId != null) ...[
              StatusBadge(
                'HIGHLIGHTING CONFLICT ${state.selectedIssueId}',
                color: AppTheme.amber,
                dot: true,
              ),
              const SizedBox(width: 8),
              IconButton.outlined(
                tooltip: 'Clear Highlight',
                icon: const Icon(Icons.close, size: 16),
                onPressed: () => state.resetMap(),
              ),
            ],
          ],
        ),
        const SizedBox(height: 18),

        // 3D Interactive Map Canvas
        Map3D(
          building: building,
          floors: floors,
          selectedFloor: selectedFloor,
          selectedProperty: selectedProp,
          highlightedIssueId: state.selectedIssueId,
          highlightedPropertyIds: state.highlightedPropertyIds,
          exploded: state.exploded,
          onExplode: state.toggleExplode,
          onReset: state.resetMap,
          onSelectFloor: state.selectFloor,
          onSelectProperty: state.selectProperty,
        ),
        const SizedBox(height: 18),

        // Hierarchy Selector Strip: Parcel -> Building -> Floor
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Parcel & Building Selectors
            Expanded(
              flex: 5,
              child: Panel(
                title: 'Cadastral & Building Selectors',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('PARCELS (2D LAND BOUNDARIES)', style: TextStyle(color: AppTheme.textMuted, fontSize: 10, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: state.parcels.map((p) {
                        final isSel = p.id == building?.parcelId;
                        return ChoiceChip(
                          label: Text(p.id),
                          selected: isSel,
                          onSelected: (_) async {
                            final b = state.buildings.firstWhere((x) => x.parcelId == p.id, orElse: () => state.buildings.first);
                            await state.selectBuilding(b);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    const Text('BUILDINGS (3D STRUCTURE VOLUMES)', style: TextStyle(color: AppTheme.textMuted, fontSize: 10, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: state.buildings.map((b) {
                        final isConflictB = b.id == 'B006' || b.id == 'B007';
                        final isSel = b.id == building?.id;
                        return ChoiceChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(b.id),
                              if (isConflictB) ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.warning_amber_rounded, size: 13, color: AppTheme.amber),
                              ],
                            ],
                          ),
                          selected: isSel,
                          selectedColor: isConflictB ? AppTheme.amber.withOpacity(0.2) : null,
                          onSelected: (_) => state.selectBuilding(b),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Floor Strata Selector
            Expanded(
              flex: 6,
              child: Panel(
                title: 'Vertical Floor Strata',
                trailing: StatusBadge('${floors.length} LEVELS', color: AppTheme.cyan),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select vertical level to reveal interior 3D property units and generate spatial coordinates.',
                      style: TextStyle(color: AppTheme.textMuted, fontSize: 11),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: floors.map((f) {
                        final isSel = f.id == selectedFloor?.id;
                        return InkWell(
                          onTap: () => state.selectFloor(f),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSel ? AppTheme.cyan.withOpacity(0.18) : AppTheme.panelElevated,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSel ? AppTheme.cyan : AppTheme.line,
                                width: isSel ? 1.5 : 1.0,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.layers_outlined,
                                  size: 16,
                                  color: isSel ? AppTheme.cyan : AppTheme.textMuted,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  f.name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                                    color: isSel ? AppTheme.cyan : AppTheme.text,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '(+${f.level * 4}m)',
                                  style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // Property Units on Selected Floor
        if (selectedFloor != null) ...[
          Panel(
            title: 'Property Units on ${selectedFloor.name} (${selectedFloor.properties.length} Units)',
            trailing: selectedProp != null
                ? StatusBadge('SELECTED: ${selectedProp.unit}', color: AppTheme.cyan)
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Click a unit below to focus spatial volume, inspect dimensions, and generate prototype 3D ULPIN.',
                  style: TextStyle(color: AppTheme.textMuted, fontSize: 11),
                ),
                const SizedBox(height: 14),
                LayoutBuilder(builder: (context, constraints) {
                  final cols = constraints.maxWidth > 800 ? 2 : 1;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      mainAxisExtent: 110,
                    ),
                    itemCount: selectedFloor.properties.length,
                    itemBuilder: (context, idx) {
                      final p = selectedFloor.properties[idx];
                      final isSel = p.id == selectedProp?.id;
                      final isConflict = state.highlightedPropertyIds.contains(p.id);

                      return InkWell(
                        onTap: () => state.selectProperty(p),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isSel
                                ? AppTheme.cyan.withOpacity(0.12)
                                : isConflict
                                    ? AppTheme.amber.withOpacity(0.12)
                                    : AppTheme.panelElevated,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSel
                                  ? AppTheme.cyan
                                  : isConflict
                                      ? AppTheme.amber
                                      : AppTheme.line,
                              width: isSel || isConflict ? 2.0 : 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: isConflict
                                      ? AppTheme.amber.withOpacity(0.15)
                                      : p.usage == 'Residential'
                                          ? AppTheme.blue.withOpacity(0.15)
                                          : AppTheme.violet.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  isConflict
                                      ? Icons.warning_amber_rounded
                                      : p.usage == 'Residential'
                                          ? Icons.home_outlined
                                          : Icons.storefront_outlined,
                                  color: isConflict
                                      ? AppTheme.amber
                                      : p.usage == 'Residential'
                                          ? AppTheme.blue
                                          : AppTheme.violet,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'UNIT ${p.unit}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900,
                                            color: AppTheme.text,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        StatusBadge(
                                          p.usage.toUpperCase(),
                                          color: p.usage == 'Residential' ? AppTheme.blue : AppTheme.violet,
                                          fontSize: 9,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Area: ${p.area.toStringAsFixed(0)} m² • Dim: ${p.width}m × ${p.depth}m × ${p.height}m',
                                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSel)
                                FilledButton.icon(
                                  onPressed: () {
                                    state.navIndex = 2; // Jump to ULPIN generator
                                    state.notifyListeners();
                                  },
                                  style: FilledButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  icon: const Icon(Icons.qr_code, size: 15),
                                  label: const Text('GENERATE ULPIN', style: TextStyle(fontSize: 11)),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
