import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 2027-trendy, colorful, lightweight animated background.
/// Three translucent radial gradients drift slowly. Very smooth.
class AuroraBackground extends StatefulWidget {
  const AuroraBackground({
    super.key,
    this.intensity = .65, // overall opacity of spots
    this.speed = 1.0,     // 1.0 => ~24s loop
  });

  final double intensity;
  final double speed;

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: (24000 ~/ widget.speed)),
  )..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Subtle static base gradient (cheap).
    final base = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [Color(0xFF0F1116), Color(0xFF14161D)]
              : const [Color(0xFFF8FAFF), Color(0xFFF3F6FF)],
        ),
      ),
    );

    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          base,
          AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) {
              final t = _ctrl.value;

              // Very slow sinusoidal drift (keeps GPU cool).
              final dx1 = math.sin(t * 2 * math.pi) * .12;
              final dy1 = math.cos(t * 2 * math.pi) * .10;

              final dx2 = math.cos(t * 2 * math.pi + 1.3) * .10;
              final dy2 = math.sin(t * 2 * math.pi + 0.7) * .12;

              final dx3 = math.sin(t * 2 * math.pi + 2.1) * .08;
              final dy3 = math.cos(t * 2 * math.pi + 2.4) * .09;

              final o = (isDark ? .55 : .35) * widget.intensity;

              return CustomPaint(
                painter: _AuroraPainter(
                  spots: [
                    _Spot(offset: Alignment(-.7 + dx1, -.55 + dy1), color: const Color(0xFF6EE7F9), radiusFrac: .65, opacity: o),
                    _Spot(offset: Alignment(.6 + dx2, -.15 + dy2), color: const Color(0xFFFF72D2), radiusFrac: .55, opacity: o * .9),
                    _Spot(offset: Alignment(-.15 + dx3, .55 + dy3), color: const Color(0xFFA78BFA), radiusFrac: .75, opacity: o * .85),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Spot {
  const _Spot({
    required this.offset,
    required this.color,
    required this.radiusFrac,
    required this.opacity,
  });

  final Alignment offset;   // center position in -1..1 space
  final Color color;
  final double radiusFrac;  // fraction of min(width, height)
  final double opacity;
}

class _AuroraPainter extends CustomPainter {
  _AuroraPainter({required this.spots});
  final List<_Spot> spots;

  @override
  void paint(Canvas canvas, Size size) {
    final shortest = math.min(size.width, size.height);

    for (final s in spots) {
      final center = s.offset.alongSize(size);
      final r = shortest * s.radiusFrac;

      final rect = Rect.fromCircle(center: center, radius: r);
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            s.color.withOpacity(s.opacity),
            s.color.withOpacity(0.0),
          ],
          stops: const [0.0, 1.0],
        ).createShader(rect);

      canvas.drawCircle(center, r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _AuroraPainter oldDelegate) =>
      !identical(oldDelegate.spots, spots);
}
