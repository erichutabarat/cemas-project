import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../data/models/article_model.dart';

class ArticleCardWidget extends StatelessWidget {
  final ArticleModel article;

  const ArticleCardWidget({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    const Color cardColor = Colors.white;
    const String fallbackAssetPath = 'assets/images/onboarding_welcome.png';
    if (kDebugMode) {
      print("Data Article Card: $article");
    }
    return Card(
      color: cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon and Title Row
            Row(
              children: [
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Image (Placeholder)
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // Use a background color while loading
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                // Use Image.network to handle remote URL loading and error states
                child: Image.network(
                  'https://erichutabarat.my.id${article.imageUrl}',
                  fit: BoxFit.cover,

                  // 🎯 The fix is here: using errorBuilder for fallback
                  errorBuilder: (context, error, stackTrace) {
                    // If the image fails to load from the network, show a local asset
                    return Image.asset(
                      fallbackAssetPath,
                      fit: BoxFit.cover,
                      // Fallback for if the local asset itself is missing
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        );
                      },
                    );
                  },

                  // Optional: Add a simple loading indicator
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              article.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
