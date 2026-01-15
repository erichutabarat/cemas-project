package routes

import (
	"deteksi_cemas_backend/controllers"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func SetupAudioRoutes(router *gin.Engine, db *gorm.DB) {
	audioController := controllers.NewAudioController(db)

	// Group routes under /api
	// Your ESP32 is looking for /api/upload
	api := router.Group("/api")
	{
		api.POST("/upload", audioController.UploadAudio)
	}
}