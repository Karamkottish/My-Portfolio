import 'dart:ui';
import 'package:flutter/material.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  // ================= TECH SKILLS =================
  static const List<String> skills = [
    'Flutter', 'Dart', 'Firebase', 'REST APIs', 'Git', 'CI/CD',
    'Provider', 'Riverpod', 'Clean Architecture', 'SQLite',
    'UI / UX', 'GetX', 'React.js', 'Next.js', 'Tailwind CSS',
    'TypeScript', 'Animations', 'Jira', 'Agile Methodology',
    'Linux', 'GitHub', 'GitLab', 'MVC', 'MVVM',
    'React Native', 'Expo Go', 'Rendering', 'Performance Optimization',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ===== Tech Skills =====
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final s in skills)
              _TechSkillChip(label: s, isDark: isDark),
          ],
        ),

        const SizedBox(height: 28),
        const _GradientDivider(),

        // ===== Soft Skills =====
        const SizedBox(height: 20),
        const _Subheader(title: 'Soft Skills'),
        const SizedBox(height: 12),
        const SoftSkillsSection(),

        const SizedBox(height: 28),
        const _GradientDivider(),

        // ===== Languages =====
        const SizedBox(height: 20),
        const _Subheader(title: 'Languages'),
        const SizedBox(height: 12),
        const LanguagesSection(),
      ],
    );
  }
}

// =======================================================
// 2026 Tech Skill Chip (Glass + Calm)
// =======================================================

class _TechSkillChip extends StatelessWidget {
  const _TechSkillChip({
    required this.label,
    required this.isDark,
  });

  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : Colors.black.withOpacity(0.04),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: cs.outlineVariant.withOpacity(0.35),
            ),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ),
    );
  }
}

// =======================================================
// Soft Skills (Leadership-focused, 2026 wording)
// =======================================================

class SoftSkillsSection extends StatelessWidget {
  const SoftSkillsSection({super.key});

  static const List<String> soft = [
    'Leadership & Decision Making',
    'Managerial Thinking',
    'Problem Solving',
    'Critical Thinking',
    'Clear Communication',
    'Cross-functional Collaboration',
    'Adaptability',
    'Working Under Pressure',
    'Fast Learner',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final s in soft)
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                      Colors.white.withOpacity(0.08),
                      Colors.white.withOpacity(0.04),
                    ]
                        : [
                      Colors.black.withOpacity(0.05),
                      Colors.black.withOpacity(0.02),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: cs.outlineVariant.withOpacity(0.35),
                  ),
                ),
                child: Text(
                  s,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// =======================================================
// Languages (Modern Progress Style)
// =======================================================

class LanguagesSection extends StatelessWidget {
  const LanguagesSection({super.key});

  static const langs = <MapEntry<String, double>>[
    MapEntry('Arabic', 1.0),
    MapEntry('English', 0.85),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: langs.map((e) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  e.key,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: e.value,
                    minHeight: 10,
                    backgroundColor: cs.surfaceVariant.withOpacity(.5),
                    valueColor:
                    AlwaysStoppedAnimation<Color>(cs.primary),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// =======================================================
// Subheader
// =======================================================

class _Subheader extends StatelessWidget {
  const _Subheader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
    );
  }
}

// =======================================================
// Gradient Divider
// =======================================================

class _GradientDivider extends StatelessWidget {
  const _GradientDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFF6AC1),
            Color(0xFFFFD166),
            Color(0xFF06D6A0),
            Color(0xFF00E5FF),
            Color(0xFF8B5CF6),
          ],
        ),
      ),
    );
  }
}
