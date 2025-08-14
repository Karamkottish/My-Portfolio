import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  final List<Map<String, dynamic>> skills = const [
    {"name": "Flutter", "level": 0.9},
    {"name": "Dart", "level": 0.85},
    {"name": "UI/UX Design", "level": 0.8},
    {"name": "Firebase", "level": 0.75},
    {"name": "REST APIs", "level": 0.8},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Skills",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ...skills.map((skill) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: FadeInUp(
              duration: const Duration(milliseconds: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Skill label and percentage
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        skill["name"],
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        "${(skill["level"] * 100).toInt()}%",
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Custom gradient progress bar
                  Stack(
                    children: [
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Container(
                        height: 8,
                        width: MediaQuery.of(context).size.width * skill["level"],
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.teal, Colors.lightBlueAccent],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
