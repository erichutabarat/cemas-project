/// Model for a single journal entry saved by the user.
///
/// Mirrors the style of `AssessmentResult` used elsewhere in the app so it
/// plugs in cleanly with existing repository/JSON patterns.
class JournalEntry {
  final int? id;
  final String mood;
  final String content;
  final DateTime? createdAt;

  JournalEntry({
    this.id,
    required this.mood,
    required this.content,
    this.createdAt,
  });

  /// Build from a JSON map (e.g. a response from your backend).
  ///
  /// Adjust the key names below if your API uses different casing
  /// (this assumes Go/Gorm-style `ID` and `CreatedAt`, matching the
  /// `fetchUsersSurveyHistory` data you're already parsing).
  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['ID'] as int?,
      mood: json['mood'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: json['CreatedAt'] != null
          ? DateTime.tryParse(json['CreatedAt'] as String)
          : null,
    );
  }

  /// Convert to a JSON map for sending to your backend when saving.
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'ID': id,
      'mood': mood,
      'content': content,
      if (createdAt != null) 'CreatedAt': createdAt!.toIso8601String(),
    };
  }

  /// Handy for updating an entry immutably (e.g. after an edit).
  JournalEntry copyWith({
    int? id,
    String? mood,
    String? content,
    DateTime? createdAt,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      mood: mood ?? this.mood,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
