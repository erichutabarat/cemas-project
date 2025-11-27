package routes

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	
	"deteksi_cemas_backend/controllers" // Using the user-provided module path
	"deteksi_cemas_backend/middlewares"
)

// SetupUserRoutes sets up the user-related routes
func SetupUserRoutes(r *gin.Engine, db *gorm.DB) {
	userController := controllers.NewUserController(db)
	
	userRoutes := r.Group("/api/user")
	userRoutes.Use(middlewares.AuthMiddleware())
	{
		userRoutes.GET("/profile", userController.GetProfile)
	}
}