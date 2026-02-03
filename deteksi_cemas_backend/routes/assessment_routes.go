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

    // Base group: /api/assessment
    assessment := router.Group("/api/assessment")
    {
        // 1. Public Route: /api/assessment/questions
        assessment.GET("/questions", assessmentController.GetQuestions)

        // 2. All routes below this will use the AuthMiddleware
        assessment.Use(middlewares.AuthMiddleware())
        {
            // Path: /api/assessment/submit
            assessment.POST("/submit", assessmentController.SubmitAssessment)
            
            // Path: /api/assessment/result/:id
            assessment.DELETE("/result/:id", assessmentController.DeleteResult)

            // Path: /api/assessment/consent
            assessment.POST("/consent", assessmentController.SubmitInformedConsent)

            // Path: /api/assessment/consent
            assessment.GET("/consent", assessmentController.GetInformedConsent)

        }
    }
}