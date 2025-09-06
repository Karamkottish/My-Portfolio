import 'package:flutter/material.dart';

typedef SectionTap = void Function(String id);

/// Centered nav bar with solid black text (includes "Diploma")
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
    const Color kText = Colors.black;      // <- always black
    const Color kTextDim = Colors.black87; // slight contrast

    Widget navItem(String id, String label) {
      return TextButton(
        onPressed: () => onTap(id),
        style: TextButton.styleFrom(
          foregroundColor: kText, // text/ink
          overlayColor: Colors.black12, // press ripple
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: kText,          // <- force black
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: .2,
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: Container(
        height: preferredSize.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFF7F1FF)], // soft bg
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border(
            bottom: BorderSide(color: Color(0x1F000000)), // subtle divider
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    color: kTextDim, // slightly softer black
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    letterSpacing: .2,
                  ),
                ),
                const SizedBox(width: 48),

                // Links (scrolls if too narrow)
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        navItem('about', 'About'),
                        navItem('experience', 'Experience'),
                        navItem('skills', 'Skills'),
                        navItem('projects', 'Projects'),
                        navItem('courses', 'Courses'),
                        navItem('diploma', 'Diploma'), // NEW
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
