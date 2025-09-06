import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';
import '../widgets/social_icon_button.dart';
// Hide CoursesSection if an older portfolio_hero.dart accidentally exported it
import '../widgets/portfolio_hero.dart' hide CoursesSection;
import '../widgets/sticky_rainbow_nav.dart';
import '../widgets/colorful_background.dart';
import '../widgets/elegant_background.dart';
import '../widgets/experience_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/courses_section.dart';
import '../widgets/blob_background.dart';

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: buildAppTheme(Brightness.light),
      darkTheme: buildAppTheme(Brightness.dark),
      home: const PortfolioHomePage(),
    );
  }
}

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  final _scrollCtrl = ScrollController();

  // section anchors
  final _aboutKey = GlobalKey();
  final _expKey = GlobalKey();
  final _skillsKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _coursesKey = GlobalKey();
  final _diplomaKey = GlobalKey(); // ⬅️ NEW: diploma anchor

  static const String cvUrl =
      'https://drive.google.com/file/d/1poZ04SmRsSOIlX_r2RMkc4BL9byvsoUT/view?usp=sharing';

  void _jumpTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeOutCubic,
        alignment: 0.05, // keep headings nicely visible
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    return Scaffold(
      // Sticky rainbow nav
      appBar: StickyRainbowNav(
        onTap: (id) {
          switch (id) {
            case 'about':
              _jumpTo(_aboutKey);
              break;
            case 'experience':
              _jumpTo(_expKey);
              break;
            case 'skills':
              _jumpTo(_skillsKey);
              break;
            case 'projects':
              _jumpTo(_projectsKey);
              break;
            case 'courses':
              _jumpTo(_coursesKey);
              break;
            case 'diploma': // ⬅️ NEW: scroll to diploma
              _jumpTo(_diplomaKey);
              break;
          }
        },
      ),
      body: Stack(
        children: [
          // Elegant mesh background
          const Positioned.fill(child: BlobBackground(speed: 0.18)),

          // content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, c) {
                final max = c.maxWidth;
                final isThree = max >= 1180;
                final isTwo = max >= 820 && !isThree;
                final columns = isThree ? 3 : (isTwo ? 2 : 1);
                final grid = SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.08,
                );

                return CustomScrollView(
                  controller: _scrollCtrl,
                  slivers: [
                    // === HERO (About) ===
                    SliverToBoxAdapter(
                      key: _aboutKey,
                      child: PortfolioHero(
                        name: 'Karam Kottish',
                        onJumpToProjects: () => _jumpTo(_projectsKey),
                        cvUrl: cvUrl,
                        email: 'karamkottish@gmail.com',
                      ),
                    ),

                    // 🔹 Animated divider
                    const SliverToBoxAdapter(child: AnimatedGradientDivider()),

                    // === SOCIALS ===
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 12,
                          children: const [
                            SocialIconButton(
                              assetPath: 'lib/assets/icons/icons8-github-100.svg',
                              tooltip: 'GitHub',
                              url: 'https://github.com/KaramKottish',
                            ),
                            SocialIconButton(
                              assetPath: 'lib/assets/icons/icons8-linkedin-100.svg',
                              tooltip: 'LinkedIn',
                              url: 'https://www.linkedin.com/in/karam-kottish/',
                            ),
                            SocialIconButton(
                              assetPath: 'lib/assets/icons/icons8-gitlab-100.svg',
                              tooltip: 'GitLab',
                              url: 'https://gitlab.com/KaramKottish',
                            ),
                          ],
                        ),
                      ),
                    ),

                    // === EXPERIENCE ===
                    SliverToBoxAdapter(
                      key: _expKey,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            _SectionHeader(icon: Icons.badge_outlined, title: 'Experience'),
                            SizedBox(height: 10),
                            ExperienceSection(),
                          ],
                        ),
                      ),
                    ),

                    // 🔹 Animated divider
                    const SliverToBoxAdapter(child: AnimatedGradientDivider()),

                    // === TECHNICAL SKILLS ===
                    SliverToBoxAdapter(
                      key: _skillsKey,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            _SectionHeader(icon: Icons.code_outlined, title: 'Technical Skills'),
                            SizedBox(height: 10),
                            SkillsSection(),
                          ],
                        ),
                      ),
                    ),

                    // 🔹 Animated divider
                    const SliverToBoxAdapter(child: AnimatedGradientDivider()),

                    // === SOFT SKILLS + LANGS ===
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            _SectionHeader(icon: Icons.handshake_outlined, title: 'Soft Skills'),
                            SizedBox(height: 10),
                            SoftSkillsSection(),
                            SizedBox(height: 18),
                            _SectionHeader(icon: Icons.language_outlined, title: 'Languages'),
                            SizedBox(height: 10),
                            LanguagesSection(),
                          ],
                        ),
                      ),
                    ),

                    // 🔹 Animated divider
                    const SliverToBoxAdapter(child: AnimatedGradientDivider()),

                    // === PROJECTS HEADER ===
                    SliverToBoxAdapter(
                      key: _projectsKey,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
                        child: const _SectionHeader(icon: Icons.auto_awesome, title: 'Projects'),
                      ),
                    ),

                    // === PROJECTS GRID ===
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                      sliver: SliverGrid(
                        gridDelegate: grid,
                        delegate: SliverChildListDelegate(const [
                          _ProjectCard(
                            title: '🎓 Graduation App',
                            subtitle: 'Flutter Lead • 2025',
                            description: 'Connecting Labors with Clients, offline cache, video demo.',
                            image: 'lib/assets/projects/RevonixYellow.jpg',
                            gradient: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                            tags: ['Flutter', 'Clean Architure ', 'NodeJs', 'Riverpod','Stripe','Firebase Notifications '],
                          ),
                          _ProjectCard(
                            title: '🛍️ E-commerce Clone',
                            subtitle: 'Solo • 2023',
                            description: 'Catalog, cart, payments, responsive web + mobile.',
                            image: 'lib/assets/projects/Shein-logo.png',
                            gradient: [Color(0xFF06D6A0), Color(0xFF00E5FF)],
                            tags: ['Stripe', 'Firebase', 'Responsive'],
                          ),
                          _ProjectCard(
                            title: '🔄 Change Volenteering App',
                            subtitle: 'Flutter Lead • 2023',
                            description: 'An App that helps Volenteerers connect with companies to volenteer with , theming, analytics.',
                            image: 'lib/assets/projects/Change.png',
                            gradient: [Color(0xFFFF6AC1), Color(0xFFFFD166)],
                            tags: ['Getx', 'Charts', 'Theming'],
                          ),
                        ]),
                      ),
                    ),

                    // 🔹 Animated divider
                    const SliverToBoxAdapter(child: AnimatedGradientDivider()),

                    // === COURSES ===
                    SliverToBoxAdapter(
                      key: _coursesKey,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            _SectionHeader(icon: Icons.school_outlined, title: 'Courses'),
                            SizedBox(height: 10),
                            CoursesSection(),
                          ],
                        ),
                      ),
                    ),

                    // 🔹 Divider before Diploma (optional)
                    const SliverToBoxAdapter(child: AnimatedGradientDivider()),

                    // === DIPLOMA (under Courses) ===
                    SliverToBoxAdapter(
                      key: _diplomaKey, // ⬅️ key attached so nav can scroll here
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
                        child: DiplomaSection(number: 1),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: t.colorScheme.primary),
        const SizedBox(width: 8),
        Text(title, style: t.textTheme.titleLarge),
      ],
    );
  }
}

