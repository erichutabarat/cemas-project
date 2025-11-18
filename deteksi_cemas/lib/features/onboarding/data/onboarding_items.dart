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
        "Selamat datang di aplikasi Deteksi Cemas, dimana anda dapat mendeteksi tingkat kecemasan sedari dini.",
    image: "assets/images/onboarding_welcome.png",
  ),
  OnboardingItem(
    title: "Periksa Detak Jantung",
    description:
        "Dengan device IoT dan machine learning, anda dapat memeriksa detak jantung dengan akurasi yang tinggi untuk mendeteksi tingkat kecemasan.",
    image: "assets/images/onboarding_heartbeat.png",
  ),
  OnboardingItem(
    title: "Survey Kondisi Pengguna",
    description:
        "Dengan survey ini, kami dapat memahami kondisi anda dengan lebih baik untuk memberikan rekomendasi yang tepat.",
    image: "assets/images/onboarding_survey.png",
  ),
  OnboardingItem(
    title: "Lihat Riwayat Pengguna",
    description:
        "Dengan fitur riwayat, anda dapat mengawasi tingkat kecemasan secara berkala untuk melakukan terapi.",
    image: "assets/images/onboarding_history.png",
  ),
  OnboardingItem(
    title: "Jelajahi Fitur Lainnya",
    description:
        "Temukan berbagai fitur tambahan yang dapat membantu anda dalam mengelola kecemasan.",
    image: "assets/images/onboarding_explore.png",
  ),
];
