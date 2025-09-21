import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Ultra-light, smooth background:
/// - Just two softly moving radial blobs (Transform only)
/// - Subtle vignette for contrast
/// - Set animate=false for zero motion
class LiteAuroraBackground extends StatefulWidget {
  const LiteAuroraBackground({
    super.key,
    this.animate = true,
    this.speed = 0.5,     // 0.5 ≈ 30s loop
    this.intensity = .6,  // 0..1
  });

  final bool animate;
  final double speed;
  final double intensity;

  @override
  State<LiteAuroraBackground> createState() => _LiteAuroraBackgroundState();
}

class _LiteAuroraBackgroundState extends State<LiteAuroraBackground>
    with SingleTickerProviderStateMixin {
  AnimationController? _ctrl;

  @override
  void initState() {
    super.initState();
    if (widget.animate) {
      _ctrl = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: (30000 ~/ widget.speed)),
      )..repeat();
    }
  }

  @override
  void dispose() {
    _ctrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget core = Stack(
      children: [
        // base gradient
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? const [Color(0xFF0E1016), Color(0xFF141827)]
                    : const [Color(0xFFF8FAFF), Color(0xFFF1F5FF)],
              ),
            ),
          ),
        ),
        // blob A
        _MovingBlob(
          controller: _ctrl,
          color: const Color(0xFF61E7FF),
          sizeFrac: .75,
          dx: 0.35,
          dy: -0.15,
          intensity: .9 * widget.intensity,
        ),
        // blob B
        _MovingBlob(
          controller: _ctrl,
          color: const Color(0xFFFF7AD1),
          sizeFrac: .65,
          dx: -0.3,
          dy: 0.25,
          intensity: .8 * widget.intensity,
          phase: .6,
        ),
        // vignette for text contrast
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.1,
                colors: [
                  Colors.black.withOpacity(isDark ? .20 : .10),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );

    return RepaintBoundary(
      child: (widget.animate && _ctrl != null)
          ? AnimatedBuilder(animation: _ctrl!, builder: (_, __) => core)
          : core,
    );
  }
}

class _MovingBlob extends StatelessWidget {
  const _MovingBlob({
    required this.controller,
    required this.color,
    required this.sizeFrac,
    required this.dx,
    required this.dy,
    required this.intensity,
    this.phase = 0.0,
  });

  final AnimationController? controller;
  final Color color;
  final double sizeFrac;
  final double dx;
  final double dy;
  final double intensity;
  final double phase;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: LayoutBuilder(builder: (context, c) {
        final w = c.maxWidth;
        final h = c.maxHeight;
        final shortest = w < h ? w : h;
        final blobSize = shortest * sizeFrac;

        final t = (controller?.value ?? 0) * 2 * math.pi + phase;
        final ox = math.sin(t) * 12.0;
        final oy = math.cos(t * .9) * 10.0;

        return Transform.translate(
          offset: Offset(ox, oy),
          child: Align(
            alignment: Alignment(dx, dy),
            child: IgnorePointer(
              child: Container(
                width: blobSize,
                height: blobSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      color.withOpacity(.55 * intensity),
                      color.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
