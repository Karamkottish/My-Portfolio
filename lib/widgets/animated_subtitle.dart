import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AnimatedSubtitle extends StatelessWidget {
  const AnimatedSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedTextKit(
          repeatForever: true,
          pause: const Duration(milliseconds: 1200),
          animatedTexts: [
            TypewriterAnimatedText(
              "Flutter (Main) / Web Developer (Fresher)",
              textAlign: TextAlign.center,
              textStyle: const TextStyle(
                fontSize: 18,
                color: Colors.tealAccent,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
              speed: Duration(milliseconds: 80),
              cursor: "|", // 🔹 blinking cursor
            ),
            TypewriterAnimatedText(
              "Semi Front–Full Stack • Learning more…",
              textAlign: TextAlign.center,
              textStyle: const TextStyle(
                fontSize: 15,
                color: Colors.white70,
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
              speed: Duration(milliseconds: 80),
              cursor: "|", // 🔹 blinking cursor
            ),
          ],
          displayFullTextOnTap: true,
          stopPauseOnTap: true,
        ),
      ],
    );
  }
}
