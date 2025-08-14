import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import '../data/profile_data.dart';
import '../widgets/animated_tagline.dart';
import '../widgets/experience_section.dart';
import '../widgets/skills_section.dart';
import 'cv_viewer_page.dart';
import 'package:video_player/video_player.dart';

class PortfolioHomePage extends StatelessWidget {
  const PortfolioHomePage({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openCV(BuildContext context) async {
    if (kIsWeb) {
      final String cvUrl = '${Uri.base}assets/cv/KaramKottishCV.pdf';
      final Uri url = Uri.parse(cvUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, webOnlyWindowName: '_blank');
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CVViewerPage()),
      );
    }
  }

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

  // UPDATED: added mediaSize and moved GitLab icon under description
  Widget _buildProjectCard(
      BuildContext context,
      Project project, {
        String? imagePath,
        String? videoPath,
        String? projectLink,
        String? gitlabLink,
        double? mediaSize, // pass 200.0 to make square like profile image
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
                  // IMAGE/THUMBNAIL
                  if (imagePath != null)
                    if (mediaSize != null)
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SizedBox(
                            width: mediaSize,
                            height: mediaSize,
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    else
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          imagePath,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                  else
                    Container(
                      height: mediaSize ?? 200,
                      width: mediaSize ?? double.infinity,
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

                  // TITLE
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

                  // META
                  Text(
                    "${project.role} • ${project.date}",
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),

                  // SUMMARY
                  Text(
                    project.summary,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),

                  // GitLab ICON moved under description
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
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
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

        // Revonix card: square image 200x200 and GitLab under description
        _buildProjectCard(
          context,
          ProfileData.projects[0],
          videoPath: 'lib/assets/videos/fullvideoGrad.MP4',
          imagePath: 'lib/assets/projects/RevonixYellow.jpg',
          projectLink: ProfileData.projects[0].link!,
          gitlabLink: ProfileData.projects[0].gitlabLink,
          mediaSize: 200, // square like profile
        ),
        const SizedBox(height: 20),

        LayoutBuilder(
          builder: (context, constraints) {
            double cardWidth = (constraints.maxWidth / 2) - 12;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: cardWidth,
                  child: _buildProjectCard(
                    context,
                    ProfileData.projects[1],
                    imagePath: 'lib/assets/projects/Shein-logo.png',
                    // keep default banner style; say the word and I'll square it too
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: cardWidth,
                  child: _buildProjectCard(
                    context,
                    ProfileData.projects[2],
                    imagePath: 'lib/assets/projects/Change.png',
                    mediaSize: 200, // square like profile (Change Volunteer)
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
                    SlideInDown(
                      duration: const Duration(milliseconds: 800),
                      child: Text(
                        ProfileData.name,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const AnimatedTagline(),
                    const SizedBox(height: 20),
                    FadeIn(
                      duration: const Duration(milliseconds: 800),
                      child: Text(
                        ProfileData.profileSummary,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialButton(
                            'lib/assets/icons/icons8-linkedin-100.svg',
                            ProfileData.linkedin),
                        const SizedBox(width: 16),
                        _buildSocialButton(
                            'lib/assets/icons/icons8-github-100.svg',
                            ProfileData.github),
                        const SizedBox(width: 16),
                        _buildSocialButton(
                            'lib/assets/icons/icons8-gitlab-100.svg',
                            ProfileData.gitlab),
                        const SizedBox(width: 16),
                        _buildSocialButton(
                            'lib/assets/icons/icons8-gmail-96.svg',
                            'mailto:${ProfileData.email}'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    BounceInUp(
                      duration: const Duration(milliseconds: 800),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => _openCV(context),
                        icon: const Icon(Icons.picture_as_pdf,
                            color: Colors.white),
                        label: const Text(
                          "View My CV",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const ExperienceSection(),
              const SizedBox(height: 40),
              const SkillsSection(),
              const SizedBox(height: 40),
              _buildProjectsSection(context),
            ],
          ),
        ),
      ),
    );
  }
}

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
