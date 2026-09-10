import 'package:flutter/material.dart';

/// Identidad ALIVIO CONSTRUCTOR: azul + naranja del logo (casco y
/// rompepavimento sonriente), amable pero de obra.
///
/// Decisiones (pase frontend-design):
/// - El amarillo es SEÑAL y ACCIÓN, no decoración: FABs, selección,
///   la franja de obra. Todo lo demás es sobrio.
/// - Estructura con bordes de 1px, no con sombras difusas.
/// - Radius concéntrico: contenedores 12, elementos internos 8.
/// - Jerarquía por peso tipográfico (w800/w400), labels en sentence
///   case (el wordmark de marca es la única versal).
/// - Lo memorable en una sola cosa: la franja diagonal amarillo/negro
///   bajo el AppBar (señalización de obra).
class AppTheme {
  /// Naranja de acción (se llamó yellow en la era DEMACO).
  static const yellow = Color(0xFFF08A12);
  static const blue = Color(0xFF23509E);

  /// Azul noche para tarjetas héroe (KPIs, capital).
  static const ink = Color(0xFF1B2E5B);
  static const steel = Color(0xFF4A4A4A);
  static const paper = Color(0xFFF4F5F7);
  static const border = Color(0xFFE2E4EA);
  static const graphite = Color(0xFF565B63);
  static const okGreen = Color(0xFF1E7A3C);
  static const alertRed = Color(0xFFC23A2B);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: blue,
      brightness: Brightness.light,
      primary: blue,
      secondary: yellow,
      surface: Colors.white,
    );
    const r8 = BorderRadius.all(Radius.circular(8));
    const r12 = BorderRadius.all(Radius.circular(12));
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: paper,
      appBarTheme: const AppBarTheme(
        backgroundColor: blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: r12,
          side: BorderSide(color: border),
        ),
        margin: EdgeInsets.symmetric(vertical: 4),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: graphite,
        visualDensity: VisualDensity.compact,
      ),
      dividerTheme:
          const DividerThemeData(color: border, thickness: 1, space: 1),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        side: const BorderSide(color: border),
        shape: const RoundedRectangleBorder(borderRadius: r8),
        labelStyle: const TextStyle(fontSize: 12, color: ink),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        enabledBorder: OutlineInputBorder(
            borderRadius: r8, borderSide: BorderSide(color: border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: r8,
            borderSide: BorderSide(color: ink, width: 1.5)),
        border: OutlineInputBorder(borderRadius: r8),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: const RoundedRectangleBorder(borderRadius: r8),
          textStyle:
              const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: const RoundedRectangleBorder(borderRadius: r8),
          side: const BorderSide(color: graphite),
          textStyle:
              const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: const WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: r8)),
          side: const WidgetStatePropertyAll(
              BorderSide(color: border)),
          backgroundColor: WidgetStateProperty.resolveWith((states) =>
              states.contains(WidgetState.selected)
                  ? yellow.withValues(alpha: .30)
                  : Colors.white),
          textStyle: const WidgetStatePropertyAll(
              TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
          visualDensity: VisualDensity.compact,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: yellow,
        foregroundColor: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14))),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: yellow.withValues(alpha: .25),
        labelTextStyle: const WidgetStatePropertyAll(
            TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ink,
        contentTextStyle: const TextStyle(color: Colors.white),
        actionTextColor: yellow,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: r8),
      ),
      expansionTileTheme: const ExpansionTileThemeData(
        shape: RoundedRectangleBorder(),
        collapsedShape: RoundedRectangleBorder(),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
            fontWeight: FontWeight.w800, letterSpacing: -0.3),
        titleMedium: TextStyle(fontWeight: FontWeight.w800),
        bodyMedium: TextStyle(fontSize: 13.5),
      ),
    );
  }
}

/// Franja de obra ALIVIO (diagonales azul/naranja del logo): el
/// acento de marca, una vez por pantalla bajo el AppBar.
class HazardStripe extends StatelessWidget
    implements PreferredSizeWidget {
  const HazardStripe({super.key, this.height = 5});

  final double height;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _HazardPainter()),
    );
  }
}

class _HazardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final yellowPaint = Paint()..color = AppTheme.yellow;
    final inkPaint = Paint()..color = AppTheme.blue;
    canvas.drawRect(Offset.zero & size, yellowPaint);
    const w = 12.0;
    for (var x = -size.height; x < size.width; x += w * 2) {
      final path = Path()
        ..moveTo(x, size.height)
        ..lineTo(x + size.height, 0)
        ..lineTo(x + size.height + w, 0)
        ..lineTo(x + w, size.height)
        ..close();
      canvas.drawPath(path, inkPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Presión táctil (better-ui): scale 0.96 exacto, interrumpible.
class Pressable extends StatefulWidget {
  const Pressable({super.key, required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) => setState(() => _down = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _down ? 0.96 : 1,
        duration: const Duration(milliseconds: 120),
        curve: const Cubic(0.2, 0, 0, 1),
        child: widget.child,
      ),
    );
  }
}
