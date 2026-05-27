// ignore_for_file: use_build_context_synchronously

import 'package:deteksi_cemas/features/dashboard_admin/domain/repository/inspection_repository.dart';
import 'package:deteksi_cemas/features/onboarding/domain/repository/backend_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:deteksi_cemas/features/dashboard_admin/data/models/inspection_model.dart';
import 'package:just_audio/just_audio.dart';

class InspectionDetailScreen extends StatefulWidget {
  final Inspection inspection;
  const InspectionDetailScreen({super.key, required this.inspection});

  @override
  State<InspectionDetailScreen> createState() => _InspectionDetailScreenState();
}

class _InspectionDetailScreenState extends State<InspectionDetailScreen> {
  // Helper to color-code anxiety severity dynamically
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  late String _currentFilename;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _currentFilename = widget.inspection.audioUrl.split('/').last;

    _audioPlayer.playerStateStream.listen((playerState) {
      if (mounted) {
        setState(() {
          _isPlaying = playerState.playing;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Always release audio hardware resources
    super.dispose();
  }

  Color _getSeverityColor(String? level) {
    switch (level?.toLowerCase()) {
      case 'high':
        return Colors.redAccent;
      case 'moderate':
        return Colors.orangeAccent;
      case 'low':
        return Colors.greenAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    final result = widget.inspection.result;
    final severityColor = _getSeverityColor(result?.anxietyLevel);
    final formattedDate = DateFormat(
      'dd MMM yyyy, HH:mm',
    ).format(widget.inspection.createdAt);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Modern off-white background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        title: Text(
          'Inspection Details',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: widget.inspection.checked
                  ? Colors.green.withOpacity(0.1)
                  : Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  widget.inspection.checked
                      ? Icons.check_circle
                      : Icons.pending,
                  size: 16,
                  color: widget.inspection.checked
                      ? Colors.green
                      : Colors.amber,
                ),
                const SizedBox(width: 4),
                Text(
                  widget.inspection.checked ? 'Checked' : 'Pending',
                  style: TextStyle(
                    color: widget.inspection.checked
                        ? Colors.green
                        : Colors.amber,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SECTION 1: METADATA HEADER ---
            _buildSectionHeader('Metadata Info'),
            const SizedBox(height: 10),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildMetaRow(
                      Icons.fingerprint,
                      'Inspection ID',
                      '#${widget.inspection.id}',
                    ),
                    const Divider(height: 24),
                    _buildMetaRow(
                      Icons.person_outline,
                      'User ID',
                      '#${widget.inspection.userID}',
                    ),
                    const Divider(height: 24),
                    _buildMetaRow(
                      Icons.calendar_today_outlined,
                      'Created At',
                      formattedDate,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- SECTION 2: AUDIO PLAYBACK FILE ---
            _buildSectionHeader('Audio Source File'),
            const SizedBox(height: 10),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: const Color(
                0xFF0F172A,
              ), // Dark elegant slate card for media player
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.tealAccent.withOpacity(0.2),
                      child: const Icon(
                        Icons.audiotrack,
                        color: Colors.tealAccent,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: _showEditFilenameModal,
                        behavior: HitTestBehavior.opaque,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _currentFilename, // Uses dynamic state string tracking updates
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.edit,
                                  color: Colors.tealAccent,
                                  size: 14,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isPlaying
                                  ? 'Playing track...'
                                  : 'Click text to rename file',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        _isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        color: Colors.tealAccent,
                        size: 40,
                      ),
                      onPressed: _togglePlayback, // Triggers playback toggling
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- SECTION 3: ANALYSIS RESULTS ---
            _buildSectionHeader('Analysis Result Data'),
            const SizedBox(height: 10),
            if (result == null)
              _buildNoResultCard()
            else ...[
              // Primary Anxiety Level Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [severityColor.withOpacity(0.85), severityColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: severityColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ANXIETY LEVEL',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      result.anxietyLevel.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildWhiteMetrics(
                          'Score',
                          '${result.anxietyScore.toStringAsFixed(1)}%',
                        ),
                        _buildWhiteMetrics(
                          'Confidence',
                          '${calcConfidencePercentage(result.confidence).toStringAsFixed(1)}%',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Secondary Vital Metrics (BPM / HRV) Grid
              Row(
                children: [
                  Expanded(
                    child: _buildVitalsCard(
                      'Heart Rate',
                      '${result.bpm} BPM',
                      Icons.favorite,
                      Colors.redAccent,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildVitalsCard(
                      'HRV metric',
                      '${result.hrv} ms',
                      Icons.bolt,
                      Colors.amber,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // --- REUSABLE UI WIDGET COMPONENT METHOD ---

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF64748B),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildMetaRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildWhiteMetrics(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildVitalsCard(
    String title,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.analytics_outlined,
            color: Colors.amber.shade700,
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            'No Analysis Data Available',
            style: TextStyle(
              color: Colors.amber.shade900,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'This audio inspection has either not been processed yet or processing failed.',
            style: TextStyle(color: Colors.amber.shade800, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // Handle Play/Pause execution
  Future<void> _togglePlayback() async {
    final backendUrl = await BackendRepository.getBackendUrl();
    final fileLocation = '$backendUrl/uploads/$_currentFilename';
    try {
      if (kDebugMode) {
        print('Attempting to play audio from URL: $fileLocation');
      }
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.setUrl(fileLocation);
        await _audioPlayer.play();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        // ignore: duplicate_ignore
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('Error playing audio: $e')));
    }
  }

  void _showEditFilenameModal() {
    final TextEditingController controller = TextEditingController(
      text: _currentFilename,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Slides up comfortably above virtual keyboards
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) {
        // Renamed this context to prevent mixing them up
        return Padding(
          padding: EdgeInsets.only(
            top: 24,
            left: 24,
            right: 24,
            bottom:
                MediaQuery.of(modalContext).viewInsets.bottom +
                24, // Adapts to keyboard height
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Audio Filename',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Filename',
                  hintText: 'example.wav',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.edit_note),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(modalContext),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      // Removed 'async' since we are using .then()
                      final newName = controller.text.trim();
                      final repo = InspectionsRepository();

                      if (newName.isNotEmpty) {
                        // 1. CAPTURE the ScaffoldMessenger from the main screen's context
                        // before we pop the modal out of existence.
                        final messenger = ScaffoldMessenger.of(context);

                        // 2. Close the modal sheet using its own context
                        Navigator.pop(modalContext);

                        repo
                            .updateInspectionFilename(
                              widget.inspection.id,
                              newName,
                            )
                            .then((response) {
                              // 3. Use the safe, captured messenger here
                              messenger.showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Filename updated successfully!',
                                  ),
                                ),
                              );
                              setState(() {
                                _currentFilename = newName;
                              });
                            })
                            .catchError((error) {
                              // 4. Use the safe, captured messenger here too
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Error updating filename: $error',
                                  ),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            });
                      }
                    },
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  double calcConfidencePercentage(double confidence) {
    if (confidence <= 1) {
      return confidence * 100;
    } else {
      return (confidence - 0.5) * 100;
    }
  }
}
