import 'package:deteksi_cemas/features/auth/presentation/widget/responsive_layout.dart';
import 'package:flutter/material.dart';

class GuestFeedbackScreen extends StatefulWidget {
  const GuestFeedbackScreen({super.key});

  @override
  State<GuestFeedbackScreen> createState() => _GuestFeedbackScreenState();
}

class _GuestFeedbackScreenState extends State<GuestFeedbackScreen> {
  final Map<String, int> _ratings = {
    'UI/UX': -1,
    'Fungsionalitas': -1,
    'Fitur': -1,
    'Kepuasan': -1,
  };

  final TextEditingController _feedbackController = TextEditingController();

  // Menggunakan icon yang lebih modern (Rounded)
  final List<IconData> _emojis = [
    Icons.sentiment_very_dissatisfied_rounded,
    Icons.sentiment_dissatisfied_rounded,
    Icons.sentiment_neutral_rounded,
    Icons.sentiment_satisfied_rounded,
    Icons.sentiment_very_satisfied_rounded,
  ];

  bool get _isFormValid =>
      !_ratings.values.contains(-1) && _feedbackController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF8FAFC,
      ), // Warna background modern (Off-white/Slate)
      appBar: AppBar(
        title: const Text(
          "Feedback Pengguna",
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: responsiveLayout(
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),

                // Card Container untuk Pertanyaan agar terlihat menyatu
                ..._ratings.keys.map(
                  (category) => _buildModernRatingCard(category),
                ),

                const SizedBox(height: 8),
                const Text(
                  "Masukan Tambahan",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 12),
                _buildModernTextField(),

                const SizedBox(height: 40),
                _buildModernSubmitButton(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.rate_review_rounded,
            color: Colors.blue,
            size: 28,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Bantu Kami Berkembang",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Penilaian Anda sangat membantu validasi riset Deteksi Cemas.",
          style: TextStyle(fontSize: 15, color: Color(0xFF64748B), height: 1.5),
        ),
      ],
    );
  }

  Widget _buildModernRatingCard(String category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                category,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF334155),
                ),
              ),
              const Spacer(),
              if (_ratings[category] != -1)
                const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 18,
                ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_emojis.length, (index) {
              bool isSelected = _ratings[category] == index;
              return GestureDetector(
                onTap: () => setState(() => _ratings[category] = index),
                child: AnimatedScale(
                  scale: isSelected ? 1.2 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _getColor(index).withOpacity(0.15)
                              : Colors.grey.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _emojis[index],
                          size: 28,
                          color: isSelected
                              ? _getColor(index)
                              : Colors.grey.shade400,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getLabel(index),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? _getColor(index)
                              : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTextField() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: _feedbackController,
        maxLines: 4,
        onChanged: (_) => setState(() {}),
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: "Ceritakan pengalaman Anda secara detail...",
          hintStyle: TextStyle(color: Colors.grey.shade400),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.blue, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildModernSubmitButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _isFormValid ? _submitFeedback : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          disabledBackgroundColor: Colors.grey.shade300,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: _isFormValid ? 8 : 0,
          shadowColor: Colors.blue.withOpacity(0.4),
        ),
        child: const Text(
          "Kirim Feedback",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Helper Methods tetap sama namun dengan warna yang lebih soft (Pastel-ish)
  Color _getColor(int index) {
    const colors = [
      Color(0xFFF87171), // Red
      Color(0xFFFB923C), // Orange
      Color(0xFFFBBF24), // Amber
      Color(0xFF4ADE80), // Light Green
      Color(0xFF22C55E), // Green
    ];
    return colors[index];
  }

  String _getLabel(int index) {
    const labels = ["Buruk", "Kurang", "Cukup", "Baik", "Sangat Baik"];
    return labels[index];
  }

  void _submitFeedback() {
    // Logic submit tetap sama
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Icon(
          Icons.check_circle_outline_rounded,
          color: Colors.green,
          size: 60,
        ),
        content: const Text(
          "Terima kasih atas partisipasi Anda dalam riset kami!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Tutup",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
