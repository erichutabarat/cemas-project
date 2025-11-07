package routers

import (
	"net/http"
	"cemas-backend/controllers"
)

// AssessmentRoutes registers all routes related to the self-assessment service.
func AssessmentRoutes(mux *http.ServeMux) {
	mux.HandleFunc("/api/assessment/questions", controllers.GetAssessmentQuestions)
	mux.HandleFunc("/api/assessment/submit", controllers.SubmitAssessment)
}