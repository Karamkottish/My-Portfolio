import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class SoftSkillsSection extends StatelessWidget {
  const SoftSkillsSection({super.key});

  final List<String> softSkills = const [
    "Problem Solving",
    "Communication",
    "Teamwork",
    "Adaptability",
    "Work Under Pressure",
    "Quick Learner",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text("🤝 ",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(
              "Soft Skills",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(
            softSkills.length,
                (i) => FadeInUp(
              duration: Duration(milliseconds: 300 + (i * 60)),
              child: Chip(
                backgroundColor: Colors.blueGrey.shade700,
                label: Text(
                  softSkills[i],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
