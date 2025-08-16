import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class LanguagesSection extends StatelessWidget {
  const LanguagesSection({super.key});

  final List<_Language> languages = const [
    _Language(name: "English", level: "Fluent", flag: "🇬🇧"),
    _Language(name: "Arabic", level: "Native", flag: "🇸🇦"),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text("🌍 ",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(
              "Languages",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: List.generate(
            languages.length,
                (i) {
              final lang = languages[i];
              return FadeInLeft(
                duration: Duration(milliseconds: 350 + (i * 60)),
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade700.withOpacity(.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(lang.flag, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Text(
                        "${lang.name} — ${lang.level}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Language {
  final String name, level, flag;
  const _Language({required this.name, required this.level, required this.flag});
}
