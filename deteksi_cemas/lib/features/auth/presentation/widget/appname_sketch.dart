import 'package:flutter/material.dart';

Widget appNameSketch() {
  return Align(
    alignment: Alignment.topCenter,
    child: Padding(
      padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
      child: Text(
        "Deteksi Cemas",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              blurRadius: 4.0,
              color: Colors.black.withValues(alpha: 0.3),
              offset: Offset(2.0, 2.0),
            ),
          ],
        ),
      ),
    ),
  );
}
