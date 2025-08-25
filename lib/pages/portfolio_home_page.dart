import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import '../data/profile_data.dart';
import '../widgets/animated_subtitle.dart';
import '../widgets/animated_tagline.dart';
import '../widgets/experience_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/courses_section.dart';
import 'package:video_player/video_player.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


class PortfolioHomePage extends StatelessWidget {
  const PortfolioHomePage({super.key});

  // Brand palette
  static const _bgGradient = LinearGradient(
    colors: [Color(0xFF0f2027), Color(0xFF203a43), Color(0xFF2c5364)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const _glassBorder = BorderSide(color: Colors.white24);
  static final _glassDecoration = BoxDecoration(
    color: Colors.white.withOpacity(0.06),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: _glassBorder.color),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.25),
        blurRadius: 20,
        offset: Offset(0, 8),
      ),
    ],
  );

  // 🔹 Launch URL (with UX feedback)
  Future<void> _launchURL(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      if (kIsWeb) {
        await launchUrl(uri, webOnlyWindowName: '_blank');
      } else {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open: $url')),
        );
      }
    }
  }

  // 🔹 Open CV Link
  Future<void> _openCV(BuildContext context) async {
    const String cvLink =
        'https://drive.google.com/file/d/1suoB76RVTw4BK922sjrRt6hf-b1uU9qC/view?usp=sharing';
    await _launchURL(context, cvLink);
  }

  // 🔹 Social button (hover/focus/tooltip/semantics)
  Widget _buildSocialButton(
      BuildContext context, {
        required String assetPath,
        required String tooltip,
        required String url,
      }) {
    return FocusableActionDetector(
      mouseCursor: SystemMouseCursors.click,
      child: Tooltip(
        message: tooltip,
        waitDuration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.85),
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: () => _launchURL(context, url),
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24),
            ),
            child: Semantics(
              label: tooltip,
              button: true,
              child: SvgPicture.asset(
                assetPath,
                height: 28,
                width: 28,
                fit: BoxFit.contain,
                colorFilter:
                const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Section header
  Widget _sectionHeader(String title, {IconData? icon}) {
    return Row(
      children: [
        if (icon != null)
          Icon(icon, color: Colors.tealAccent, size: 22),
        if (icon != null) const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // 🔹 Projects Card
  Widget _buildProjectCard(
      BuildContext context,
      Project project, {
        String? imagePath,
        String? videoPath,
        String? projectLink,
        String? gitlabLink,
        double? mediaSize,
      }) {
    return _HoverScale(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            if (videoPath != null) {
              await showDialog(
                context: context,
                barrierColor: Colors.black.withOpacity(0.6),
                builder: (_) => ProjectVideoDemo(videoPath: videoPath),
              );
              if (projectLink != null) {
                await _launchURL(context, projectLink);
              }
            } else if (project.link != null) {
              await _launchURL(context, project.link!);
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            padding: const EdgeInsets.all(16),
            decoration: _glassDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: imagePath != null
                      ? Image.asset(
                    imagePath,
                    height: mediaSize ?? 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _imageFallback(
                      height: mediaSize ?? 200,
                    ),
                  )
                      : _imageFallback(height: mediaSize ?? 200),
                ),
                const SizedBox(height: 12),
                Text(
                  project.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${project.role} • ${project.date}",
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 10),
                Text(
                  project.summary,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
                if (gitlabLink != null) ...[
                  const SizedBox(height: 12),
                  _pillLinkButton(
                    context,
                    iconAsset: 'lib/assets/icons/icons8-gitlab-100.svg',
                    label: 'View Repo',
                    onTap: () => _launchURL(context, gitlabLink),
                  ),
                ],
                if (projectLink != null && videoPath == null) ...[
                  const SizedBox(height: 8),
                  _primaryTextButton(
                    label: 'Open Project',
                    onTap: () => _launchURL(context, projectLink),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageFallback({required double height}) {
    return Container(
      height: height,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Text(
        "No Image",
        style: TextStyle(color: Colors.white70, fontSize: 16),
      ),
    );
  }

  // 🔹 Text button
  Widget _primaryTextButton({required String label, required VoidCallback onTap}) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: Colors.lightBlueAccent,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  // 🔹 Small pill button with SVG
  Widget _pillLinkButton(
      BuildContext context, {
        required String iconAsset,
        required String label,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconAsset,
              height: 18,
              width: 18,
              colorFilter:
              const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  // 🔹 Projects Section
  Widget _buildProjectsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader("Projects", icon: Icons.work_outline),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final isThreeCol = constraints.maxWidth >= 1180;
            final isTwoCol = constraints.maxWidth >= 780 && !isThreeCol;
            final columns = isThreeCol ? 3 : (isTwoCol ? 2 : 1);
            final gap = 20.0;
            final cardWidth =
                (constraints.maxWidth - gap * (columns - 1)) / columns;

            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                SizedBox(
                  width: cardWidth,
                  child: FadeInUp(
                    duration: const Duration(milliseconds: 450),
                    child: _buildProjectCard(
                      context,
                      ProfileData.projects[0],
                      videoPath: 'lib/assets/videos/fullvideoGrad.MP4',
                      imagePath: ProfileData.projects[0].image ??
                          'lib/assets/projects/RevonixYellow.jpg',
                      projectLink: ProfileData.projects[0].link,
                      gitlabLink: ProfileData.projects[0].gitlabLink,
                      mediaSize: 200,
                    ),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    child: _buildProjectCard(
                      context,
                      ProfileData.projects[1],
                      imagePath: ProfileData.projects[1].image ??
                          'lib/assets/projects/Shein-logo.png',
                      projectLink: ProfileData.projects[1].link,
                      gitlabLink: ProfileData.projects[1].gitlabLink,
                    ),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: FadeInUp(
                    duration: const Duration(milliseconds: 750),
                    child: _buildProjectCard(
                      context,
                      ProfileData.projects[2],
                      imagePath: ProfileData.projects[2].image ??
                          'lib/assets/projects/Change.png',
                      projectLink: ProfileData.projects[2].link,
                      gitlabLink: ProfileData.projects[2].gitlabLink,
                      mediaSize: 200,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  // 🔹 Profile intro paragraph for hirers (concise, scannable)
  Widget _profileIntro() {
    return Column(
      children: const [
        Text(
          "Ambitious Flutter developer and Informatics Engineering student with real-world delivery experience. I design clean, intuitive UIs and ship scalable apps with Flutter, Dart, Firebase, and REST APIs—spanning e-commerce, social impact, and artisan marketplaces. Curious by nature, I’m actively exploring AI, cloud, and security to build products that feel fast, look delightful, and solve real problems.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
        ),
        SizedBox(height: 12),
        Text(
          "Open to internships and junior roles where I can contribute immediately while growing fast.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.tealAccent,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f2027),
      body: Container(
        decoration: const BoxDecoration(gradient: _bgGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 🔝 HEADER
                    ZoomIn(
                      duration: const Duration(milliseconds: 700),
                      child: _HeroAvatar(),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      ProfileData.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const AnimatedTagline(),
                    const AnimatedSubtitle(),
                    const SizedBox(height: 18),
                    _profileIntro(),
                    const SizedBox(height: 20),

                    // 🔹 Socials
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildSocialButton(
                          context,
                          assetPath: 'lib/assets/icons/icons8-github-100.svg',
                          tooltip: 'GitHub',
                          url: ProfileData.github,
                        ),
                        _buildSocialButton(
                          context,
                          assetPath: 'lib/assets/icons/icons8-linkedin-100.svg',
                          tooltip: 'LinkedIn',
                          url: ProfileData.linkedin,
                        ),
                        _buildSocialButton(
                          context,
                          assetPath: 'lib/assets/icons/icons8-gitlab-100.svg',
                          tooltip: 'GitLab',
                          url: ProfileData.gitlab,
                        ),
                        _buildSocialButton(
                          context,
                          assetPath: 'lib/assets/icons/icons8-gmail-96.svg',
                          tooltip: 'Email',
                          url: 'mailto:${ProfileData.email}',
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // 🔹 View My CV button
                    ElevatedButton.icon(
                      onPressed: () => _openCV(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      icon: const Icon(Icons.picture_as_pdf, size: 20),
                      label: const Text(
                        "View My CV",
                        style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),

                    const SizedBox(height: 36),
                    // Experience
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _sectionHeader("Experience",
                          icon: Icons.badge_outlined),
                    ),
                    const SizedBox(height: 12),
                    const ExperienceSection(),

                    const SizedBox(height: 36),
                    // Skills
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _sectionHeader("Technical Skills",
                          icon: Icons.code_outlined),
                    ),
                    const SizedBox(height: 12),
                    const SkillsSection(),

                    const SizedBox(height: 36),
                    // Soft Skills
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _sectionHeader("Soft Skills",
                          icon: Icons.handshake_outlined),
                    ),
                    const SizedBox(height: 12),
                    const SoftSkillsSection(),

                    const SizedBox(height: 36),
                    // Languages
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _sectionHeader("Languages",
                          icon: Icons.language_outlined),
                    ),
                    const SizedBox(height: 12),
                    const LanguagesSection(),

                    const SizedBox(height: 36),
                    _buildProjectsSection(context),

                    const SizedBox(height: 36),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _sectionHeader("Courses",
                          icon: Icons.school_outlined),
                    ),
                    const SizedBox(height: 12),
                    const CoursesSection(),
                    const SizedBox(height: 24),
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

// ==================== 🔹 Avatar with gradient ring ====================
class _HeroAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 216,
          width: 216,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(
              colors: [
                Colors.tealAccent,
                Colors.lightBlueAccent,
                Colors.purpleAccent,
                Colors.tealAccent,
              ],
              stops: [0.0, 0.33, 0.66, 1.0],
            ),
          ),
        ),
        Container(
          height: 206,
          width: 206,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.6),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.asset(
            'lib/assets/images/profile.jpg',
            height: 200,
            width: 200,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 200,
              width: 200,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Icon(Icons.person, color: Colors.white70, size: 56),
            ),
          ),
        ),
      ],
    );
  }
}

// ==================== 🔹 Soft Skills Section (chips with icons) ====================
class SoftSkillsSection extends StatelessWidget {
  const SoftSkillsSection({super.key});

  final skills = const [
    ("Work Under Pressure", Icons.speed),
    ("Problem Solving", Icons.psychology_outlined),
    ("Good Communication", Icons.record_voice_over_outlined),
    ("Team Work", Icons.groups_2_outlined),
    ("Ability to Adapt", Icons.autorenew),
    ("Quick Learner", Icons.flash_on_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 700),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: skills
            .map(
              (s) => Chip(
            avatar: Icon(
              s.$2,
              size: 18,
              color: Colors.tealAccent,
            ),
            backgroundColor: Colors.white10,
            label: Text(
              s.$1,
              style: const TextStyle(color: Colors.white),
            ),
            shape: StadiumBorder(
              side: BorderSide(color: Colors.white24),
            ),
          ),
        )
            .toList(),
      ),
    );
  }
}

// ==================== 🔹 Languages Section (progress bars) ====================
class LanguagesSection extends StatelessWidget {
  const LanguagesSection({super.key});

  Widget _langRow(String name, double level) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            name,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: level,
              minHeight: 10,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(Colors.tealAccent),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 700),
      child: Column(
        children: [
          _langRow("English", 0.85),
          const SizedBox(height: 12),
          _langRow("Arabic", 1.0),
        ],
      ),
    );
  }
}

// ==================== 🔹 Project Video Demo with controls ====================
class ProjectVideoDemo extends StatefulWidget {
  final String videoPath;
  const ProjectVideoDemo({super.key, required this.videoPath});

  @override
  State<ProjectVideoDemo> createState() => _ProjectVideoDemoState();
}

class _ProjectVideoDemoState extends State<ProjectVideoDemo> {
  late VideoPlayerController _controller;
  bool _muted = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        if (mounted) setState(() {});
        _controller
          ..setLooping(true)
          ..play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (!_controller.value.isInitialized) return;
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
  }

  void _toggleMute() {
    setState(() {
      _muted = !_muted;
      _controller.setVolume(_muted ? 0 : 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black87,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: _controller.value.isInitialized
                ? _controller.value.aspectRatio
                : 16 / 9,
            child: _controller.value.isInitialized
                ? GestureDetector(
              onTap: _togglePlay,
              child: VideoPlayer(_controller),
            )
                : const Center(child: CircularProgressIndicator()),
          ),
          // Controls
          Positioned(
            right: 8,
            top: 8,
            child: IconButton(
              tooltip: 'Close',
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            left: 8,
            bottom: 8,
            child: Row(
              children: [
                IconButton(
                  tooltip:
                  _controller.value.isPlaying ? 'Pause' : 'Play',
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: _togglePlay,
                ),
                IconButton(
                  tooltip: _muted ? 'Unmute' : 'Mute',
                  icon: Icon(
                    _muted ? Icons.volume_off : Icons.volume_up,
                    color: Colors.white,
                  ),
                  onPressed: _toggleMute,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== 🔹 Hover scale wrapper ====================
class _HoverScale extends StatefulWidget {
  final Widget child;
  const _HoverScale({required this.child});

  @override
  State<_HoverScale> createState() => _HoverScaleState();
}
// ==================== 🔹 Animated Subtitle ====================
class AnimatedSubtitle extends StatelessWidget {
  const AnimatedSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedTextKit(
          repeatForever: true,
          pause: const Duration(milliseconds: 1200),
          animatedTexts: [
            TypewriterAnimatedText(
              "Flutter (Main) / Web Developer (Fresher)",
              textAlign: TextAlign.center,
              textStyle: const TextStyle(
                fontSize: 18,
                color: Colors.tealAccent,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
              speed: Duration(milliseconds: 80),
              cursor: "|", // blinking cursor
            ),
            TypewriterAnimatedText(
              "Semi Front–Full Stack • Learning more…",
              textAlign: TextAlign.center,
              textStyle: const TextStyle(
                fontSize: 15,
                color: Colors.white70,
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
              speed: Duration(milliseconds: 80),
              cursor: "|", // blinking cursor
            ),
          ],
          displayFullTextOnTap: true,
          stopPauseOnTap: true,
        ),
      ],
    );
  }
}

class _HoverScaleState extends State<_HoverScale> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 180),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          transform: Matrix4.identity()..translate(0.0, _hovered ? -2.0 : 0.0),
          child: widget.child,
        ),
      ),
    );
  }
}
