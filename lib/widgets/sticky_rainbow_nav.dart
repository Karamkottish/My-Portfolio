// lib/widgets/sticky_rainbow_nav.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef SectionTap = void Function(String id);

/// Centered nav bar with soft gradient bg.
/// • Desktop/tablet: inline links
/// • Mobile: title + modern glassy bottom-sheet menu (2026 style)
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
      HapticFeedback.selectionClick();
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        barrierColor: Colors.black.withOpacity(0.25),
        backgroundColor: Colors.transparent,
        builder: (_) => _MobileMenuSheet(onTap: onTap),
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
                  _GlassIconButton(
                    tooltip: 'Menu',
                    icon: Icons.grid_view_rounded,
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

/// —————————————————————————————————————————————
/// 2026 Mobile Menu: glassmorphism, drag, big taps
/// —————————————————————————————————————————————
class _MobileMenuSheet extends StatefulWidget {
  const _MobileMenuSheet({required this.onTap});
  final SectionTap onTap;

  @override
  State<_MobileMenuSheet> createState() => _MobileMenuSheetState();
}

class _MobileMenuSheetState extends State<_MobileMenuSheet> {
  final _controller = DraggableScrollableController();
  double _extent = 0.0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() => _extent = _controller.size);
    });
  }

  void _select(String id) {
    HapticFeedback.lightImpact();
    Navigator.of(context).maybePop();
    widget.onTap(id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Stack(
      children: [
        // Backdrop blur under the sheet
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: const SizedBox.expand(),
          ),
        ),

        DraggableScrollableSheet(
          controller: _controller,
          snap: true,
          expand: false,
          initialChildSize: 0.64,
          minChildSize: 0.50,
          maxChildSize: 0.92,
          builder: (context, scrollController) {
            final headerOpacity = (_extent - 0.5).clamp(0.0, 1.0);
            return SafeArea(
              top: false,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  // glassy gradient
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      cs.surface.withOpacity(0.9),
                      cs.surfaceVariant.withOpacity(0.75),
                    ],
                  ),
                  border: Border.all(color: cs.outlineVariant.withOpacity(.3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 28,
                      offset: const Offset(0, -6),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: CustomScrollView(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      // Drag handle + animated header
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Container(
                              height: 5,
                              width: 44,
                              decoration: BoxDecoration(
                                color: cs.outlineVariant.withOpacity(.6),
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                            const SizedBox(height: 12),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 180),
                              opacity: headerOpacity,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18),
                                child: _GradientHeader(),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),

                      // Search (visual anchor; optional behavior)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                          child: _SearchField(
                            hintText: 'Quick jump…',
                            onSubmitted: (value) {
                              // naive matcher
                              final q = value.trim().toLowerCase();
                              const ids = [
                                'about','experience','skills','projects','courses','diploma'
                              ];
                              final matched = ids.firstWhere(
                                    (id) => id.startsWith(q),
                                orElse: () => '',
                              );
                              if (matched.isNotEmpty) _select(matched);
                            },
                          ),
                        ),
                      ),

                      // Nav list
                      SliverList.list(
                        children: [
                          _NavTile(
                            icon: Icons.person_rounded,
                            label: 'About',
                            subtitle: 'Who I am & what I do',
                            onTap: () => _select('about'),
                          ),
                          _NavTile(
                            icon: Icons.work_history_rounded,
                            label: 'Experience',
                            subtitle: 'Roles, impact, achievements',
                            onTap: () => _select('experience'),
                          ),
                          _NavTile(
                            icon: Icons.auto_awesome_rounded,
                            label: 'Skills',
                            subtitle: 'Tech stack & tools',
                            onTap: () => _select('skills'),
                          ),
                          _NavTile(
                            icon: Icons.movie_rounded,
                            label: 'Projects',
                            subtitle: 'Demos, videos, case studies',
                            trailing: _Badge(text: 'New'),
                            onTap: () => _select('projects'),
                          ),
                          _NavTile(
                            icon: Icons.school_rounded,
                            label: 'Courses',
                            subtitle: 'Certificates & coursework',
                            onTap: () => _select('courses'),
                          ),
                          _NavTile(
                            icon: Icons.workspace_premium_rounded,
                            label: 'Diploma',
                            subtitle: 'Academic highlights',
                            onTap: () => _select('diploma'),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),

                      // Footer actions
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: _PrimaryButton(
                                  icon: Icons.download_rounded,
                                  label: 'Download CV',
                                  onPressed: () {
                                    HapticFeedback.selectionClick();
                                    // handled by parent hero section; here we just close menu:
                                    Navigator.of(context).maybePop();
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _GhostButton(
                                  icon: Icons.nightlight_round,
                                  label: 'Theme',
                                  onPressed: () {
                                    HapticFeedback.selectionClick();
                                    // Let app-level theme toggle handle this if you wire it later.
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Theme toggle goes here ✨'),
                                        behavior: SnackBarBehavior.floating,
                                        duration: Duration(milliseconds: 1200),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

/// ——————————————————
/// Small UI pieces
/// ——————————————————
class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({required this.tooltip, required this.icon, required this.onPressed});
  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip,
      child: InkResponse(
        onTap: onPressed,
        radius: 28,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: cs.surface.withOpacity(.75),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outlineVariant.withOpacity(.35)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Icon(icon, color: Colors.black87, size: 22),
        ),
      ),
    );
  }
}

class _GradientHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cs.primary.withOpacity(.10),
            cs.secondary.withOpacity(.08),
            cs.tertiary.withOpacity(.10),
          ],
        ),
        border: Border.all(color: cs.outlineVariant.withOpacity(.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [cs.primary, cs.tertiary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(Icons.explore_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Navigate fast • Explore sections • Smooth scroll',
              maxLines: 2,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                letterSpacing: .2,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.hintText, required this.onSubmitted});
  final String hintText;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextField(
      textInputAction: TextInputAction.search,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search_rounded),
        filled: true,
        fillColor: cs.surface.withOpacity(.85),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.outlineVariant.withOpacity(.4)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.outlineVariant.withOpacity(.35)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.primary.withOpacity(.6), width: 1.2),
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: cs.primary.withOpacity(.08),
        highlightColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: cs.surface.withOpacity(.92),
            border: Border.all(color: cs.outlineVariant.withOpacity(.35)),
          ),
          child: Row(
            children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [cs.primary, cs.secondary],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Icon(icon, color: Colors.black87),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          letterSpacing: .2,
                        )),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: cs.onSurfaceVariant,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: .15,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
              const SizedBox(width: 6),
              Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.primary.withOpacity(.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: cs.primary,
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: .2,
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.icon, required this.label, required this.onPressed});
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
      ),
    );
  }
}

class _GhostButton extends StatelessWidget {
  const _GhostButton({required this.icon, required this.label, required this.onPressed});
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18, color: Colors.black87),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        side: BorderSide(color: cs.outlineVariant.withOpacity(.6)),
        backgroundColor: cs.surface.withOpacity(.75),
        foregroundColor: Colors.black,
      ),
    );
  }
}
