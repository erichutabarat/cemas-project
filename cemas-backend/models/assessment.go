package models

// AssessmentQuestion is the struct for a single HARS question
type AssessmentQuestion struct {
	ID          int    `json:"id"`
	Category    string `json:"category"` // e.g., "Anxious Mood", "Tension"
	Question    string `json:"question"` // e.g., "Worrying, anticipation of the worst..."
	SymptomType string `json:"symptom_type"` // e.g., "Psychic" or "Somatic"
}

// AnswerRequest is the structure for a single answer submitted by the user
type AnswerRequest struct {
	QuestionID int `json:"question_id"`
	// HARS scores are 0=Not present, 1=Mild, 2=Moderate, 3=Severe, 4=Very Severe
	Score int `json:"score"` 
}

// AssessmentResult is the final calculated score and its meaning
type AssessmentResult struct {
	TotalScore   int    `json:"total_score"`
	AnxietyLevel string `json:"anxiety_level"` // e.g., "No Anxiety", "Mild", "Moderate", "Severe"
}