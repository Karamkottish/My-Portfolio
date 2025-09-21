// lib/widgets/designs_section.dart
import 'package:flutter/material.dart';

class DesignsSection extends StatefulWidget {
  const DesignsSection({super.key});

  @override
  State<DesignsSection> createState() => _DesignsSectionState();
}

class _DesignsSectionState extends State<DesignsSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _enter =
  AnimationController(vsync: this, duration: const Duration(milliseconds: 600))
    ..forward();

  @override
  void dispose() {
    _enter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final w = MediaQuery.sizeOf(context).width;
    final isMobile = w < 600;
    final maxW = isMobile ? w - 24 : (w > 1200 ? 1100.0 : w - 48);

    final items = <_DesignCardData>[
      _DesignCardData(
        imagePath: 'lib/assets/images/3D.png',
        title: 'Social Design — 3D',
        subtitle: 'Facebook & LinkedIn',
        tag: 'Social',
      ),
      _DesignCardData(
        imagePath: 'lib/assets/images/Default.png',
        title: 'Social Design — Default',
        subtitle: 'Facebook & LinkedIn',
        tag: 'Social',
      ),
      _DesignCardData(
        imagePath: 'lib/assets/images/front.png',
        title: 'Brochure — Front',
        subtitle: 'Print ready',
        tag: 'Brochure',
      ),
      _DesignCardData(
        imagePath: 'lib/assets/images/back.png',
        title: 'Brochure — Back',
        subtitle: 'Print ready',
        tag: 'Brochure',
      ),
      _DesignCardData(
        imagePath: 'lib/assets/images/softtectlogo1.png',
        title: 'Branding — SoftTech Logo',
        subtitle: 'Identity',
        tag: 'Brand',
      ),
      _DesignCardData(
        imagePath: 'lib/assets/images/new.png',
        title: 'Branding — New',
        subtitle: 'Identity',
        tag: 'Brand',
      ),
    ];

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW),
        child: FadeTransition(
          opacity: _enter.drive(Tween<double>(begin: 0, end: 1)
              .chain(CurveTween(curve: Curves.easeOutCubic))),
          child: SlideTransition(
            position: _enter.drive(
              Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeOutCubic)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(Icons.palette_outlined, color: cs.primary, size: isMobile ? 20 : 24),
                    const SizedBox(width: 8),
                    Text(
                      'Designs',
                      style: isMobile ? t.titleMedium : t.titleLarge,
                    ),
                    const SizedBox(width: 10),
                    _GradientPill(
                      label: 'Social • Brochure • Brand',
                      isMobile: isMobile,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Used for my Social Media Marketing for Facebook and LinkedIn.',
                  style: t.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: 14),

                // Grid
                _ResponsiveGrid(
                  children: [
                    for (final d in items) _DesignCard(data: d),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientPill extends StatelessWidget {
  const _GradientPill({required this.label, this.isMobile = false});
  final String label;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 10 : 12,
        vertical: isMobile ? 5 : 6.5,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF73C7), Color(0xFF57D0FF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(.16)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          letterSpacing: .2,
        ),
      ),
    );
  }
}

/// Responsive wrap/grid that keeps cards tidy and light.
class _ResponsiveGrid extends StatelessWidget {
  const _ResponsiveGrid({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isMobile = w < 600;
    final spacing = isMobile ? 10.0 : 12.0;

    return LayoutBuilder(builder: (_, box) {
      // target item width ~ 280–320 on desktop, ~160–200 on mobile
      final target = isMobile ? 180.0 : 300.0;
      final count = (box.maxWidth / target).clamp(1, 4).floor();
      final itemW = (box.maxWidth - spacing * (count - 1)) / count;
      final ratio = isMobile ? 4 / 5 : 16 / 10; // taller on mobile

      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: [
          for (final c in children)
            SizedBox(width: itemW, child: AspectRatio(aspectRatio: ratio, child: c)),
        ],
      );
    });
  }
}

class _DesignCardData {
  final String imagePath;
  final String title;
  final String subtitle;
  final String tag;

  _DesignCardData({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.tag,
  });
}

class _DesignCard extends StatefulWidget {
  const _DesignCard({required this.data});
  final _DesignCardData data;

  @override
  State<_DesignCard> createState() => _DesignCardState();
}

class _DesignCardState extends State<_DesignCard> {
  bool _hover = false;

  void _openViewer() {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: InteractiveViewer(
          minScale: 0.8,
          maxScale: 4,
          child: Center(
            child: Image.asset(widget.data.imagePath, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? Colors.white24 : Colors.black12;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        scale: _hover ? 1.02 : 1.0,
        child: GestureDetector(
          onTap: _openViewer,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? .24 : .14),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Image
                  Image.asset(
                    widget.data.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: cs.surfaceVariant,
                      alignment: Alignment.center,
                      child: Icon(Icons.image_not_supported_outlined,
                          color: cs.onSurfaceVariant),
                    ),
                  ),
                  // Top rainbow strip
                  const Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    height: 6,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
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
                  ),
                  // Bottom overlay details
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 160),
                    opacity: _hover ? 1 : .92,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(.65),
                              Colors.black.withOpacity(.15),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                        child: Row(
                          children: [
                            // Tag pill
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.12),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: Colors.white.withOpacity(.18),
                                ),
                              ),
                              child: Text(
                                widget.data.tag,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Titles
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.data.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 6,
                                          color: Colors.black54,
                                          offset: Offset(1, 1),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.data.subtitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Zoom icon
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.14),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(.22),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(6),
                                child: Icon(Icons.zoom_in,
                                    size: 18, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
