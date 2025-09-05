import 'dart:math';
import 'package:flutter/material.dart';

/// Darker pastel blob background for better text contrast.
class BlobBackground extends StatefulWidget {
  const BlobBackground({super.key, this.speed = 0.18});
  final double speed;

  @override
  State<BlobBackground> createState() => _BlobBackgroundState();
}

class _BlobBackgroundState extends State<BlobBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: (20000 / widget.speed).round()),
  )..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => CustomPaint(painter: _BlobPainter(t: _ctrl.value)),
    );
  }
}

class _BlobPainter extends CustomPainter {
  const _BlobPainter({required this.t});
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    // Base — soft dark gray instead of white
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFF1E1E26), // dark background
    );

    // Drifting blobs with slightly higher opacity
    final fields = <({Color c, Offset p, double r, double dx, double dy, double ph})>[
      (c: const Color(0xFFFF91AF), p: Offset(size.width * .18, size.height * .32), r: 320, dx: 16, dy: 12, ph: 0.0),
      (c: const Color(0xFFEEB479), p: Offset(size.width * .82, size.height * .18), r: 300, dx: 14, dy: 11, ph: .5),
      (c: const Color(0xFF7FE0C9), p: Offset(size.width * .60, size.height * .55), r: 420, dx: 18, dy: 14, ph: 1.0),
      (c: const Color(0xFFFFE785), p: Offset(size.width * .28, size.height * .72), r: 360, dx: 14, dy: 12, ph: 1.6),
      (c: const Color(0xFFBE99E6), p: Offset(size.width * .88, size.height * .70), r: 340, dx: 12, dy: 10, ph: 2.2),
    ];

    for (final f in fields) {
      final off = Offset(
        sin(t * 3 * pi + f.ph) * f.dx,
        cos(t * 2 * pi + f.ph) * f.dy,
      );
      final center = f.p + off;
      final shader = RadialGradient(
        colors: [
          f.c.withOpacity(.55),
          f.c.withOpacity(.18),
          Colors.transparent,
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: f.r));
      canvas.drawCircle(center, f.r, Paint()..shader = shader);
    }

    // Very subtle top-to-bottom fade
    final overlay = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.black.withOpacity(.12),
        Colors.transparent,
        Colors.black.withOpacity(.12),
      ],
      stops: const [0, .5, 1],
    ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, Paint()..shader = overlay);
  }

  @override
  bool shouldRepaint(covariant _BlobPainter old) => old.t != t;
}
