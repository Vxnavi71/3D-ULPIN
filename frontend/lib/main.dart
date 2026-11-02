import 'package:flutter/material.dart';
import 'providers/app_state.dart';
import 'models/models.dart';
import 'theme/app_theme.dart';
import 'screens/dashboard.dart';
import 'screens/map_screen.dart';
import 'screens/ulpin_screen.dart';
import 'screens/validation_screen.dart';
import 'screens/property_screen.dart';
import 'screens/pipeline_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/registration_screen.dart';
import 'widgets/common.dart';

void main() => runApp(const LunaraApp());

class LunaraApp extends StatefulWidget {
  const LunaraApp({super.key});
  @override
  State<LunaraApp> createState() => _LunaraAppState();
}

class _LunaraAppState extends State<LunaraApp> {
  final state = AppState();

  @override
  void initState() {
    super.initState();
    state.initialize();
  }

  @override
  void dispose() {
    state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: state,
        builder: (context, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'LUNARA – 3D ULPIN & Vertical Property Intelligence',
          theme: AppTheme.theme,
          home: _Shell(state: state),
        ),
      );
}

class _Shell extends StatefulWidget {
  final AppState state;
  const _Shell({required this.state});

  @override
  State<_Shell> createState() => _ShellState();
}

class _ShellState extends State<_Shell> {
  late final TextEditingController _searchCtrl;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _nav(int index) {
    widget.state.navIndex = index;
    widget.state.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.state;
    final screens = [
      DashboardScreen(state: s, startDemo: s.runPipeline),
      MapScreen(state: s),
      UlpinScreen(state: s),
      ValidationScreen(state: s),
      PropertyScreen(state: s),
      PipelineScreen(state: s),
      SettingsScreen(
        state: s,
        onShowSplash: () {
          s.showSplash = true;
          s.showRegistration = false;
          s.notifyListeners();
        },
        onShowRegister: () {
          s.showSplash = false;
          s.showRegistration = true;
          s.notifyListeners();
        },
      ),
    ];

    Widget content;
    if (s.loading) {
      content = const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppTheme.cyan),
            SizedBox(height: 16),
            Text('Initializing LUNARA 3D Engine…', style: TextStyle(color: AppTheme.muted, fontSize: 13)),
          ],
        ),
      );
    } else if (s.error != null && s.buildings.isEmpty) {
      content = _ErrorState(message: s.error!, retry: s.initialize);
    } else {
      content = screens[s.navIndex.clamp(0, screens.length - 1)];
    }

    // Splash / Registration overlay
    if (s.showSplash) {
      return Scaffold(
        body: SplashScreen(
          onEnter: () {
            s.showSplash = false;
            s.notifyListeners();
          },
          onJudgeDemo: s.startJudgeDemo,
          onRegister: () {
            s.showSplash = false;
            s.showRegistration = true;
            s.notifyListeners();
          },
        ),
      );
    }

    if (s.showRegistration) {
      return Scaffold(
        body: RegistrationScreen(
          onRegistered: () {
            s.showRegistration = false;
            s.notifyListeners();
          },
          onCancel: () {
            s.showRegistration = false;
            s.showSplash = true;
            s.notifyListeners();
          },
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Main App Body
            Expanded(
              child: Row(
                children: [
                  _Sidebar(state: s, onNav: _nav),
                  Expanded(
                    child: Column(
                      children: [
                        _Topbar(state: s, searchCtrl: _searchCtrl, onNav: _nav),
                        Expanded(child: content),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Judge Demo Interactive Stepper Controller (Floating Bar at bottom)
            if (s.isJudgeTour)
              _JudgeDemoBar(state: s),
          ],
        ),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final AppState state;
  final void Function(int) onNav;

  const _Sidebar({required this.state, required this.onNav});

  static const items = [
    (0, Icons.dashboard_outlined, 'Dashboard'),
    (1, Icons.view_in_ar_outlined, '3D Map'),
    (2, Icons.pin_drop_outlined, 'ULPIN Generator'),
    (3, Icons.rule_folder_outlined, 'Spatial Validation'),
    (4, Icons.account_tree_outlined, 'Property Details'),
    (5, Icons.rocket_launch_outlined, 'Demo Pipeline'),
    (6, Icons.settings_outlined, 'Settings'),
  ];

  @override
  Widget build(BuildContext context) => Container(
        width: 235,
        decoration: const BoxDecoration(
          color: AppTheme.panel,
          border: Border(right: BorderSide(color: AppTheme.line)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Branding Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 4),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppTheme.cyan.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.cyan.withValues(alpha: 0.3)),
                    ),
                    child: const Icon(Icons.location_searching, color: AppTheme.cyan, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LUNARA',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                          color: AppTheme.text,
                        ),
                      ),
                      Text(
                        '3D PROPERTY INTELLIGENCE',
                        style: TextStyle(
                          color: AppTheme.cyan,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 10),

            // Nav Items
            ...items.map((e) => _NavItem(
                  icon: e.$2,
                  label: e.$3,
                  selected: state.navIndex == e.$1,
                  onTap: () => onNav(e.$1),
                )),

            const Spacer(),

            // Demo Mode Info Box
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF091924),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.cyan.withValues(alpha: 0.2)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.verified_user_outlined, size: 14, color: AppTheme.cyan),
                        SizedBox(width: 6),
                        Text(
                          'SIH 2026 PROTOTYPE',
                          style: TextStyle(color: AppTheme.cyan, fontWeight: FontWeight.w800, fontSize: 10),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text('PS-26011 • Team 168736', style: TextStyle(color: AppTheme.muted, fontSize: 10)),
                    SizedBox(height: 2),
                    Text('DEMO MODE • Synthetic Data', style: TextStyle(color: AppTheme.dim, fontSize: 9.5)),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? AppTheme.cyan.withValues(alpha: 0.14) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: selected ? AppTheme.cyan.withValues(alpha: 0.3) : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                Icon(icon, size: 18, color: selected ? AppTheme.cyan : AppTheme.muted),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    color: selected ? AppTheme.text : AppTheme.muted,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class _Topbar extends StatelessWidget {
  final AppState state;
  final TextEditingController searchCtrl;
  final void Function(int) onNav;

  const _Topbar({
    required this.state,
    required this.searchCtrl,
    required this.onNav,
  });

  Future<void> _handleSearch(String raw) async {
    final query = raw.trim().toUpperCase();
    if (query.isEmpty) return;

    // Check building match
    final bMatches = state.buildings.where((x) => x.id == query || x.name.toUpperCase().contains(query)).toList();
    if (bMatches.isNotEmpty) {
      await state.selectBuilding(bMatches.first);
      onNav(1);
      return;
    }

    // Check parcel match
    for (final p in state.parcels) {
      if (p.id == query || p.name.toUpperCase().contains(query)) {
        final b = state.buildings.firstWhere((x) => x.parcelId == p.id, orElse: () => state.buildings.first);
        await state.selectBuilding(b);
        onNav(1);
        return;
      }
    }

    // Search via backend or in-memory
    for (final bld in state.buildings) {
      final data = await state.api.building(bld.id);
      final rawFloors = data['floors'] as List? ?? [];
      for (final rawFloor in rawFloors) {
        final floor = Floor.fromJson(rawFloor);
        for (final prop in floor.properties) {
          final digits = prop.unit.replaceAll(RegExp(r'\D'), '');
          final unitCode = (digits.isEmpty ? '001' : digits).padLeft(3, '0');
          final prototype = 'TS-HYD-D01-${prop.parcelId}-${prop.buildingId}-F${floor.level.toString().padLeft(2, '0')}-U$unitCode'.toUpperCase();

          if (prop.id.toUpperCase() == query || prop.unit.toUpperCase() == query || prototype == query) {
            await state.selectBuilding(bld);
            state.selectFloor(floor);
            state.selectProperty(prop);
            onNav(1);
            return;
          }
        }
      }
    }

    // Fallback: search via API
    final searchRes = await state.api.search(query);
    if (searchRes['building_id'] != null) {
      final b = state.buildings.firstWhere((x) => x.id == searchRes['building_id'], orElse: () => state.buildings.first);
      await state.selectBuilding(b);
      onNav(1);
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        height: 68,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: const BoxDecoration(
          color: AppTheme.panel,
          border: Border(bottom: BorderSide(color: AppTheme.line)),
        ),
        child: Row(
          children: [
            // Search Box
            Expanded(
              child: SizedBox(
                height: 42,
                child: TextField(
                  controller: searchCtrl,
                  onSubmitted: _handleSearch,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Search parcel (P001), building (B001), unit (A-201) or ULPIN…',
                    hintStyle: const TextStyle(color: AppTheme.dim, fontSize: 12),
                    prefixIcon: const Icon(Icons.search, size: 18, color: AppTheme.muted),
                    filled: true,
                    fillColor: AppTheme.panel2,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            const StatusBadge('PS-26011', color: AppTheme.blue),
            const SizedBox(width: 8),

            // Start Live Demo quick action
            OutlinedButton.icon(
              onPressed: () {
                onNav(5);
                state.runPipeline();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.violet,
                side: const BorderSide(color: AppTheme.violet),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              icon: const Icon(Icons.rocket_launch_outlined, size: 15),
              label: const Text('START LIVE DEMO', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11)),
            ),
            const SizedBox(width: 8),

            // Run Spatial Validation quick action
            OutlinedButton.icon(
              onPressed: () {
                onNav(3);
                state.runValidation();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.amber,
                side: const BorderSide(color: AppTheme.amber),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              icon: const Icon(Icons.fact_check_outlined, size: 15),
              label: const Text('RUN VALIDATION', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11)),
            ),
            const SizedBox(width: 8),

            // Prominent JUDGE DEMO Button
            FilledButton.icon(
              onPressed: state.startJudgeDemo,
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.cyan,
                foregroundColor: const Color(0xFF042F2E),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              icon: const Icon(Icons.play_circle_fill, size: 18),
              label: const Text(
                'JUDGE DEMO',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 0.5),
              ),
            ),
          ],
        ),
      );
}

class _JudgeDemoBar extends StatelessWidget {
  final AppState state;
  const _JudgeDemoBar({required this.state});

  @override
  Widget build(BuildContext context) {
    final stepInfo = AppState.judgeTourSteps[(state.judgeStep - 1).clamp(0, AppState.judgeTourSteps.length - 1)];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1E2D),
        border: const Border(top: BorderSide(color: AppTheme.cyan, width: 2)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 10, offset: const Offset(0, -2)),
        ],
      ),
      child: Row(
        children: [
          // Step Counter Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.cyan.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.cyan),
            ),
            child: Text(
              'STEP ${state.judgeStep} / 15',
              style: const TextStyle(color: AppTheme.cyan, fontWeight: FontWeight.w900, fontSize: 12),
            ),
          ),
          const SizedBox(width: 16),

          // Step Title & Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  stepInfo['title'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: AppTheme.text),
                ),
                Text(
                  stepInfo['desc'] ?? '',
                  style: const TextStyle(color: AppTheme.muted, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Stepper Buttons: Prev, Next, Exit
          OutlinedButton(
            onPressed: state.judgeStep > 1 ? state.prevJudgeStep : null,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: const Text('PREV', style: TextStyle(fontSize: 11)),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: state.nextJudgeStep,
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.cyan,
              foregroundColor: const Color(0xFF042F2E),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
            icon: Icon(state.judgeStep < 15 ? Icons.arrow_forward : Icons.check_circle, size: 16),
            label: Text(
              state.judgeStep < 15 ? 'NEXT STEP' : 'FINISH DEMO',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Exit Demo Tour',
            icon: const Icon(Icons.close, color: AppTheme.muted, size: 20),
            onPressed: state.stopJudgeDemo,
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback retry;

  const _ErrorState({required this.message, required this.retry});

  @override
  Widget build(BuildContext context) => Center(
        child: Panel(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 48, color: AppTheme.amber),
              const SizedBox(height: 14),
              const Text(
                'Backend Connection Note',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: const TextStyle(color: AppTheme.muted, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(onPressed: retry, child: const Text('RETRY INITIALIZE')),
            ],
          ),
        ),
      );
}
