// lib/widgets/sticky_rainbow_nav.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef SectionTap = void Function(String id);

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

    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            height: preferredSize.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFFFFF), Color(0xFFF6F2FF)],
              ),
              border: Border(bottom: BorderSide(color: Color(0x19000000))),
              boxShadow: [
                BoxShadow(
                  color: Color(0x12000000),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                )
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        if (isMobile)
                          _GlassIconButton(
                            tooltip: 'Menu',
                            icon: Icons.grid_view_rounded,
                            onPressed: () => _openMobileMenu(context),
                          ),
                        if (isMobile) const SizedBox(width: 10),

                        // Title (fixed width on desktop so links can sit right after it)
                        Flexible(
                          flex: 0,
                          child: Padding(
                            padding: EdgeInsets.only(right: isMobile ? 0 : 24),
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black.withOpacity(.86),
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                                letterSpacing: .2,
                              ),
                            ),
                          ),
                        ),

                        // Desktop inline nav group (left aligned)
                        if (!isMobile) ...[
                          Flexible(
                            flex: 0,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  _NavLink(id: 'about', label: 'About', onTap: onTap),
                                  _NavLink(id: 'experience', label: 'Experience', onTap: onTap),
                                  _NavLink(id: 'skills', label: 'Skills', onTap: onTap),
                                  _NavLink(id: 'projects', label: 'Projects', onTap: onTap),
                                  _NavLink(id: 'courses', label: 'Courses', onTap: onTap),
                                  _NavLink(id: 'diploma', label: 'Diploma', onTap: onTap),
                                  _NavLink(id: 'designs', label: 'Designs', onTap: onTap),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],

                        // Mobile: minimalist quick-action to open menu
                        if (isMobile) ...[
                          const Spacer(),
                          _DotBadgeAction(
                            tooltip: 'Quick actions',
                            onPressed: () => _openMobileMenu(context),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openMobileMenu(BuildContext context) async {
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
}

/// ------------------------------------------------------------------
/// Desktop link
/// ------------------------------------------------------------------
class _NavLink extends StatefulWidget {
  const _NavLink({required this.id, required this.label, required this.onTap});

  final String id;
  final String label;
  final SectionTap onTap;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hover = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      mouseCursor: SystemMouseCursors.click,
      onShowFocusHighlight: (_) => setState(() {}),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: Semantics(
          button: true,
          label: widget.label,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: GestureDetector(
              onTapDown: (_) => setState(() => _pressed = true),
              onTapCancel: () => setState(() => _pressed = false),
              onTapUp: (_) => setState(() => _pressed = false),
              onTap: () => widget.onTap(widget.id),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                curve: Curves.easeOut,
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                transform: Matrix4.identity()
                  ..translate(0.0, _hover ? -1.5 : 0.0)
                  ..scale(_pressed ? 0.98 : 1.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: _hover ? Colors.black.withOpacity(.035) : Colors.transparent,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Label with subtle gradient on hover/press
                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (rect) {
                        final base = const LinearGradient(
                          colors: [Color(0xFF111111), Color(0xFF111111)],
                        );
                        final hoverGrad = const LinearGradient(
                          colors: [Color(0xFFFF6AC1), Color(0xFF00E5FF)],
                        );
                        return (_hover || _pressed ? hoverGrad : base)
                            .createShader(Offset.zero & rect.size);
                      },
                      child: Text(
                        widget.label,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: .2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Animated underline
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOutCubic,
                      height: 2.5,
                      width: _hover ? 24 : 0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// Mobile Menu (glassmorphism, search, big taps, subtle animations)
/// ------------------------------------------------------------------
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
    _controller.addListener(() => setState(() => _extent = _controller.size));
  }

  void _select(String id) {
    HapticFeedback.lightImpact();
    Navigator.of(context).maybePop();
    widget.onTap(id);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Stack(
      children: [
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
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      cs.surface.withOpacity(0.92),
                      cs.surfaceVariant.withOpacity(0.80),
                    ],
                  ),
                  border: Border.all(color: cs.outlineVariant.withOpacity(.32)),
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
                      // Handle + animated header
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Container(
                              height: 5, width: 44,
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

                      // Search
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                          child: _SearchField(
                            hintText: 'Quick jump…',
                            onSubmitted: (value) {
                              final q = value.trim().toLowerCase();
                              const ids = [
                                'about','experience','skills','projects','courses','diploma','designs'
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
                            trailing: const _Badge(text: 'New'),
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
                          _NavTile(
                            icon: Icons.palette_rounded,
                            label: 'Designs',
                            subtitle: 'Social, Brochure & Branding',
                            onTap: () => _select('designs'),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),

                      // 🔻 Footer actions removed to keep the sheet focused & clean.
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

/// ------------------------------------------------------------------
/// Small UI pieces
/// ------------------------------------------------------------------
class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

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
          child: Icon(icon, color: Colors.black.withOpacity(.86), size: 22),
        ),
      ),
    );
  }
}

class _DotBadgeAction extends StatelessWidget {
  const _DotBadgeAction({required this.tooltip, required this.onPressed});
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: cs.surface.withOpacity(.72),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: cs.outlineVariant.withOpacity(.35)),
          ),
          child: Row(
            children: [
              Container(
                width: 6, height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF6AC1), Color(0xFF00E5FF)],
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.more_horiz_rounded, size: 18, color: Colors.black87),
            ],
          ),
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
            width: 36, height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [cs.primary, cs.tertiary],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
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
                    Text(
                      label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        letterSpacing: .2,
                      ),
                    ),
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
