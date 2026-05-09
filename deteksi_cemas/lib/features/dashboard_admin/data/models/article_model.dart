class ArticleModel {
  int id;
  String name;
  String url;
  String description;
  String anxietyLevel;

  ArticleModel({
    required this.id,
    required this.name,
    required this.url,
    required this.description,
    required this.anxietyLevel,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'],
      name: json['name'],
      url: json['image_url'],
      description: json['description'],
      anxietyLevel: json['anxiety_level'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': url,
      'description': description,
      'anxiety_level': anxietyLevel,
    };
  }
}
