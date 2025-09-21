// lib/widgets/portfolio_hero.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PortfolioHero extends StatefulWidget {
  const PortfolioHero({
    super.key,
    required this.name,
    required this.onJumpToProjects,
    required this.cvUrl,
    required this.email,
    this.compact = false,
  });

  final String name;
  final VoidCallback onJumpToProjects;
  final String cvUrl;
  final String email;
  final bool compact;

  @override
  State<PortfolioHero> createState() => _PortfolioHeroState();
}

class _PortfolioHeroState extends State<PortfolioHero>
    with TickerProviderStateMixin { // ✅ allow multiple tickers
  late final AnimationController _ctrl =
  AnimationController(vsync: this, duration: const Duration(seconds: 10));
  late final CurvedAnimation _curve =
  CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);

  // Entrance animation (fade + slide)
  late final AnimationController _enter =
  AnimationController(vsync: this, duration: const Duration(milliseconds: 650))
    ..forward();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Respect user's reduced motion preference
    final reduced = MediaQuery.of(context).disableAnimations;
    if (reduced) {
      _ctrl.stop();
    } else {
      if (!_ctrl.isAnimating) _ctrl.repeat();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _enter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final size = MediaQuery.sizeOf(context);
    final isMobile = size.width < 720 || widget.compact;

    // Slightly slower shimmer on tiny screens (battery friendly)
    if (!_ctrl.isAnimating && !MediaQuery.of(context).disableAnimations) {
      _ctrl.repeat(
        period: Duration(milliseconds: isMobile ? 12000 : 10000),
      );
    }

    return AnimatedBuilder(
      animation: _curve,
      builder: (_, __) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            isMobile ? 28 : 64,
            20,
            isMobile ? 20 : 32,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: FadeTransition(
                opacity: _enter.drive(Tween<double>(begin: 0, end: 1)),
                child: SlideTransition(
                  position: _enter.drive(
                    Tween<Offset>(
                      begin: const Offset(0, .06),
                      end: Offset.zero,
                    ).chain(CurveTween(curve: Curves.easeOutCubic)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _AnimatedHeadline(
                        line1: "Hey, I'm ${widget.name} 👋",
                        line2: 'Flutter Developer / Frontend Web Developer',
                        progress: _curve.value,
                        isMobile: isMobile,
                      ),
                      const SizedBox(height: 14),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 900),
                        child: Text(
                          'Clean UI, smooth motion, and real-world performance — with a sprinkle of Engineering.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: cs.onSurfaceVariant,
                            fontSize: isMobile ? 14 : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),

                      // CTAs with tiny hover scale for delight (no layout shift)
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 12,
                        runSpacing: 10,
                        children: [
                          _HoverScale(
                            child: _PillCTA(
                              label: '🎉 View Projects',
                              onPressed: widget.onJumpToProjects,
                              bg: const Color(0xFF7C3AED),
                            ),
                          ),
                          _HoverScale(
                            child: _CandyCTA(
                              label: '🗂  View CV',
                              onPressed: () => _launch(context, widget.cvUrl),
                            ),
                          ),
                          _HoverScale(
                            child: _CandyCTA(
                              label: '✉️ Contact Me',
                              onPressed: () =>
                                  _launch(context, 'mailto:${widget.email}'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<void> _launch(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    final ok = await launchUrl(
      uri,
      mode: url.startsWith('mailto:')
          ? LaunchMode.platformDefault
          : LaunchMode.externalApplication,
    );
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not open: $url')));
    }
  }
}

/// ---------- Headline with smooth shimmer & glow ----------
class _AnimatedHeadline extends StatelessWidget {
  const _AnimatedHeadline({
    required this.line1,
    required this.line2,
    required this.progress,
    required this.isMobile,
  });

  final String line1;
  final String line2;
  final double progress;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    // progress is eased 0..1; convert to a loop with cosine for ultra smoothness
    final easedLoop = (1 - math.cos(progress * 2 * math.pi)) / 2; // 0..1..0
    final dx = _lerpDouble(-180, 220, easedLoop); // shimmer travel

    const rainbow = LinearGradient(
      colors: [
        Color(0xFFFF6AC1),
        Color(0xFFFFD166),
        Color(0xFF06D6A0),
        Color(0xFF00E5FF),
        Color(0xFF8B5CF6),
      ],
    );

    final nameSize = isMobile ? 36.0 : 66.0;
    final roleSize = isMobile ? 32.0 : 60.0;

    return Column(
      children: [
        // NAME — gradient + soft glow for readability
        Stack(
          alignment: Alignment.center,
          children: [
            Text(
              line1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: nameSize,
                height: 1.05,
                fontWeight: FontWeight.w900,
                color: Colors.transparent,
                shadows: const [
                  Shadow(blurRadius: 20, color: Color(0x55FFFFFF), offset: Offset(0, 2)),
                  Shadow(blurRadius: 36, color: Color(0x33FFFFFF), offset: Offset(0, 6)),
                ],
              ),
            ),
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (rect) {
                final h = rect.height == 0 ? (isMobile ? 40.0 : 72.0) : rect.height;
                final area = Rect.fromLTWH(dx, 0, rect.width + 360, h);
                return rainbow.createShader(area);
              },
              child: Text(
                line1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: nameSize,
                  height: 1.05,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.4,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // ROLE — slightly smaller to keep focus on name
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (rect) {
            final h = rect.height == 0 ? (isMobile ? 38.0 : 68.0) : rect.height;
            final area = Rect.fromLTWH(dx, 0, rect.width + 360, h);
            return rainbow.createShader(area);
          },
          child: Text(
            line2,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: roleSize,
              height: 1.06,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.6,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  double _lerpDouble(num a, num b, double t) => a + (b - a) * t;
}

/// ---------- Buttons ----------
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

/// ---------- Tiny hover scale wrapper (perf-safe, no layout shift) ----------
class _HoverScale extends StatefulWidget {
  const _HoverScale({required this.child, this.scale = 1.04});
  final Widget child;
  final double scale;

  @override
  State<_HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<_HoverScale> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        scale: _hover ? widget.scale : 1,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
