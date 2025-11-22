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
}

String formatDate(DateTime date) {
  return DateFormat('dd MMM yyyy • HH:mm').format(date);
}
