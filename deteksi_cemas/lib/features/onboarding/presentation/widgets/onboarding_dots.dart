import 'package:flutter/material.dart';

class OnboardingDots extends StatelessWidget {
  final int count;
  final int current;

  const OnboardingDots({super.key, required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),

          width: isActive ? 24 : 8,
          height: 8,

          decoration: BoxDecoration(
            color: isActive
                ? Colors.white
                : Colors.white.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }),
    );
  }
}
