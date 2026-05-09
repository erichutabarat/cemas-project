import 'package:deteksi_cemas/features/dashboard_admin/data/models/hars_models.dart';
import 'package:deteksi_cemas/features/dashboard_admin/data/models/hars_reponse_models.dart';
import 'package:deteksi_cemas/features/dashboard_admin/domain/repository/hars_repository.dart';
import 'package:deteksi_cemas/features/dashboard_admin/presentation/widget/hars_stat_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class QuestionAdminScreen extends StatefulWidget {
  const QuestionAdminScreen({super.key});

  @override
  State<QuestionAdminScreen> createState() => _QuestionAdminScreenState();
}

class _QuestionAdminScreenState extends State<QuestionAdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<HarsQuestions> _questions = [];
  List<HarsResponse> _responses = [];

  bool _loadingQuestions = false;
  bool _loadingResponses = false;

  String _selectedFilter = "Semua";
  final List<String> _filters = [
    "Semua",
    "Ringan",
    "Sedang",
    "Berat",
    "Sangat Berat",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchQuestions();
    _fetchResponses();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ─── Fetch ───────────────────────────────────────────────────────────────────

  Future<void> _fetchQuestions() async {
    setState(() => _loadingQuestions = true);
    try {
      final questions = await HarsRepository().fetchHarsQuestions();
      if (!mounted) return;
      setState(() {
        _questions = questions;
        _loadingQuestions = false;
      });
      if (kDebugMode) print("Fetched ${_questions.length} questions");
    } catch (error, stackTrace) {
      if (!mounted) return;
      setState(() => _loadingQuestions = false);
      if (kDebugMode) print("ERROR fetching questions: $error\n$stackTrace");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat pertanyaan: $error")),
      );
    }
  }

  Future<void> _fetchResponses() async {
    setState(() => _loadingResponses = true);
    try {
      final responses = await HarsRepository().fetchHarsResponses();
      if (!mounted) return;
      setState(() {
        _responses = responses;
        _loadingResponses = false;
      });
      if (kDebugMode) print("Fetched ${_responses.length} responses");
    } catch (error, stackTrace) {
      if (!mounted) return;
      setState(() => _loadingResponses = false);
      if (kDebugMode) print("ERROR fetching responses: $error\n$stackTrace");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal memuat respons: $error")));
    }
  }

  // ─── Severity helpers ─────────────────────────────────────────────────────────

  Color _severityColor(String severity) {
    switch (severity) {
      case "Normal":
        return Colors.green;
      case "Mild Anxiety":
        return Colors.yellow;
      case "Moderate Anxiety":
        return Colors.orange;
      case "Severe Anxiety":
        return Colors.red.shade700;
      case "Very Severe Anxiety":
        return Colors.red.shade900;
      default:
        return Colors.grey;
    }
  }

  Color _severityBg(String severity) =>
      _severityColor(severity).withOpacity(0.1);

  // ─── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Kelola Pertanyaan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        actions: [
          ListenableBuilder(
            listenable: _tabController,
            builder: (_, __) => _tabController.index == 0
                ? IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: _showAddQuestionSheet,
                  )
                : const SizedBox.shrink(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue.shade300,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: "Pertanyaan"),
            Tab(text: "Respons User"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildQuestionsPage(), _buildResponsesPage()],
      ),
    );
  }

  // ── PAGE 1: Questions ──────────────────────────────────────────────────────────

  Widget _buildQuestionsPage() {
    if (_loadingQuestions) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: Colors.white,
          child: Row(
            children: [
              _buildChip("Total: ${_questions.length} Kategori", Colors.blue),
              const SizedBox(width: 8),
              _buildChip("Skala HARS", Colors.orange),
            ],
          ),
        ),
        Expanded(
          child: _questions.isEmpty
              ? const Center(
                  child: Text(
                    "Tidak ada pertanyaan",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _questions.length,
                  itemBuilder: (context, index) =>
                      _buildQuestionCard(_questions[index]),
                ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(HarsQuestions q) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF1E3A8A).withOpacity(0.1),
          child: Text(
            "${q.id}",
            style: const TextStyle(
              color: Color(0xFF1E3A8A),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          q.questionId, // ← typed field
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text("${q.category} • ${q.symptomType}"), // ← typed fields
        children: [
          const Divider(height: 1),
          ...q.options.map(
            // ← List<HarsOptions>, no cast
            (opt) => ListTile(
              dense: true,
              leading: const Icon(
                Icons.check_circle_outline,
                size: 18,
                color: Colors.green,
              ),
              title: Text(opt.optionId), // ← typed field
              trailing: Text(
                "Score: ${opt.score}", // ← typed field
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _showEditQuestionSheet(q),
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text("Edit"),
                ),
                TextButton.icon(
                  onPressed: () => _confirmDelete(q),
                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                  label: const Text(
                    "Hapus",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── PAGE 2: Responses ──────────────────────────────────────────────────────────

  Widget _buildResponsesPage() {
    if (_loadingResponses) {
      return const Center(child: CircularProgressIndicator());
    }

    final filtered = _selectedFilter == "Semua"
        ? _responses
        : _responses.where((r) => r.level == _selectedFilter).toList();

    return CustomScrollView(
      slivers: [
        // ── Filter chips ──────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _filters.map((f) {
                  final isSelected = _selectedFilter == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedFilter = f),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF1E3A8A)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF1E3A8A)
                                : Colors.grey.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          f,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),

        // ── Count chip ────────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFFF8FAFC),
            child: Row(
              children: [
                _buildChip(
                  "Menampilkan ${filtered.length} respons",
                  Colors.blueGrey,
                ),
              ],
            ),
          ),
        ),

        // ── Empty state ───────────────────────────────────────────────────────
        if (filtered.isEmpty)
          const SliverFillRemaining(
            child: Center(
              child: Text(
                "Tidak ada respons",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else ...[
          // ── Charts ─────────────────────────────────────────────────────────
          SliverToBoxAdapter(child: HarsStatsChart(responses: _responses)),

          // ── Response cards ──────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            sliver: SliverList.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) =>
                  _buildResponseCard(filtered[index]),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildResponseCard(HarsResponse resp) {
    final severity = resp.level; // ← typed field
    final score = resp.score; // ← typed field
    const maxScore = 56;
    final progress = (score / maxScore).clamp(0.0, 1.0);

    // Format DateTime to readable string
    final submittedAt =
        "${resp.createdAt.day.toString().padLeft(2, '0')} "
        "${_monthName(resp.createdAt.month)} "
        "${resp.createdAt.year} • "
        "${resp.createdAt.hour.toString().padLeft(2, '0')}:"
        "${resp.createdAt.minute.toString().padLeft(2, '0')}";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                resp.guest.name, // ← typed field
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _severityBg(severity),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  severity,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _severityColor(severity),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            submittedAt, // ← formatted from createdAt
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              color: _severityColor(severity),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total skor: $score / $maxScore",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "${resp.guest.name.split(' ').first} • ${resp.guest.gender}", // ← guest info
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _showResponseDetail(resp),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.visibility_outlined,
                  size: 16,
                  color: Color(0xFF1E3A8A),
                ),
                SizedBox(width: 4),
                Text(
                  "Lihat detail",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF1E3A8A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Dialogs / Sheets ───────────────────────────────────────────────────────────

  void _showAddQuestionSheet() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Tambah pertanyaan — coming soon")),
    );
  }

  void _showEditQuestionSheet(HarsQuestions q) {
    // ← typed param
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Edit: ${q.questionId}")), // ← typed field
    );
  }

  void _confirmDelete(HarsQuestions q) {
    // ← typed param
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus pertanyaan?"),
        content: Text(
          "\"${q.questionId}\" akan dihapus secara permanen.",
        ), // ← typed field
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              // TODO: call delete API then _fetchQuestions()
              Navigator.pop(context);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showResponseDetail(HarsResponse resp) {
    // ← typed param
    final submittedAt =
        "${resp.createdAt.day.toString().padLeft(2, '0')} "
        "${_monthName(resp.createdAt.month)} "
        "${resp.createdAt.year}";

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resp.guest.name, // ← typed field
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(
              "Submitted: $submittedAt",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            _detailRow("Email", resp.guest.email), // ← typed field
            _detailRow("Gender", resp.guest.gender),
            _detailRow("Usia", "${resp.guest.age} tahun"),
            const SizedBox(height: 12),
            _detailRow("Total skor", "${resp.score} / 56"),
            _detailRow("Tingkat kecemasan", resp.level),
            const SizedBox(height: 16),
            const Text(
              "Jawaban per pertanyaan akan tampil di sini "
              "setelah koneksi database tersedia.",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────────

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return months[month];
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
