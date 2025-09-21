// lib/widgets/diploma_section.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Diploma (Courses-style: colorful card + gradient number pill + animation)
class DiplomaSection extends StatefulWidget {
  const DiplomaSection({super.key, this.number = 1});
  final int number;

  @override
  State<DiplomaSection> createState() => _DiplomaSectionState();
}

class _DiplomaSectionState extends State<DiplomaSection>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  late final AnimationController _anim =
  AnimationController(vsync: this, duration: const Duration(seconds: 3))
    ..repeat();

  static const String mainDiploma = 'lib/assets/Diploma/uiuxDiploma.png';
  static const List<String> gallery = [
    'lib/assets/Diploma/userxperienceDesign.png',
    'lib/assets/Diploma/userxperienceReserach.png',
    'lib/assets/Diploma/userdesignFundementals.png',
    'lib/assets/Diploma/designPrincepls.png',
  ];

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 720;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header like Courses: title + gradient pill with number
            Row(
              children: [
                Text(
                  'Diploma',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                _GradientPill(text: widget.number.toString().padLeft(2, '0')),
              ],
            ),
            const SizedBox(height: 12),

            // Main colorful card (matches Courses visual language)
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 820),
                  child: AnimatedBuilder(
                    animation: _anim,
                    builder: (_, __) {
                      final t = _anim.value * 2 * math.pi;
                      final dy = math.sin(t) * 6; // float
                      final scale = 0.995 + (math.cos(t) * 0.005);
                      return Transform.translate(
                        offset: Offset(0, dy),
                        child: Transform.scale(
                          scale: scale,
                          child: const _DiplomaCoursesStyleCard(
                            imagePath: mainDiploma,
                            title: 'UI/UX Diploma',
                            subtitle: 'Tap to view certificate set',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Gallery (compact grid)
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: LayoutBuilder(
                      builder: (_, box) {
                        final crossAxisCount = isMobile ? 2 : 4;
                        const spacing = 10.0;
                        final rawItemW =
                            (box.maxWidth - spacing * (crossAxisCount - 1)) /
                                crossAxisCount;
                        final itemW =
                        isMobile ? rawItemW : rawItemW.clamp(0, 220).toDouble();
                        final itemH = itemW * (2 / 3); // 3:2 ratio

                        return Wrap(
                          spacing: spacing,
                          runSpacing: spacing,
                          children: [
                            for (final p in gallery)
                              SizedBox(
                                width: itemW,
                                height: itemH,
                                child: _GalleryThumb(imagePath: p),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              crossFadeState:
              _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 220),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small gradient pill to display "01", "02", ...
class _GradientPill extends StatelessWidget {
  const _GradientPill({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6AC1), Color(0xFF00E5FF)],
        ),
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}

/// Courses-style card: rounded, border, shadow, top rainbow strip, bottom overlay
class _DiplomaCoursesStyleCard extends StatelessWidget {
  const _DiplomaCoursesStyleCard({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  final String imagePath;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final border = isDark ? Colors.white24 : Colors.black12;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade800,
                  child: const Center(
                    child: Icon(Icons.broken_image,
                        color: Colors.white54, size: 48),
                  ),
                ),
              ),
            ),
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
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black54, Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 14,
              bottom: 12,
              right: 14,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
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
                          subtitle,
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
                  const Icon(Icons.zoom_in, size: 18, color: Colors.white70),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GalleryThumb extends StatelessWidget {
  const _GalleryThumb({required this.imagePath});
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(imagePath, fit: BoxFit.cover),
          Positioned(
            right: 6,
            bottom: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.zoom_in, size: 12, color: Colors.white),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  barrierColor: Colors.black87,
                  builder: (_) => GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: InteractiveViewer(
                      minScale: 0.8,
                      maxScale: 4,
                      child: Center(
                        child: Image.asset(imagePath, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
