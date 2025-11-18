import 'package:flutter/material.dart';

class OnboardingController {
  final PageController pageController = PageController();
  int currentIndex = 0;

  void onPageChanged(int index) {
    currentIndex = index;
  }

  void nextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
