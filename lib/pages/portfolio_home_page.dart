import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import '../data/profile_data.dart';
import '../widgets/animated_tagline.dart';
import '../widgets/experience_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/courses_section.dart';
import 'package:video_player/video_player.dart';

class PortfolioHomePage extends StatelessWidget {
  const PortfolioHomePage({super.key});

  // 🔹 Launch URL
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // 🔹 Open CV Link
  Future<void> _openCV(BuildContext context) async {
    const String cvLink =
        'https://drive.google.com/file/d/1suoB76RVTw4BK922sjrRt6hf-b1uU9qC/view?usp=sharing';
    final uri = Uri.parse(cvLink);

    if (await canLaunchUrl(uri)) {
      if (kIsWeb) {
        await launchUrl(uri, webOnlyWindowName: '_blank');
      } else {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open CV link')),
        );
      }
    }
  }

  // 🔹 Social button
  Widget _buildSocialButton(String assetPath, String url) {
    return InkWell(
      onTap: () => _launchURL(url),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24),
        ),
        child: SvgPicture.asset(
          assetPath,
          height: 28,
          width: 28,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
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
    return StatefulBuilder(
      builder: (context, setState) {
        bool isHovered = false;
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () async {
              if (videoPath != null) {
                await showDialog(
                  context: context,
                  builder: (_) => ProjectVideoDemo(videoPath: videoPath),
                );
                if (projectLink != null) {
                  _launchURL(projectLink);
                }
              } else if (project.link != null) {
                _launchURL(project.link!);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              transform: Matrix4.identity()..scale(isHovered ? 1.05 : 1.0),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
                boxShadow: isHovered
                    ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 6),
                  )
                ]
                    : [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (imagePath != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        imagePath,
                        height: mediaSize ?? 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Container(
                      height: mediaSize ?? 200,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "No Image",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    project.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlueAccent,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${project.role} • ${project.date}",
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    project.summary,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  if (gitlabLink != null) ...[
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => _launchURL(gitlabLink),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: SvgPicture.asset(
                          'lib/assets/icons/icons8-gitlab-100.svg',
                          height: 24,
                          width: 24,
                          colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 🔹 Projects Section (ALL THREE, like before)
  Widget _buildProjectsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Projects",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),

        // Responsive 1–2 column layout
        LayoutBuilder(
          builder: (context, constraints) {
            final isTwoCol = constraints.maxWidth >= 750;
            final cardWidth =
            isTwoCol ? (constraints.maxWidth / 2) - 12 : constraints.maxWidth;

            return Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                // 1) Revonix — square 200x200 + video + GitLab
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
                      projectLink: ProfileData.projects[0].link!,
                      gitlabLink: ProfileData.projects[0].gitlabLink,
                      mediaSize: 200, // square like profile pic
                    ),
                  ),
                ),

                // 2) Shein Replica — banner style
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
                      // no mediaSize -> keep banner
                    ),
                  ),
                ),

                // 3) Change Volunteering — square 200x200
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
                      mediaSize: 200, // square like profile pic
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0f2027), Color(0xFF203a43), Color(0xFF2c5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔝 HEADER
              Center(
                child: Column(
                  children: [
                    ZoomIn(
                      duration: const Duration(milliseconds: 800),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'lib/assets/images/profile.jpg',
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      ProfileData.name,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const AnimatedTagline(),
                    const SizedBox(height: 20),

                    // 🔹 View My CV button
                    ElevatedButton.icon(
                      onPressed: () => _openCV(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.picture_as_pdf, size: 20),
                      label: const Text(
                        "View My CV",
                        style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
              const ExperienceSection(),
              const SizedBox(height: 40),
              const SkillsSection(),

              // 🟢 Soft Skills
              const SizedBox(height: 40),
              const SoftSkillsSection(),

              // 🟢 Languages
              const SizedBox(height: 40),
              const LanguagesSection(),

              const SizedBox(height: 40),
              _buildProjectsSection(context),

              const SizedBox(height: 40),
              const CoursesSection(),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== 🔹 Soft Skills Section ====================
class SoftSkillsSection extends StatelessWidget {
  const SoftSkillsSection({super.key});

  final skills = const [
    "Work Under Pressure",
    "Problem Solving",
    "Good Communication",
    "Team Work",
    "Ability to Adapt",
    "Quick Learner",
  ];

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Soft Skills",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: skills
                .map(
                  (s) => Chip(
                backgroundColor: Colors.white10,
                label: Text(s,
                    style: const TextStyle(color: Colors.white)),
              ),
            )
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ==================== 🔹 Languages Section ====================
class LanguagesSection extends StatelessWidget {
  const LanguagesSection({super.key});

  Widget _buildDots(int filled, int total) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        total,
            (i) => Icon(
          Icons.circle,
          size: 12,
          color: i < filled ? Colors.tealAccent : Colors.white24,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Languages",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("English", style: TextStyle(color: Colors.white)),
              _buildDots(4, 5),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Arabic", style: TextStyle(color: Colors.white)),
              _buildDots(5, 5),
            ],
          ),
        ],
      ),
    );
  }
}

// ==================== 🔹 Project Video Demo ====================
class ProjectVideoDemo extends StatefulWidget {
  final String videoPath;
  const ProjectVideoDemo({super.key, required this.videoPath});

  @override
  State<ProjectVideoDemo> createState() => _ProjectVideoDemoState();
}

class _ProjectVideoDemoState extends State<ProjectVideoDemo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black87,
      insetPadding: const EdgeInsets.all(20),
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: _controller.value.isInitialized
            ? VideoPlayer(_controller)
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
