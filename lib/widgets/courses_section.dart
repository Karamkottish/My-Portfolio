import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CoursesSection extends StatefulWidget {
  const CoursesSection({super.key});

  @override
  State<CoursesSection> createState() => _CoursesSectionState();
}

class _Course {
  final String title;
  final String file;
  const _Course(this.title, this.file);
}

class _CoursesSectionState extends State<CoursesSection> {
  late final PageController _controller;
  int _index = 0;

  Timer? _autoTimer;
  Timer? _resumeDelay;

  final List<_Course> courses = const [
    _Course("Agile (Foundations)", "lib/assets/courses/Agile.png"),
    _Course("Project Management – Udemy", "lib/assets/images/ProjectMnagament.jpg"),
    _Course("User Experience Design (EN) — EDRAAK", "lib/assets/courses/EdrakuiuxEng.png"),
    _Course("تصميم تجربة المستخدم — إدراك", "lib/assets/courses/EdrakuiuxArab.png"),
    _Course("UX Researcher — Edraak", "lib/assets/courses/edrakeuxresreacher.png"),
    _Course("Flutter Advanced", "lib/assets/courses/flutterad.jpg"),
    _Course("Manara Fellowship", "lib/assets/courses/manara.png"),
    _Course("Git Training", "lib/assets/courses/git.png"),
    _Course("Ethical Hacking", "lib/assets/courses/hacking.png"),
    _Course("UI/UX Diploma", "lib/assets/Diploma/uiuxDiploma.png"),
    _Course("Computational Thinking", "lib/assets/courses/computiional.png"),
    _Course("Google Cloud AI", "lib/assets/courses/googlecould.png"),
    _Course("Google Cloud Operations", "lib/assets/courses/googleoperations.png"),
    _Course("Modern JavaScript — Manara", "lib/assets/courses/modernJS.png"),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.85);
    _startAutoplay();
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _resumeDelay?.cancel();
    _controller.dispose();
    super.dispose();
  }

  // ===== Autoplay =====
  void _startAutoplay() {
    if (_autoTimer?.isActive == true) return;
    _autoTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_controller.hasClients) return;
      _controller.animateToPage(
        (_index + 1) % courses.length,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  void _pause() {
    _autoTimer?.cancel();
    _autoTimer = null;
  }

  void _resume() {
    _resumeDelay?.cancel();
    _resumeDelay = Timer(const Duration(seconds: 5), _startAutoplay);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final width = MediaQuery.of(context).size.width;
    final height = width < 600 ? 230.0 : min(400.0, width * 0.35);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ===== Header =====
        Row(
          children: [
            Text(
              'Courses',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(width: 12),
            _CountBadge(count: courses.length),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Certifications & professional learning',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 18),

        // ===== Carousel =====
        SizedBox(
          height: height,
          child: GestureDetector(
            onPanDown: (_) => _pause(),
            onPanEnd: (_) => _resume(),
            child: PageView.builder(
              controller: _controller,
              itemCount: courses.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (context, i) {
                final course = courses[i];

                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    double value = 1;
                    if (_controller.position.haveDimensions) {
                      value = (_controller.page! - i).abs();
                      value = (1 - value * 0.2).clamp(0.85, 1.0);
                    }

                    return Transform.scale(
                      scale: value,
                      child: Opacity(opacity: value, child: child),
                    );
                  },
                  child: Tilt3D(
                    maxTilt: 10, // 👈 subtle = premium
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () => _openCourse(context, course),
                        child: _ImageCard(course: course),
                      ),
                    ),
                  ),

                );
              },
            ),
          ),
        ),

        const SizedBox(height: 16),

        // ===== Indicators =====
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.black12,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Wrap(
              spacing: 8,
              children: List.generate(
                courses.length,
                    (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  height: 8,
                  width: i == _index ? 28 : 8,
                  decoration: BoxDecoration(
                    gradient: i == _index
                        ? const LinearGradient(
                      colors: [Color(0xFF00E5FF), Color(0xFFFF6AC1)],
                    )
                        : null,
                    color: i == _index
                        ? null
                        : (isDark ? Colors.white30 : Colors.black38),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _openCourse(BuildContext context, _Course course) {
    final file = course.file.toLowerCase();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => file.endsWith('.pdf')
            ? PdfViewerPage(filePath: course.file, title: course.title)
            : ImageViewerPage(filePath: course.file, title: course.title),
      ),
    );
  }
}

// ===== Badge =====
class _CountBadge extends StatelessWidget {
  final int count;
  const _CountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6AC1), Color(0xFF00E5FF)],
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$count courses',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}
class Tilt3D extends StatefulWidget {
  final Widget child;
  final double maxTilt; // degrees

  const Tilt3D({
    super.key,
    required this.child,
    this.maxTilt = 12,
  });

  @override
  State<Tilt3D> createState() => _Tilt3DState();
}

class _Tilt3DState extends State<Tilt3D>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Offset _tilt = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails d, Size size) {
    final dx = (d.localPosition.dx / size.width - 0.5) * 2;
    final dy = (d.localPosition.dy / size.height - 0.5) * 2;

    setState(() {
      _tilt = Offset(
        dy.clamp(-1.0, 1.0),
        -dx.clamp(-1.0, 1.0),
      );
    });
  }

  void _resetTilt() {
    _controller.forward(from: 0).then((_) {
      setState(() => _tilt = Offset.zero);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return GestureDetector(
          onPanUpdate: (d) => _onPanUpdate(d, constraints.biggest),
          onPanEnd: (_) => _resetTilt(),
          onPanCancel: _resetTilt,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, child) {
              final t = Curves.easeOut.transform(1 - _controller.value);
              final tiltX = _tilt.dx * widget.maxTilt * t;
              final tiltY = _tilt.dy * widget.maxTilt * t;

              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // perspective
                  ..rotateX(tiltX * pi / 180)
                  ..rotateY(tiltY * pi / 180),
                child: child,
              );
            },
            child: widget.child,
          ),
        );
      },
    );
  }
}

// ===== Image Card =====
class _ImageCard extends StatelessWidget {
  final _Course course;
  const _ImageCard({required this.course});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.5 : 0.2),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(course.file, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.75),
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Text(
                    course.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===== Viewers =====
class PdfViewerPage extends StatelessWidget {
  final String filePath;
  final String title;
  const PdfViewerPage({super.key, required this.filePath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SfPdfViewer.asset(filePath),
    );
  }
}

class ImageViewerPage extends StatelessWidget {
  final String filePath;
  final String title;
  const ImageViewerPage({super.key, required this.filePath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: PhotoView(
        imageProvider: AssetImage(filePath),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
      ),
    );
  }
}
