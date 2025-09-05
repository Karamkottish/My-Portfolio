import 'package:flutter/material.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    final items = <_Exp>[
      _Exp(
        role: 'Frontend Developer intern',
        company: 'Springer Capital ',
        date: 'August 2025 – present',
        points: [
          'Built with NextJs, React, and TailwindCSS.',
          'Integrated REST endpoints and caching.',
          'Improved accessibility and dark mode support.',
        ],
      ),
      _Exp(
        role: 'Junior Flutter Dev ',
        company: 'Solo',
        date: '2023 – Present',
        points: [
          'Delivered e-commerce and portfolio apps.',
          'Implemented CI steps and ',
          'Collaborated via GitHub/GitLab, code reviews.',
        ],
      ),
    ];

    return Column(
      children: [
        for (final it in items) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: DefaultTextStyle(
                style: t.bodyMedium!,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${it.role} • ${it.company}', style: t.titleMedium),
                    const SizedBox(height: 4),
                    Text(it.date, style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                    const SizedBox(height: 10),
                    ...it.points.map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('•  '),
                          Expanded(child: Text(p)),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _Exp {
  final String role;
  final String company;
  final String date;
  final List<String> points;
  _Exp({required this.role, required this.company, required this.date, required this.points});
}
