import 'package:deteksi_cemas/features/survey/data/models/assessment_questions_models.dart';

int calulateMxPossibleScore(int totalQuestions) {
  // list of questions
  const int maxScorePerQuestion = 4;
  return totalQuestions * maxScorePerQuestion;
}

String getAnxietyLevel(int totalScore, List<AssessmentQuestion> questions) {
  int maxPossibleScore = calulateMxPossibleScore(questions.length);
  if (maxPossibleScore == 0) return "No questions to assess";
  double scorePercentage = (totalScore / maxPossibleScore) * 100;

  // anxiety level
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
