package routes

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"deteksi_cemas_backend/controllers"
	"deteksi_cemas_backend/middlewares"
)

// SetupAssessmentRoutes initializes and registers all assessment endpoints.
func SetupAssessmentRoutes(router *gin.Engine, db *gorm.DB) {
	assessmentController := controllers.NewAssessmentController(db)

	assessment := router.Group("/api/assessment")

	// Route tanpa middleware
	assessment.GET("/questions", assessmentController.GetQuestions)

	// Route dengan middleware
	assessment.POST("/submit", middlewares.AuthMiddleware(), assessmentController.SubmitAssessment)
}