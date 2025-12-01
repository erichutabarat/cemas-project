class OnboardingItem {
  final String title;
  final String description;
  final String image;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.image,
  });
}

final onboardingItems = [
  OnboardingItem(
    title: "Deteksi Cemas",
    description:
        "Welcome to the Deteksi Cemas, where you can detect your anxiety levels early.",
    image: "assets/images/onboarding_welcome.png",
  ),
  OnboardingItem(
    title: "Check Heartbeat",
    description:
        "With IoT devices and machine learning, you can check your heartbeat with high accuracy to detect anxiety levels.",
    image: "assets/images/onboarding_heartbeat.png",
  ),
  OnboardingItem(
    title: "User Condition Survey",
    description:
        "With this survey, we can better understand your condition to provide accurate recommendations.",
    image: "assets/images/onboarding_survey.png",
  ),
  OnboardingItem(
    title: "View User History",
    description:
        "With the history feature, you can monitor anxiety levels regularly for therapy.",
    image: "assets/images/onboarding_history.png",
  ),
  OnboardingItem(
    title: "Explore More Features",
    description:
        "Discover various additional features that can help you manage anxiety.",
    image: "assets/images/onboarding_explore.png",
  ),
];
