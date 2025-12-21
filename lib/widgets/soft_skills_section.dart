import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class SoftSkillsSection extends StatelessWidget {
  const SoftSkillsSection({super.key});

  final List<String> softSkills = const [
    "Leadership & Decision Making",
    "Product & Managerial Thinking",
    "Critical Thinking",
    "Problem Solving",
    "Clear Communication",
    "Cross-functional Collaboration",
    "Adaptability",
    "Working Under Pressure",
    "Fast Learner",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ===== Section Header =====
        Row(
          children: [
            Icon(
              Icons.handshake_outlined,
              color: cs.primary,
              size: 26,
            ),
            const SizedBox(width: 8),
            Text(
              "Soft Skills",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          "People, leadership, and product-focused strengths",
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 18),

        // ===== Skills =====
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(
            softSkills.length,
                (i) => FadeInUp(
              duration: Duration(milliseconds: 280 + (i * 70)),
              child: _SoftSkillChip(
                label: softSkills[i],
                isDark: isDark,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =======================================================
// 2026 Glass-Style Skill Chip
// =======================================================

class _SoftSkillChip extends StatelessWidget {
  const _SoftSkillChip({
    required this.label,
    required this.isDark,
  });

  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                Colors.white.withOpacity(0.08),
                Colors.white.withOpacity(0.04),
              ]
                  : [
                Colors.black.withOpacity(0.04),
                Colors.black.withOpacity(0.02),
              ],
            ),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: cs.outlineVariant.withOpacity(0.35),
            ),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ),
    );
  }
}
