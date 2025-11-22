import 'package:deteksi_cemas/features/dashboard/domain/models/medical_record_model.dart';

final List<MedicalRecordModel> sampleMedicalRecords = [
  MedicalRecordModel(
    id: 1,
    bpm: 72,
    result: "Healthy", // Healthy
    checkedAt: DateTime(2025, 10, 20, 9, 30),
  ),
  MedicalRecordModel(
    id: 2,
    bpm: 105,
    result: "Low", // Low (Anxiety)
    checkedAt: DateTime(2025, 10, 20, 14, 05),
  ),
  MedicalRecordModel(
    id: 3,
    bpm: 65,
    result: "Healthy", // Healthy
    checkedAt: DateTime(2025, 10, 21, 8, 0),
  ),
  MedicalRecordModel(
    id: 4,
    bpm: 135,
    result: "Moderate", // Moderate (Anxiety)
    checkedAt: DateTime(2025, 10, 21, 19, 45),
  ),
  MedicalRecordModel(
    id: 5,
    bpm: 168,
    result: "High", // High (Anxiety/Panic)
    checkedAt: DateTime(2025, 10, 22, 11, 15),
  ),
  MedicalRecordModel(
    id: 6,
    bpm: 92,
    result: "Healthy", // Healthy
    checkedAt: DateTime(2025, 10, 22, 17, 30),
  ),
  MedicalRecordModel(
    id: 7,
    bpm: 118,
    result: "Low", // Low (Anxiety)
    checkedAt: DateTime(2025, 10, 23, 7, 0),
  ),
];
