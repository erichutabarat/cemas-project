// ignore_for_file: use_build_context_synchronously

import 'package:deteksi_cemas/features/onboarding/onboarding_controller.dart';
import 'package:deteksi_cemas/features/onboarding/services/onboarding_services.dart';
import 'package:deteksi_cemas/l10n/app_localizations.dart';
import 'package:deteksi_cemas/features/onboarding/data/onboarding_items.dart'; // Keep the class definition
import 'package:deteksi_cemas/theme/app_theme.dart';
import 'package:deteksi_cemas/theme/color_list.dart';
import 'package:flutter/material.dart';
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
    // 1. Initialize Localization
    final l10n = AppLocalizations.of(context)!;

    // 2. Build the list dynamically inside build()
    // This ensures it refreshes when the language changes
    final List<OnboardingItem> translatedItems = [
      OnboardingItem(
        title: l10n.onboardingTitle1,
        description: l10n.onboardingDesc1,
        image: "assets/images/onboarding_welcome.png",
      ),
      OnboardingItem(
        title: l10n.onboardingTitle2,
        description: l10n.onboardingDesc2,
        image: "assets/images/onboarding_heartbeat.png",
      ),
      OnboardingItem(
        title: l10n.onboardingTitle3,
        description: l10n.onboardingDesc3,
        image: "assets/images/onboarding_survey.png",
      ),
      OnboardingItem(
        title: l10n.onboardingTitle4,
        description: l10n.onboardingDesc4,
        image: "assets/images/onboarding_history.png",
      ),
      OnboardingItem(
        title: l10n.onboardingTitle5,
        description: l10n.onboardingDesc5,
        image: "assets/images/onboarding_explore.png",
      ),
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.softChillReversed),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: translatedItems.length,
                onPageChanged: (index) {
                  setState(() => controller.onPageChanged(index));
                },
                itemBuilder: (_, index) {
                  return OnboardingContent(item: translatedItems[index]);
                },
              ),
            ),

            const SizedBox(height: 8),

            OnboardingDots(
              count: translatedItems.length,
              current: controller.currentIndex,
            ),

            const SizedBox(height: 18),

            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: ElevatedButton(
                  onPressed: () async {
                    if (controller.currentIndex == translatedItems.length - 1) {
                      await OnboardingService.setCompleted();
                      Navigator.pushReplacementNamed(context, "/login");
                    } else {
                      controller.nextPage();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorList.aquaCyan,
                    foregroundColor: Colors.white,
                    elevation: 3,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    // 3. Translated Button Text
                    controller.currentIndex == translatedItems.length - 1
                        ? l10n.getStarted
                        : l10n.next,
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
