import 'package:flutter/material.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    // ============================ DATA ============================
    // Fill roles with real start/end dates. end == null means "Present".

    final companies = <_CompanyExp>[
      _CompanyExp(
        sort: 1000, // HIGHER THAN ALL → appears first
        name: 'NPT Solutions',
        logoPath: 'lib/assets/images/NPT.png',
        location: 'Banglore, India · Remote',
        roles: [
          _RoleExp(
            title: 'Frontend Web Developer(React Js )',
            employmentType: 'Full Time',
            start: DateTime(2025, 8),
            end: null,
            bullets: [
              'Built responsive web apps with React/Next.js and TypeScript.',
              'Translated designs into clean, reusable components.',
              'Improved performance via API integrations, caching, and code optimization.',
              'Added accessibility improvements and dark-mode support.',
            ],
            skillsLine: 'React.js, Next.js and +9 skills',
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
            title: 'Associate Software Engineer',
            employmentType: 'Full Time (Flutter Developer TeamLeader)',
            start: DateTime(2025, 9),
            end: null,
            bullets: [
              'Developing the app from scratch using GitHub and Firebase.',
              'Collaborated with cross-functional teams to define app requirements and user flows.',
              'Focused on building scalable, maintainable, and production-ready features.',
            ],
            skillsLine: 'GitHub, Firebase and +7 skills',
          ),
          _RoleExp(
            title: 'Social Media Admin',
            employmentType: 'Full-time',
            start: DateTime(2025, 9),
            end: null,
            bullets: [
              'Managed Facebook and LinkedIn pages to strengthen brand presence and engagement.',
              'Created, scheduled, and optimized posts to reach wider audiences and maintain consistent activity.',
              'Analyzed engagement metrics to adjust strategies and improve community interaction.',
            ],
            skillsLine: 'Social Media Marketing, Facebook Marketing and +4 skills',
          ),
        ],
      ),
      _CompanyExp(
        sort: 990,
        name: 'Vica Web Solutions',
        logoPath: 'lib/assets/images/vica.jpeg',
        location: 'Damascus, Damascus Governorate, Syria · Remote',
        roles: [
          _RoleExp(
            title: 'Frontend Web Developer intern',
            employmentType: 'Internship',
            start: DateTime(2025, 9),
            end: null,
            summary:
            'Passionate about creating user-friendly, responsive, and visually appealing web apps.',
            bullets: [
              'Built with HTML, CSS, JavaScript, TypeScript, React.js, and Tailwind CSS.',
              'Implemented reusable UI components to ensure design consistency and speed.',
              'Integrated REST and GraphQL endpoints for dynamic data and state updates.',
              'Optimized performance (lazy loading, code-splitting, image optimization).',
              'Participated in Agile ceremonies and sprint delivery.',
            ],
            skillsLine: 'GitHub, React.js and +6 skills',
          ),
        ],
      ),
      _CompanyExp(
        sort: 980,
        name: 'Springer Capital',
        logoPath: 'lib/assets/images/springer_capital_logo.jpeg',
        location: 'Chicago, Illinois, United States · Remote',
        roles: [
          _RoleExp(
            title: 'Frontend Web Developer(React Js TeamLeader)',
            employmentType: 'Internship',
            start: DateTime(2025, 8), // Aug 2025
            end: null,
            bullets: [
              'Built responsive web apps with React/Next.js and TypeScript.',
              'Translated designs into clean, reusable components.',
              'Improved performance via API integrations, caching, and code optimization.',
              'Added accessibility improvements and dark-mode support.',
            ],
            skillsLine: 'React.js, Next.js and +9 skills',
          ),
        ],
      ),
      _CompanyExp(
        sort: 900,
        name: 'SoftTechSyria',
        logoPath: 'lib/assets/images/SoftTech3D.png',
        location: 'Damascus, Damascus Governorate, Syria · Remote',
        roles: [
          _RoleExp(
            title: 'Flutter Developer',
            employmentType: 'Part-time',
            start: DateTime(2025, 1),
            end: null,
            bullets: [
              'Freelance Flutter dev shipping fast, beautiful iOS/Android apps end-to-end.',
              'Stable, production-ready builds from scoping to store release.',
              'Clean architecture, smooth UX, reliable CI/CD.',
              'Rapid MVPs, slick animations, and reliable releases to App Store & Play.',
            ],
            skillsLine: 'Stripe, SOLID and +9 skills',
          ),
        ],
      ),
      _CompanyExp(
        sort: 700,
        name: 'focal X agency',
        logoPath: 'lib/assets/images/focal_x_agency_logo.jpeg',
        location: 'Damascus Governorate, Syria · Remote',
        roles: [
          _RoleExp(
            title: 'Flutter Developer Intern',
            employmentType: 'Internship',
            start: DateTime(2023, 2),
            end: DateTime(2024, 6),
            bullets: [
              'Flutter app development—advanced course and production projects.',
              'Integrated Firebase services for auth, analytics, and realtime data.',
              'Focused on performance, clean code, and UI polish.',
            ],
            skillsLine: 'GitHub, Firebase and +26 skills',
          ),
        ],
      ),
    ];

    // New → Old by the custom "sort" key
    companies.sort((a, b) => b.sort.compareTo(a.sort));

    // ============================ UI ============================
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final company in companies) ...[
          _CompanyHeader(
            name: company.name,
            logoPath: company.logoPath,
            overallPeriod: _formatCompanyPeriod(company.roles),
            location: company.location,
          ),
          const SizedBox(height: 8),
          for (final role in company.roles) ...[
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: DefaultTextStyle(
                  style: t.bodyMedium!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${role.title} • ${role.employmentType}',
                          style: t.titleMedium),
                      const SizedBox(height: 4),
                      Text(
                        _formatRolePeriod(role.start, role.end),
                        style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                      ),
                      if (role.summary != null) ...[
                        const SizedBox(height: 8),
                        Text(role.summary!),
                      ],
                      const SizedBox(height: 10),
                      ...role.bullets.map(
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
                      if (role.skillsLine != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.workspace_premium_outlined,
                                size: 18, color: cs.primary),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                role.skillsLine!,
                                style: t.bodySmall?.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 4), // subtle gap between companies
        ],
      ],
    );
  }

  // ======================= HELPERS =======================

  static String _formatCompanyPeriod(List<_RoleExp> roles) {
    // Company period spans earliest start to latest end (or Present if any ongoing).
    final starts = roles.map((r) => r.start);
    final ends = roles.map((r) => r.end).where((e) => e != null).cast<DateTime>();

    final startMin = starts.reduce((a, b) => a.isBefore(b) ? a : b);
    final endMax =
    roles.any((r) => r.end == null) ? null : ends.reduce((a, b) => a.isAfter(b) ? a : b);

    return '${_monthYear(startMin)} – ${endMax == null ? 'Present' : _monthYear(endMax)}'
        ' · ${_humanDuration(startMin, endMax)}';
  }

  static String _formatRolePeriod(DateTime start, DateTime? end) {
    return '${_monthYear(start)} – ${end == null ? 'Present' : _monthYear(end)}'
        ' · ${_humanDuration(start, end)}';
  }

  static String _monthYear(DateTime d) {
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return '${months[d.month - 1]} ${d.year}';
  }

  /// Returns "1 mo", "2 mos", "1 yr", "1 yr 3 mos", etc.
  /// Rules:
  /// - Minimum is 1 month (never "0 mos").
  /// - Ongoing roles (end == null) **round up** partial months so current work doesn't undercount.
  static String _humanDuration(DateTime start, DateTime? end) {
    final now = DateTime.now();
    final to = end ?? now;

    // Base month difference
    int months = (to.year - start.year) * 12 + (to.month - start.month);

    // Adjust for day-of-month to avoid counting an incomplete month
    if (to.day < start.day) {
      months -= 1;
    }

    // For ongoing roles, if there are remaining days beyond full months, round up
    if (end == null) {
      final anchor = DateTime(start.year, start.month + months, start.day);
      if (to.isAfter(anchor)) {
        months += 1;
      }
    }

    // Never show 0
    months = months.clamp(1, 100000);

    final years = months ~/ 12;
    final rem = months % 12;

    if (years == 0) return '$months ${months == 1 ? 'mo' : 'mos'}';
    if (rem == 0) return '$years ${years == 1 ? 'yr' : 'yrs'}';
    return '$years ${years == 1 ? 'yr' : 'yrs'} $rem mos';
  }
}

// ========================= MODELS =========================

class _CompanyExp {
  final int sort; // higher = newer
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

  _RoleExp({
    required this.title,
    required this.employmentType,
    required this.start,
    required this.end,
    required this.bullets,
    this.summary,
    this.skillsLine,
  });
}

// =============== Company header (logo + name + meta) ===============

class _CompanyHeader extends StatelessWidget {
  const _CompanyHeader({
    required this.name,
    required this.location,
    required this.overallPeriod,
    this.logoPath,
  });

  final String name;
  final String location;
  final String overallPeriod;
  final String? logoPath;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (logoPath != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              logoPath!,
              width: 36,
              height: 36,
              fit: BoxFit.cover,
            ),
          ),
        if (logoPath != null) const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: t.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(overallPeriod,
                  style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
              Text(location,
                  style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
            ],
          ),
        ),
      ],
    );
  }
}
