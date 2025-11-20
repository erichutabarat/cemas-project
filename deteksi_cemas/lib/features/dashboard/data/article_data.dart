import '../domain/models/article_model.dart';

final List<ArticleModel> dummyArticleData = [
  // Healthy Food Articles (Type: healthyFood)
  ArticleModel(
    id: 'food_1',
    title: 'Avocado Toast',
    imageUrl: 'assets/images/food.jpg', // Replace with your asset path
    description: 'Great source of healthy fats and fiber.',
    type: ArticleType.healthyFood,
  ),
  ArticleModel(
    id: 'food_2',
    title: 'Berry Smoothie',
    imageUrl: 'assets/images/food.jpg',
    description: 'Packed with antioxidants for immunity.',
    type: ArticleType.healthyFood,
  ),

  // Healthy Activity Articles (Type: healthyActivity)
  ArticleModel(
    id: 'activity_1',
    title: '30 Min Yoga Flow',
    imageUrl: 'assets/images/jogging.jpg',
    description: 'Reduces stress and improves flexibility.',
    type: ArticleType.healthyActivity,
  ),
  ArticleModel(
    id: 'activity_2',
    title: 'Daily Brisk Walk',
    imageUrl: 'assets/images/jogging.jpg',
    description: 'Boosts cardiovascular health gently.',
    type: ArticleType.healthyActivity,
  ),
];
