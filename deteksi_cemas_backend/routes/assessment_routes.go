package routes

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"deteksi_cemas_backend/controllers"
)

// SetupAssessmentRoutes initializes and registers all assessment endpoints.
func SetupAssessmentRoutes(router *gin.Engine, db *gorm.DB){
	// Create a new controller instance, passing the database connection (Dependency Injection)
	assessmentController := controllers.NewAssessmentController(db)
	
	// Group routes under /api/assessment
	assessment := router.Group("/api/assessment")
	{
		// POST /api/assessment/question
		assessment.GET("/questions", assessmentController.GetQuestions)
		// POST /api/assessment/submit
		assessment.POST("/submit", assessmentController.SubmitAssessment)
	}
}