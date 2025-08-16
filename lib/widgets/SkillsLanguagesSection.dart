import 'package:flutter/material.dart';

class SkillsAndLanguages extends StatelessWidget {
  const SkillsAndLanguages({super.key});

  @override
  Widget build(BuildContext context) {
    final skills = [
      "Work Under Pressure",
      "Problem Solving",
      "Good Communication Skills",
      "Team Work",
      "Ability to Adapt",
      "Quick Learner",
    ];

    final languages = {
      "English": 4, // out of 5
      "Arabic": 5,
      "German": 2,
    };

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Skills ----
            Text(
              "Soft Skills",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(thickness: 1.5),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: skills
                  .map((skill) => Chip(
                label: Text(skill),
                backgroundColor: Colors.blue.shade50,
                labelStyle: const TextStyle(color: Colors.black87),
              ))
                  .toList(),
            ),
            const SizedBox(height: 24),

            // ---- Languages ----
            Text(
              "Languages",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(thickness: 1.5),
            Column(
              children: languages.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < entry.value
                                ? Icons.circle
                                : Icons.circle_outlined,
                            size: 16,
                            color: index < entry.value
                                ? Colors.blueAccent
                                : Colors.grey,
                          );
                        }),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
