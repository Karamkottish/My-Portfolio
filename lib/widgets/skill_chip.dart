import 'package:flutter/material.dart';

class SkillChip extends StatelessWidget {
  final String skill;
  const SkillChip({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        skill,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.blue.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.blue.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
