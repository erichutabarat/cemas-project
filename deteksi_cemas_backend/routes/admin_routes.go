package routes


import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"deteksi_cemas_backend/controllers"
	"deteksi_cemas_backend/middlewares"
)

func SetupAdminRoutes(router *gin.Engine, db *gorm.DB) {
	adminController := controllers.NewAdminController(db)

	adminGroup := router.Group("/api/admin")
	adminGroup.Use(middlewares.AdminOnly())

	adminGroup.GET("/users/statistics", adminController.Statistics)
}