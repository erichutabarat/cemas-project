class MedicalRecordModel {
  final int id;
  final String audioUrl;
  final bool checked;
  final DateTime checkedAt;
  final int bpm;
  final int hrv; // Added
  final double anxietyScore; // Added
  final String result;
  final double confidence; // Added

  MedicalRecordModel({
    required this.id,
    required this.audioUrl,
    required this.checked,
    required this.checkedAt,
    required this.bpm,
    required this.hrv,
    required this.anxietyScore,
    required this.result,
    required this.confidence,
  });

  factory MedicalRecordModel.fromJson(Map<String, dynamic> json) {
    // Check if the nested 'result' object exists
    final resultData = json['result'];
    final bool hasResult = resultData != null;

    return MedicalRecordModel(
      id: json['id'] ?? 0,
      audioUrl: json['audio_url'] ?? '',
      checked: json['checked'] ?? false,
      checkedAt: DateTime.parse(json['created_at']),
      // Extracting from nested 'result' Map
      bpm: hasResult ? (resultData['bpm'] ?? 0) : 0,
      hrv: hasResult ? (resultData['hrv'] ?? 0) : 0,
      anxietyScore: hasResult
          ? (resultData['anxiety_score']?.toDouble() ?? 0.0)
          : 0.0,
      result: hasResult
          ? (resultData['anxiety_level'] ?? "Unknown")
          : "Unknown",
      confidence: hasResult
          ? (resultData['confidence']?.toDouble() ?? 0.0)
          : 0.0,
    );
  }
}
