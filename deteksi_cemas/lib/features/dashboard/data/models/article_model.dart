class ArticleModel {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final ArticleType type; // Distinguishes between Food and Activity

  ArticleModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.type,
  });
}

// Enum to clearly categorize the article type
enum ArticleType { healthyFood, healthyActivity }
