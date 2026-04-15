import 'package:deteksi_cemas/features/dashboard/presentation/widgets/responsive_layout.dart';
import 'package:deteksi_cemas/features/survey/data/models/feedback_models.dart';
import 'package:deteksi_cemas/features/survey/data/models/guest_models.dart';
import 'package:deteksi_cemas/features/survey/data/repository/feedback_repository.dart';
import 'package:deteksi_cemas/theme/color_list.dart'; // Imported for AquaCyan
import 'package:flutter/material.dart';

class GuestFeedbackScreen extends StatefulWidget {
  final Guest guest;
  const GuestFeedbackScreen({super.key, required this.guest});

  @override
  State<GuestFeedbackScreen> createState() => _GuestFeedbackScreenState();
}

class _GuestFeedbackScreenState extends State<GuestFeedbackScreen> {
  final FeedbackRepository _repository = FeedbackRepository();
  final Map<int, dynamic> _answers = {};
  late Future<List<FeedbackQuestion>> _questionsFuture;

  final List<IconData> _emojis = [
    Icons.sentiment_very_dissatisfied_rounded,
    Icons.sentiment_dissatisfied_rounded,
    Icons.sentiment_neutral_rounded,
    Icons.sentiment_satisfied_rounded,
    Icons.sentiment_very_satisfied_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _questionsFuture = _repository.fetchFeedbackQuestions();
  }

  bool _isFormValid(List<FeedbackQuestion> questions) {
    return questions.every((q) {
      final answer = _answers[q.id];
      if (q.type == QuestionType.scale) return answer != null && answer != -1;
      if (q.type == QuestionType.text) {
        return answer != null && answer.toString().trim().isNotEmpty;
      }
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorList.aquaCyan,
      body: FutureBuilder<List<FeedbackQuestion>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada pertanyaan tersedia."));
          }

          final questions = snapshot.data!;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: responsiveLayout(
              content: Column(
                children: [
                  // --- SYNCED HEADER FROM SURVEY SCREEN ---
                  Container(
                    padding: const EdgeInsets.only(
                      top: 50,
                      bottom: 20,
                      left: 16,
                      right: 16,
                    ),
                    decoration: BoxDecoration(
                      color: ColorList.aquaCyan,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            "Feedback Pengguna",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48), // Balancing the back button
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderInfo(),
                        const SizedBox(height: 32),

                        ...questions.map((question) {
                          if (question.type == QuestionType.scale) {
                            return _buildModernRatingCard(question);
                          } else {
                            return _buildModernTextField(question);
                          }
                        }),

                        const SizedBox(height: 24),
                        _buildModernSubmitButton(questions),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.rate_review_rounded,
              color: ColorList.aquaCyan,
              size: 28,
            ),
            const SizedBox(width: 12),
            const Text(
              "Bantu Kami Berkembang",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          "Penilaian Anda sangat membantu validasi riset Deteksi Cemas.",
          style: TextStyle(fontSize: 15, color: Color(0xFF64748B), height: 1.5),
        ),
      ],
    );
  }

  Widget _buildModernRatingCard(FeedbackQuestion question) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.text,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_emojis.length, (index) {
                bool isSelected = _answers[question.id] == index;
                return GestureDetector(
                  onTap: () => setState(() => _answers[question.id] = index),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _getColor(index).withOpacity(0.15)
                              : Colors.grey.shade100,
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
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? _getColor(index)
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernTextField(FeedbackQuestion question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            question.text,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            maxLines: 4,
            onChanged: (val) => setState(() => _answers[question.id] = val),
            decoration: InputDecoration(
              hintText: "Ceritakan pengalaman Anda...",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: ColorList.aquaCyan, width: 1.5),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildModernSubmitButton(List<FeedbackQuestion> questions) {
    final bool valid = _isFormValid(questions);
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: FilledButton.icon(
        onPressed: valid ? () => _submitFeedback(questions) : null,
        style: FilledButton.styleFrom(
          backgroundColor: ColorList.aquaCyan,
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: const Icon(Icons.send_rounded),
        label: const Text(
          "Kirim Feedback",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Color _getColor(int index) {
    const colors = [
      Color(0xFFF87171), // Red
      Color(0xFFFB923C), // Orange
      Color(0xFFFBBF24), // Yellow
      Color(0xFF4ADE80), // Light Green
      Color(0xFF22C55E), // Green
    ];
    return colors[index];
  }

  String _getLabel(int index) {
    const labels = ["Buruk", "Kurang", "Cukup", "Baik", "Sangat Baik"];
    return labels[index];
  }

  // Inside _GuestFeedbackScreenState
  void _submitFeedback(List<FeedbackQuestion> questions) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Transform the _answers map into the format:
      // { "feedback_question_id": id, "response": "value" }
      final List<Map<String, dynamic>> feedbackData = _answers.entries.map((
        entry,
      ) {
        return {
          "feedback_question_id": entry.key,
          // .toString() ensures that even rating indices (int) are sent as Strings
          // to match your JSON example: "response": "1"
          "response": entry.value.toString(),
        };
      }).toList();

      await _repository.submitFeedback(
        guest: widget.guest,
        feedbacks: feedbackData,
      );

      if (!mounted) return;
      Navigator.pop(context); // Pop loading

      // Show Success Dialog
      _showSuccessDialog();
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Pop loading
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal mengirim feedback: $e")));
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Icon(
          Icons.check_circle_rounded,
          color: ColorList.aquaCyan,
          size: 60,
        ),
        content: const Text(
          "Terima kasih atas partisipasi Anda!",
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                //back to survey
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to survey screen
                Navigator.pop(
                  context,
                ); // Go back to dashboard or wherever you want
              },
              child: Text(
                "Selesai",
                style: TextStyle(
                  color: ColorList.aquaCyan,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
