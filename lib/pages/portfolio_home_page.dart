import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';
import '../theme.dart';
import '../widgets/inline_video_player.dart' show InlineVideoPlayer;
import '../widgets/social_icon_button.dart';
import '../widgets/portfolio_hero.dart' hide CoursesSection;
import '../widgets/sticky_rainbow_nav.dart';
import '../widgets/blob_background.dart';
import '../widgets/experience_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/courses_section.dart';

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

  static const String cvUrl =
      'https://drive.google.com/file/d/1poZ04SmRsSOIlX_r2RMkc4BL9byvsoUT/view?usp=sharing';

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
    return Scaffold(
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
            case 'diploma':
              _jumpTo(_diplomaKey);
              break;
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

            // Cards feel taller on mobile so media looks good
            final childAspect =
            isDesktop ? 1.10 : (isTablet ? 1.03 : 0.88);

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
                // Softer background on phones for perf and legibility
                Positioned.fill(
                  child: Opacity(
                    opacity: isMobile ? 0.35 : 0.55,
                    child: const BlobBackground(speed: 0.18),
                  ),
                ),
                CustomScrollView(
                  controller: _scrollCtrl,
                  slivers: [
                    SliverToBoxAdapter(
                      key: _aboutKey,
                      child: Padding(
                        padding: horizontalPad.copyWith(
                          top: isMobile ? 8 : 0,
                        ),
                        child: PortfolioHero(
                          name: 'Karam Kottish',
                          onJumpToProjects: () => _jumpTo(_projectsKey),
                          cvUrl: cvUrl,
                          email: 'karamkottish@gmail.com',
                          // You can add optional size hints in your hero widget if desired
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: isMobile ? 18 : 28,
                        ),
                        child: const AnimatedGradientDivider(),
                      ),
                    ),

                    // Socials – bigger touch targets on mobile
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

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: isMobile ? 18 : 28,
                        ),
                        child: const AnimatedGradientDivider(),
                      ),
                    ),

                    SliverToBoxAdapter(
                      key: _expKey,
                      child: Padding(
                        padding: horizontalPad.copyWith(
                          top: isMobile ? 8 : 16,
                        ),
                        child: const ExperienceSection(),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: isMobile ? 18 : 28,
                        ),
                        child: const AnimatedGradientDivider(),
                      ),
                    ),

                    SliverToBoxAdapter(
                      key: _skillsKey,
                      child: Padding(
                        padding: horizontalPad.copyWith(
                          top: isMobile ? 12 : 24,
                        ),
                        child: const SkillsSection(),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: isMobile ? 18 : 28,
                        ),
                        child: const AnimatedGradientDivider(),
                      ),
                    ),

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
                        delegate: SliverChildListDelegate(const [
                          _ProjectCard(
                            title: '🎓 Graduation App " Revonix "',
                            subtitle: 'Flutter Lead • 2025',
                            description:
                            'Connecting Labors with Clients, offline cache, video demo.',
                            image: 'lib/assets/projects/RevonixYellow.jpg',
                            gradient: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                            tags: [
                              'Flutter',
                              'Clean Architecture',
                              'NodeJs',
                              'Riverpod',
                              'Stripe',
                              'Firebase Notifications',
                              'Languages',
                              'Dio'
                            ],
                            isVideo: true,
                            videoPath: 'lib/assets/videos/fullvideoGrad.MP4',
                          ),
                          _ProjectCard(
                            title: '🛍️ E-commerce Clone',
                            subtitle: 'Solo • 2023',
                            description:
                            'Catalog, cart, payments, responsive web + mobile.',
                            image: 'lib/assets/projects/Shein-logo.png',
                            gradient: [Color(0xFF06D6A0), Color(0xFF00E5FF)],
                            tags: ['Stripe', 'Firebase', 'Responsive'],
                          ),
                          _ProjectCard(
                            title: 'Semester Project 🔄 Change Volenteering App',
                            subtitle: 'Flutter Lead • 2023',
                            description:
                            'Connect volunteers with companies, theming, analytics.',
                            image: 'lib/assets/projects/Change.png',
                            gradient: [Color(0xFFFF6AC1), Color(0xFFFFD166)],
                            tags: ['Getx', 'Charts', 'Theming', 'Languages', 'Http'],
                            isVideo: true,
                            videoPath: 'lib/assets/videos/CVPMobileV1.mp4',
                          ),
                        ]),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: isMobile ? 18 : 28,
                        ),
                        child: const AnimatedGradientDivider(),
                      ),
                    ),

                    SliverToBoxAdapter(
                      key: _coursesKey,
                      child: Padding(
                        padding: horizontalPad.copyWith(
                          top: isMobile ? 12 : 24,
                        ),
                        child: const CoursesSection(),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: isMobile ? 18 : 28,
                        ),
                        child: const AnimatedGradientDivider(),
                      ),
                    ),

                    SliverToBoxAdapter(
                      key: _diplomaKey,
                      child: Padding(
                        padding: horizontalPad.copyWith(
                          top: isMobile ? 8 : 12,
                          bottom: isMobile ? 8 : 0,
                        ),
                        child: const DiplomaSection(number: 1),
                      ),
                    ),

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
        Icon(
          icon,
          color: t.colorScheme.primary,
          size: isMobile ? 20 : 24,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: (isMobile ? t.textTheme.titleMedium : t.textTheme.titleLarge),
        ),
      ],
    );
  }
}

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
  });

  final String title;
  final String subtitle;
  final String description;
  final String image;
  final List<Color> gradient;
  final List<String> tags;
  final bool isVideo;
  final String? videoPath;

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _playVideo = false;

  void _onVisibilityChanged(VisibilityInfo info) {
    if (widget.isVideo && widget.videoPath != null) {
      if (info.visibleFraction > 0.6 && !_playVideo) {
        setState(() => _playVideo = true);
      } else if (info.visibleFraction < 0.2 && _playVideo) {
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
            if (widget.isVideo) {
              setState(() => _playVideo = !_playVideo);
            }
          },
          child: Ink(
            padding: EdgeInsets.all(isMobile ? 10 : 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: isMobile ? 5 : 6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: widget.gradient),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(height: isMobile ? 8 : 10),

                // Media area
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: widget.isVideo &&
                        widget.videoPath != null &&
                        _playVideo
                        ? Stack(
                      children: [
                        InlineVideoPlayer(assetPath: widget.videoPath!),
                        // Fullscreen button with larger tap target on phones
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
                Text(
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
                Text(
                  widget.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
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
                              ? Theme.of(context)
                              .textTheme
                              .labelSmall
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
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 18 : 28),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) {
          return CustomPaint(
            painter: _DividerPainter(progress: _ctrl.value),
            child: const SizedBox(height: 4, width: double.infinity),
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

    final base = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFFF6AC1),
          Color(0xFFFFD166),
          Color(0xFF06D6A0),
          Color(0xFF00E5FF),
          Color(0xFF8B5CF6),
        ],
      ).createShader(rect);

    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(10));
    canvas.drawRRect(rrect, base);

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
