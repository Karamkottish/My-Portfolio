import 'package:flutter/material.dart';

class GlowingAvatar extends StatefulWidget {
  final String imagePath;   // e.g. 'asset/images/profilepic.jpg'
  final double size;        // avatar diameter
  final Duration pulse;     // glow pulse duration

  const GlowingAvatar({
    super.key,
    required this.imagePath,
    this.size = 120,
    this.pulse = const Duration(seconds: 2),
  });

  @override
  State<GlowingAvatar> createState() => _GlowingAvatarState();
}

class _GlowingAvatarState extends State<GlowingAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
  AnimationController(vsync: this, duration: widget.pulse)..repeat(reverse: true);
  late final Animation<double> _glow = Tween(begin: 0.15, end: 0.45)
      .chain(CurveTween(curve: Curves.easeInOut))
      .animate(_c);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _glow,
      builder: (_, __) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(
              colors: [
                cs.primary.withValues(alpha: 0.9),
                cs.secondary.withValues(alpha: 0.9),
                cs.primary.withValues(alpha: 0.9),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: cs.primary.withValues(alpha: _glow.value),
                blurRadius: 28 + 24 * _glow.value,
                spreadRadius: 2 + 2 * _glow.value,
              ),
            ],
          ),
          padding: const EdgeInsets.all(4),
          child: ClipOval(
            child: Image.asset(
              widget.imagePath,
              fit: BoxFit.cover,
              // graceful fallback if asset path is wrong/missing
              errorBuilder: (_, __, ___) => _AvatarFallback(
                initials: _initialsFromName(),
              ),
            ),
          ),
        );
      },
    );
  }

  String _initialsFromName() {
    // Simple fallback initials. Replace with your ProfileData if you like.
    const name = 'Karam Kottish';
    final parts = name.split(' ').where((s) => s.isNotEmpty).toList();
    final first = parts.isNotEmpty ? parts.first[0] : 'K';
    final last = parts.length > 1 ? parts.last[0] : 'K';
    return (first + last).toUpperCase();
  }
}

class _AvatarFallback extends StatelessWidget {
  final String initials;
  const _AvatarFallback({required this.initials});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: cs.surfaceContainerHighest,
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
