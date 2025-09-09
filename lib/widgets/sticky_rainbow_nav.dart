// lib/widgets/sticky_rainbow_nav.dart
import 'package:flutter/material.dart';

typedef SectionTap = void Function(String id);

/// Centered nav bar with soft gradient bg.
/// • Desktop/tablet: inline links
/// • Mobile: title + hamburger -> bottom sheet menu
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
    final w = MediaQuery.sizeOf(context).width;
    final isMobile = w < 720;

    const Color kText = Colors.black;
    const Color kTextDim = Colors.black87;

    Widget navItem(String id, String label) {
      return TextButton(
        onPressed: () => onTap(id),
        style: TextButton.styleFrom(
          foregroundColor: kText,
          overlayColor: Colors.black12,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: kText,
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: .2,
          ),
        ),
      );
    }

    Future<void> _openMobileMenu() async {
      // Define local helper BEFORE use so closures can see it
      void select(String id) {
        Navigator.of(context).maybePop();
        onTap(id);
      }

      await showModalBottomSheet<void>(
        context: context,
        useSafeArea: true,
        showDragHandle: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _MobileNavTile(label: 'About',      onPressed: () => select('about')),
                _MobileNavTile(label: 'Experience', onPressed: () => select('experience')),
                _MobileNavTile(label: 'Skills',     onPressed: () => select('skills')),
                _MobileNavTile(label: 'Projects',   onPressed: () => select('projects')),
                _MobileNavTile(label: 'Courses',    onPressed: () => select('courses')),
                _MobileNavTile(label: 'Diploma',    onPressed: () => select('diploma')),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      );
    }

    return Material(
      color: Colors.transparent,
      child: Container(
        height: preferredSize.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFF7F1FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border(bottom: BorderSide(color: Color(0x1F000000))),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Row(
              children: [
                const SizedBox(width: 16),
                if (isMobile)
                  IconButton(
                    tooltip: 'Menu',
                    icon: const Icon(Icons.menu, color: Colors.black, size: 24),
                    onPressed: _openMobileMenu,
                  ),
                if (isMobile) const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: isMobile ? TextAlign.center : TextAlign.left,
                    style: const TextStyle(
                      color: kTextDim,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      letterSpacing: .2,
                    ),
                  ),
                ),

                if (!isMobile) ...[
                  const SizedBox(width: 24),
                  Flexible(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          navItem('about', 'About'),
                          navItem('experience', 'Experience'),
                          navItem('skills', 'Skills'),
                          navItem('projects', 'Projects'),
                          navItem('courses', 'Courses'),
                          navItem('diploma', 'Diploma'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileNavTile extends StatelessWidget {
  const _MobileNavTile({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: const Icon(Icons.radio_button_unchecked, color: Colors.black54, size: 18),
      title: const SizedBox.shrink(), // to keep layout stable if you tweak below
      subtitle: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w800,
          letterSpacing: .2,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.black45),
    );
  }
}
