package routes

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"deteksi_cemas_backend/controllers"
	"deteksi_cemas_backend/middlewares"
)

// SetupHeartbeatRoutes sets up the routes for heartbeat-related endpoints.
func SetupHeartbeatRoutes(r *gin.Engine, db *gorm.DB) {
	heartbeatController := controllers.NewHeartbeatController(db)
	
	heartbeat := r.Group("/api/heartbeat")
	heartbeat.Use(middlewares.AuthMiddleware())
	{
		heartbeat.POST("/upload", heartbeatController.Upload)
		heartbeat.POST("/analyze", heartbeatController.Analyze)
	}
}