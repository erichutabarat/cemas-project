import 'package:flutter/material.dart';

Widget responsiveLayout({required Widget content}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      // Desktop/Tablet view (Width > 600px)
      if (constraints.maxWidth > 600) {
        return Container(
          color: Theme.of(
            context,
          ).scaffoldBackgroundColor, // Background for the "empty" sides
          child: Center(
            child: FractionallySizedBox(
              widthFactor: 0.5, // Takes up 70% of the screen width
              child: content,
            ),
          ),
        );
      }

      // Mobile view (Full width)
      return content;
    },
  );
}
