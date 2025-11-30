package routes

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"deteksi_cemas_backend/controllers"
)

func SetupRecommendationRoutes(r *gin.Engine, db *gorm.DB) {
	recommendationController := controllers.NewRecommendationController(db)
	
	recommendationRoutes := r.Group("/api/recommendations")
	{
		recommendationRoutes.GET("/activities", recommendationController.GetActivityRecommendations)
		recommendationRoutes.GET("/foods", recommendationController.GetFoodRecommendations)
		recommendationRoutes.POST("/upload/activity", recommendationController.UploadActivity)
		recommendationRoutes.POST("/upload/food", recommendationController.UploadFood)
	}
}