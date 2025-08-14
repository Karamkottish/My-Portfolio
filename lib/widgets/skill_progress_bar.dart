import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SkillProgressBar extends StatefulWidget {
  final String skill;
  /// 0.0 to 1.0
  final double level;
  /// Optional: add a small stagger per row (ms)
  final int delayMs;

  const SkillProgressBar({
    super.key,
    required this.skill,
    required this.level,
    this.delayMs = 0,
  });

  @override
  State<SkillProgressBar> createState() => _SkillProgressBarState();
}

class _SkillProgressBarState extends State<SkillProgressBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _anim;
  bool _played = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _anim = Tween<double>(begin: 0, end: widget.level).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _maybePlay() async {
    if (_played) return;
    _played = true;
    if (widget.delayMs > 0) {
      await Future.delayed(Duration(milliseconds: widget.delayMs));
    }
    if (mounted) _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ValueKey('skill-${widget.skill}'),
      onVisibilityChanged: (info) {
        // Trigger once when at least 20% visible
        if (!_played && info.visibleFraction >= 0.2) {
          _maybePlay();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label + percentage
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.skill,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AnimatedBuilder(
                  animation: _anim,
                  builder: (_, __) => Text(
                    '${(_anim.value * 100).round()}%',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AnimatedBuilder(
                animation: _anim,
                builder: (context, _) {
                  return LinearProgressIndicator(
                    value: _anim.value,
                    minHeight: 10,
                    backgroundColor: Colors.white.withOpacity(0.18),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
