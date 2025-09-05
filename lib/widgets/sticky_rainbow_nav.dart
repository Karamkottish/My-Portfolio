import 'package:flutter/material.dart';

typedef SectionTap = void Function(String id);

/// Fully centered rainbow nav bar with title + links
class StickyRainbowNav extends StatelessWidget implements PreferredSizeWidget {
  const StickyRainbowNav({
    super.key,
    required this.onTap,
    this.title = 'Karam Portfolio',
  });

  final SectionTap onTap;
  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget link(String id, String label) => TextButton(
      onPressed: () => onTap(id),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87, // darker, more readable
        ),
      ),
    );

    return Material(
      color: Colors.transparent,
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFFDF7FF)], // light elegant
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border(
            bottom: BorderSide(color: cs.outlineVariant.withOpacity(0.3)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // ✅ everything centered
          children: [
            // Title
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 48),

            // Nav links
            link('about', 'About'),
            link('experience', 'Experience'),
            link('skills', 'Skills'),
            link('projects', 'Projects'),
            link('courses', 'Courses'),
          ],
        ),
      ),
    );
  }
}
