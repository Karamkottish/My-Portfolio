import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CoursesSection extends StatefulWidget {
  const CoursesSection({super.key});

  @override
  State<CoursesSection> createState() => _CoursesSectionState();
}

class _CoursesSectionState extends State<CoursesSection> {
  late final PageController _controller;
  int _index = 0;
  Timer? _timer;

  final List<Map<String, String>> courses = [
    {"title": "Flutter Advanced", "file": "lib/assets/courses/flutterad.jpg"},
    {"title": "Manara Fellowship", "file": "lib/assets/courses/manara.png"},
    {"title": "Git Training", "file": "lib/assets/courses/git.png"},
    {"title": "Ethical Hacking", "file": "lib/assets/courses/hacking.png"},
    {"title": "Intro to Cryptography", "file": "lib/assets/courses/img.png"},
    {"title": "Computational Thinking", "file": "lib/assets/courses/computiional.png"},
    {"title": "Google Cloud AI", "file": "lib/assets/courses/googlecould.png"},
    {"title": "Google Cloud Operations", "file": "lib/assets/courses/googleoperations.png"},
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.85);

    if (courses.isNotEmpty) {
      _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
        if (_controller.hasClients) {
          int next = (_index + 1) % courses.length;
          _controller.animateToPage(
            next,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return const Center(child: Text("No courses available"));
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dotColor = isDark ? Colors.white70 : Colors.black54;

    final width = MediaQuery.of(context).size.width;
    final height = width < 600 ? 220.0 : min(360.0, width * 0.35);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Courses',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 16),

        SizedBox(
          height: height,
          child: PageView.builder(
            controller: _controller,
            itemCount: courses.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) {
              final course = courses[i];
              return GestureDetector(
                onTap: () {
                  _openCourse(context, course["file"]!, course["title"]!);
                },
                child: _ImageCard(
                  filePath: course["file"]!,
                  title: course["title"]!,
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        Center(
          child: Wrap(
            spacing: 6,
            children: List.generate(
              courses.length,
                  (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 8,
                width: i == _index ? 22 : 8,
                decoration: BoxDecoration(
                  color: i == _index
                      ? Colors.tealAccent
                      : dotColor.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _openCourse(BuildContext context, String file, String title) {
    if (file.toLowerCase().endsWith(".pdf")) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PdfViewerPage(filePath: file, title: title),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ImageViewerPage(filePath: file, title: title),
        ),
      );
    }
  }
}

class _ImageCard extends StatelessWidget {
  final String filePath;
  final String title;
  const _ImageCard({required this.filePath, required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? Colors.white24 : Colors.black12;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              filePath,
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
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.65), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Positioned(
            left: 12,
            bottom: 12,
            right: 12,
            child: Text(
              title,
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    blurRadius: 6,
                    color: Colors.black54,
                    offset: Offset(1, 1),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 📌 PDF Viewer Page
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

/// 📌 Image Fullscreen Viewer
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
