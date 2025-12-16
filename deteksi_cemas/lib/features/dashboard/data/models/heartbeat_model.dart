class UploadResponse {
  final String audioUrl;
  final int inspectionId;
  final String message;

  UploadResponse({
    required this.audioUrl,
    required this.inspectionId,
    required this.message,
  });

  // Factory method to create an object from the JSON map
  factory UploadResponse.fromJson(Map<String, dynamic> json) {
    return UploadResponse(
      audioUrl: json['audio_url'] as String,
      inspectionId: json['inspection_id'] as int,
      message: json['message'] as String,
    );
  }
}
