import 'package:flutter/material.dart';
import '../providers/app_state.dart';
import '../models/models.dart';
import '../widgets/common.dart';
import '../theme/app_theme.dart';

class ValidationScreen extends StatefulWidget {
  final AppState state;
  const ValidationScreen({super.key, required this.state});

  @override
  State<ValidationScreen> createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {
  String _filter = 'ALL';

  @override
  Widget build(BuildContext context) {
    final s = widget.state;
    final validation = s.dashboardData['validation'] as Map<String, dynamic>? ?? {
      'total_checks': 28,
      'passed': 21,
      'warnings': 5,
      'critical': 2,
    };

    final issues = s.issues.isNotEmpty
        ? s.issues
        : [
            ValidationIssue(
              id: 'V001',
              type: 'OVERLAP',
              buildingId: 'B001',
              floorId: 'B001-F01',
              propertyIds: ['B001-U201', 'B001-U202'],
              severity: 'Warning',
              description: 'Synthetic horizontal overlap between adjacent property volumes on Floor 2.',
              status: 'open',
            ),
            ValidationIssue(
              id: 'V002',
              type: 'GAP',
              buildingId: 'B002',
              floorId: 'B002-F02',
              propertyIds: ['B002-U301', 'B002-U302'],
              severity: 'Warning',
              description: 'Synthetic gap detected between floor property boundaries.',
              status: 'open',
            ),
            ValidationIssue(
              id: 'V003',
              type: 'VALID',
              buildingId: 'B003',
              floorId: 'B003-F00',
              propertyIds: ['B003-U101'],
              severity: 'Pass',
              description: 'No spatial conflict detected. Topology matches cadastral boundary.',
              status: 'open',
            ),
            ValidationIssue(
              id: 'V004',
              type: 'OVERLAP',
              buildingId: 'B004',
              floorId: 'B004-F01',
              propertyIds: ['B004-U201', 'B004-U202'],
              severity: 'Critical',
              description: 'Synthetic critical volume intersection requiring spatial review.',
              status: 'open',
            ),
            ValidationIssue(
              id: 'V005',
              type: 'VALID',
              buildingId: 'B005',
              floorId: 'B005-F02',
              propertyIds: ['B005-U301', 'B005-U302'],
              severity: 'Pass',
              description: 'No spatial conflict detected. 3D bounding geometry valid.',
              status: 'open',
            ),
            ValidationIssue(
              id: 'V006',
              type: 'BOUNDARY_ENCROACHMENT',
              buildingId: 'B006',
              floorId: 'B006-F00',
              propertyIds: ['B006-U101', 'B006-U102'],
              severity: 'Critical',
              description: 'Footprint encroachment: Building B006 width (31m) breaches Parcel P006 boundary (26m).',
              status: 'open',
            ),
            ValidationIssue(
              id: 'V007',
              type: 'VERTICAL_OVERLAP',
              buildingId: 'B007',
              floorId: 'B007-F01',
              propertyIds: ['B007-U201', 'B007-U202'],
              severity: 'Warning',
              description: 'Vertical elevation clash: Floor 1 ceiling elevation (+6.4m) intersects Floor 2 base (+6.2m).',
              status: 'open',
            ),
          ];

    final filteredIssues = issues.where((i) {
      if (_filter == 'ALL') return true;
      if (_filter == 'OVERLAP') return i.type == 'OVERLAP' || i.type == 'VERTICAL_OVERLAP';
      if (_filter == 'ENCROACHMENT') return i.type == 'BOUNDARY_ENCROACHMENT';
      if (_filter == 'GAP') return i.type == 'GAP';
      if (_filter == 'VALID') return i.type == 'VALID';
      return true;
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Title & Actions
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: SectionTitle(
                'Spatial Validation & Topology Checks',
                subtitle: 'Automated 3D geometric conflict detection: footprint encroachments, vertical overlaps, and boundary topology.',
              ),
            ),
            FilledButton.icon(
              onPressed: s.runValidation,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('RUN SPATIAL VALIDATION'),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 4 KPI Cards
        Row(
          children: [
            Expanded(
              child: MetricCard(
                label: 'Total Checks',
                value: '${validation['total_checks'] ?? 28}',
                icon: Icons.fact_check_outlined,
                color: AppTheme.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricCard(
                label: 'Passed',
                value: '${validation['passed'] ?? 21}',
                icon: Icons.check_circle_outline,
                color: AppTheme.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricCard(
                label: 'Warnings',
                value: '${validation['warnings'] ?? 5}',
                icon: Icons.warning_amber_rounded,
                color: AppTheme.amber,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricCard(
                label: 'Critical',
                value: '${validation['critical'] ?? 2}',
                icon: Icons.error_outline_rounded,
                color: AppTheme.amber,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Filter Bar
        Panel(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Text('FILTER CHECKS:', style: TextStyle(color: AppTheme.textMuted, fontSize: 11, fontWeight: FontWeight.w800)),
              const SizedBox(width: 14),
              _filterTab('ALL (${issues.length})', 'ALL'),
              const SizedBox(width: 8),
              _filterTab('ENCROACHMENT', 'ENCROACHMENT'),
              const SizedBox(width: 8),
              _filterTab('OVERLAPS', 'OVERLAP'),
              const SizedBox(width: 8),
              _filterTab('GAPS', 'GAP'),
              const SizedBox(width: 8),
              _filterTab('VALID', 'VALID'),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // List of Issue Cards
        Panel(
          title: 'Validation Results & Spatial Conflicts (${filteredIssues.length})',
          trailing: const StatusBadge('SYNTHETIC CHECKS', color: AppTheme.cyan),
          child: Column(
            children: [
              for (final issue in filteredIssues) ...[
                _IssueCard(
                  issue: issue,
                  isSelected: s.selectedIssueId == issue.id,
                  onViewIn3D: () => s.selectIssue(issue),
                  onMarkReviewed: () => s.markIssueReviewed(issue),
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _filterTab(String label, String value) {
    final isSel = _filter == value;
    return InkWell(
      onTap: () => setState(() => _filter = value),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSel ? AppTheme.cyan.withOpacity(0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSel ? AppTheme.cyan : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
            color: isSel ? AppTheme.cyan : AppTheme.textMuted,
          ),
        ),
      ),
    );
  }
}

class _IssueCard extends StatelessWidget {
  final ValidationIssue issue;
  final bool isSelected;
  final VoidCallback onViewIn3D;
  final VoidCallback onMarkReviewed;

  const _IssueCard({
    required this.issue,
    required this.isSelected,
    required this.onViewIn3D,
    required this.onMarkReviewed,
  });

  @override
  Widget build(BuildContext context) {
    final isCritical = issue.severity == 'Critical';
    final isWarning = issue.severity == 'Warning';
    final color = isCritical || isWarning ? AppTheme.amber : AppTheme.green;
    final isReviewed = issue.status == 'reviewed';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? color.withOpacity(0.12) : AppTheme.panelElevated,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? color : AppTheme.line,
          width: isSelected ? 2.0 : 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              issue.type.contains('ENCROACH')
                  ? Icons.domain_disabled_rounded
                  : issue.type.contains('OVERLAP')
                      ? Icons.layers
                      : issue.type == 'GAP'
                          ? Icons.space_bar
                          : Icons.check_circle_outline,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),

          // Content Body
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${issue.type.replaceAll('_', ' ')} • ${issue.id}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(width: 10),
                    StatusBadge(issue.severity.toUpperCase(), color: color, fontSize: 9),
                    const SizedBox(width: 6),
                    StatusBadge(
                      isReviewed ? 'REVIEWED' : 'OPEN',
                      color: isReviewed ? AppTheme.green : AppTheme.textMuted,
                      fontSize: 9,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  issue.description,
                  style: const TextStyle(color: AppTheme.text, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.apartment_outlined, size: 14, color: AppTheme.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      'Building ${issue.buildingId} • Floor ${issue.floorId}',
                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.home_work_outlined, size: 14, color: AppTheme.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      'Affected: ${issue.propertyIds.join(', ')}',
                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Action Buttons
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FilledButton.icon(
                onPressed: onViewIn3D,
                style: FilledButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: const Color(0xFF042F2E),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                icon: const Icon(Icons.view_in_ar, size: 15),
                label: const Text('VIEW IN 3D MAP', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(height: 6),
              if (!isReviewed && issue.type != 'VALID')
                OutlinedButton.icon(
                  onPressed: onMarkReviewed,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  ),
                  icon: const Icon(Icons.check, size: 13),
                  label: const Text('MARK REVIEWED', style: TextStyle(fontSize: 10)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
