import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';
import '../theme.dart';
import '../widgets/social_icon_button.dart';
import '../widgets/portfolio_hero.dart' hide CoursesSection;
import '../widgets/sticky_rainbow_nav.dart';
import '../widgets/colorful_background.dart';
import '../widgets/elegant_background.dart';
import '../widgets/experience_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/courses_section.dart';
import '../widgets/blob_background.dart';
import '../widgets/inline_video_player.dart';

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
      body: Stack(
        children: [
          const Positioned.fill(child: BlobBackground(speed: 0.18)),
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
                    SliverToBoxAdapter(
                      key: _aboutKey,
                      child: PortfolioHero(
                        name: 'Karam Kottish',
                        onJumpToProjects: () => _jumpTo(_projectsKey),
                        cvUrl: cvUrl,
                        email: 'karamkottish@gmail.com',
                      ),
                    ),

                    const SliverToBoxAdapter(child: AnimatedGradientDivider()),

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

                    const SliverToBoxAdapter(child: AnimatedGradientDivider()),

                    SliverToBoxAdapter(
                      key: _expKey,
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: ExperienceSection(),
                      ),
                    ),

                    const SliverToBoxAdapter(child: AnimatedGradientDivider()),

                    SliverToBoxAdapter(
                      key: _skillsKey,
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
                        child: SkillsSection(),
                      ),
                    ),

                    const SliverToBoxAdapter(child: AnimatedGradientDivider()),

                    SliverToBoxAdapter(
                      key: _projectsKey,
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(20, 28, 20, 8),
                        child: _SectionHeader(icon: Icons.auto_awesome, title: 'Projects'),
                      ),
                    ),

                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                      sliver: SliverGrid(
                        gridDelegate: grid,
                        delegate: SliverChildListDelegate(const [
                          _ProjectCard(
                            title: '🎓 Graduation App " Revonix "',
                            subtitle: 'Flutter Lead • 2025',
                            description: 'Connecting Labors with Clients, offline cache, video demo.',
                            image: 'lib/assets/projects/RevonixYellow.jpg',
                            gradient: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                            tags: ['Flutter', 'Clean Architecture', 'NodeJs', 'Riverpod','Stripe','Firebase Notifications','Languages','Dio'],
                            isVideo: true,
                            videoPath: 'lib/assets/videos/fullvideoGrad.MP4',
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
                            title: 'Semester Project 🔄 Change Volenteering App',
                            subtitle: 'Flutter Lead • 2023',
                            description: 'An App that helps Volunteers connect with companies, theming, analytics.',
                            image: 'lib/assets/projects/Change.png',
                            gradient: [Color(0xFFFF6AC1), Color(0xFFFFD166)],
                            tags: ['Getx', 'Charts', 'Theming','Languages','Http'],
                            isVideo: true,
                            videoPath: 'lib/assets/videos/CVPMobileV1.mp4',
                          ),
                        ]),
                      ),
                    ),

                    const SliverToBoxAdapter(child: AnimatedGradientDivider()),

                    SliverToBoxAdapter(
                      key: _coursesKey,
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
                        child: CoursesSection(),
                      ),
                    ),

                    const SliverToBoxAdapter(child: AnimatedGradientDivider()),

                    SliverToBoxAdapter(
                      key: _diplomaKey,
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
  VideoPlayerController? _inlineController;

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
  void dispose() {
    _inlineController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

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
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: widget.gradient),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 10),

                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: widget.isVideo && widget.videoPath != null && _playVideo
                        ? Stack(
                      children: [
                        InlineVideoPlayer(assetPath: widget.videoPath!),

                        Positioned(
                          right: 8,
                          bottom: 8,
                          child: IconButton(
                            icon: const Icon(Icons.fullscreen,
                                color: Colors.white, size: 32),
                            onPressed: () async {
                              final pos = _inlineController?.value.position ?? Duration.zero;

                              final returnedPos = await Navigator.push<Duration>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FullscreenVideoPlayer(
                                    assetPath: widget.videoPath!,
                                    startPosition: pos,
                                  ),
                                ),
                              );

                              if (returnedPos != null && _inlineController != null) {
                                await _inlineController!.seekTo(returnedPos);
                              }
                            },
                          ),
                        ),
                      ],
                    )
                        : Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          widget.image,
                          fit: BoxFit.cover,
                        ),
                        if (widget.isVideo)
                          const Center(
                            child: Icon(Icons.play_circle,
                                size: 64, color: Colors.white70),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                Text(widget.title,
                    style: Theme.of(context).textTheme.titleMedium),
                Text(
                  widget.subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: 6),
                Text(widget.description,
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final tag in widget.tags)
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
