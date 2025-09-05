import 'dart:math';
import 'package:flutter/material.dart';

/// Elegant, premium "mesh" gradient background with very subtle motion.
/// - No black areas
/// - Works in light & dark themes (reads ColorScheme)
/// - Zero jank: single animation driving lightweight paints
class ElegantBackground extends StatefulWidget {
  const ElegantBackground({super.key, this.speed = 0.25});

  /// 0.2–0.6 recommended
  final double speed;

  @override
  State<ElegantBackground> createState() => _ElegantBackgroundState();
}

class _ElegantBackgroundState extends State<ElegantBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: (24000 / widget.speed).round()),
  )..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => CustomPaint(
        painter: _MeshPainter(
          t: _ctrl.value,
          // base tones pulled from your theme for cohesion
          surface: cs.surface,
          accents: [
            const Color(0xFFB2C7FF), // sky lavender
            const Color(0xFFFFD9C7), // peach
            const Color(0xFFC6F5E7), // mint
            const Color(0xFFE8D9FF), // lilac
            const Color(0xFFFFF3B5), // soft lemon
          ],
          // slight variant overlay for depth
          overlay: cs.surfaceVariant.withOpacity(0.35),
        ),
        isComplex: true,
        willChange: true,
      ),
    );
  }
}

class _MeshPainter extends CustomPainter {
  _MeshPainter({
    required this.t,
    required this.surface,
    required this.accents,
    required this.overlay,
  });

  final double t;
  final Color surface;
  final List<Color> accents;
  final Color overlay;

  @override
  void paint(Canvas canvas, Size size) {
    // base wash
    final base = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [surface, surface.withOpacity(.96)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, base);

    // drifting radial fields (elegant mesh look)
    final fields = [
      _field(size, 0.18, 0.28, 420, accents[0], 0),
      _field(size, 0.78, 0.22, 380, accents[1], 1),
      _field(size, 0.58, 0.58, 520, accents[2], 2),
      _field(size, 0.28, 0.68, 400, accents[3], 3),
      _field(size, 0.86, 0.64, 420, accents[4], 4),
    ];

    for (final f in fields) {
      final p = Paint()
        ..shader = RadialGradient(
          colors: [
            f.color.withOpacity(.48),
            f.color.withOpacity(.08),
            Colors.transparent,
          ],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(Rect.fromCircle(center: f.center, radius: f.r));
      canvas.drawCircle(f.center, f.r, p);
    }

    // gentle diagonal sheen for polish
    final sheen = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withOpacity(.10),
          Colors.transparent,
          Colors.white.withOpacity(.06),
        ],
        stops: const [0, .5, 1],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, sheen);

    // soft overlay to unify tones
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = overlay,
    );
  }

  _Field _field(Size size, double x, double y, double r, Color c, int i) {
    // drift each field a few pixels in a slow Lissajous-like path
    final dx = sin(t * 2 * pi * (0.6 + i * .07)) * 24;
    final dy = cos(t * 2 * pi * (0.5 + i * .06)) * 20;
    return _Field(
      center: Offset(size.width * x + dx, size.height * y + dy),
      r: r,
      color: c,
    );
  }

  @override
  bool shouldRepaint(covariant _MeshPainter oldDelegate) =>
      oldDelegate.t != t ||
          oldDelegate.surface != surface ||
          oldDelegate.overlay != overlay;
}

class _Field {
  _Field({required this.center, required this.r, required this.color});
  final Offset center;
  final double r;
  final Color color;
}
