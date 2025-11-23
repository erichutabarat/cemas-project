import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  final ScrollController? controller;
  const SettingScreen({super.key, this.controller});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
