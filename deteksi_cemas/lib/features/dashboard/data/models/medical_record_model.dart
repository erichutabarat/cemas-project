import 'package:intl/intl.dart';

class MedicalRecordModel {
  final int id;
  final int bpm;
  final String result;
  final DateTime checkedAt;

  MedicalRecordModel({
    required this.id,
    required this.bpm,
    required this.result,
    required this.checkedAt,
  });

  factory MedicalRecordModel.fromJson(Map<String, dynamic> json) {
    // Check if 'result' key exists and is not null
    final hasResult = json['result'] != null;

    return MedicalRecordModel(
      id: json['id'],
      // If hasResult is true, use it. Otherwise, use 0.
      bpm: hasResult ? (json['result']['bpm'] ?? 0) : 0,
      // If hasResult is true, use anxiety_level. Otherwise, "Unknown".
      result: hasResult
          ? (json['result']['anxiety_level'] ?? "Unknown")
          : "Unknown",
      checkedAt: DateTime.parse(json['created_at']),
    );
  }
}

String formatDate(DateTime date) {
  return DateFormat('dd MMM yyyy • HH:mm').format(date);
}
