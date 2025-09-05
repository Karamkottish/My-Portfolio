import 'package:flutter/material.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final skills = [
      'Flutter', 'Dart', 'Firebase', 'REST', 'Git', 'CI/CD',
      'Provider', 'Riverpod', 'Clean Architecture', 'SQLite', 'Ui/Ux', 'Getx', 'ReactJs', 'NextJs', 'TailWind Css','TypeScript','Animations','Jira',
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final s in skills)
          Chip(
            label: Text(s),
            avatar: Icon(Icons.check_circle, size: 16, color: cs.primary),
          ),
      ],
    );
  }
}

/// Soft skills chips
class SoftSkillsSection extends StatelessWidget {
  const SoftSkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final soft = [
      'Communication',
      'Problem Solving',
      'Teamwork',
      'Adaptability',
      'Time Management',
      'Quick Learner',
      'Professionalism',
      'Work Under Pressure',
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final s in soft)
          Chip(
            label: Text(s),
            avatar: Icon(Icons.workspace_premium_outlined, size: 16, color: cs.secondary),
          ),
      ],
    );
  }
}

/// Languages with progress bars
class LanguagesSection extends StatelessWidget {
  const LanguagesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final langs = <MapEntry<String, double>>[
      const MapEntry('Arabic', 1.0),
      const MapEntry('English', 0.85),
      // Add German if you like: MapEntry('German', 0.5)
    ];

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
