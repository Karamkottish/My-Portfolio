import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A 2026-style "flow field" background: particles follow a smooth vector field,
/// creating silky streams with neon tints. GPU-friendly (Canvas only).
class FlowFieldBackground extends StatefulWidget {
  const FlowFieldBackground({super.key});

  @override
  State<FlowFieldBackground> createState() => _FlowFieldBackgroundState();
}

class _FlowFieldBackgroundState extends State<FlowFieldBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl =
  AnimationController(vsync: this, duration: const Duration(seconds: 40))
    ..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => CustomPaint(
        painter: _FlowFieldPainter(t: _ctrl.value, dark: dark),
      ),
    );
  }
}

class _FlowFieldPainter extends CustomPainter {
  _FlowFieldPainter({required this.t, required this.dark});

  final double t;
  final bool dark;

  final math.Random rng = math.Random(7);

  @override
  void paint(Canvas canvas, Size size) {
    // Base fade
    final base = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: dark
            ? [const Color(0xFF0C0F14), const Color(0xFF121827)]
            : [const Color(0xFFF8FAFF), const Color(0xFFEFF3FF)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, base);

    // Palette (matches your UI accents)
    final pink   = const Color(0xFFFF6AC1);
    final cyan   = const Color(0xFF57D0FF);
    final violet = const Color(0xFF8B5CF6);
    final mint   = const Color(0xFF06D6A0);
    final gold   = const Color(0xFFFFD166);

    final colors = [pink, violet, cyan, mint, gold];

    // Flow field params
    final cols = 70;
    final rows = (cols * size.height / size.width).round();
    final stepX = size.width / cols;
    final stepY = size.height / rows;

    double noise(double x, double y, double z) {
      // cheap 3D value noise via sin/cos blends (good enough for flow motion)
      return (math.sin(x * 1.3 + z) + math.cos(y * 1.7 - z * 1.2)) * 0.5 +
          (math.sin((x + y) * 0.7 - z * 0.6)) * 0.5;
    }

    // Draw multiple passes of streamlines
    final passes = 4;
    for (int p = 0; p < passes; p++) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = dark ? 1.2 : 1.0
        ..color = colors[p % colors.length]
            .withOpacity(dark ? 0.42 : 0.32);

      for (int i = 0; i < cols; i += 2) {
        for (int j = 0; j < rows; j += 2) {
          // seed position
          double x = i * stepX + (p * 7) % stepX;
          double y = j * stepY + (p * 11) % stepY;

          final path = Path()..moveTo(x, y);

          // integrate through the field
          final len = 36; // streamline length
          for (int k = 0; k < len; k++) {
            final nx = x / size.width;
            final ny = y / size.height;

            // smoothly evolving angle
            final angle =
                noise(nx * 3.2, ny * 3.0, t * 2 * math.pi + p * 0.7) *
                    math.pi;

            final vx = math.cos(angle);
            final vy = math.sin(angle);

            x += vx * stepX * 0.35;
            y += vy * stepY * 0.35;

            path.lineTo(x, y);
          }

          // subtle blur per pass
          canvas.saveLayer(null, Paint());
          canvas.drawPath(path, paint);
          canvas.drawPath(
              path,
              Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = paint.strokeWidth + 1.5
                ..color = paint.color.withOpacity(0.15)
                ..maskFilter =
                const MaskFilter.blur(BlurStyle.normal, 4.5));
          canvas.restore();
        }
      }
    }

    // Vignette for focus
    final vignette = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, -0.05),
        radius: 1.15,
        colors: [
          Colors.transparent,
          (dark ? Colors.black : Colors.black12).withOpacity(dark ? .33 : .12),
        ],
        stops: const [0.75, 1.0],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, vignette);
  }

  @override
  bool shouldRepaint(covariant _FlowFieldPainter oldDelegate) =>
      oldDelegate.t != t || oldDelegate.dark != dark;
}
