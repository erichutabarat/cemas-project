// ignore_for_file: use_build_context_synchronously

import 'package:deteksi_cemas/features/dashboard/data/models/journal_model.dart';
import 'package:deteksi_cemas/features/dashboard/domain/repository/journaling_repository.dart';
import 'package:deteksi_cemas/features/dashboard/presentation/widgets/responsive_layout.dart';
import 'package:deteksi_cemas/features/survey/data/models/assessment_results_models.dart';
import 'package:deteksi_cemas/features/survey/presentation/screens/hars_result_screen.dart';
import 'package:deteksi_cemas/features/survey/presentation/widgets/get_icon_level.dart';
import 'package:deteksi_cemas/theme/color_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JournalScreen extends StatefulWidget {
  final ScrollController? controller;
  const JournalScreen({super.key, this.controller});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final JournalingRepository journalingRepository = JournalingRepository();
  late Future<List<dynamic>> journalFuture;

  // --- Journal entry state ---
  final TextEditingController _journalController = TextEditingController();

  // Holds which mood is currently selected. Null = none selected yet.
  String? _selectedMoodLabel;

  // Single source of truth for the moods so the selectable row and the
  // confirmation dialog stay in sync.
  final List<Map<String, String>> _moods = const [
    {'emoji': '😊', 'label': 'Happy'},
    {'emoji': '😌', 'label': 'Calm'},
    {'emoji': '😐', 'label': 'Neutral'},
    {'emoji': '😢', 'label': 'Sad'},
  ];

  @override
  void initState() {
    super.initState();
    journalFuture = journalingRepository.fetchJournalHistory();
  }

  @override
  void dispose() {
    _journalController.dispose();
    super.dispose();
  }

  // --- REFRESH LOGIC ---
  Future<void> _refreshHistory() async {
    setState(() {
      journalFuture = journalingRepository.fetchJournalHistory();
    });
    await journalFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshHistory,
        color: ColorList.aquaCyan,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: widget.controller,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // --- Header ---
                Container(
                  padding: const EdgeInsets.all(16),
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
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Journaling",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    "Bagaimana perasaan anda hari ini? Yuk, mulai menulis jurnalmu!",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),

                const SizedBox(height: 12),
                // --- Selectable mood row ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _moods
                      .map(
                        (mood) =>
                            _buildEmotionItem(mood['emoji']!, mood['label']!),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),

                // --- Journal text field, wired to a controller ---
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _journalController,
                    maxLines: null,
                    minLines: 5,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: "Write your journal entry here...",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // --- Save button: opens confirmation dialog first ---
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton.icon(
                      onPressed: () => _onSavePressed(context),
                      icon: const Icon(Icons.psychology_alt),
                      label: const Text(
                        "Simpan Jurnal",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),

                // --- History Section ---
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Catatan Terakhir",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),

                FutureBuilder<List<dynamic>>(
                  future: journalFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final List<dynamic> historyData = snapshot.data ?? [];

                    if (historyData.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text(
                            'No history records found.\nPull down to refresh.',
                          ),
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: historyData.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = historyData[index];
                          final int id = item['ID'];
                          final int score = item['score'];
                          final String level = item['level'];
                          final Color levelColor = _getLevelColor(level);
                          final DateTime? createdAt = item['CreatedAt'] != null
                              ? DateTime.tryParse(item['CreatedAt'])
                              : null;

                          final String dateString = createdAt != null
                              ? DateFormat(
                                  'MMM dd, yyyy',
                                ).format(createdAt.toLocal())
                              : 'N/A';

                          final AssessmentResult result = AssessmentResult(
                            id: id,
                            totalScore: score,
                            anxietyLevel: level,
                            createdAt: createdAt,
                          );

                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: levelColor.withAlpha(128),
                                width: 1.5,
                              ),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: levelColor.withAlpha(50),
                                child: Icon(
                                  getIconLevel(level),
                                  color: levelColor,
                                ),
                              ),
                              title: Text(
                                level,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: levelColor,
                                ),
                              ),
                              subtitle: Text('Score: $score\nID: $id'),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    dateString,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Text(
                                    'View Details',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => responsiveLayout(
                                    content: HarsResultScreen(result: result),
                                  ),
                                ),
                              ),
                              onLongPress: () => _showDeleteDialog(index, id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getLevelColor(String? level) {
    if (level == null) return Colors.grey;
    switch (level.toLowerCase()) {
      case 'normal':
        return Colors.green.shade500;
      case 'mild anxiety':
        return Colors.yellow.shade700;
      case 'moderate anxiety':
        return Colors.orange.shade700;
      case 'severe anxiety':
        return Colors.red.shade600;
      case 'very serious anxiety':
        return Colors.red.shade800;
      default:
        return Colors.blueGrey;
    }
  }

  // --- Tappable mood item; highlights when selected ---
  Widget _buildEmotionItem(String emoji, String label) {
    final bool isSelected = _selectedMoodLabel == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          // Tapping the same mood again deselects it.
          _selectedMoodLabel = isSelected ? null : label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorList.aquaCyan.withAlpha(40)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? ColorList.aquaCyan : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? ColorList.aquaCyan : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Validate, then show confirmation before submitting ---
  void _onSavePressed(BuildContext context) {
    final text = _journalController.text.trim();

    if (_selectedMoodLabel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose how you feel first.')),
      );
      return;
    }

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write something before saving.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Save this journal entry?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mood: $_selectedMoodLabel'),
              const SizedBox(height: 8),
              Text(text, maxLines: 5, overflow: TextOverflow.ellipsis),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _submitJournal(text, _selectedMoodLabel!);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // --- Actually persist the journal entry ---
  Future<void> _submitJournal(String text, String mood) async {
    final entry = JournalEntry(mood: mood, content: text);

    try {
      await journalingRepository.saveJournalEntry(entry);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Journal saved!')));

      setState(() {
        _journalController.clear();
        _selectedMoodLabel = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save journal: ${e.toString()}')),
      );
    }
  }

  void _showDeleteDialog(int index, int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete History'),
          content: Text('Are you sure you want to delete record ID $id?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteJournal(index, id);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteJournal(int index, int id) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Deleting record...'),
        duration: Duration(milliseconds: 500),
      ),
    );

    try {
      await journalingRepository.deleteJournalByID(id);

      setState(() {
        journalFuture = journalingRepository.fetchJournalHistory();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Record deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete: ${e.toString()}')),
      );
    }
  }
}
