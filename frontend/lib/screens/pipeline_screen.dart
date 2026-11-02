import 'package:flutter/material.dart';
import '../providers/app_state.dart';
import '../widgets/common.dart';
import '../theme/app_theme.dart';

class PipelineScreen extends StatelessWidget {
  final AppState state;
  const PipelineScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    const stageNames = [
      ('DATA', 'Cadastral parcel ingestion & geospatial normalization', Icons.dataset_outlined),
      ('BUILDING DETECTION', 'Structural footprint detection from synthetic 2D parcel plans', Icons.apartment_outlined),
      ('FLOOR EXTRACTION', 'Vertical level separation & elevation slicing', Icons.layers_outlined),
      ('3D GEOMETRY', '3D volumetric mesh generation & local coordinate assignment', Icons.view_in_ar_outlined),
      ('PROPERTY MAPPING', 'Graph linkage: Parcel → Building → Floor → Property Units', Icons.account_tree_outlined),
      ('3D ULPIN', 'Spatial encoding & prototype 3D ULPIN generation', Icons.pin_drop_outlined),
      ('VALIDATION', 'Geometric overlap detection, gap analysis & topological verification', Icons.rule_folder_outlined),
      ('VERIFICATION', 'Cryptographic digital property record hashing & immutable registry logging', Icons.verified_outlined),
    ];

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Title & Actions
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: SectionTitle(
                'Live Processing Pipeline',
                subtitle: 'End-to-end data transformation: Data → AI Agents → 3D Mapping → ULPIN → Database → Verification → Web.',
              ),
            ),
            FilledButton.icon(
              onPressed: state.pipelineRunning ? null : state.runPipeline,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
              icon: state.pipelineRunning
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF042F2E)),
                    )
                  : const Icon(Icons.play_arrow, size: 18),
              label: Text(
                state.pipelineRunning ? 'PROCESSING PIPELINE…' : 'RUN DEMO PIPELINE',
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Pipeline Stages Vertical Stepper
        Panel(
          title: 'Modular Agent Workflow Stages (8)',
          trailing: StatusBadge(
            state.pipelineRunning
                ? 'EXECUTING AGENTS'
                : state.pipeline.isNotEmpty
                    ? 'ALL STAGES COMPLETE'
                    : 'READY TO RUN',
            color: state.pipelineRunning
                ? AppTheme.cyan
                : state.pipeline.isNotEmpty
                    ? AppTheme.green
                    : AppTheme.textMuted,
            dot: true,
          ),
          child: Column(
            children: [
              for (int i = 0; i < stageNames.length; i++) ...[
                _StageRow(
                  index: i + 1,
                  name: stageNames[i].$1,
                  subtitle: stageNames[i].$2,
                  icon: stageNames[i].$3,
                  isComplete: state.pipeline.any((x) => x['name'] == stageNames[i].$1 && x['status'] == 'COMPLETE'),
                  isProcessing: state.pipelineActiveIndex == i,
                  isLast: i == stageNames.length - 1,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Agent Orchestrator Outputs
        if (state.pipeline.isNotEmpty) ...[
          Panel(
            title: 'Agent Orchestrator Output Ledger (${state.pipeline.length} payloads)',
            trailing: const StatusBadge('SYNTHETIC AI SERVICES', color: AppTheme.violet),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Payload responses produced deterministically by Python service agents:',
                  style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                ),
                const SizedBox(height: 14),
                for (final stage in state.pipeline) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.panelElevated,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.line),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StatusBadge(stage['status'] as String, color: AppTheme.green, fontSize: 9),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 180,
                          child: Text(
                            stage['name'] as String,
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppTheme.text),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            stage['detail'] != null ? stage['detail'].toString() : 'Completed successfully',
                            style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: AppTheme.cyan),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _StageRow extends StatelessWidget {
  final int index;
  final String name;
  final String subtitle;
  final IconData icon;
  final bool isComplete;
  final bool isProcessing;
  final bool isLast;

  const _StageRow({
    required this.index,
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.isComplete,
    required this.isProcessing,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = isComplete
        ? AppTheme.emerald
        : isProcessing
            ? AppTheme.cyan
            : AppTheme.dim;

    return Column(
      children: [
        Row(
          children: [
            // Stage Number / Indicator
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isProcessing ? AppTheme.cyan : statusColor.withValues(alpha: 0.5),
                  width: isProcessing ? 2.0 : 1.0,
                ),
              ),
              child: isProcessing
                  ? const Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.cyan),
                    )
                  : Icon(
                      isComplete ? Icons.check : icon,
                      size: 16,
                      color: statusColor,
                    ),
            ),
            const SizedBox(width: 14),

            // Name & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'STAGE $index: $name',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: isComplete || isProcessing ? AppTheme.text : AppTheme.muted,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (isProcessing) const StatusBadge('RUNNING…', color: AppTheme.cyan, fontSize: 9),
                      if (isComplete) const StatusBadge('COMPLETE', color: AppTheme.emerald, fontSize: 9),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: AppTheme.muted, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!isLast)
          Container(
            height: 18,
            margin: const EdgeInsets.only(left: 17),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: isComplete ? AppTheme.emerald.withValues(alpha: 0.5) : AppTheme.line,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
