import 'package:deteksi_cemas/features/survey/data/models/assessment_questions_models.dart';

int calculateMaxPossibleScore(List<AssessmentQuestion> questions) {
  int maxScore = 0;
  for (var question in questions) {
    for (var option in question.options) {
      // Sum the score of every possible symptom across all questions
      maxScore += option.score;
    }
  }
  return maxScore;
}

String getAnxietyLevel(int totalScore) {
  // Official HARS Scoring:
  // < 17 : Mild severity
  // 18 – 24 : Mild to moderate severity
  // 25 – 30 : Moderate to severe severity
  // > 30 : Severe/Very Serious

  // level that set and used in HARS Result Screen
  // < 13: Normal
  // 14-26: Mild Anxiety
  // 27-40: Moderate Anxiety
  // 41-53: Severe Anxiety
  // > 53: Very Serious Anxiety

  if (totalScore < 13) {
    return "Normal";
  } else if (totalScore <= 26) {
    return "Mild Anxiety";
  } else if (totalScore <= 40) {
    return "Moderate Anxiety";
  } else if (totalScore <= 53) {
    return "Severe Anxiety";
  } else {
    return "Very Serious Anxiety";
  }
}
