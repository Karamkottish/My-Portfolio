import 'package:flutter/material.dart';

class TimelineItem extends StatelessWidget {
  final String title, subtitle, date, place;
  final List<String> bullets;

  const TimelineItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.place,
    required this.date,
    this.bullets = const [],
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 8, right: 12),
          decoration: BoxDecoration(
            color: cs.primary,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: t.titleLarge),
              Text('$subtitle • $place',
                  style:
                  t.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
              Text(date,
                  style:
                  t.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
              if (bullets.isNotEmpty) ...[
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: bullets
                      .map(
                        (b) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• '),
                          Expanded(child: Text(b))
                        ],
                      ),
                    ),
                  )
                      .toList(),
                )
              ]
            ],
          ),
        )
      ],
    );
  }
}
