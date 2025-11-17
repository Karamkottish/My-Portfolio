import 'package:flutter/material.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  static const List<String> skills = [
    'Flutter', 'Dart', 'Firebase', 'REST', 'Git', 'CI/CD',
    'Provider', 'Riverpod', 'Clean Architecture', 'SQLite',
    'Ui/Ux', 'Getx', 'ReactJs', 'NextJs', 'TailWind Css',
    'TypeScript','Animations','Jira','Agile Methodology',
    'Linux','Github','Gitlab','M-V-C','M-V-V-M','Render','React Native','Expo Go'
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tech Skills
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final s in skills)
              Chip(
                label: Text(s),
                avatar: Icon(Icons.check_circle, size: 16, color: cs.primary),
              ),
          ],
        ),

        const SizedBox(height: 20),
        const _GradientDivider(),

        // Soft Skills
        const SizedBox(height: 16),
        const _Subheader(title: 'Soft Skills'),
        const SizedBox(height: 8),
        const SoftSkillsSection(),

        const SizedBox(height: 20),
        const _GradientDivider(),

        // Languages
        const SizedBox(height: 16),
        const _Subheader(title: 'Languages'),
        const SizedBox(height: 8),
        const LanguagesSection(),
      ],
    );
  }
}

/// Gradient divider like the one used in your main page
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

class SoftSkillsSection extends StatelessWidget {
  const SoftSkillsSection({super.key});

  static const List<String> soft = [
    'Communication','Problem Solving','Teamwork','Adaptability',
    'Time Management','Quick Learner','Professionalism','Work Under Pressure',
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final s in soft)
          Chip(
            label: Text(s),
            avatar: Icon(Icons.workspace_premium_outlined,
                size: 16, color: cs.secondary),
          ),
      ],
    );
  }
}

class LanguagesSection extends StatelessWidget {
  const LanguagesSection({super.key});

  static const langs = <MapEntry<String,double>>[
    MapEntry('Arabic', 1.0),
    MapEntry('English', 0.85),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: langs.map((e) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              SizedBox(width: 120, child: Text(e.key)),
              const SizedBox(width: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: e.value,
                    minHeight: 10,
                    backgroundColor: cs.surfaceVariant,
                    color: cs.primary,
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

class _Subheader extends StatelessWidget {
  const _Subheader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
