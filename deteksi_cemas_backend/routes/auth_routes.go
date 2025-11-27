package routes

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"deteksi_cemas_backend/controllers"
)

// SetupAuthRoutes initializes and registers all authentication endpoints.
// It receives the Gin router and the database instance as parameters.
func SetupAuthRoutes(router *gin.Engine, db *gorm.DB) {
	// Create a new controller instance, passing the database connection (Dependency Injection)
	authController := controllers.NewAuthController(db)

	// Group routes under /api/auth
	auth := router.Group("/api/auth")
	{
		// POST /api/auth/register
		auth.POST("/register", authController.Register)
		// POST /api/auth/login
		auth.POST("/login", authController.Login)
	}

	// Example: A status route outside the auth group
	router.GET("/api/status", func(c *gin.Context) {
		c.JSON(200, gin.H{"status": "API is running and configured"})
	})
}