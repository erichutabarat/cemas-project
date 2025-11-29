package controllers

import (
	"net/http"
	
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	
	"deteksi_cemas_backend/models" // Using the user-provided module path
)

type AssessmentController struct {
	DB *gorm.DB
}

func NewAssessmentController(db *gorm.DB) *AssessmentController	{
	return &AssessmentController{DB: db}
}

func (ac *AssessmentController) GetQuestions(c *gin.Context){
	var questions []models.HarsQuestions
	if err := ac.DB.Find(&questions).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to retrieve questions"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"questions": questions})
}

func (ac *AssessmentController) SubmitAssessment(c *gin.Context){
	userID, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}
	var input struct {
		Score int     `json:"score" binding:"required"`
		Level string  `json:"level" binding:"required"`
	}
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input format or missing fields", "details": err.Error()})
		return
	}

	result := models.HarsResults{
		UserID: userID.(int),
		Score: input.Score,
		Level: input.Level,
	}
	
	if err := ac.DB.Create(&result).Error;  err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to submit assessment"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Assessment submitted successfully", "result": result})
}