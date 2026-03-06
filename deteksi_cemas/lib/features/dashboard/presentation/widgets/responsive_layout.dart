import 'package:deteksi_cemas/theme/color_list.dart';
import 'package:flutter/material.dart';

Widget responsiveLayout({required Widget content}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth > 600) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [ColorList.lavenderGray, ColorList.aquaCyan],
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.antiAlias,
                child: content,
              ),
            ),
          ),
        );
      }

      return content;
    },
  );
}
