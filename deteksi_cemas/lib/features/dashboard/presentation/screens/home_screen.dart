import 'package:deteksi_cemas/features/dashboard/data/article_data.dart';
import 'package:deteksi_cemas/features/dashboard/domain/models/article_model.dart';
import 'package:deteksi_cemas/features/dashboard/presentation/widgets/article_card.dart';
import 'package:deteksi_cemas/features/dashboard/presentation/widgets/header_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  // Declare the controller as nullable
  final ScrollController? controller;

  // Make the parameter nullable (ScrollController?) in the constructor
  // You should also remove 'required' unless you enforce it elsewhere.
  const HomeScreen({super.key, this.controller});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.red.shade400,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    // 💡 Use the full, unfiltered list of dummy data
    final List<ArticleModel> allArticles = dummyArticleData;
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.all(0),
        child: SingleChildScrollView(
          controller: widget.controller,
          child: Column(
            children: [
              HeaderCard(),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Search"),
                  hintText: "Search something here",
                ),
              ),
              SizedBox(height: 14),
              Text(
                'Articles',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              _buildVerticalCardList(allArticles),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build the vertical ListView
  Widget _buildVerticalCardList(List<ArticleModel> articles) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ArticleCardWidget(article: articles[index]),
        );
      },
    );
  }
}
