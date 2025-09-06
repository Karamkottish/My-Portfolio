// lib/widgets/portfolio_hero.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// ================= HERO =================
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
            Positioned.fill(
              child: CustomPaint(painter: _BlobPainter(progress: _anim.value)),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(painter: _ConfettiPainter(progress: _anim.value)),
              ),
            ),
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
                            'Clean UI, smooth motion, and real-world performance — with a sprinkle of Engineering .',
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
    if (!await launchUrl(
      uri,
      mode: url.startsWith('mailto:')
          ? LaunchMode.platformDefault
          : LaunchMode.externalApplication,
    )) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not open: $url')));
    }
  }
}

/// ================= HERO SUPPORT WIDGETS =================

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

    // Robust shader: if rect.height is 0 (rare on web), give a sane fallback height
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
        LayoutBuilder(
          builder: (_, box) {
            final gradient = const LinearGradient(
              colors: [
                Color(0xFFFF6AC1),
                Color(0xFFFFD166),
                Color(0xFF06D6A0),
                Color(0xFF00E5FF),
                Color(0xFF8B5CF6),
              ],
            );
            return ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (rect) {
                final h = rect.height == 0 ? (mobile ? 42.0 : 70.0) : rect.height;
                final r = Rect.fromLTWH(-200 + dx, 0, rect.width + 400, h);
                return gradient.createShader(r);
              },
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
            );
          },
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

/// ================= DECORATIVE PAINTERS =================

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
  bool shouldRepaint(covariant _BlobPainter oldDelegate) => oldDelegate.progress != progress;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
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
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => oldDelegate.progress != progress;
}

/// ==========================================================================
/// DIPLOMA (Courses-style: colorful card + gradient number pill + animation)
/// ==========================================================================
/// Use this widget UNDER your CoursesSection in the page file:
///   const DiplomaSection(number: 1),
class DiplomaSection extends StatefulWidget {
  const DiplomaSection({super.key, this.number = 1});
  final int number;

  @override
  State<DiplomaSection> createState() => _DiplomaSectionState();
}

class _DiplomaSectionState extends State<DiplomaSection>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  late final AnimationController _anim =
  AnimationController(vsync: this, duration: const Duration(seconds: 3))
    ..repeat();

  static const String mainDiploma = 'lib/assets/Diploma/uiuxDiploma.png';
  static const List<String> gallery = [
    'lib/assets/Diploma/userxperienceDesign.png',
    'lib/assets/Diploma/userxperienceReserach.png',
    'lib/assets/Diploma/userdesignFundementals.png',
    'lib/assets/Diploma/designPrincepls.png',
  ];

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 720;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header like Courses: title + gradient pill with number
            Row(
              children: [
                Text(
                  'Diploma',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                _GradientPill(text: widget.number.toString().padLeft(2, '0')),
              ],
            ),
            const SizedBox(height: 12),

            // Main colorful card (matches Courses visual language)
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 820),
                  child: AnimatedBuilder(
                    animation: _anim,
                    builder: (_, __) {
                      final t = _anim.value * 2 * pi;
                      final dy = sin(t) * 6; // float
                      final scale = 0.995 + (cos(t) * 0.005);
                      return Transform.translate(
                        offset: Offset(0, dy),
                        child: Transform.scale(
                          scale: scale,
                          child: _DiplomaCoursesStyleCard(
                            imagePath: mainDiploma,
                            title: 'UI/UX Diploma',
                            subtitle: _expanded
                                ? 'Tap to collapse'
                                : 'Tap to view certificate set',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Gallery (compact grid)
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: LayoutBuilder(
                      builder: (_, box) {
                        final crossAxisCount = isMobile ? 2 : 4;
                        const spacing = 10.0;
                        final rawItemW = (box.maxWidth -
                            spacing * (crossAxisCount - 1)) /
                            crossAxisCount;
                        final itemW = isMobile
                            ? rawItemW
                            : rawItemW.clamp(0, 220).toDouble();
                        final itemH = itemW * (2 / 3); // 3:2 ratio

                        return Wrap(
                          spacing: spacing,
                          runSpacing: spacing,
                          children: [
                            for (final p in gallery)
                              SizedBox(
                                width: itemW,
                                height: itemH,
                                child: _GalleryThumb(imagePath: p),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              crossFadeState:
              _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 220),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small gradient pill to display "01", "02", ...
class _GradientPill extends StatelessWidget {
  const _GradientPill({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient:
        const LinearGradient(colors: [Color(0xFFFF6AC1), Color(0xFF00E5FF)]),
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}

/// Courses-style card: rounded, border, shadow, top rainbow strip, bottom overlay
class _DiplomaCoursesStyleCard extends StatelessWidget {
  const _DiplomaCoursesStyleCard({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  final String imagePath;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final border = isDark ? Colors.white24 : Colors.black12;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,

      // 🔧 Give Stack a finite size with AspectRatio
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Stack(
          children: [
            // Image
            Positioned.fill(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade800,
                  child: const Center(
                    child: Icon(Icons.broken_image,
                        color: Colors.white54, size: 48),
                  ),
                ),
              ),
            ),

            // Rainbow header strip
            const Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: 6,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFF6AC1),
                      Color(0xFFFFD166),
                      Color(0xFF06D6A0),
                      Color(0xFF00E5FF),
                      Color(0xFF8B5CF6),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.55), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),

            // Bottom title + hint
            Positioned(
              left: 14,
              bottom: 12,
              right: 14,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            shadows: [
                              Shadow(
                                blurRadius: 6,
                                color: Colors.black54,
                                offset: Offset(1, 1),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.zoom_in, size: 18, color: Colors.white70),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _GalleryThumb extends StatelessWidget {
  const _GalleryThumb({required this.imagePath});
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(imagePath, fit: BoxFit.cover),
          Positioned(
            right: 6,
            bottom: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.zoom_in, size: 12, color: Colors.white),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  barrierColor: Colors.black87,
                  builder: (_) => GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: InteractiveViewer(
                      minScale: 0.8,
                      maxScale: 4,
                      child: Center(
                        child: Image.asset(imagePath, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
