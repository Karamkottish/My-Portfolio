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

    // ✅ NEW
    this.pmFocus = true,
    this.atsMode = false,
    this.currentlyAt = 'Paws Pal Connect',
  });

  final String name;
  final VoidCallback onJumpToProjects;
  final String cvUrl;
  final String email;
  final bool compact;

  /// Recruiter-first variant
  final bool pmFocus;

  /// Disable gradients / animation for ATS & PDF
  final bool atsMode;

  /// Status pill text
  final String currentlyAt;

  @override
  State<PortfolioHero> createState() => _PortfolioHeroState();
}

class _PortfolioHeroState extends State<PortfolioHero>
    with TickerProviderStateMixin {
  late final AnimationController _shimmer =
  AnimationController(vsync: this, duration: const Duration(seconds: 10));

  late final AnimationController _enter =
  AnimationController(vsync: this, duration: const Duration(milliseconds: 650))
    ..forward();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = MediaQuery.of(context).disableAnimations || widget.atsMode;
    if (!reduceMotion && !_shimmer.isAnimating) {
      _shimmer.repeat();
    }
  }

  @override
  void dispose() {
    _shimmer.dispose();
    _enter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);
    final isMobile = size.width < 720 || widget.compact;
    final reduceMotion = MediaQuery.of(context).disableAnimations || widget.atsMode;

    final roleLine = widget.pmFocus
        ? 'Product Manager · Flutter & Frontend Engineer · React Native'
        : 'Flutter Developer · Frontend Engineer · React Native';

    final description = widget.pmFocus
        ? 'I lead and build digital products — from strategy and UX to scalable Flutter and frontend engineering.'
        : 'I design and build clean, performant Flutter and frontend applications with smooth UX.';

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
            opacity: reduceMotion
                ? const AlwaysStoppedAnimation(1)
                : _enter.drive(Tween(begin: 0.0, end: 1.0)),
            child: SlideTransition(
              position: reduceMotion
                  ? const AlwaysStoppedAnimation(Offset.zero)
                  : _enter.drive(
                Tween(
                  begin: const Offset(0, .06),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeOutCubic)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Headline(
                    name: widget.name,
                    role: roleLine,
                    shimmer: _shimmer,
                    isMobile: isMobile,
                    atsMode: widget.atsMode,
                    isDark: isDark,
                  ),

                  if (!widget.atsMode) ...[
                    const SizedBox(height: 10),
                    _StatusPill(
                      label: 'Currently at ${widget.currentlyAt}',
                      color: cs.primary,
                    ),
                  ],

                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                        fontSize: isMobile ? 14 : null,
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 10,
                    children: [
                      _CTA(
                        filled: true,
                        label: '🚀 Explore Projects',
                        onPressed: widget.onJumpToProjects,
                      ),
                      _CTA(
                        label: '📄 View CV',
                        onPressed: () => _launch(context, widget.cvUrl),
                      ),
                      _CTA(
                        label: '✉️ Contact',
                        onPressed: () =>
                            _launch(context, 'mailto:${widget.email}'),
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
  }

  static Future<void> _launch(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

// ===================== HEADLINE =====================

class _Headline extends StatelessWidget {
  const _Headline({
    required this.name,
    required this.role,
    required this.shimmer,
    required this.isMobile,
    required this.atsMode,
    required this.isDark,
  });

  final String name;
  final String role;
  final AnimationController shimmer;
  final bool isMobile;
  final bool atsMode;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final nameSize = isMobile ? 36.0 : 66.0;
    final roleSize = isMobile ? 26.0 : 44.0;

    if (atsMode) {
      return Column(
        children: [
          Text("Hey, I'm $name",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: nameSize, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(role,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: roleSize, fontWeight: FontWeight.w700)),
        ],
      );
    }

    return AnimatedBuilder(
      animation: shimmer,
      builder: (_, __) {
        final t = shimmer.value;
        final dx = (1 - math.cos(t * 2 * math.pi)) / 2 * 360 - 180;

        final gradient = LinearGradient(
          colors: isDark
              ? const [
            Color(0xFF8B5CF6),
            Color(0xFF06D6A0),
          ]
              : const [
            Color(0xFFFF6AC1),
            Color(0xFFFFD166),
            Color(0xFF06D6A0),
            Color(0xFF00E5FF),
            Color(0xFF8B5CF6),
          ],
        );

        return Column(
          children: [
            _ShimmerText(
              text: "Hey, I'm $name 👋",
              size: nameSize,
              dx: dx,
              gradient: gradient,
            ),
            const SizedBox(height: 8),
            _ShimmerText(
              text: role,
              size: roleSize,
              dx: dx,
              gradient: gradient,
            ),
          ],
        );
      },
    );
  }
}
class ProductImpactSection extends StatelessWidget {
  const ProductImpactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    final impacts = [
      'Led product roadmap driving +32% user engagement',
      'Shipped 18 production releases with zero critical rollbacks',
      'Reduced delivery cycle by 40% through sprint optimization',
      'Translated business needs into actionable user stories',
      'Improved onboarding clarity via UX iteration & feedback',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Product Impact',
            style: t.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 14),
        ...impacts.map(
              (i) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.trending_up, color: cs.primary, size: 18),
                const SizedBox(width: 10),
                Expanded(child: Text(i, style: t.bodyMedium)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
class ProductPhilosophySection extends StatelessWidget {
  const ProductPhilosophySection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('How I Think About Products',
            style: t.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        Text(
          '• I start with the problem, not the feature\n'
              '• I validate assumptions early and iterate fast\n'
              '• UX is a product decision, not decoration\n'
              '• I optimize for outcomes, not output\n'
              '• I balance speed with long-term maintainability',
          style: t.bodyMedium?.copyWith(height: 1.6),
        ),
      ],
    );
  }
}
class ProductThinkingSection extends StatelessWidget {
  const ProductThinkingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('How I Think About Products',
            style: t.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        Text(
          '• Start with the problem, not the feature\n'
              '• Ship small, learn fast\n'
              '• UX is a product decision\n'
              '• Optimize for outcomes, not output\n'
              '• Balance speed with scalability',
          style: t.bodyMedium?.copyWith(height: 1.6),
        ),
      ],
    );
  }
}

class CurrentlyBuildingSection extends StatelessWidget {
  const CurrentlyBuildingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Currently Building',
            style: t.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        Text(
          '• Scaling Paws Pal Connect features based on user analytics\n'
              '• Improving onboarding and retention flows\n'
              '• Deepening product analytics & feedback loops\n'
              '• Expanding leadership into multi-product ownership',
          style: t.bodyMedium?.copyWith(height: 1.6),
        ),
      ],
    );
  }
}

class _ShimmerText extends StatelessWidget {
  const _ShimmerText({
    required this.text,
    required this.size,
    required this.dx,
    required this.gradient,
  });

  final String text;
  final double size;
  final double dx;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (rect) =>
          gradient.createShader(Rect.fromLTWH(dx, 0, rect.width + 360, rect.height)),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: size,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.6,
        ),
      ),
    );
  }
}

// ===================== SMALL UI =====================

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(label,
          style: TextStyle(color: color, fontWeight: FontWeight.w700)),
    );
  }
}

class _CTA extends StatelessWidget {
  const _CTA({
    required this.label,
    required this.onPressed,
    this.filled = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return filled
        ? FilledButton(onPressed: onPressed, child: Text(label))
        : OutlinedButton(onPressed: onPressed, child: Text(label));
  }

}
