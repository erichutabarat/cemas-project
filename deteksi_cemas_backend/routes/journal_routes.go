package routes

import (
	"deteksi_cemas_backend/controllers" // Using the user-provided module path
	"deteksi_cemas_backend/middlewares"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// SetupJournalRoutes sets up the journal-related routes
func SetupJournalRoutes(r *gin.Engine, db *gorm.DB) {
	journalController := controllers.NewJournalController(db)
	journalRoutes := r.Group("/api/journal")
	journalRoutes.Use(middlewares.AuthMiddleware())
	{
		journalRoutes.POST("", journalController.CreateJournal)
		journalRoutes.GET("", journalController.GetJournalHistory)
		journalRoutes.DELETE("/:id", journalController.DeleteJournal)
	}
}