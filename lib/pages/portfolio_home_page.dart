import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';

import '../theme.dart';
import '../widgets/designs_section.dart';
import '../widgets/inline_video_player.dart' show InlineVideoPlayer;
import '../widgets/social_icon_button.dart';
import '../widgets/portfolio_hero.dart' hide CoursesSection;
import '../widgets/sticky_rainbow_nav.dart';

// Smooth background & divider
import '../widgets/lite_aurora_background.dart';
import '../widgets/calm_divider.dart';

// Your sections
import '../widgets/experience_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/courses_section.dart';
import '../widgets/diploma_section.dart';

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

  final _aboutKey = GlobalKey();
  final _expKey = GlobalKey();
  final _skillsKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _coursesKey = GlobalKey();
  final _diplomaKey = GlobalKey();
  final _designsKey = GlobalKey();


  static const String cvUrl =
      'https://drive.google.com/file/d/1-hgV-zkoYVaZudk9sFSjY8rXolNTnWx4/view?usp=sharing';

  static const int skillsCount = 24;

  void _jumpTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeOutCubic,
        alignment: 0.05,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final shortest = MediaQuery.of(context).size.shortestSide;
    final animateBg = shortest >= 900; // animate only on large screens

    return Scaffold(
        appBar: StickyRainbowNav(
          onTap: (id) {
            switch (id) {
              case 'about': _jumpTo(_aboutKey); break;
              case 'experience': _jumpTo(_expKey); break;
              case 'skills': _jumpTo(_skillsKey); break;
              case 'projects': _jumpTo(_projectsKey); break;
              case 'courses': _jumpTo(_coursesKey); break;
              case 'diploma': _jumpTo(_diplomaKey); break;
              case 'designs': _jumpTo(_designsKey); break; // ✅ NEW
            }
          },
        ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            final max = c.maxWidth;
            final isMobile = max < 600;
            final isTablet = max >= 600 && max < 1024;
            final isDesktop = max >= 1024;

            final columns = isDesktop ? 3 : (isTablet ? 2 : 1);
            final childAspect = isDesktop ? 1.10 : (isTablet ? 1.03 : 0.88);

            final grid = SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: isMobile ? 12 : 16,
              crossAxisSpacing: isMobile ? 12 : 16,
              childAspectRatio: childAspect,
            );

            final horizontalPad = EdgeInsets.symmetric(
              horizontal: isDesktop ? 20 : (isTablet ? 16 : 12),
            );

            return Stack(
              children: [
                // Smooth + light background
                Positioned.fill(
                  child: LiteAuroraBackground(
                    animate: animateBg,
                    speed: 0.5,
                    intensity: .60,
                  ),
                ),

                CustomScrollView(
                  controller: _scrollCtrl,
                  slivers: [
                    // ===== Hero / About =====
                    SliverToBoxAdapter(
                      key: _aboutKey,
                      child: Padding(
                        padding: horizontalPad.copyWith(top: isMobile ? 8 : 0),
                        child: PortfolioHero(
                          name: 'Karam Kottish',
                          onJumpToProjects: () => _jumpTo(_projectsKey),
                          cvUrl: cvUrl,
                          email: 'karamkottish@gmail.com',
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: CalmDivider()),

                    // ===== Socials =====
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: horizontalPad.copyWith(
                          bottom: isMobile ? 4 : 8,
                        ),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: isMobile ? 10 : 12,
                          runSpacing: isMobile ? 8 : 10,
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
                    const SliverToBoxAdapter(child: CalmDivider()),

                    // ===== Experience =====
                    SliverToBoxAdapter(
                      key: _expKey,
                      child: Padding(
                        padding: horizontalPad.copyWith(
                          top: isMobile ? 8 : 16,
                          bottom: isMobile ? 4 : 8,
                        ),
                        child: _SectionHeader(
                          icon: Icons.work_outline,
                          title: 'Experience',
                          isMobile: isMobile,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: horizontalPad.copyWith(top: isMobile ? 8 : 12),
                        child: const ExperienceSection(),
                      ),
                    ),
                    const SliverToBoxAdapter(child: CalmDivider()),

                    // ===== Skills =====
                    SliverToBoxAdapter(
                      key: _skillsKey,
                      child: Padding(
                        padding: horizontalPad.copyWith(
                          top: isMobile ? 12 : 24,
                          bottom: isMobile ? 4 : 8,
                        ),
                        child: _SectionHeaderWithBadge(
                          icon: Icons.build_outlined,
                          title: 'Skills',
                          label: '$skillsCount skills',
                          isMobile: isMobile,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: horizontalPad.copyWith(top: isMobile ? 8 : 12),
                        child: const SkillsSection(),
                      ),
                    ),
                    const SliverToBoxAdapter(child: CalmDivider()),

                    // ===== Projects =====
                    SliverToBoxAdapter(
                      key: _projectsKey,
                      child: Padding(
                        padding: horizontalPad.copyWith(
                          top: isMobile ? 16 : 28,
                          bottom: isMobile ? 4 : 8,
                        ),
                        child: _SectionHeader(
                          icon: Icons.auto_awesome,
                          title: 'Projects',
                          isMobile: isMobile,
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        isDesktop ? 20 : (isTablet ? 16 : 12),
                        isMobile ? 8 : 12,
                        isDesktop ? 20 : (isTablet ? 16 : 12),
                        isMobile ? 18 : 24,
                      ),
                      sliver: SliverGrid(
                        gridDelegate: grid,
                        // NOTE: SliverGrid expects a SliverChildDelegate, not a Widget
                        delegate: SliverChildListDelegate([
                          _ProjectCard(
                            title: '🏫 Karam University',
                            subtitle: 'React Native • 2025',
                            description: 'Modern, clean, trendy university platform with 3D UI and responsive UX. '
                                'Built in Flutter with Firebase integration and scalable architecture.',
                            image: 'lib/assets/images/karamuniversitywithoutBackground.png',
                            gradient: const [Color(0xFF8B5CF6), Color(0xFF06D6A0)],
                            tags: const ['React Native', 'Firebase', 'Clean UI', '3D Design', 'Full Stack'],
                            isVideo: false,
                            trailingTitleWidget: const _HoverGithubButton(
                              url: 'https://github.com/Karamkottish/MyUniversity',
                            ),
                          ),
                          _ProjectCard(
                            title: '🐾 Paws Pal Connect',
                            subtitle: 'Associate Software Engineer • 2025',
                            description:
                            'Flutter app built from scratch: auth, Firebase, GitHub workflow, and clean UX.',
                            image: 'lib/assets/images/withoutBG.png',
                            gradient: const [
                              Color(0xFF3B82F6),
                              Color(0xFF8B5CF6)
                            ],
                            tags: const [
                              'Flutter',
                              'Firebase',
                              'GitHub',
                              'Riverpod',
                              'Scrum Team member'
                            ],
                            isVideo: false,
                            trailingTitleWidget: const _HoverGithubButton(
                              url: 'https://github.com/pawspalconnect/ppc/tree/Karam',
                            ),
                          ),
                          _ProjectCard(
                            title: '🛒 E-commerce Web',
                            subtitle: 'FrontEnd Web Developer • 2025',
                            description: 'medical dashboard web application built with React.js, featuring product management, UI components, and clean responsive design.',
                            image: 'lib/assets/images/DoctorPic.png',
                            gradient: const [Color(0xFF00C6FF), Color(0xFF0072FF)], // blue gradient for web
                            tags: const ['React.js', 'JavaScript', 'Web App', 'Responsive','Clean Ui'],
                            isVideo: false,
                            trailingTitleWidget: const _HoverGithubButton(
                              url: 'https://github.com/AbdallahZagh/E-commerce-web/tree/store_dashboard',
                            ),
                          ),
                          _ProjectCard(
                            title: '📦 SoftTech Warehouse',
                            subtitle: 'Part-time • 2025',
                            description: 'Warehouse management mobile app (internal tooling).',
                            image: 'lib/assets/images/softtectlogo2.png',
                            gradient: const [Color(0xFF06D6A0), Color(0xFF00E5FF)],
                            tags: const ['Flutter', 'REST', 'SQLite', 'Provider', 'Clean Architecture'],
                            isVideo: false,
                            trailingTitleWidget: const _HoverGithubButton(
                              url: 'https://github.com/Karamkottish/WareHouse-Flutter',
                            ),
                          ),

                          // --- Your previous projects (kept as examples) ---
                          _ProjectCard(
                            title: '🎓 Graduation App " Revonix "',
                            subtitle: 'Flutter Lead • 2025',
                            description: 'Connecting Labors with Clients, offline cache, video demo.',
                            image: 'lib/assets/projects/RevonixYellow.jpg',
                            gradient: const [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                            tags: const [
                              'Flutter',
                              'Clean Architecture',
                              'Django',
                              'Riverpod',
                              'Stripe',
                              'MTN Cash',
                              'Syriatel Cash',
                              'Firebase Push Notifications',
                              'Languages',
                              'Dio',
                            ],
                            isVideo: false, // <- using image cover now
                            // 👇 GitLab hover button next to the title:
                            trailingTitleWidget: const _HoverGithubButton(
                              url: 'https://gitlab.com/revonix1/revonix-frontend',
                              asset: 'lib/assets/icons/icons8-gitlab-100.svg',
                              size: 18, // tweak if you want
                            ),
                          ),

                          _ProjectCard(
                            title: '🛍️ E-commerce Clone',
                            subtitle: 'Solo • 2023',
                            description:
                            'Catalog, cart, payments, responsive web + mobile.',
                            image: 'lib/assets/projects/Shein-logo.png',
                            gradient: const [
                              Color(0xFF06D6A0),
                              Color(0xFF00E5FF)
                            ],
                            tags: const ['Stripe', 'Firebase', 'Responsive'],
                          ),
                          _ProjectCard(
                            title:
                            'Semester Project 🔄 Change Volenteering App',
                            subtitle: 'Flutter Lead • 2023',
                            description:
                            'Connect volunteers with companies, theming, analytics.',
                            image: 'lib/assets/projects/Change.png',
                            gradient: const [
                              Color(0xFFFF6AC1),
                              Color(0xFFFFD166)
                            ],
                            tags: const [
                              'Getx',
                              'Charts',
                              'Theming',
                              'Languages',
                              'Http'
                            ],
                            isVideo: true,
                            videoPath: 'lib/assets/videos/CVPMobileV1.mp4',
                            trailingTitleWidget: const _HoverGithubButton(
                              url: 'https://github.com/Karamkottish/Change-ASPU/tree/flutter',
                            ),
                          ),
                        ]),
                      ),
                    ),
                    const SliverToBoxAdapter(child: CalmDivider()),

                    // ===== Courses =====
                    SliverToBoxAdapter(
                      key: _coursesKey,
                      child: Padding(
                        padding: horizontalPad.copyWith(
                          top: isMobile ? 12 : 24,
                          bottom: isMobile ? 4 : 8,
                        ),
                        child: _SectionHeader(
                          icon: Icons.menu_book_outlined,
                          title: 'Courses',
                          isMobile: isMobile,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: horizontalPad.copyWith(top: isMobile ? 8 : 12),
                        child: const CoursesSection(),
                      ),
                    ),
                    const SliverToBoxAdapter(child: CalmDivider()),

                    // ===== Diploma =====
                    // ===== Diploma =====
                    SliverToBoxAdapter(
                      key: _diplomaKey,
                      child: Padding(
                        padding: horizontalPad.copyWith(
                          top: isMobile ? 8 : 12,
                          bottom: isMobile ? 12 : 16,
                        ),
                        child: DiplomaSection(number: 1),
                      ),
                    ),

                    const SliverToBoxAdapter(child: CalmDivider()),

// ===== Designs =====
                    SliverToBoxAdapter(
                      key: _designsKey, // ✅ so we can scroll here
                      child: Padding(
                        padding: horizontalPad.copyWith(top: isMobile ? 8 : 12),
                        child: const DesignsSection(),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 24)),

                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}


// ---------------- Section headers ----------------

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    this.isMobile = false,
  });
  final IconData icon;
  final String title;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: t.colorScheme.primary, size: isMobile ? 20 : 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: (isMobile ? t.textTheme.titleMedium : t.textTheme.titleLarge),
        ),
      ],
    );
  }
}

class _SectionHeaderWithBadge extends StatelessWidget {
  const _SectionHeaderWithBadge({
    required this.icon,
    required this.title,
    required this.label,
    this.isMobile = false,
  });

  final IconData icon;
  final String title;
  final String label;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final titleStyle =
    isMobile ? t.textTheme.titleMedium : t.textTheme.titleLarge;

    return Row(
      children: [
        Icon(icon, color: t.colorScheme.primary, size: isMobile ? 20 : 24),
        const SizedBox(width: 8),
        Text(title, style: titleStyle),
        const SizedBox(width: 10),
        _GradientPill(label: label, isMobile: isMobile),
      ],
    );
  }
}

class _GradientPill extends StatelessWidget {
  const _GradientPill({required this.label, this.isMobile = false});
  final String label;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final double padH = isMobile ? 12 : 14;
    final double padV = isMobile ? 5.5 : 7;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFFF73C7), Color(0xFF57D0FF)],
        ),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// ---------------- Project card & video (now supports trailingTitleWidget) ----------------

class _ProjectCard extends StatefulWidget {
  const _ProjectCard({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.image,
    required this.gradient,
    required this.tags,
    this.isVideo = false,
    this.videoPath,
    this.trailingTitleWidget,
  });

  final String title;
  final String subtitle;
  final String description;
  final String image;
  final List<Color> gradient;
  final List<String> tags;
  final bool isVideo;
  final String? videoPath;

  /// Optional small widget to show next to the title (e.g., a GitHub icon).
  final Widget? trailingTitleWidget;

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _playVideo = false;

  void _onVisibilityChanged(VisibilityInfo info) {
    if (widget.isVideo && widget.videoPath != null) {
      if (info.visibleFraction > 0.8 && !_playVideo) {
        setState(() => _playVideo = true);
      } else if (info.visibleFraction < 0.4 && _playVideo) {
        setState(() => _playVideo = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return VisibilityDetector(
      key: Key(widget.title),
      onVisibilityChanged: _onVisibilityChanged,
      child: Material(
        color: cs.surface,
        elevation: 2,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            if (widget.isVideo) setState(() => _playVideo = !_playVideo);
          },
          child: Ink(
            padding: EdgeInsets.all(isMobile ? 10 : 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // top gradient strip
                Container(
                  height: isMobile ? 5 : 6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: widget.gradient),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(height: isMobile ? 8 : 10),

                // media
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: widget.isVideo &&
                        widget.videoPath != null &&
                        _playVideo
                        ? Stack(
                      children: [
                        InlineVideoPlayer(assetPath: widget.videoPath!),
                        Positioned(
                          right: 8,
                          bottom: 8,
                          child: Material(
                            color: Colors.black54,
                            shape: const CircleBorder(),
                            child: IconButton(
                              icon: const Icon(Icons.fullscreen,
                                  color: Colors.white, size: 28),
                              onPressed: () async {
                                await Navigator.push<Duration>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FullscreenVideoPlayer(
                                      assetPath: widget.videoPath!,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                        : Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(widget.image, fit: BoxFit.cover),
                        if (widget.isVideo)
                          const Center(
                            child: Icon(Icons.play_circle,
                                size: 64, color: Colors.white70),
                          ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: isMobile ? 6 : 8),

                // Title row with optional trailing widget (e.g., GitHub icon)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        widget.title,
                        style: isMobile
                            ? Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600)
                            : Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (widget.trailingTitleWidget != null) ...[
                      const SizedBox(width: 8),
                      widget.trailingTitleWidget!,
                    ],
                  ],
                ),

                Text(
                  widget.subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: cs.onSurfaceVariant),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: isMobile ? 4 : 6),
                Text(widget.description, maxLines: 2, overflow: TextOverflow.ellipsis),

                SizedBox(height: isMobile ? 6 : 8),
                Wrap(
                  spacing: isMobile ? 4 : 6,
                  runSpacing: isMobile ? 4 : 6,
                  children: [
                    for (final tag in widget.tags)
                      Chip(
                        label: Text(
                          tag,
                          style: isMobile
                              ? Theme.of(context).textTheme.labelSmall
                              : Theme.of(context).textTheme.labelMedium,
                        ),
                        visualDensity: VisualDensity.compact,
                        side: BorderSide(color: cs.outlineVariant),
                        backgroundColor: cs.surfaceVariant.withOpacity(.35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FullscreenVideoPlayer extends StatefulWidget {
  final String assetPath;
  final Duration startPosition;

  const FullscreenVideoPlayer({
    super.key,
    required this.assetPath,
    this.startPosition = Duration.zero,
  });

  @override
  State<FullscreenVideoPlayer> createState() => _FullscreenVideoPlayerState();
}

class _FullscreenVideoPlayerState extends State<FullscreenVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.assetPath)
      ..initialize().then((_) async {
        if (widget.startPosition > Duration.zero) {
          await _controller.seekTo(widget.startPosition);
        }
        setState(() {});
        _controller.play();
      });
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _controller.value.position);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
              : const CircularProgressIndicator(color: Colors.white),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: 'play',
              mini: isMobile,
              backgroundColor: Colors.white,
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              heroTag: 'mute',
              mini: isMobile,
              backgroundColor: Colors.white,
              onPressed: _toggleMute,
              child: Icon(
                _isMuted ? Icons.volume_off : Icons.volume_up,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _HoverGithubButton extends StatefulWidget {
  const _HoverGithubButton({
    required this.url,
    this.size = 18,
    this.asset = 'lib/assets/icons/icons8-github-100.svg',
  });

  final String url;
  final double size;
  final String asset;

  @override
  State<_HoverGithubButton> createState() => _HoverGithubButtonState();
}

class _HoverGithubButtonState extends State<_HoverGithubButton> {
  bool _hover = false;

  Future<void> _open() async {
    final uri = Uri.parse(widget.url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: _open,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          scale: _hover ? 1.12 : 1.0,
          child: AnimatedRotation(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            turns: _hover ? 0.02 : 0.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: cs.surfaceVariant.withOpacity(.35),
                shape: BoxShape.circle,
                boxShadow: _hover
                    ? [
                  BoxShadow(
                    color: cs.primary.withOpacity(.35),
                    blurRadius: 12,
                    spreadRadius: 1.5,
                  ),
                ]
                    : const [],
                border: Border.all(
                  color: _hover
                      ? cs.primary.withOpacity(.45)
                      : cs.outlineVariant.withOpacity(.35),
                ),
              ),
              child: SvgPicture.asset(
                widget.asset,
                width: widget.size,
                height: widget.size,
                colorFilter: ColorFilter.mode(cs.onSurface, BlendMode.srcIn),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

