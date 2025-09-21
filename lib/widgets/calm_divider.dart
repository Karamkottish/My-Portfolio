import 'package:flutter/material.dart';

/// Static (non-animated) gradient divider to keep page buttery smooth.
class CalmDivider extends StatelessWidget {
  const CalmDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 18 : 28),
      child: Container(
        height: 4,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            colors: [
              Color(0xFFFF6AC1),
              Color(0xFFFFD166),
              Color(0xFF06D6A0),
              Color(0xFF00E5FF),
              Color(0xFF8B5CF6),
            ],
          ),
        ),
      ),
    );
  }
}
