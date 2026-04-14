package routes

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"deteksi_cemas_backend/controllers"
)

// SetupFeedbackRoutes sets up the routes for feedback-related endpoints.
func SetupFeedbackRoutes(r *gin.Engine, db *gorm.DB) {
	feedbackController := controllers.NewFeedbackController(db)

	feedback := r.Group("/api/feedback")
	feedback.GET("/questions", feedbackController.GetFeedbackQuestions)
	feedback.POST("/submit", feedbackController.SubmitFeedback)
}