// ignore_for_file: use_build_context_synchronously

import 'package:deteksi_cemas/features/dashboard/data/models/journal_model.dart';
import 'package:deteksi_cemas/features/dashboard/domain/repository/journaling_repository.dart';
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
  late Future<List<JournalEntry>> journalFuture;

  // --- Journal entry state ---
  final TextEditingController _journalController = TextEditingController();

  // Holds which mood is currently selected. Null = none selected yet.
  String? _selectedMoodLabel;

  // Single source of truth for the moods so the selectable row, the
  // confirmation dialog, and the history list all stay in sync.
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

                FutureBuilder<List<JournalEntry>>(
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

                    final List<JournalEntry> historyData = snapshot.data ?? [];

                    if (historyData.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text(
                            'No journal entries yet.\nPull down to refresh.',
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
                          final JournalEntry entry = historyData[index];
                          final String emoji = _getMoodEmoji(entry.mood);
                          final Color moodColor = _getMoodColor(entry.mood);

                          final String dateString = entry.createdAt != null
                              ? DateFormat(
                                  'MMM dd, yyyy',
                                ).format(entry.createdAt!.toLocal())
                              : 'N/A';

                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: moodColor.withAlpha(128),
                                width: 1.5,
                              ),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: moodColor.withAlpha(50),
                                child: Text(
                                  emoji,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                              title: Text(
                                entry.mood,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: moodColor,
                                ),
                              ),
                              subtitle: Text(
                                entry.content,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Text(
                                dateString,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () =>
                                  _showEntryDetail(entry, emoji, dateString),
                              onLongPress: entry.id != null
                                  ? () => _showDeleteDialog(index, entry.id!)
                                  : null,
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

  // --- Mood -> emoji / color lookups, sourced from the same list used
  // for the selectable row so everything stays consistent. ---
  String _getMoodEmoji(String mood) {
    final match = _moods.firstWhere(
      (m) => m['label']!.toLowerCase() == mood.toLowerCase(),
      orElse: () => const {'emoji': '📝'},
    );
    return match['emoji']!;
  }

  Color _getMoodColor(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return Colors.green.shade600;
      case 'calm':
        return Colors.teal.shade600;
      case 'neutral':
        return Colors.blueGrey;
      case 'sad':
        return Colors.indigo.shade400;
      default:
        return Colors.blueGrey;
    }
  }

  // --- Tap a history card to read the full entry ---
  void _showEntryDetail(JournalEntry entry, String emoji, String dateString) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(entry.mood),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(dateString, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 12),
                Text(entry.content),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
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
        // Refresh the history list so the new entry shows up immediately.
        journalFuture = journalingRepository.fetchJournalHistory();
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
          title: const Text('Delete Journal Entry'),
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
