import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../data/models/medical_record_model.dart';

class InspectionDetailScreen extends StatelessWidget {
  final MedicalRecordModel record;

  const InspectionDetailScreen({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    // Logic for color based on anxiety level
    Color statusColor = _getStatusColor(record.result);

    return Scaffold(
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

            // 2. Metrics Grid
            const Text(
              "Heart Metrics",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.5,
              children: [
                _buildMetricTile(
                  "BPM",
                  record.bpm == 0 ? "N/A" : "${record.bpm}",
                  FontAwesomeIcons.heartPulse,
                  Colors.red,
                ),
                _buildMetricTile(
                  "HRV",
                  record.hrv == 0 ? "N/A" : "${record.hrv} ms",
                  FontAwesomeIcons.waveSquare,
                  Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 3. AI Analysis Section
            const Text(
              "AI Analysis Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInfoTile(
              "Confidence Score",
              "${(record.confidence * 100).toStringAsFixed(1)}%",
              "How certain the AI is about this result.",
              Icons.psychology,
            ),
            _buildInfoTile(
              "Anxiety Score",
              "${record.anxietyScore.toStringAsFixed(1)}/100",
              "Higher scores indicate more symptoms detected.",
              Icons.analytics,
            ),
            // Only show button if result is Unknown
            const SizedBox(height: 32),
            if (record.result == "Unknown")
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

  Widget _buildHeaderCard(Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
      ),
      child: Column(
        children: [
          Text(
            record.result.toUpperCase(),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Detected Anxiety Level",
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
        style: const TextStyle(fontWeight: FontWeight.bold),
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
    // Show a loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // TODO: Call your Repository method here
      // await historyRepo.analyzeInspection(record.id);

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Analysis complete! Please refresh history."),
          ),
        );

        Navigator.pop(context); // Go back to History list
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
