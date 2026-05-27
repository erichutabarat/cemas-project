class Inspection {
  final int id;
  final int userID;
  final String audioUrl;
  final bool checked;
  final DateTime createdAt;
  Result? result;

  Inspection({
    required this.id,
    required this.userID,
    required this.audioUrl,
    required this.checked,
    required this.createdAt,
    this.result,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userID': userID,
      'audioUrl': audioUrl,
      'checked': checked,
      'createdAt': createdAt.toIso8601String(),
      'result': result?.toMap(),
    };
  }

  factory Inspection.fromMap(Map<String, dynamic> map) {
    return Inspection(
      id: map['id'] as int,
      userID: map['user_id'] as int,
      audioUrl: map['audio_url'] as String,
      checked: map['checked'] as bool,
      createdAt: DateTime.parse(map['created_at'] as String),
      result: map['result'] != null
          ? Result.fromMap(map['result'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => toMap();

  factory Inspection.fromJson(Map<String, dynamic> json) =>
      Inspection.fromMap(json);
}

class Result {
  final int id;
  final double anxietyScore;
  final String anxietyLevel;
  final int hrv;
  final int bpm;
  final double confidence;
  final DateTime createdAt;

  Result({
    required this.id,
    required this.anxietyScore,
    required this.anxietyLevel,
    required this.hrv,
    required this.bpm,
    required this.confidence,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'anxietyScore': anxietyScore,
      'anxietyLevel': anxietyLevel,
      'hrv': hrv,
      'bpm': bpm,
      'confidence': confidence,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Result.fromMap(Map<String, dynamic> map) {
    return Result(
      id: map['id'] as int,
      anxietyScore: (map['anxiety_score'] as num).toDouble(),
      anxietyLevel: map['anxiety_level'] as String,
      hrv: map['hrv'] as int,
      bpm: map['bpm'] as int,
      confidence: (map['confidence'] as num).toDouble(),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => toMap();

  factory Result.fromJson(Map<String, dynamic> json) => Result.fromMap(json);
}
