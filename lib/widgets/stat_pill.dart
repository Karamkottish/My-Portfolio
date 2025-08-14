import 'package:flutter/material.dart';

class StatPill extends StatelessWidget {
  final IconData icon;
  final String label, value;

  const StatPill({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(right: 12, bottom: 12),
      decoration: BoxDecoration(
        color: cs.secondaryContainer.withOpacity(0.7),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: cs.onSecondaryContainer),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              color: cs.onSecondaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: TextStyle(color: cs.onSecondaryContainer),
          ),
        ],
      ),
    );
  }
}
