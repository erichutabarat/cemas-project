import 'package:flutter/material.dart';

IconData getIconLevel(String level) {
  // Normalize the string to handle case sensitivity
  switch (level.toLowerCase()) {
    case 'normal':
      // A satisfied, calm face
      return Icons.sentiment_very_satisfied;

    case 'mild anxiety':
      // A neutral, slightly concerned face
      return Icons.sentiment_neutral;

    case 'moderate anxiety':
      // A dissatisfied/worried face
      return Icons.sentiment_dissatisfied;

    case 'severe anxiety':
      // A very worried or sad face
      return Icons.sentiment_very_dissatisfied;

    case 'very serious anxiety':
      // A face representing "sick" or "distressed"
      return Icons.sick;

    default:
      return Icons.help_outline;
  }
}
