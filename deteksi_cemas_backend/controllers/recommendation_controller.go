package controllers

import (
	"net/http"
	
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"deteksi_cemas_backend/models"
)

type RecommendationController struct {
	DB *gorm.DB
}

func NewRecommendationController(db *gorm.DB) *RecommendationController {
	return &RecommendationController{DB: db}
}

func (rc *RecommendationController) GetActivityRecommendations(c *gin.Context) {
	var activities []models.RecommendationActivity

	if err := rc.DB.Find(&activities).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch activity recommendations"})
		return
	}
	
	c.JSON(http.StatusOK, activities)
}

func (rc *RecommendationController) GetFoodRecommendations(c *gin.Context) {
	var foods []models.RecommendationFood
	
	if err := rc.DB.Find(&foods).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch food recommendations"})
		return
	}
	
	c.JSON(http.StatusOK, foods)
}