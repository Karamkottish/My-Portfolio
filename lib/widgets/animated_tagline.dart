import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../data/profile_data.dart';

class AnimatedTagline extends StatelessWidget {
  const AnimatedTagline({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      child: AnimatedTextKit(
        repeatForever: true,
        pause: const Duration(milliseconds: 1200),
        animatedTexts: ProfileData.taglines
            .map(
              (tagline) => TyperAnimatedText(
            tagline,
            speed: const Duration(milliseconds: 45),
          ),
        )
            .toList(),
      ),
    );
  }
}
