import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import '../data/profile_data.dart';
import '../widgets/animated_tagline.dart';
import '../widgets/experience_section.dart';
import '../widgets/skills_section.dart';
import 'cv_viewer_page.dart';

class PortfolioHomePage extends StatelessWidget {
  const PortfolioHomePage({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _openCV(BuildContext context) async {
    if (kIsWeb) {
      final String cvUrl = '${Uri.base}assets/cv/KaramKottishCV.pdf';
      final Uri url = Uri.parse(cvUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, webOnlyWindowName: '_blank');
      } else {
        throw 'Could not open CV';
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CVViewerPage(),
        ),
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

  Widget _buildProjectCard(Project project, String imagePath, Color glowColor) {
    return _HoverZoomCard(
      glowColor: glowColor,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (imagePath.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  imagePath,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
            if (imagePath.isNotEmpty) const SizedBox(height: 12),
            InkWell(
              onTap: () => _launchURL(project.link ?? ProfileData.github),
              child: Text(
                project.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlueAccent,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "${project.role} • ${project.date}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              project.summary,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsSection(BuildContext context) {
    // Images for projects
    final List<String> projectImages = [
      "lib/assets/projects/RevonixYellow.jpg", // Revonix
      "", // Shein Replica (no image)
      "lib/assets/projects/Change.png", // Change Volunteer App
    ];

    // Glow colors for projects
    final List<Color> glowColors = [
      Colors.amberAccent, // Revonix
      Colors.tealAccent, // Shein Replica
      Colors.lightBlueAccent, // Change Volunteer App
    ];

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
        ...ProfileData.projects.asMap().entries.map((entry) {
          final index = entry.key;
          final project = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Center(
              child: index.isEven
                  ? SlideInLeft(
                duration: Duration(milliseconds: 500 + (index * 200)),
                child: _buildProjectCard(
                  project,
                  projectImages[index],
                  glowColors[index],
                ),
              )
                  : SlideInRight(
                duration: Duration(milliseconds: 500 + (index * 200)),
                child: _buildProjectCard(
                  project,
                  projectImages[index],
                  glowColors[index],
                ),
              ),
            ),
          );
        }).toList(),
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
              // Hero Section
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

                    // Social Icons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialButton(
                          'lib/assets/icons/icons8-linkedin-100.svg',
                          ProfileData.linkedin,
                        ),
                        const SizedBox(width: 16),
                        _buildSocialButton(
                          'lib/assets/icons/icons8-github-100.svg',
                          ProfileData.github,
                        ),
                        const SizedBox(width: 16),
                        _buildSocialButton(
                          'lib/assets/icons/icons8-gitlab-100.svg',
                          ProfileData.gitlab,
                        ),
                        const SizedBox(width: 16),
                        _buildSocialButton(
                          'lib/assets/icons/icons8-gmail-96.svg',
                          'mailto:${ProfileData.email}',
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // View My CV Button
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

              // Sections
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

class _HoverZoomCard extends StatefulWidget {
  final Widget child;
  final Color glowColor;

  const _HoverZoomCard({
    required this.child,
    required this.glowColor,
  });

  @override
  State<_HoverZoomCard> createState() => _HoverZoomCardState();
}

class _HoverZoomCardState extends State<_HoverZoomCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            boxShadow: _hovering
                ? [
              BoxShadow(
                color: widget.glowColor.withOpacity(0.6),
                blurRadius: 20,
                spreadRadius: 5,
              )
            ]
                : [],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
