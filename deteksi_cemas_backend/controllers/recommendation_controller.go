package controllers

import (
	"net/http"
	"fmt"
	"path/filepath"
	"strings"
	"mime/multipart"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"deteksi_cemas_backend/models"
)

const MaxImageSize = 5 * 1024 * 1024 // 5 MB (5 megabytes)

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

func (rc *RecommendationController) SaveFiles(c *gin.Context, file *multipart.FileHeader, category string) (string, error) {
	contentType := file.Header.Get("Content-Type")
	if(!strings.HasPrefix(contentType, "image/")){
		return "", fmt.Errorf("Uploaded file is not an image")
	}

	if file.Size > MaxImageSize {
		// Calculate size in MB for a friendly error message
		maxMB := float64(MaxImageSize) / 1024 / 1024
		return "", fmt.Errorf("file size is too large. Maximum allowed size is %.1f MB", maxMB)
	}
	
	const uploadDir = "uploads"
	filename := filepath.Base(file.Filename)
	dst := filepath.Join(uploadDir, category, filename)

	// save files
	if err:= c.SaveUploadedFile(file, dst); err != nil {
		return "", fmt.Errorf("Failed to save file: %v", err)
	}

	// return save data
	return "/uploads/" + category + "/" + filename, nil
}

func (rc *RecommendationController) UploadActivity(c *gin.Context) {
	var req models.UploadActivityRequest
	if err := c.ShouldBind(&req); err != nil {
        // Use c.AbortWithStatusJSON for clearer error handling
        c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{
            "error":   "Invalid request data or missing form fields.",
            "details": err.Error(), // <-- SHOW THE REAL ERROR HERE
        })
        return
    }

	imageUrl, err := rc.SaveFiles(c, req.ImageFile, "activities")
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	
	activity := models.RecommendationActivity{
		Name:         req.Name,
		Description:  req.Description,
		AnxietyLevel: req.AnxietyLevel,
		ImageUrl:     imageUrl,
	}
	if err := rc.DB.Create(&activity).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save activity recommendation"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Activity recommendation uploaded successfully", "activity": activity})
}

func (rc *RecommendationController) UploadFood(c *gin.Context) {
	var req models.UploadFoodRequest
	if err := c.ShouldBind(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request data"})
		return
	}
	
	imageUrl, err := rc.SaveFiles(c, req.ImageFile, "foods")
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	
	food := models.RecommendationFood{
		Name:         req.Name,
		Description:  req.Description,
		AnxietyLevel: req.AnxietyLevel,
		ImageUrl:     imageUrl,
	}
	if err := rc.DB.Create(&food).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save food recommendation"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Food recommendation uploaded successfully", "food": food})
}