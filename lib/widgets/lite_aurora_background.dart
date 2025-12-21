import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 2026 Atmospheric Background
/// - No blobs
/// - No images
/// - Light planes + ambient glow
/// - Extremely subtle motion
class LiteAuroraBackground extends StatefulWidget {
  const LiteAuroraBackground({
    super.key,
    this.animate = true,
    this.speed = 0.4,
    this.intensity = 0.55,
  });

  final bool animate;
  final double speed;
  final double intensity;

  @override
  State<LiteAuroraBackground> createState() => _LiteAuroraBackgroundState();
}

class _LiteAuroraBackgroundState extends State<LiteAuroraBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (36000 ~/ widget.speed)),
    );

    if (widget.animate) {
      _ctrl.repeat();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) {
          final t = _ctrl.value;

          final hueShift = math.sin(t * 2 * math.pi) * 6;

          return Stack(
            children: [
              // ─────────────────────────────────────────────
              // Base atmospheric gradient
              // ─────────────────────────────────────────────
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? const [
                        Color(0xFF0A0D14),
                        Color(0xFF141A2E),
                        Color(0xFF0F1220),
                      ]
                          : const [
                        Color(0xFFF9FBFF),
                        Color(0xFFF1F5FF),
                        Color(0xFFEFF2FF),
                      ],
                    ),
                  ),
                ),
              ),

              // ─────────────────────────────────────────────
              // Light Plane 1 (top-left → center)
              // ─────────────────────────────────────────────
              _LightPlane(
                angle: -0.6,
                offset: -0.25 + math.sin(t * 2 * math.pi) * 0.03,
                color: _shiftHue(
                  isDark
                      ? const Color(0xFF6EE7F9)
                      : const Color(0xFFB8CCFF),
                  hueShift,
                ),
                intensity: widget.intensity * 0.7,
              ),

              // ─────────────────────────────────────────────
              // Light Plane 2 (bottom-right → center)
              // ─────────────────────────────────────────────
              _LightPlane(
                angle: 2.4,
                offset: 0.35 + math.cos(t * 2 * math.pi) * 0.03,
                color: _shiftHue(
                  isDark
                      ? const Color(0xFFFF7AD1)
                      : const Color(0xFFFFC7E5),
                  -hueShift,
                ),
                intensity: widget.intensity * 0.6,
              ),

              // ─────────────────────────────────────────────
              // Ambient glow band (center horizon)
              // ─────────────────────────────────────────────
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          (isDark
                              ? const Color(0xFF5B8CFF)
                              : const Color(0xFF8BA4FF))
                              .withOpacity(0.08 * widget.intensity),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ─────────────────────────────────────────────
              // Vignette (text & glass contrast)
              // ─────────────────────────────────────────────
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      radius: 1.2,
                      colors: [
                        Colors.black.withOpacity(isDark ? 0.32 : 0.12),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Light Plane (directional, not a blob)
// ─────────────────────────────────────────────
class _LightPlane extends StatelessWidget {
  const _LightPlane({
    required this.angle,
    required this.offset,
    required this.color,
    required this.intensity,
  });

  final double angle;
  final double offset;
  final Color color;
  final double intensity;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Transform.rotate(
          angle: angle,
          child: Align(
            alignment: Alignment(offset, 0),
            child: Container(
              width: MediaQuery.of(context).size.width * 1.4,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.0),
                    color.withOpacity(0.35 * intensity),
                    color.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Hue shift utility (very subtle)
// ─────────────────────────────────────────────
Color _shiftHue(Color color, double delta) {
  final hsv = HSVColor.fromColor(color);
  return hsv.withHue((hsv.hue + delta) % 360).toColor();
}
