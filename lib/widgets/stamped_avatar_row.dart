import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

/// ======= SIZING CONSTANTS (tweak here) =======
const double kAvatarOuterSize = 216;            // your avatar ring diameter
const double kStampSize       = kAvatarOuterSize - 28; // stamps slightly smaller
const double kStampGap        = 28;             // space between stamp and avatar

/// =========================
/// Circular passport-style stamp
/// =========================
class CircularStamp extends StatelessWidget {
  final String topText;
  final String bottomText;
  final double size;
  final Color color;
  final double tilt;
  final Duration delay;

  const CircularStamp({
    super.key,
    required this.topText,
    required this.bottomText,
    this.size = kStampSize,
    this.color = const Color(0xFF22D3EE),
    this.tilt = 0.0,
    this.delay = const Duration(milliseconds: 120),
  });

  @override
  Widget build(BuildContext context) {
    final core = Transform.rotate(
      angle: tilt,
      child: CustomPaint(
        painter: _StampPainter(ink: color),
        size: Size.square(size),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size * 0.10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  topText.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                    fontSize: size * 0.13,
                  ),
                ),
                SizedBox(height: size * 0.02),
                Icon(Icons.star_rate_rounded,
                    size: size * 0.15, color: color.withOpacity(0.9)),
                SizedBox(height: size * 0.02),
                Text(
                  bottomText.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                    fontSize: size * 0.13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return FadeIn(
      delay: delay,
      duration: const Duration(milliseconds: 420),
      child:
      ZoomIn(from: 0.78, duration: const Duration(milliseconds: 360), child: core),
    );
  }
}

/// Painter draws a bold ring + dashed inner ring (ink-stamp look)
class _StampPainter extends CustomPainter {
  final Color ink;
  _StampPainter({required this.ink});

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2;
    final center = Offset(r, r);

    // Outer bold ring (slightly slimmer for big sizes)
    final outer = Paint()
      ..color = ink.withOpacity(0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.045;
    canvas.drawCircle(center, r * 0.92, outer);

    // Inner dashed ring
    final inner = Paint()
      ..color = ink.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.022;
    const dashCount = 42;
    final dashSweep = (2 * 3.14159) / (dashCount * 2);
    final rr = r * 0.72;
    for (int i = 0; i < dashCount; i++) {
      final start = i * dashSweep * 2;
      final rect = Rect.fromCircle(center: center, radius: rr);
      canvas.drawArc(rect, start, dashSweep, false, inner);
    }

    // Subtle ink bleed
    final bleed = Paint()
      ..color = ink.withOpacity(0.16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.09
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);
    canvas.drawCircle(center, r * 0.92, bleed);
  }

  @override
  bool shouldRepaint(covariant _StampPainter oldDelegate) =>
      oldDelegate.ink != ink;
}

/// =========================
/// Row wrapper that places stamps BESIDE your avatar
/// (no overlap thanks to kStampSize + kStampGap)
/// =========================
class StampedAvatarRow extends StatelessWidget {
  final Widget avatar; // pass your _HeroAvatar() here

  const StampedAvatarRow({super.key, required this.avatar});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ⬅️ Left stamp
        const CircularStamp(
          topText: 'Junior Flutter',
          bottomText: 'Developer',
          size: kStampSize,
          color: Color(0xFF22D3EE),
          tilt: -0.14,
          delay: Duration(milliseconds: 80),
        ),

        const SizedBox(width: kStampGap),

        // 👤 Avatar (kept at full outer size)
        SizedBox(
          width: kAvatarOuterSize,
          height: kAvatarOuterSize,
          child: ZoomIn(
            duration: const Duration(milliseconds: 700),
            child: avatar,
          ),
        ),

        const SizedBox(width: kStampGap),

        // ➡️ Right stamp
        const CircularStamp(
          topText: 'Fresh Web',
          bottomText: 'Developer',
          size: kStampSize,
          color: Color(0xFFA78BFA),
          tilt: 0.14,
          delay: Duration(milliseconds: 160),
        ),
      ],
    );
  }
}
