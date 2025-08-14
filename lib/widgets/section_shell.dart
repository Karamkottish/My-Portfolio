import 'package:flutter/material.dart';

class SectionShell extends StatelessWidget {
  final String id;
  final String title;
  final Widget child;

  const SectionShell({
    super.key,
    required this.id,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      key: ValueKey(id),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: t.displaySmall),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}
