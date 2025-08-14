import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../data/profile_data.dart';
import 'section_title.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle("Experience"),
        const SizedBox(height: 10),
        ...ProfileData.experiences.asMap().entries.map((entry) {
          final index = entry.key;
          final exp = entry.value;

          // Alternate animation direction for variety
          final animation = index.isEven
              ? SlideInLeft(
            duration: const Duration(milliseconds: 700),
            delay: Duration(milliseconds: index * 200),
            child: _buildCard(exp),
          )
              : SlideInRight(
            duration: const Duration(milliseconds: 700),
            delay: Duration(milliseconds: index * 200),
            child: _buildCard(exp),
          );

          return animation;
        }),
      ],
    );
  }

  Widget _buildCard(exp) {
    return Card(
      color: Colors.white10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(exp.title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            Text("${exp.org} • ${exp.location}",
                style: const TextStyle(color: Colors.white70)),
            Text("${exp.start} - ${exp.end}",
                style: const TextStyle(color: Colors.white60)),
            const SizedBox(height: 8),
            ...exp.bullets.map(
                  (b) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("• ", style: TextStyle(color: Colors.white70)),
                  Expanded(
                    child: Text(b,
                        style: const TextStyle(color: Colors.white70)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
