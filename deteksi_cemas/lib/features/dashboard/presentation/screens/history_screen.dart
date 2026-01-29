import 'package:deteksi_cemas/features/dashboard/data/models/medical_record_model.dart';
import 'package:deteksi_cemas/features/dashboard/domain/repository/history_repository.dart';
import 'package:deteksi_cemas/features/dashboard/presentation/widgets/medical_history_card.dart';
import 'package:deteksi_cemas/features/dashboard/presentation/widgets/shaded_line.dart';
import 'package:deteksi_cemas/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  final ScrollController? controller;
  const HistoryScreen({super.key, this.controller});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<MedicalRecordModel> medicalRecords = [];
  bool isLoading = true;
  final historyRepo = HistoryRepository();
  @override
  void initState() {
    super.initState();
    _loadMedicalRecords();
  }

  void _loadMedicalRecords() async {
    try {
      // 1. Explicitly type the result from the repo
      final List<MedicalRecordModel> records = await historyRepo
          .fetchUsersInspectionHistory();
      if (kDebugMode) {
        print("Fetched records: $records");
      }
      setState(() {
        medicalRecords = records;
        isLoading = false;
      });
    } catch (e) {
      // Handle error appropriately
      if (kDebugMode) {
        print('Error fetching medical records: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(0),
        child: SingleChildScrollView(
          controller: widget.controller,
          child: Column(
            children: [
              // history header
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.history, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      l10n.history,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.info_rounded, color: Colors.white),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // heart rate zone
              Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(color: Colors.red.shade100),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Heart Rate Zone",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Text(
                              "Know more",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.red.shade700,
                              ),
                            ),
                            Icon(Icons.arrow_right_rounded, size: 30),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 18),
                    ShadedLineWidget(),
                  ],
                ),
              ),
              SizedBox(height: 26),

              // Medical History
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.medical_history,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 14),
                    // list here
                    isLoading
                        ? CircularProgressIndicator()
                        : ListView.separated(
                            shrinkWrap:
                                true, // <-- allow height to grow with content
                            physics:
                                NeverScrollableScrollPhysics(), // <-- disable scrolling here
                            itemCount: medicalRecords.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final item = medicalRecords[index];
                              return MedicalHistoryCard(medicalRecord: item);
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
