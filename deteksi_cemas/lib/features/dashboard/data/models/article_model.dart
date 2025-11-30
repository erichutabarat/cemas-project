enum ArticleType { healthyFood, healthyActivity }

class ArticleModel {
  final int id;
  final String title; // This will now hold the value from 'name'
  final String imageUrl;
  final String description;
  final ArticleType type;

  ArticleModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.type,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    // Determine the ArticleType
    // For the food endpoint, you know the type is 'healthyFood'
    // For a mixed endpoint, you might check a 'type' field, or rely on which endpoint provided the data.
    // Assuming this function is used for both 'activities' and 'foods' data:

    // Check for the presence of 'name' (for food) or 'title' (for activity)
    final String titleKey = json.containsKey('name') ? 'name' : 'title';

    // If the data came from the foods endpoint, we can be sure it's food.
    // If you need the type to be dynamic, you would look for a 'type' field in the JSON.
    ArticleType articleType = json.containsKey('name')
        ? ArticleType.healthyFood
        : ArticleType.healthyActivity;

    return ArticleModel(
      // Use null-aware operators and default values for safety
      id: (json['id'] as num? ?? 0).toInt(),

      // 🎯 FIX: Use the determined titleKey ('name' or 'title') to fetch the title
      title: json[titleKey] as String? ?? 'No Title Available',

      // Assuming 'image_url' maps to 'imageUrl'
      imageUrl: json['image_url'] as String? ?? '',

      description: json['description'] as String? ?? '',

      type: articleType,
    );
  }
}
