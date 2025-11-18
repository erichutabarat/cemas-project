import 'package:deteksi_cemas/features/onboarding/onboarding_controller.dart';
import 'package:flutter/material.dart';
import '../../data/onboarding_items.dart';
import '../widgets/onboarding_content.dart';
import '../widgets/onboarding_dots.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = OnboardingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller.pageController,
              itemCount: onboardingItems.length,
              onPageChanged: (index) {
                setState(() => controller.onPageChanged(index));
              },
              itemBuilder: (_, index) {
                return OnboardingContent(item: onboardingItems[index]);
              },
            ),
          ),

          const SizedBox(height: 20),

          OnboardingDots(
            count: onboardingItems.length,
            current: controller.currentIndex,
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: ElevatedButton(
              onPressed: () {
                if (controller.currentIndex == onboardingItems.length - 1) {
                  // Navigator.pushReplacementNamed(context, "/home");
                } else {
                  controller.nextPage();
                }
              },
              child: Text(
                controller.currentIndex == onboardingItems.length - 1
                    ? "Get Started"
                    : "Next",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
