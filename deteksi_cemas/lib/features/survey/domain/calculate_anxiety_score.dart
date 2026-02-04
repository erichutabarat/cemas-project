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

String getAnxietyLevel(int totalScore, List<AssessmentQuestion> questions) {
  // Get the dynamic total based on the actual options available
  int maxPossibleScore = calculateMaxPossibleScore(questions);

  if (maxPossibleScore == 0) return "No questions to assess";

  double scorePercentage = (totalScore / maxPossibleScore) * 100;

  // Anxiety level logic remains the same, but now based on a dynamic 100%
  if (scorePercentage <= 30) {
    return "No Anxiety";
  } else if (scorePercentage <= 45) {
    return "Mild Anxiety";
  } else if (scorePercentage <= 60) {
    return "Moderate Anxiety";
  } else {
    return "Severe Anxiety";
  }
}
