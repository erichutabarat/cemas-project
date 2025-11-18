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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E6AD8), Color(0xFF6AD8E0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
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

            const SizedBox(height: 8),

            OnboardingDots(
              count: onboardingItems.length,
              current: controller.currentIndex,
            ),

            const SizedBox(height: 18),

            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: SizedBox(
                // 1. Mengatur lebar tombol menjadi 70% dari lebar layar
                width: MediaQuery.of(context).size.width * 0.7,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.currentIndex == onboardingItems.length - 1) {
                      // Navigator.pushReplacementNamed(context, "/home");
                    } else {
                      controller.nextPage();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF3B2A5F),
                    elevation: 3,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    controller.currentIndex == onboardingItems.length - 1
                        ? "Get Started"
                        : "Next",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
