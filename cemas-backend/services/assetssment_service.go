package services

import (
	"cemas-backend/models"
)

// GetAssessmentQuestions retrieves all HARS questions.
func GetAssessmentQuestions() ([]models.AssessmentQuestion, error) {
	// TODO: Implement logic to fetch all 14 HARS questions from the database.
	// For now, return dummy data:
	dummyQuestions := []models.AssessmentQuestion{
		// --- 14 Standard HARS Questions ---
		{ID: 1, Category: "Anxious Mood", Question: "Worrying, anticipation of the worst, fearful anticipation.", SymptomType: "Psychic"},
		{ID: 2, Category: "Tension", Question: "Feelings of tension, fatigability, startle response, moved to tears easily, trembling, feelings of restlessness.", SymptomType: "Psychic"},
		{ID: 3, Category: "Fears", Question: "Fear of dark, of strangers, of being left alone, of animals, of traffic, of crowds.", SymptomType: "Psychic"},
		{ID: 4, Category: "Insomnia", Question: "Difficulty in falling asleep, broken sleep, unsatisfying sleep and fatigue on waking, dreams, nightmares.", SymptomType: "Psychic"},
		{ID: 5, Category: "Intellectual", Question: "Difficulty in concentration, poor memory.", SymptomType: "Psychic"},
		{ID: 6, Category: "Depressed Mood", Question: "Loss of interest, lack of pleasure in hobbies, depression, early waking, diurnal swing.", SymptomType: "Psychic"},
		{ID: 7, Category: "Somatic (Muscular)", Question: "Pains and aches, twitching, stiffness, myoclonic jerks, grinding of teeth, unsteady voice, increased muscular tone.", SymptomType: "Somatic"},
		{ID: 8, Category: "Somatic (Sensory)", Question: "Tinnitus, blurring of vision, hot and cold flushes, feelings of weakness, pricking sensation.", SymptomType: "Somatic"},
		{ID: 9, Category: "Cardiovascular", Question: "Tachycardia, palpitations, pain in chest, throbbing of vessels, fainting feelings, missing beat.", SymptomType: "Somatic"},
		{ID: 10, Category: "Respiratory", Question: "Pressure or constriction in chest, choking feelings, sighing, dyspnea.", SymptomType: "Somatic"},
		{ID: 11, Category: "Gastrointestinal", Question: "Difficulty in swallowing, wind, abdominal pain, burning sensations, 'empty' feeling, nausea, vomiting, borborygmi, loose bowels, loss of weight, constipation.", SymptomType: "Somatic"},
		{ID: 12, Category: "Genitourinary", Question: "Frequency of micturition, urgency of micturition, amenorrhea, menorrhagia, development of frigidity, premature ejaculation, loss of libido, impotence.", SymptomType: "Somatic"},
		{ID: 13, Category: "Autonomic", Question: "Dry mouth, flushing, pallor, tendency to sweat, giddiness, tension headache, raising of hair.", SymptomType: "Somatic"},
		{ID: 14, Category: "Behavior at Interview", Question: "Fidgeting, restlessness or pacing, tremor of hands, furrowed brow, strained face, sighing or rapid respiration, facial pallor, swallowing, etc.", SymptomType: "Somatic"},

		// --- 6 Additional Anxiety Questions (from GAD-7/other) ---
		{ID: 15, Category: "General Anxiety", Question: "Feeling nervous, anxious, or on edge nearly every day.", SymptomType: "Psychic"},
		{ID: 16, Category: "General Anxiety", Question: "Not being able to stop or control worrying nearly every day.", SymptomType: "Psychic"},
		{ID: 17, Category: "General Anxiety", Question: "Feeling afraid, as if something awful might happen.", SymptomType: "Psychic"},
		{ID: 18, Category: "General Anxiety", Question: "Becoming easily annoyed or irritable.", SymptomType: "Psychic"},
		{ID: 19, Category: "Somatic", Question: "Feeling restless, making it hard to sit still.", SymptomType: "Somatic"},
		{ID: 20, Category: "Somatic", Question: "Experiencing headaches, stomach problems, or unexplained pains.", SymptomType: "Somatic"},
	}
	return dummyQuestions, nil
}

// CalculateAnxietyScore calculates the HARS score based on user answers.
func CalculateAnxietyScore(answers []models.AnswerRequest) (models.AssessmentResult, error) {
	var totalScore int
	for _, answer := range answers {
		totalScore += answer.Score
	}

	var anxietyLevel string
	if totalScore <= 17 {
		anxietyLevel = "Mild Anxiety"
	} else if totalScore <= 24 {
		anxietyLevel = "Moderate Anxiety"
	} else {
		anxietyLevel = "Severe Anxiety"
	}

	result := models.AssessmentResult{
		TotalScore:   totalScore,
		AnxietyLevel: anxietyLevel,
	}

	return result, nil
}