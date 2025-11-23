import 'package:flutter/material.dart';

class ArticleScreen extends StatefulWidget {
  final ScrollController? controller;
  const ArticleScreen({super.key, this.controller});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: widget.controller,
        child: Column(children: [Text("test")]),
      ),
    );
  }
}
