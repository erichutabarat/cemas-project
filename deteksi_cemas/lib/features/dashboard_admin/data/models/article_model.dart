enum ArticleType { food, activity }

class ArticleModel {
  final int id;
  final String name;
  final ArticleType articleType;
  final String url;
  final String description;
  final String anxietyLevel;

  ArticleModel({
    required this.id,
    required this.name,
    required this.articleType,
    required this.url,
    required this.description,
    required this.anxietyLevel,
  });

  // ← type is passed in from the repository, not read from JSON
  factory ArticleModel.fromJson(
    Map<String, dynamic> json, {
    required ArticleType type,
  }) {
    return ArticleModel(
      id: json['id'],
      name: json['name'],
      articleType: type,
      url: json['image_url'],
      description: json['description'],
      anxietyLevel: json['anxiety_level'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'article_type': articleType.name, // ← .name gives 'food' or 'activity'
      'image_url': url,
      'description': description,
      'anxiety_level': anxietyLevel,
    };
  }
}
