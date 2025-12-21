import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ExperienceSection extends StatefulWidget {
  const ExperienceSection({super.key});

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  bool _hasAnimated = false;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final isDesktop = MediaQuery.of(context).size.width >= 1024;

    final companies = <_CompanyExp>[
      _CompanyExp(
        sort: 1000,
        name: 'NPT Solutions',
        logoPath: 'lib/assets/images/NPT.png',
        location: 'Bangalore, India · Remote',
        roles: [
          _RoleExp(
            title: 'Frontend Web Developer (React.js)',
            employmentType: 'Full-time',
            start: DateTime(2025, 8),
            end: null,
            bullets: [
              'Built scalable, responsive web applications using React, Next.js, and TypeScript.',
              'Converted Figma designs into reusable, accessible UI components.',
              'Optimized performance using code-splitting, memoization, and API caching.',
              'Implemented dark mode and accessibility best practices (ARIA, contrast, keyboard nav).',
            ],
            skillsLine: 'React.js, Next.js, TypeScript, Performance Optimization',
          ),
        ],
      ),

      _CompanyExp(
        sort: 999,
        name: 'Paws Pal Connect',
        logoPath: 'lib/assets/images/LOGO3D.png',
        location: 'Bangalore Urban, Karnataka, India · Remote',
        roles: [
          _RoleExp(
            title: 'Product Manager',
            employmentType: 'Full-time',
            start: DateTime(2025, 12),
            end: null,
            summary: 'Promoted from Flutter Team Lead to Product Manager.',
            bullets: [
              'Owned end-to-end product roadmap and feature prioritization.',
              'Defined product requirements, user stories, and acceptance criteria.',
              'Led sprint planning, backlog grooming, and cross-team alignment.',
              'Used analytics and user feedback to guide roadmap decisions.',
            ],
            metrics: const {
              'Users': '12k+',
              'Releases': '18',
              'Velocity': '+32%',
            },
            skillsLine: 'Product Strategy, Roadmapping, Agile, Scrum, Analytics',
          ),
          _RoleExp(
            title: 'Flutter Team Lead',
            employmentType: 'Full-time',
            start: DateTime(2025, 9),
            end: DateTime(2025, 12),
            bullets: [
              'Led Flutter app development from scratch using Firebase and GitHub.',
              'Defined scalable architecture and enforced clean code practices.',
              'Reviewed PRs and mentored junior Flutter developers.',
            ],
            skillsLine: 'Flutter, Firebase FCM, GitHub, Team Leadership , AWS , Languages , Themes',
          ),
          _RoleExp(
            title: 'Social Media Admin',
            employmentType: 'Full-time',
            start: DateTime(2025, 9),
            end: DateTime(2025, 12),
            bullets: [
              'Managed Facebook and LinkedIn company pages.',
              'Planned and scheduled content to increase reach and engagement.',
              'Analyzed engagement metrics and optimized posting strategy.',
            ],
            skillsLine: 'Social Media Marketing, Content Strategy',
          ),
        ],
      ),

      _CompanyExp(
        sort: 990,
        name: 'Vica Web Solutions',
        logoPath: 'lib/assets/images/vica.jpeg',
        location: 'Damascus, Syria · Remote',
        roles: [
          _RoleExp(
            title: 'Frontend Web Developer Intern',
            employmentType: 'Internship',
            start: DateTime(2025, 9),
            end: null,
            summary:
            'Focused on building responsive, modern, and user-friendly web applications.',
            bullets: [
              'Developed UI using HTML, CSS, TypeScript, React.js, and Tailwind CSS.',
              'Built reusable components for faster development cycles.',
              'Integrated REST and GraphQL APIs.',
              'Applied performance optimizations such as lazy loading.',
            ],
            skillsLine: 'React.js, TypeScript, Tailwind CSS, GraphQL',
          ),
        ],
      ),

      _CompanyExp(
        sort: 980,
        name: 'Springer Capital',
        logoPath: 'lib/assets/images/springer_capital_logo.jpeg',
        location: 'Chicago, Illinois, USA · Remote',
        roles: [
          _RoleExp(
            title: 'Frontend Web Developer (React Team Lead)',
            employmentType: 'Internship',
            start: DateTime(2025, 8),
            end: DateTime(2025, 12),
            bullets: [
              'Led React frontend team and reviewed code contributions.',
              'Built responsive dashboards using React, Next.js, and TypeScript.',
              'Collaborated closely with backend and design teams.',
              'Improved application performance and accessibility.',
            ],
            skillsLine: 'React.js, Next.js, Team Leadership',
          ),
        ],
      ),

      _CompanyExp(
        sort: 900,
        name: 'SoftTechSyria',
        logoPath: 'lib/assets/images/SoftTech3D.png',
        location: 'Damascus, Syria · Remote',
        roles: [
          _RoleExp(
            title: 'Flutter Developer',
            employmentType: 'Part-time',
            start: DateTime(2025, 1),
            end: DateTime(2025, 10),
            bullets: [
              'Delivered production-ready Flutter apps for iOS and Android.',
              'Implemented clean architecture and scalable state management.',
              'Handled CI/CD pipelines and store deployments.',
              'Built smooth animations and polished UI/UX.',
            ],
            skillsLine: 'Flutter, Clean Architecture, CI/CD, Animations',
          ),
        ],
      ),

      _CompanyExp(
        sort: 700,
        name: 'Focal X Agency',
        logoPath: 'lib/assets/images/focal_x_agency_logo.jpeg',
        location: 'Damascus, Syria · Remote',
        roles: [
          _RoleExp(
            title: 'Flutter Developer Intern',
            employmentType: 'Internship',
            start: DateTime(2023, 2),
            end: DateTime(2024, 6),
            bullets: [
              'Completed advanced Flutter training and real production projects.',
              'Integrated Firebase authentication, analytics, and realtime database.',
              'Focused on performance optimization and UI polish.',
            ],
            skillsLine: 'Flutter, Firebase, GitHub',
          ),
        ],
      ),
    ];

    companies.sort((a, b) => b.sort.compareTo(a.sort));

    return VisibilityDetector(
      key: const Key('experience-section'),
      onVisibilityChanged: (info) {
        if (!_hasAnimated && info.visibleFraction > 0.25) {
          setState(() => _hasAnimated = true);
        }
      },
      child: AnimatedOpacity(
        opacity: _hasAnimated ? 1 : 0,
        duration: const Duration(milliseconds: 600),
        child: AnimatedSlide(
          offset: _hasAnimated ? Offset.zero : const Offset(0, 0.08),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final company in companies) ...[
                _CompanyHeader(company: company),
                const SizedBox(height: 14),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isDesktop) _YearRail(roles: company.roles),
                    Expanded(
                      child: Column(
                        children: [
                          for (final role in company.roles) ...[
                            _RoleCard(role: role),
                            const SizedBox(height: 18),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ================= ROLE CARD =================

class _RoleCard extends StatefulWidget {
  const _RoleCard({required this.role});
  final _RoleExp role;

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final isPrimary = widget.role.title == 'Product Manager';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isPrimary
            ? cs.primary.withOpacity(0.06)
            : cs.surfaceVariant.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPrimary
              ? cs.primary.withOpacity(0.5)
              : cs.outlineVariant.withOpacity(0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(widget.role.title,
                    style: t.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    )),
              ),
              if (isPrimary) _Pill(label: 'Promoted', color: cs.primary),
            ],
          ),

          const SizedBox(height: 4),
          Text(
            formatRolePeriod(widget.role.start, widget.role.end),
            style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),

          if (widget.role.summary != null) ...[
            const SizedBox(height: 8),
            Text(widget.role.summary!,
                style: t.bodyMedium?.copyWith(fontStyle: FontStyle.italic)),
          ],

          const SizedBox(height: 12),

          if (widget.role.metrics != null) ...[
            Wrap(
              spacing: 12,
              children: widget.role.metrics!.entries
                  .map((e) => _Metric(label: e.key, value: e.value))
                  .toList(),
            ),
            const SizedBox(height: 12),
          ],

          ...widget.role.bullets
              .take(_expanded ? widget.role.bullets.length : 2)
              .map((b) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text('• $b'),
          )),

          if (widget.role.bullets.length > 2)
            TextButton(
              onPressed: () => setState(() => _expanded = !_expanded),
              child: Text(_expanded ? 'Show less' : 'Show more'),
            ),

          if (widget.role.skillsLine != null) ...[
            const SizedBox(height: 8),
            Text(widget.role.skillsLine!,
                style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
          ],
        ],
      ),
    );
  }
}

