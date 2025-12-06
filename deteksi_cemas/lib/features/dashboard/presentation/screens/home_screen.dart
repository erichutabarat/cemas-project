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
              quickMenu(context),
              SizedBox(height: 20),
              // --- Articles Section ---
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

  Widget quickMenu(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              spreadRadius: -5,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Quick Menu",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // GRID STYLE
            Row(
              children: [
                Expanded(
                  child: _quickItem(
                    icon: Icons.auto_graph_rounded,
                    label: "Heartbeat Analyze",
                    color: Colors.red.shade300,
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _quickItem(
                    icon: Icons.assignment_rounded,
                    label: "Anxiety Survey (HARS)",
                    color: Colors.red.shade300,
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _quickItem(
                    icon: Icons.history_rounded,
                    label: "User History",
                    color: Colors.red.shade300,
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _quickItem(
                    icon: Icons.today,
                    label: "Today Activity Planner",
                    color: Colors.red.shade300,
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
