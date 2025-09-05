import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Colorful, happy hero with rainbow headline, candy buttons, and confetti shapes.
class PortfolioHero extends StatefulWidget {
  const PortfolioHero({
    super.key,
    required this.name,
    required this.onJumpToProjects,
    required this.cvUrl,
    required this.email,
  });

  final String name;
  final VoidCallback onJumpToProjects;
  final String cvUrl;
  final String email;

  @override
  State<PortfolioHero> createState() => _PortfolioHeroState();
}

class _PortfolioHeroState extends State<PortfolioHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim =
  AnimationController(vsync: this, duration: const Duration(seconds: 10))
    ..repeat();

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        return Stack(
          children: [
            // playful pastel background blobs
            Positioned.fill(
              child: CustomPaint(
                painter: _BlobPainter(progress: _anim.value),
              ),
            ),
            // confetti dots
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _ConfettiPainter(progress: _anim.value),
                ),
              ),
            ),
            // content
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 64, 20, 32),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _RainbowHeadline(
                          line1: 'Hey, I\'m ${widget.name} 👋',
                          line2: 'Flutter Developer / Frontend Web Developer',
                          progress: _anim.value,
                        ),
                        const SizedBox(height: 14),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 900),
                          child: Text(
                            'Clean UI, smooth motion, and real-world performance — '
                                'with a sprinkle of Engineering .',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: cs.onSurfaceVariant),
                          ),
                        ),
                        const SizedBox(height: 22),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 12,
                          runSpacing: 10,
                          children: [
                            _PillCTA(
                              label: '🎉 View Projects',
                              onPressed: widget.onJumpToProjects,
                              bg: const Color(0xFF7C3AED),
                            ),
                            _CandyCTA(
                              label: '📄 View CV',
                              onPressed: () => _launch(context, widget.cvUrl),
                            ),
                            _CandyCTA(
                              label: '✉️ Contact Me',
                              onPressed: () =>
                                  _launch(context, 'mailto:${widget.email}'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // cheerful wave divider
                SizedBox(
                  height: 90,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _WavePainter(
                      leftColor: const Color(0xFF00E5FF),
                      rightColor: const Color(0xFFFF6AC1),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  static Future<void> _launch(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri,
        mode: url.startsWith('mailto:')
            ? LaunchMode.platformDefault
            : LaunchMode.externalApplication)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not open: $url')));
    }
  }
}

/// Animated rainbow headline (solid intro + gradient marquee)
class _RainbowHeadline extends StatelessWidget {
  const _RainbowHeadline({
    required this.line1,
    required this.line2,
    required this.progress,
  });

  final String line1;
  final String line2;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final mobile = w < 720;

    // Animate gradient offset for a subtle shimmer
    final dx = (progress * 600) % 600;

    return Column(
      children: [
        Text(
          line1,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: mobile ? 30 : 48,
            height: 1.08,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0F172A),
            letterSpacing: -.4,
          ),
        ),
        const SizedBox(height: 6),
        ShaderMask(
          shaderCallback: (rect) => const LinearGradient(
            colors: [
              Color(0xFFFF6AC1),
              Color(0xFFFFD166),
              Color(0xFF06D6A0),
              Color(0xFF00E5FF),
              Color(0xFF8B5CF6),
            ],
          ).createShader(Rect.fromLTWH(-200 + dx, 0, rect.width + 400, rect.height)),
          child: Text(
            line2,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: mobile ? 36 : 64,
              height: 1.06,
              fontWeight: FontWeight.w900,
              color: Colors.white, // masked by shader
              letterSpacing: -.6,
            ),
          ),
        ),
      ],
    );
  }
}

class _PillCTA extends StatelessWidget {
  const _PillCTA({required this.label, required this.onPressed, required this.bg});
  final String label;
  final VoidCallback onPressed;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        elevation: 3,
      ),
      child: Text(label),
    );
  }
}

class _CandyCTA extends StatelessWidget {
  const _CandyCTA({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: cs.primary,
        side: BorderSide(color: cs.primary.withOpacity(.35)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      child: Text(label),
    );
  }
}

// ===== Decorative Painters =====

class _WavePainter extends CustomPainter {
  _WavePainter({required this.leftColor, required this.rightColor});
  final Color leftColor;
  final Color rightColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [leftColor, rightColor],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Offset.zero & size);

    final p = Path()
      ..moveTo(0, size.height * .35)
      ..quadraticBezierTo(size.width * .25, size.height * .55, size.width * .55, size.height * .50)
      ..quadraticBezierTo(size.width * .85, size.height * .45, size.width, size.height * .60)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(p, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BlobPainter extends CustomPainter {
  _BlobPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final blobs = [
      (color: const Color(0xFFFFEEF6), center: Offset(size.width * .2, size.height * .25), r: 220.0),
      (color: const Color(0xFFE7FFF8), center: Offset(size.width * .8, size.height * .22), r: 200.0),
      (color: const Color(0xFFEFF4FF), center: Offset(size.width * .55, size.height * .48), r: 280.0),
    ];

    for (var i = 0; i < blobs.length; i++) {
      final dx = sin(progress * 2 * pi + i) * 12;
      final dy = cos(progress * 2 * pi + i) * 8;
      final paint = Paint()..color = blobs[i].color;
      canvas.drawCircle(blobs[i].center + Offset(dx, dy), blobs[i].r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BlobPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = Random(42);
    final colors = const [
      Color(0xFFFF6AC1),
      Color(0xFFFFD166),
      Color(0xFF06D6A0),
      Color(0xFF00E5FF),
      Color(0xFF8B5CF6),
    ];
    final paint = Paint();

    for (int i = 0; i < 70; i++) {
      final c = colors[i % colors.length].withOpacity(0.25);
      paint.color = c;
      final x = (i * 97 + progress * size.width * 0.6) % size.width;
      final y = (i * 37) % size.height * .9;
      final r = 2.5 + (i % 3);
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
