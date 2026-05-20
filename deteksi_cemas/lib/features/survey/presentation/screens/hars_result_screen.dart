import 'package:deteksi_cemas/features/survey/data/models/assessment_results_models.dart';
import 'package:deteksi_cemas/features/survey/presentation/widgets/article_recommendation.dart';
import 'package:deteksi_cemas/features/survey/presentation/widgets/get_icon_level.dart';
import 'package:deteksi_cemas/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
// Ensure this path is correct for AssessmentResult

// Assuming AssessmentResult is the same as AssessmentResult from previous models.
// If not, please adjust the import and class name accordingly.

class HarsResultScreen extends StatefulWidget {
  // We need to pass the AssessmentResult to this screen
  final AssessmentResult? result;

  const HarsResultScreen({super.key, this.result});

  @override
  State<HarsResultScreen> createState() => _HarsResultScreenState();
}

class _HarsResultScreenState extends State<HarsResultScreen> {
  // Helper function to determine color based on anxiety level
  Color _getAnxietyLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'normal':
        return Colors.green.shade600;
      case 'mild anxiety':
        return Colors.yellow.shade700;
      case 'moderate anxiety':
        return Colors.orange.shade700;
      case 'severe anxiety':
        return Colors.red.shade600;
      case 'very severe anxiety':
        return Colors.red.shade700;
      case 'very serious anxiety':
        return Colors.red.shade800;
      default:
        return Colors.red.shade900;
    }
  }

  // Helper function for a descriptive message (can be expanded)
  String _getDescriptiveMessage(String level) {
    switch (level.toLowerCase().trim()) {
      case 'normal':
        return "Tingkat kecemasan Anda berada dalam batas normal. Gejala yang dirasakan minimal dan tidak mengganggu fungsi adaptasi sehari-hari. Tetap pertahankan pola hidup sehat dan manajemen stres yang baik.";

      case 'mild anxiety':
        return "Anda mengindikasikan gejala kecemasan ringan (mild anxiety). Secara klinis, ini adalah respons emosional minor yang umumnya belum mengganggu produktivitas secara signifikan. Anda disarankan melakukan teknik relaksasi mandiri, latihan pernapasan, atau evaluasi kebiasaan harian.";

      case 'moderate anxiety':
        return "Hasil evaluasi menunjukkan kecemasan sedang (moderate anxiety). Pada tahap ini, manifestasi klinis kecemasan mungkin sudah mulai mengganggu konsentrasi, pola tidur, atau aktivitas harian Anda. Pertimbangkan untuk berkonsultasi dengan profesional kesehatan mental (psikolog/psikiater) untuk strategi koping yang lebih efektif.";

      case 'severe anxiety':
        return "Skor Anda mengindikasikan kecemasan berat (severe anxiety). Kondisi klinis ini memerlukan intervensi medis karena berpotensi mengganggu fungsi psikososial dan fisik secara signifikan. Kami menyarankan Anda untuk menjadwalkan konsultasi dengan psikolog klinis atau psikiater guna mendapatkan penanganan yang tepat.";

      case 'very severe anxiety':
        return "Skor Anda menunjukkan kecemasan sangat berat (very severe anxiety). Secara klinis, tingkat ini menandakan distres emosional ekstrem yang umumnya melumpuhkan (debilitating) fungsi harian, serta dapat memicu manifestasi fisik yang intens (seperti serangan panik mendalam). Kondisi ini memerlukan intervensi klinis dan penanganan medis darurat. Harap segera hubungi psikiater, psikolog klinis, atau layanan gawat darurat kesehatan mental terdekat.";

      case 'very serious anxiety':
        return "Hasil evaluasi menunjukkan kecemasan sangat serius (very serious anxiety). Kondisi ini menandakan tingkat distress emosional yang ekstrem, dengan potensi risiko tinggi terhadap keselamatan diri sendiri atau orang lain. Manifestasi klinis pada tahap ini sering kali melibatkan gejala psikotik, disosiasi, atau ideasi bunuh diri. Intervensi medis darurat sangat diperlukan. Harap segera hubungi layanan gawat darurat kesehatan mental, psikiater, atau psikolog klinis untuk penanganan intensif dan mendesak.";

      default:
        return "Terima kasih telah menyelesaikan pengisian kuesioner. Hasil evaluasi tingkat kecemasan Anda memerlukan tinjauan lebih lanjut oleh tenaga medis atau profesional kesehatan mental resmi.";
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final Color levelColor = _getAnxietyLevelColor(widget.result!.anxietyLevel);
    final String descriptiveMessage = _getDescriptiveMessage(
      widget.result!.anxietyLevel,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('HARS Survey Results'),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          // Custom back button to go to main app screen, not back to survey questions
          icon: const Icon(
            Icons.close,
          ), // Or Icons.arrow_back, depending on desired navigation
          onPressed: () => Navigator.of(context).pop(), // Pops
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Confetti/Celebration or prominent icon
              Center(
                child: Icon(
                  getIconLevel(widget.result!.anxietyLevel),
                  size: 80,
                  color: levelColor,
                ),
              ),
              const SizedBox(height: 20),

              // Title Card for Anxiety Level
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: levelColor.withValues(
                  alpha: 0.3,
                ), // Soft background color
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        '${l10n.anxietylevelis}:',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(color: Colors.grey.shade700),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.result!.anxietyLevel,
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: levelColor,
                              fontSize: 40,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Total Score Display
              _buildResultRow(
                context,
                'Total Score',
                '${widget.result?.totalScore} / 67', // Assuming 56 is the max HARS score
                Icons.score,
                Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 20),

              // Descriptive Message Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${l10n.whatthismeans}:',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        descriptiveMessage,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ArticleRecommendation(level: widget.result!.anxietyLevel),
              const SizedBox(height: 30),

              // Action Buttons (Next Steps
              _buildActionButton(
                context,
                'Go to Home',
                Icons.home,
                () {
                  // Navigate back to the main dashboard/home screen
                  Navigator.of(context).pushReplacementNamed('/dashboard');
                },
                isPrimary: true, // Make this button more prominent
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(width: 15),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onPressed, {
    bool isPrimary = false,
  }) {
    return FilledButton.icon(
      icon: Icon(icon),
      label: Text(text),
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: isPrimary
            ? Theme.of(context).primaryColor
            : Colors.grey.shade200,
        foregroundColor: isPrimary ? Colors.white : Colors.black87,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16),
        elevation: isPrimary ? 5 : 2,
      ),
    );
  }
}