// ================= COMPANY HEADER =================

class _CompanyHeader extends StatelessWidget {
  const _CompanyHeader({required this.company});
  final _CompanyExp company;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        if (company.logoPath != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(company.logoPath!, width: 36, height: 36),
          ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(company.name,
                  style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              Text(
                formatCompanyPeriod(company.roles),
                style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
              Text(company.location,
                  style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
            ],
          ),
        ),
      ],
    );
  }
}

// ================= YEAR RAIL =================

class _YearRail extends StatelessWidget {
  const _YearRail({required this.roles});
  final List<_RoleExp> roles;

  @override
  Widget build(BuildContext context) {
    final years = roles.map((r) => r.start.year).toSet().toList()..sort();
    return SizedBox(
      width: 64,
      child: Column(
        children: years
            .map((y) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 28),
          child: Text('$y'),
        ))
            .toList(),
      ),
    );
  }
}

// ================= SMALL UI =================

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label,
          style: TextStyle(color: color, fontWeight: FontWeight.w700)),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: t.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
        Text(label, style: t.bodySmall),
      ],
    );
  }
}

// ================= MODELS =================

class _CompanyExp {
  final int sort;
  final String name;
  final String? logoPath;
  final String location;
  final List<_RoleExp> roles;

  _CompanyExp({
    required this.sort,
    required this.name,
    required this.location,
    required this.roles,
    this.logoPath,
  });
}

class _RoleExp {
  final String title;
  final String employmentType;
  final DateTime start;
  final DateTime? end;
  final String? summary;
  final List<String> bullets;
  final String? skillsLine;
  final Map<String, String>? metrics;

  _RoleExp({
    required this.title,
    required this.employmentType,
    required this.start,
    required this.end,
    required this.bullets,
    this.summary,
    this.skillsLine,
    this.metrics,
  });
}

// ================= HELPERS (TOP-LEVEL) =================

String formatCompanyPeriod(List<_RoleExp> roles) {
  final start =
  roles.map((r) => r.start).reduce((a, b) => a.isBefore(b) ? a : b);
  final end = roles.any((r) => r.end == null)
      ? null
      : roles.map((r) => r.end!).reduce((a, b) => a.isAfter(b) ? a : b);
  return '${monthYear(start)} – ${end == null ? 'Present' : monthYear(end)}';
}

String formatRolePeriod(DateTime start, DateTime? end) {
  return '${monthYear(start)} – ${end == null ? 'Present' : monthYear(end)}';
}

String monthYear(DateTime d) {
  const m = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return '${m[d.month - 1]} ${d.year}';
}