/// Colorful card with gradient header strip + emoji tags
class _ProjectCard extends StatelessWidget {
  const _ProjectCard({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.image,
    required this.gradient,
    required this.tags,
  });

  final String title;
  final String subtitle;
  final String description;
  final String image;
  final List<Color> gradient;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surface,
      elevation: 2,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {},
        child: Ink(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // gradient header strip
              Container(
                height: 6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradient),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: cs.surfaceVariant,
                      alignment: Alignment.center,
                      child: const Text('No Image'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final tag in tags)
                    Chip(
                      label: Text(tag),
                      visualDensity: VisualDensity.compact,
                      side: BorderSide(color: cs.outlineVariant),
                      backgroundColor: cs.surfaceVariant.withOpacity(.35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Animated rainbow divider with a subtle shimmer
class AnimatedGradientDivider extends StatefulWidget {
  const AnimatedGradientDivider({super.key});

  @override
  State<AnimatedGradientDivider> createState() =>
      _AnimatedGradientDividerState();
}

class _AnimatedGradientDividerState extends State<AnimatedGradientDivider>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) {
          return CustomPaint(
            painter: _DividerPainter(progress: _ctrl.value),
            child: const SizedBox(
              height: 4,
              width: double.infinity,
            ),
          );
        },
      ),
    );
  }
}

class _DividerPainter extends CustomPainter {
  _DividerPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final margin = 60.0;
    final rect = Rect.fromLTWH(margin, 0, size.width - margin * 2, size.height);

    // Base rainbow gradient
    final base = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFFF6AC1), // pink
          Color(0xFFFFD166), // yellow
          Color(0xFF06D6A0), // teal
          Color(0xFF00E5FF), // blue
          Color(0xFF8B5CF6), // violet
        ],
      ).createShader(rect)
      ..strokeCap = StrokeCap.round;

    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(10));
    canvas.drawRRect(rrect, base);

    // Moving soft highlight (subtle shimmer)
    final bandWidth = rect.width * 0.18;
    final x = rect.left + (rect.width + bandWidth) * progress - bandWidth;
    final highlightRect = Rect.fromLTWH(x, rect.top, bandWidth, rect.height);

    final highlight = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.white.withOpacity(0.0),
          Colors.white.withOpacity(0.35),
          Colors.white.withOpacity(0.0),
        ],
      ).createShader(highlightRect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(highlightRect, const Radius.circular(10)),
      highlight,
    );
  }

  @override
  bool shouldRepaint(covariant _DividerPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
