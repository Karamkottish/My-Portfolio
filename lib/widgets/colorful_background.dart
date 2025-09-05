import 'dart:math';
import 'package:flutter/material.dart';

/// Pastel gradient blobs + confetti. Drop behind any scroll view.
class ColorfulBackground extends StatefulWidget {
  const ColorfulBackground({super.key, this.intensity = 1.0});

  final double intensity;

  @override
  State<ColorfulBackground> createState() => _ColorfulBackgroundState();
}

class _ColorfulBackgroundState extends State<ColorfulBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl =
  AnimationController(vsync: this, duration: const Duration(seconds: 12))
    ..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _BlobPainter(_ctrl.value, widget.intensity))),
          Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _ConfettiPainter(_ctrl.value)))),
        ],
      ),
    );
  }
}

class _BlobPainter extends CustomPainter {
  _BlobPainter(this.t, this.k);
  final double t;
  final double k;

  @override
  void paint(Canvas canvas, Size size) {
    final blobs = [
      (c: const Color(0xFFFFEEF6), x: .18, y: .24, r: 260.0),
      (c: const Color(0xFFE8FFFB), x: .82, y: .22, r: 230.0),
      (c: const Color(0xFFEFF2FF), x: .56, y: .48, r: 320.0),
      (c: const Color(0xFFFFF6E5), x: .28, y: .60, r: 260.0),
    ];
    for (var i = 0; i < blobs.length; i++) {
      final dx = sin(t * 2 * pi + i) * 12 * k;
      final dy = cos(t * 2 * pi + i) * 10 * k;
      final p = Paint()..color = blobs[i].c;
      canvas.drawCircle(Offset(size.width * blobs[i].x + dx, size.height * blobs[i].y + dy), blobs[i].r, p);
    }
  }

  @override
  bool shouldRepaint(covariant _BlobPainter old) => old.t != t || old.k != k;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.t);
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final List<Color> colors = const [
      Color(0xFFFF6AC1), Color(0xFFFFD166), Color(0xFF06D6A0),
      Color(0xFF00E5FF), Color(0xFF8B5CF6),
    ];
    final p = Paint();
    for (int i = 0; i < 80; i++) {
      p.color = colors[i % colors.length].withOpacity(.22);
      final x = (i * 97 + t * size.width * .6) % size.width;
      final y = (i * 41) % size.height * .9;
      canvas.drawCircle(Offset(x, y), 2.4 + (i % 3), p);
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) => old.t != t;
}
