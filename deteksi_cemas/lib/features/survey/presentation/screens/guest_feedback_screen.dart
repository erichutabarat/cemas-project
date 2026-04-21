import 'package:deteksi_cemas/features/dashboard/presentation/widgets/responsive_layout.dart';
import 'package:deteksi_cemas/features/survey/data/models/feedback_models.dart';
import 'package:deteksi_cemas/features/survey/data/models/guest_models.dart';
import 'package:deteksi_cemas/features/survey/data/repository/feedback_repository.dart';
import 'package:deteksi_cemas/theme/color_list.dart';
import 'package:flutter/foundation.dart';
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
  final ScrollController _scrollController = ScrollController();

  int _currentStep = 0; // 0: UEQ, 1: SUS & General

  @override
  void initState() {
    super.initState();
    _questionsFuture = _repository.fetchFeedbackQuestions();
  }

  List<FeedbackQuestion> _getVisibleQuestions(List<FeedbackQuestion> all) {
    if (_currentStep == 0) {
      return all.where((q) => q.category == 'ueq').toList();
    } else {
      return all
          .where((q) => q.category == 'sus' || q.category == 'general')
          .toList();
    }
  }

  bool _isStepValid(List<FeedbackQuestion> visibleQuestions) {
    return visibleQuestions.every((q) {
      if (!_answers.containsKey(q.id)) return false;
      final answer = _answers[q.id];
      if (q.type == QuestionType.scale) return answer is int;
      if (q.type == QuestionType.text) {
        return answer.toString().trim().isNotEmpty;
      }
      return true;
    });
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorList.aquaCyan,
      body: FutureBuilder<List<FeedbackQuestion>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
          final allQuestions = snapshot.data ?? [];
          final visibleQuestions = _getVisibleQuestions(allQuestions);

          return SingleChildScrollView(
            controller: _scrollController,
            child: responsiveLayout(
              content: Column(
                children: [
                  _buildHeader(context),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildStepIndicator(),
                        const SizedBox(height: 24),
                        ...visibleQuestions.map(
                          (q) => q.type == QuestionType.scale
                              ? _buildScaleCard(q)
                              : _buildTextField(q),
                        ),
                        const SizedBox(height: 24),
                        _buildNavButtons(visibleQuestions, allQuestions),
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

  Widget _buildStepIndicator() {
    return Column(
      children: [
        Text(
          _currentStep == 0
              ? "User Experience Questionnaire (UEQ)"
              : "System Usability Scale (SUS)",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: (_currentStep + 1) / 2,
          backgroundColor: Colors.white24,
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ],
    );
  }

  Widget _buildScaleCard(FeedbackQuestion question) {
    bool isUEQ = question.category == 'ueq';
    int maxScale = isUEQ ? 7 : 5;

    List<String> ueqLabels = question.text.contains(" — ")
        ? question.text.split(" — ")
        : [question.text, ""];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isUEQ) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      ueqLabels[0],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      ueqLabels[1],
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ] else
              Text(
                question.text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(maxScale, (index) {
                int val = index + 1;
                bool isSelected = _answers[question.id] == val;
                return GestureDetector(
                  onTap: () => setState(() => _answers[question.id] = val),
                  child: Column(
                    children: [
                      Container(
                        width: isUEQ ? 35 : 45,
                        height: isUEQ ? 35 : 45,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ColorList.aquaCyan
                              : Colors.grey.shade100,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? ColorList.aquaCyan
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "$val",
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      if (!isUEQ) ...[
                        const SizedBox(height: 4),
                        Text(
                          _getSusLabel(val),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
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

  String _getSusLabel(int val) {
    if (val == 1) return "Sangat Tidak Setuju";
    if (val == 5) return "Sangat Setuju";
    return "";
  }

  Widget _buildTextField(FeedbackQuestion question) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              maxLines: 3,
              onChanged: (v) => setState(() => _answers[question.id] = v),
              decoration: const InputDecoration(
                hintText: "Masukkan saran...",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40, bottom: 10),
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => _currentStep > 0
                ? setState(() => _currentStep = 0)
                : Navigator.pop(context),
          ),
          const Text(
            "Feedback Pengguna",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButtons(
    List<FeedbackQuestion> currentSet,
    List<FeedbackQuestion> all,
  ) {
    bool canProceed = _isStepValid(currentSet);
    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: TextButton(
              onPressed: () => setState(() => _currentStep = 0),
              child: const Text(
                "Kembali",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: canProceed
                ? () => _currentStep == 0
                      ? setState(() {
                          _currentStep = 1;
                          _scrollToTop();
                        })
                      : _submitFeedback(all)
                : null,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _currentStep == 0 ? "Selanjutnya" : "Kirim Feedback",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _submitFeedback(List<FeedbackQuestion> allQuestions) async {
    // 1. Tampilkan Loading Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          const Center(child: CircularProgressIndicator(color: Colors.white)),
    );

    try {
      // 2. Transformasi _answers (Map<int, dynamic>) ke List<Map<String, dynamic>>
      // Sesuai format: { "feedback_question_id": id, "response": "value" }
      final List<Map<String, dynamic>> feedbackData = _answers.entries.map((
        entry,
      ) {
        return {
          "feedback_question_id": entry.key,
          "response": entry.value
              .toString(), // Pastikan dikirim sebagai String sesuai JSON target
        };
      }).toList();

      // 3. Siapkan Data Guest (Gunakan data dari widget.guest atau fallback default)
      final guestData = widget.guest;

      // debug data
      if (kDebugMode) {
        print("Guest Data:");
        print("Name: ${guestData.name}");
        print("Email: ${guestData.email}");
        print("Gender: ${guestData.gender}");
        print("Age: ${guestData.age}");
        print("Prodi: ${guestData.prodi}");
        print("NIM: ${guestData.nim}");
        print("Phone Number: ${guestData.phoneNumber}");
        print("Feedback Data:");
      }

      // 4. Panggil Repository
      await _repository.submitFeedback(
        guest: guestData,
        feedbacks: feedbackData,
      );

      if (!mounted) return;
      Navigator.pop(context); // Tutup loading dialog

      // 5. Tampilkan Dialog Sukses
      _showSuccessDialog();
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Tutup loading dialog

      // Tampilkan Error Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal mengirim feedback: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text("Berhasil"),
        content: const Text("Terima kasih atas feedback Anda!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/survey', (r) => false),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
