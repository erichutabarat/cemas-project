package routes


import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"deteksi_cemas_backend/controllers"
	"deteksi_cemas_backend/middlewares"
)

func SetupAdminRoutes(router *gin.Engine, db *gorm.DB) {
	// create recommendation controller first
	recommendationController := controllers.NewRecommendationController(db)
	adminController := controllers.NewAdminController(db, recommendationController)

	adminGroup := router.Group("/api/admin")
	adminGroup.Use(middlewares.AdminOnly())

	adminGroup.GET("/users/statistics", adminController.Statistics)
	adminGroup.GET("/articles", adminController.GetAllArticles)
	adminGroup.POST("/articles/:type", adminController.CreateArticleByType)
	adminGroup.GET("/articles/:type/:id", adminController.GetArticleByTypeId)
	adminGroup.PUT("/articles/:type/:id", adminController.UpdateArticleByTypeId)
}