import 'package:deteksi_cemas/theme/color_list.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // 🎨 Base colors
  static const Color primary = Color(0xFF2563EB); // blue
  static const Color secondary = Color(0xFF22C55E); // green
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFEF4444);

  static final LinearGradient chillOcean = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ColorList.deepBlue, ColorList.emeraldBLue, ColorList.aquaCyan],
  );

  static const LinearGradient softChill = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [ColorList.lavenderGray, ColorList.aquaCyan],
  );

  static const LinearGradient softChillReversed = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [ColorList.aquaCyan, ColorList.lavenderGray],
  );

  static const LinearGradient pastelLagoon = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [ColorList.roseDusty, ColorList.lavenderGray],
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primary,
      secondary: secondary,
      surface: surface,
      error: error,
    ),

    scaffoldBackgroundColor: background,

    appBarTheme: const AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );
}
