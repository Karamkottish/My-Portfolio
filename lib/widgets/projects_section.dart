// lib/widgets/projects_section.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../data/profile_data.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ===== Section Header =====
        Row(
          children: [
            Text(
              "Projects",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00E5FF), Color(0xFFFF6AC1)],
                ),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                "${ProfileData.projects.length}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          "Selected product, mobile, and system builds",
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),

        // ===== Grid =====
        LayoutBuilder(
          builder: (context, constraints) {
            final cols = constraints.maxWidth >= 900
                ? 3
                : constraints.maxWidth >= 600
                ? 2
                : 1;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                mainAxisExtent: 250,
              ),
              itemCount: ProfileData.projects.length,
              itemBuilder: (context, i) {
                final project = ProfileData.projects[i];
                return FadeInUp(
                  duration: Duration(milliseconds: 350 + (i * 120)),
                  child: _ProjectCard(project: project, isDark: isDark),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

// ===================================================================
// Project Card (2026 Premium)
// ===================================================================

class _ProjectCard extends StatefulWidget {
  const _ProjectCard({required this.project, required this.isDark});
  final Project project;
  final bool isDark;

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    final theme = Theme.of(context);

    final bg = widget.isDark
        ? Colors.white.withOpacity(.06)
        : Colors.black.withOpacity(.04);

    final border = widget.isDark ? Colors.white24 : Colors.black12;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.04 : 1.0,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: border),
            boxShadow: _hovered
                ? [
              BoxShadow(
                color: Colors.black.withOpacity(.25),
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
            ]
                : [],
          ),
          clipBehavior: Clip.antiAlias,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${p.name} • ${p.role}"),
                    duration: const Duration(milliseconds: 900),
                  ),
                );
              },
              child: Stack(
                children: [
                  // ===== Image =====
                  if (p.image != null)
                    Positioned.fill(
                      child: Image.asset(
                        p.image!,
                        fit: BoxFit.cover,
                      ),
                    ),

                  // ===== Gradient Overlay =====
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(.75),
                            Colors.black.withOpacity(.35),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ===== Content =====
                  Positioned(
                    left: 14,
                    right: 14,
                    bottom: 14,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.35),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                p.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${p.role} • ${p.date}",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                p.summary,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white70,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
