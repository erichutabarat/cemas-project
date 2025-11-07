package controllers

import (
	"encoding/json"
	"net/http"
	"io"

	"cemas-backend/models"
	"cemas-backend/services"
)

// GetAssessmentQuestions handles GET /api/assessment/questions
func GetAssessmentQuestions(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	if r.Method != http.MethodGet {
		http.Error(w, `{"error": "method not allowed"}`, http.StatusMethodNotAllowed)
        return
	}
	
	// Call the service to get questions
	questions, err := services.GetAssessmentQuestions()
	if err != nil {
		http.Error(w, "Failed to get questions", http.StatusInternalServerError)
		return
	}

	json.NewEncoder(w).Encode(questions)
}

// SubmitAssessment handles POST /api/assessment/answers
func SubmitAssessment(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	if r.Method != http.MethodPost {
		http.Error(w, `{"error": "method not allowed"}`, http.StatusMethodNotAllowed)
        return
	}

	body, err := io.ReadAll(r.Body)
    if err != nil {
        http.Error(w, "Failed to read request body", http.StatusBadRequest)
        return
    }

	// The request body should be a JSON array of answers
    var answers []models.AnswerRequest
    if err := json.Unmarshal(body, &answers); err != nil {
        http.Error(w, "Invalid JSON: "+err.Error(), http.StatusBadRequest)
        return
    }

	// Call the service to calculate the score
	result, err := services.CalculateAnxietyScore(answers)
	if err != nil {
		http.Error(w, "Failed to calculate score", http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(result)
}