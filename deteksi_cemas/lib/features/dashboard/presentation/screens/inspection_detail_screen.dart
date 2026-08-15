import 'package:deteksi_cemas/features/dashboard/domain/repository/heartbeat_repository.dart';
import 'package:deteksi_cemas/features/survey/presentation/widgets/article_recommendation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../data/models/medical_record_model.dart';

class InspectionDetailScreen extends StatefulWidget {
  final MedicalRecordModel record;
  const InspectionDetailScreen({super.key, required this.record});

  @override
  State<InspectionDetailScreen> createState() => _InspectionDetailScreenState();
}

class _InspectionDetailScreenState extends State<InspectionDetailScreen> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print({
        'id': widget.record.id,
        'audioUrl': widget.record.audioUrl,
        'checked': widget.record.checked,
        'checkedAt': widget.record.checkedAt.toIso8601String(),
        'bpm': widget.record.bpm,
        'hrv': widget.record.hrv,
        'anxietyScore': widget.record.anxietyScore,
        'result': widget.record.result,
        'confidence': widget.record.confidence,
      });
    }
    _audioPlayer = AudioPlayer();
    _initAudio();
  }

  Future<void> _initAudio() async {
    // 1. Get the full string: "https://localhost:8080/uploads/rec_123.wav"
    String rawUrl = widget.record.audioUrl;

    // 2. Extract just the filename (everything after the last '/')
    String fileName = rawUrl.split('/').last;

    // 3. Combine with your real production domain
    final productionUrl = "https://deteksicemas.my.id/uploads/$fileName";

    try {
      await _audioPlayer.setUrl(productionUrl);
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.stop(); // Ensure audio stops immediately
    _audioPlayer.dispose();
    super.dispose();
  }

  // Utility to format Duration into MM:SS
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = _getStatusColor(widget.record.result);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Inspection Detail"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Summary Header Card
            _buildHeaderCard(statusColor),
            const SizedBox(height: 24),

            const Text(
              "AI Analysis Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInfoTile(
              "Confidence Score",
              "${(widget.record.confidence * 100).toStringAsFixed(1)}%",
              "How certain the AI is about this result.",
              Icons.psychology,
            ),
            const SizedBox(height: 12),

            // 3. Audio Player Section
            const Text(
              "Heartbeat Recording",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildAudioPlayerCard(),
            const SizedBox(height: 32),

            ArticleRecommendation(level: widget.record.result),
            const SizedBox(height: 32),

            // 5. Analyze Now Button (Conditional)
            if (widget.record.result == "Unknown")
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () => _handleAnalyzeNow(context),
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text(
                    "Analyze Now",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildAudioPlayerCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: StreamBuilder<PlayerState>(
        stream: _audioPlayer.playerStateStream,
        builder: (context, snapshot) {
          final playerState = snapshot.data;
          final processingState = playerState?.processingState;
          final playing = playerState?.playing;

          return Column(
            children: [
              Row(
                children: [
                  // Play/Pause Button
                  IconButton(
                    iconSize: 48,
                    icon: (playing != true)
                        ? const Icon(Icons.play_circle_fill, color: Colors.red)
                        : const Icon(
                            Icons.pause_circle_filled,
                            color: Colors.red,
                          ),
                    onPressed: () {
                      if (playing != true) {
                        _audioPlayer.play();
                      } else {
                        _audioPlayer.pause();
                      }
                    },
                  ),
                  // Progress Slider
                  Expanded(
                    child: StreamBuilder<Duration>(
                      stream: _audioPlayer.positionStream,
                      builder: (context, snapshot) {
                        final position = snapshot.data ?? Duration.zero;
                        final duration = _audioPlayer.duration ?? Duration.zero;

                        // FIX: Clamp the value so it's never > max
                        double sliderValue = position.inMilliseconds.toDouble();
                        double maxDuration = duration.inMilliseconds.toDouble();

                        // Ensure maxDuration is at least 1.0 to avoid division by zero errors
                        if (maxDuration <= 0) maxDuration = 1.0;

                        // Force sliderValue to stay within [0, maxDuration]
                        if (sliderValue > maxDuration) {
                          sliderValue = maxDuration;
                        }
                        if (sliderValue < 0) sliderValue = 0;

                        return Column(
                          children: [
                            Slider(
                              activeColor: Colors.red,
                              inactiveColor: Colors.red.withAlpha(50),
                              value: sliderValue, // Use the clamped value
                              max: maxDuration, // Use the safe max
                              onChanged: (value) {
                                _audioPlayer.seek(
                                  Duration(milliseconds: value.toInt()),
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDuration(position),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    _formatDuration(duration),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  if (processingState == ProcessingState.buffering)
                    const Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.red,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard(Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withAlpha(40),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(100), width: 1.5),
      ),
      child: Column(
        children: [
          Text(
            widget.record.result.toUpperCase(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Detected Anxiety Level",
            style: TextStyle(color: Colors.black54, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(
    String title,
    String value,
    String description,
    IconData icon,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade100,
        child: Icon(icon, color: Colors.black87),
      ),
      title: Text(
        "$title: $value",
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(description),
    );
  }

  Color _getStatusColor(String level) {
    switch (level.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'moderate':
        return Colors.orange;
      case 'severe':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _handleAnalyzeNow(BuildContext context) async {
    final heartbearRepo = HeartbeatRepository();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Logic for triggering analysis goes here
      await Future.delayed(const Duration(seconds: 2));
      bool success = await heartbearRepo.analyzeHeartbeat(widget.record.id);
      if (success) {
        if (context.mounted) {
          Navigator.pop(context); // Close loading
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Analysis complete! Please refresh history."),
            ),
          );
          Navigator.pop(context); // Return to list
        }
      } else {
        if (context.mounted) {
          Navigator.pop(context); // Close loading
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Analysis failed. Please try again later."),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }
}
