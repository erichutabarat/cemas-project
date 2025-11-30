import 'package:deteksi_cemas/features/dashboard/data/models/article_model.dart';
import 'package:deteksi_cemas/features/dashboard/domain/repository/recommendation_repository.dart';
import 'package:deteksi_cemas/features/dashboard/presentation/widgets/article_card.dart';
import 'package:deteksi_cemas/features/dashboard/presentation/widgets/header_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  // Declare the controller as nullable
  final ScrollController? controller;
  final String name;

  // Make the parameter nullable (ScrollController?) in the constructor
  // You should also remove 'required' unless you enforce it elsewhere.
  const HomeScreen({super.key, this.controller, required this.name});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final recommendationRepo = RecommendationRepository();
  List<ArticleModel> activityArticles = [];
  List<ArticleModel> foodArticles = [];
  bool isLoading = true; // Track loading state
  String? errorMessage; // To store error messages

  @override
  void initState() {
    super.initState();
    // Start fetching data and updating state
    _fetchData();
  }

  void _fetchData() {
    recommendationRepo
        .fetchRecommendations()
        .then((data) {
          // 1. Get the raw lists from the decoded map
          final List<dynamic> rawActivities = data['activities'] ?? [];
          final List<dynamic> rawFoods = data['foods'] ?? [];

          // 2. Map the raw lists (List<Map<String, dynamic>>) to your ArticleModel
          final List<ArticleModel> activities = rawActivities
              .map(
                (json) => ArticleModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();

          final List<ArticleModel> foods = rawFoods
              .map(
                (json) => ArticleModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();

          setState(() {
            activityArticles = activities;
            foodArticles = foods;
            isLoading = false;
            errorMessage = null; // Clear any previous error
          });
          if (kDebugMode) {
            print("Activity Articles Count: ${activityArticles.length}");
          }
          if (kDebugMode) {
            print("Food Articles Count: ${foodArticles.length}");
          }
        })
        .catchError((error) {
          if (kDebugMode) {
            print("Error fetching recommendations: $error");
          }
          setState(() {
            isLoading = false;
            errorMessage = error.toString(); // Store the error message
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.red.shade400,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    // 💡 Use the full, unfiltered list of dummy data
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.zero,
        child: SingleChildScrollView(
          controller: widget.controller,
          child: Column(
            children: [
              HeaderCard(name: widget.name),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  // 1. Style the container/outline
                  decoration: InputDecoration(
                    // Use the OutlineInputBorder, but customize it for a modern look
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // Softer, more modern corners
                      borderSide:
                          BorderSide.none, // Hide the default thin border
                    ),

                    // 2. Use a subtle fill color for depth
                    filled: true,
                    fillColor: Colors.white, // Light grey background
                    // 3. Labels and Hints
                    labelText: "Search",
                    hintText: "Search here...",

                    // 4. Accent style when focused
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      // Use the primary color for a clean focus effect
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),

                    // 5. Add a modern icon
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: Colors.blueGrey,
                    ),

                    // 6. Ensure density is appropriate
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 16.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 14),
              Text(
                'Articles',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              // --- Article List ---
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : errorMessage != null
                  ? Center(
                      child: Text(
                        'Error: $errorMessage',
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  : buildArticleList([...activityArticles, ...foodArticles]),
              // --- END Of Articles List ---
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build the vertical ListView
  Widget buildArticleList(List<ArticleModel> articles) {
    if (articles.isEmpty) {
      return const Center(child: Text('No articles found.'));
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: articles.length,
      itemBuilder: (context, index) {
        // Pass the ArticleModel instance directly to the widget
        return ArticleCardWidget(article: articles[index]);
      },
    );
  }
}
