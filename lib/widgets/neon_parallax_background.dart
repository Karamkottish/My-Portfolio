import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Neon, 3D-ish parallax background.
/// - Mouse/pointer tilt for depth
/// - Slow float animation
/// - Bokeh sparks + film grain for texture
/// - Tuned to be smooth on Web
class NeonParallaxBackground extends StatefulWidget {
  const NeonParallaxBackground({
    super.key,
    this.intensity = .65,     // overall brightness of blobs
    this.floatSpeed = 1.0,    // 1.0 => ~26s loop
    this.enableParallax = true,
    this.reducedMotion = false, // Set true if user prefers reduced motion
  });

  final double intensity;
  final double floatSpeed;
  final bool enableParallax;
  final bool reducedMotion;

  @override
  State<NeonParallaxBackground> createState() => _NeonParallaxBackgroundState();
}

class _NeonParallaxBackgroundState extends State<NeonParallaxBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: (26000 ~/ widget.floatSpeed)),
  )..repeat();

  // pointer -> parallax
  Offset _pointer = Offset.zero;
  Size _size = Size.zero;

  bool get _useParallax {
    if (widget.reducedMotion) return false;
    // Disable parallax on very small screens for perf + ergonomics
    final isSmall = _size.shortestSide < 540;
    return widget.enableParallax && !isSmall;
  }

  void _onHover(PointerHoverEvent e) {
    if (!_useParallax) return;
    setState(() => _pointer = e.localPosition);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final base = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [Color(0xFF0E1016), Color(0xFF151826)]
              : const [Color(0xFFF9FBFF), Color(0xFFF2F6FF)],
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        _size = Size(constraints.maxWidth, constraints.maxHeight);

        // normalized pointer offset (-1..1) from center
        final cx = _size.width / 2;
        final cy = _size.height / 2;
        final p = _useParallax
            ? Offset(
          ((_pointer.dx - cx) / _size.width).clamp(-1, 1),
          ((_pointer.dy - cy) / _size.height).clamp(-1, 1),
        )
            : Offset.zero;

        return MouseRegion(
          onHover: _onHover,
          child: RepaintBoundary(
            child: Stack(
              fit: StackFit.expand,
              children: [
                base,

                // LAYER 1 (deep) — dark vignette for contrast
                IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 1.1,
                        colors: [
                          Colors.black.withOpacity(isDark ? .22 : .10),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // LAYER 2 — neon blobs (far)
                _ParallaxLayer(
                  controller: _ctrl,
                  parallax: _useParallax ? p * 18 : Offset.zero,
                  opacity: .75 * widget.intensity,
                  spots: const [
                    _SpotData(color: Color(0xFF61E7FF), align: Alignment(-.85, -.55), radiusFrac: .75),
                    _SpotData(color: Color(0xFFFF7AD1), align: Alignment(.80, -.25), radiusFrac: .65),
                    _SpotData(color: Color(0xFFA78BFA), align: Alignment(-.10, .60), radiusFrac: .90),
                  ],
                  driftScale: 1.0,
                ),

                // LAYER 3 — neon blobs (near)
                _ParallaxLayer(
                  controller: _ctrl,
                  parallax: _useParallax ? p * 36 : Offset.zero,
                  opacity: .55 * widget.intensity,
                  spots: const [
                    _SpotData(color: Color(0xFF00E6A8), align: Alignment(-.35, -.05), radiusFrac: .55),
                    _SpotData(color: Color(0xFF7C3AED), align: Alignment(.35, .10), radiusFrac: .50),
                  ],
                  driftScale: 1.35,
                ),

                // LAYER 4 — bokeh sparkles (closest)
                IgnorePointer(
                  child: CustomPaint(
                    painter: _BokehPainter(
                      controller: _ctrl,
                      parallax: _useParallax ? p * 50 : Offset.zero,
                      count: (_size.shortestSide / 14).clamp(35, 90).toInt(),
                      isDark: isDark,
                    ),
                  ),
                ),

                // Film grain (extremely subtle)
                IgnorePointer(
                  child: _NoiseOverlay(opacity: isDark ? .06 : .04),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ---------- Parallax neon spots layer ----------

class _SpotData {
  final Color color;
  final Alignment align;
  final double radiusFrac;
  const _SpotData({
    required this.color,
    required this.align,
    required this.radiusFrac,
  });
}

class _ParallaxLayer extends StatelessWidget {
  const _ParallaxLayer({
    required this.controller,
    required this.parallax,
    required this.opacity,
    required this.spots,
    required this.driftScale,
  });

  final AnimationController controller;
  final Offset parallax;
  final double opacity;
  final List<_SpotData> spots;
  final double driftScale;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = controller.value * 2 * math.pi;

        return CustomPaint(
          painter: _NeonSpotsPainter(
            t: t,
            parallax: parallax,
            opacity: opacity,
            driftScale: driftScale,
            spots: spots,
          ),
        );
      },
    );
  }
}

class _NeonSpotsPainter extends CustomPainter {
  _NeonSpotsPainter({
    required this.t,
    required this.parallax,
    required this.opacity,
    required this.driftScale,
    required this.spots,
  });

  final double t;
  final Offset parallax;
  final double opacity;
  final double driftScale;
  final List<_SpotData> spots;

  @override
  void paint(Canvas canvas, Size size) {
    final shortest = math.min(size.width, size.height);

    for (var i = 0; i < spots.length; i++) {
      final s = spots[i];

      // Base position
      Offset center = s.align.alongSize(size);

      // Slow, tiny drift
      final dx = math.sin(t + i * 0.9) * (8.0 * driftScale);
      final dy = math.cos(t * .9 + i * 1.2) * (7.0 * driftScale);
      center += Offset(dx, dy);

      // Parallax offset
      center += parallax;

      final r = shortest * s.radiusFrac;
      final rect = Rect.fromCircle(center: center, radius: r);
      final shader = RadialGradient(
        colors: [
          s.color.withOpacity(opacity),
          s.color.withOpacity(0.0),
        ],
      ).createShader(rect);
      final paint = Paint()..shader = shader;

      // Soft outer glow shadow
      canvas.drawCircle(center, r * 1.05, Paint()
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40)
        ..color = s.color.withOpacity(opacity * .32));

      // Core blob
      canvas.drawCircle(center, r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NeonSpotsPainter old) =>
      old.t != t ||
          old.parallax != parallax ||
          old.opacity != opacity ||
          old.driftScale != driftScale ||
          !listEquals(old.spots, spots);
}

// ---------- Bokeh & Noise ----------

class _BokehPainter extends CustomPainter {
  _BokehPainter({
    required this.controller,
    required this.parallax,
    required this.count,
    required this.isDark,
  }) : super(repaint: controller);

  final AnimationController controller;
  final Offset parallax;
  final int count;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final rand = math.Random(7); // deterministic
    final t = controller.value;

    for (int i = 0; i < count; i++) {
      final base = Offset(rand.nextDouble() * size.width,
          rand.nextDouble() * size.height);

      // slow float
      final phase = i * .13;
      final dx = math.sin((t + phase) * 2 * math.pi) * 12;
      final dy = math.cos((t + phase) * 2 * math.pi) * 10;
      var pos = base + Offset(dx, dy);

      // parallax (closest layer)
      pos += parallax * 0.6;

      final r = 1.2 + (i % 4) * 0.6;
      final paint = Paint()
        ..color = (isDark ? Colors.white : Colors.black)
            .withOpacity(isDark ? .12 : .08)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawCircle(pos, r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BokehPainter oldDelegate) =>
      oldDelegate.parallax != parallax ||
          oldDelegate.count != count ||
          oldDelegate.isDark != isDark;
}

class _NoiseOverlay extends StatelessWidget {
  const _NoiseOverlay({this.opacity = .05, super.key});
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _NoisePainter(opacity: opacity),
      ),
    );
  }
}

class _NoisePainter extends CustomPainter {
  _NoisePainter({required this.opacity});
  final double opacity;
  final _rnd = math.Random(3);

  @override
  void paint(Canvas canvas, Size size) {
    final step = 3.0; // coarse grain for perf
    final paint = Paint();

    for (double y = 0; y < size.height; y += step) {
      for (double x = 0; x < size.width; x += step) {
        final v = 0.5 + _rnd.nextDouble() * 0.5; // 0.5..1.0
        paint.color = Colors.black.withOpacity(opacity * (1 - v));
        canvas.drawRect(Rect.fromLTWH(x, y, step, step), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _NoisePainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}
