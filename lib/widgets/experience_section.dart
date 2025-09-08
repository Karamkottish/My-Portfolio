import 'package:flutter/material.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    final items = <_Exp>[
      _Exp(
        role: 'Frontend Developer Intern',
        company: 'Vica Solutions',
        date: 'September 2025 – Present',
        logoPath: 'lib/assets/images/vica.jpeg',
        points: [
          'Developed responsive web applications using HTML, CSS, JavaScript, and modern frameworks (React/Next.js).',
          'Implemented reusable UI components to ensure design consistency and reduce development time.',
          'Integrated REST APIs and GraphQL endpoints for dynamic data fetching and state updates.',
          'Optimized web performance by applying lazy loading, code splitting, and image optimization techniques.',
          'Contributed to Agile sprints through daily standups, backlog refinement, and sprint planning.',
        ],
      ),
      _Exp(
        role: 'Frontend Developer Intern',
        company: 'Springer Capital',
        date: 'August 2025 – Present',
        logoPath: 'lib/assets/images/springer_capital_logo.jpeg',
        points: [
          'Built with Next.js, React, and TailwindCSS.',
          'Integrated REST endpoints and caching.',
          'Improved accessibility and dark mode support.',
        ],
      ),
      _Exp(
        role: 'Junior Flutter Developer',
        company: 'Freelance',
        date: '2023 – Present',
        logoPath: 'lib/assets/images/focal_x_agency_logo.jpeg',
        points: [
          'Delivered e-commerce and portfolio apps.',
          'Integrated RESTful APIs and Firebase services for real-time data and authentication.',
          'Implemented state management with Provider/Riverpod to handle complex app logic.',
          'Optimized performance through lazy loading, reducing widget rebuilds, and efficient rendering.',
          'Enhanced user experience with Material Design and custom animations.',
        ],
      ),
    ];

    return Column(
      children: [
        for (final it in items) ...[
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: DefaultTextStyle(
                style: t.bodyMedium!,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Logo section
                    if (it.logoPath != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          it.logoPath!,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (it.logoPath != null) const SizedBox(width: 16),

                    // ✅ Experience text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${it.role} • ${it.company}',
                              style: t.titleMedium),
                          const SizedBox(height: 4),
                          Text(it.date,
                              style: t.bodySmall
                                  ?.copyWith(color: cs.onSurfaceVariant)),
                          const SizedBox(height: 10),
                          ...it.points.map(
                                (p) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('•  '),
                                  Expanded(child: Text(p)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
  final String? logoPath;
  final List<String> points;

  _Exp({
    required this.role,
    required this.company,
    required this.date,
    required this.points,
    this.logoPath,
  });
}
