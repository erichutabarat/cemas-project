// ignore_for_file: use_build_context_synchronously

import 'package:deteksi_cemas/features/dashboard/domain/repository/user_repository.dart';
import 'package:deteksi_cemas/features/dashboard/presentation/widgets/research_info_card.dart';
import 'package:deteksi_cemas/features/survey/presentation/screens/informed_consent.dart';
import 'package:deteksi_cemas/l10n/app_localizations.dart';
import 'package:deteksi_cemas/theme/color_list.dart';
import 'package:flutter/material.dart';

class SurveyScreen extends StatefulWidget {
  final ScrollController? controller;
  const SurveyScreen({super.key, this.controller});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  final UserRepository userRepository = UserRepository();
  late Future<List<dynamic>> userHistoryFuture;

  @override
  void initState() {
    super.initState();
    userHistoryFuture = userRepository.fetchUsersSurveyHistory();
  }

  // --- REFRESH LOGIC ---
  Future<void> _refreshHistory() async {
    setState(() {
      // Re-fetching the data triggers the FutureBuilder to rebuild
      userHistoryFuture = userRepository.fetchUsersSurveyHistory();
    });
    // Wait for the future to complete before hiding the spinner
    await userHistoryFuture;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      // 1. Wrap the scrollable area with RefreshIndicator
      body: RefreshIndicator(
        onRefresh: _refreshHistory,
        color: ColorList.aquaCyan, // Optional: matches your theme
        child: SingleChildScrollView(
          // 2. Ensure it's ALWAYS scrollable so pull-to-refresh works even when empty
          physics: const AlwaysScrollableScrollPhysics(),
          controller: widget.controller,
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
                      "HARS Survey",
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

              // --- Info Card ---
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: _buildInfoCard(context),
              ),
              const SizedBox(height: 12),

              // research info card
              // Inside your SurveyScreen build method, update the ResearchInfoCard section:
              // --- research info card ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child:
                    const ResearchInfoCard(), // Ensure this component no longer has a Scaffold inside it!
              ),
              const SizedBox(height: 12),

              // --- Start Button ---
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton.icon(
                    onPressed: () => startSurvey(context),
                    icon: const Icon(Icons.psychology_alt),
                    label: Text(
                      l10n.start_survey,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 50), // Extra space at bottom for scrolling
            ],
          ),
        ),
      ),
    );
  }

  // Utility function inside _SurveyScreenState (or a mixin/util class)

  Widget _buildInfoCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.what_is_hars,
              // Increased to titleLarge (usually ~22)
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.hars_desc,
              // Increased from 14 to 16
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.hars_disclaimer,
              // Increased from default to 15
              style: const TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void startSurvey(BuildContext context) {
    // 2. Instantiate the repository manually

    // 3. Navigate and pass the required argument
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InformedConsentForm()),
    );
  }
}
