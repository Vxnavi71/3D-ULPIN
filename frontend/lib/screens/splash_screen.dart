import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class SplashScreen extends StatelessWidget {
  final VoidCallback onEnter;
  final VoidCallback onJudgeDemo;
  final VoidCallback onRegister;

  const SplashScreen({
    super.key,
    required this.onEnter,
    required this.onJudgeDemo,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Stack(
        children: [
          // Subtle background grid
          Positioned.fill(
            child: CustomPaint(
              painter: _TechGridPainter(),
            ),
          ),

          // Central Card / Content
          Center(
            child: Container(
              width: 580,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
              decoration: BoxDecoration(
                color: AppTheme.panel,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.line),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // LUNARA Hex Logo
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: AppTheme.cyan.withOpacity(0.12),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.cyan.withOpacity(0.4), width: 2),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.layers_outlined,
                        size: 40,
                        color: AppTheme.cyan,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  const Text(
                    'LUNARA',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      color: AppTheme.text,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  const Text(
                    '3D ULPIN Generation & Vertical Property Mapping',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.cyan,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    'Smart India Hackathon 2026 • Problem Statement: PS-26011 • Team ID: 168736\nCadastral Modernization from 2D Land Records to 3D Vertical Property Intelligence',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Badges
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StatusBadge('PS-26011', color: AppTheme.blue),
                      SizedBox(width: 8),
                      StatusBadge('3D CADASTRE', color: AppTheme.violet),
                      SizedBox(width: 8),
                      StatusBadge('DEMO MODE • SYNTHETIC DATA', color: AppTheme.amber, dot: true),
                    ],
                  ),
                  const SizedBox(height: 36),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: onEnter,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.cyan,
                            foregroundColor: const Color(0xFF042F2E),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          icon: const Icon(Icons.dashboard_outlined, size: 18),
                          label: const Text(
                            'ENTER PLATFORM',
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: onJudgeDemo,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.panelElevated,
                            foregroundColor: AppTheme.cyan,
                            side: const BorderSide(color: AppTheme.cyan),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          icon: const Icon(Icons.play_circle_fill, size: 18),
                          label: const Text(
                            'JUDGE DEMO',
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: onRegister,
                    icon: const Icon(Icons.person_add_alt_1_outlined, size: 15, color: AppTheme.textSecondary),
                    label: const Text(
                      'PROTOTYPE REGISTRATION / SIGN IN',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TechGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF161F2B).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TechGridPainter oldDelegate) => false;
}
