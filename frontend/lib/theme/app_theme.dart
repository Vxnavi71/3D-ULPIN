import 'package:flutter/material.dart';

class AppTheme {
  // Base UI Colors (70-80% dark neutral foundation)
  static const bg = Color(0xFF07090D);
  static const bgSecondary = Color(0xFF0B0F14);
  static const panel = Color(0xFF11161D);
  static const panelElevated = Color(0xFF171D25);
  static const line = Color(0xFF26313D);
  static const lineHighlight = Color(0xFF384758);

  static const text = Color(0xFFF8FAFC);
  static const textSecondary = Color(0xFF94A3B8);
  static const textMuted = Color(0xFF64748B);

  // Functional Colors (20-30% semantic usage)
  static const cyan = Color(0xFF22D3EE);   // Primary actions / ULPIN / Active navigation
  static const blue = Color(0xFF3B82F6);   // Spatial / Map elements / Boundaries
  static const violet = Color(0xFF8B5CF6); // AI / 3D intelligence / Insights
  static const green = Color(0xFF22C55E);  // Validated / Success
  static const amber = Color(0xFFF59E0B);  // Warnings / Conflicts / Prototype notices

  // Legacy aliases – kept for backward compatibility with existing screens
  static const muted = textMuted;
  static const dim = Color(0xFF475569);
  static const panel2 = panelElevated;
  static const rose = Color(0xFFF43F5E);   // Legacy: critical conflict (maps to amber in new palette)
  static const teal = cyan;               // Legacy alias for cyan
  static const indigo = violet;           // Legacy alias for violet
  static const emerald = green;           // Legacy alias for green

  static ThemeData theme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bg,
    colorScheme: const ColorScheme.dark(
      primary: cyan,
      secondary: blue,
      tertiary: violet,
      surface: panel,
      onSurface: text,
      onPrimary: Color(0xFF042F2E),
      outline: line,
      error: amber,
    ),
    fontFamily: 'Segoe UI',
    cardTheme: const CardThemeData(
      color: panel,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        side: BorderSide(color: line),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: line,
      thickness: 1,
      space: 1,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: cyan,
        foregroundColor: const Color(0xFF042F2E),
        elevation: 0,
        textStyle: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: text,
        side: const BorderSide(color: line),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: panelElevated,
      selectedColor: const Color(0xFF0C2B38),
      side: const BorderSide(color: line),
      labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: text),
      secondaryLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: cyan),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),
  );
}
