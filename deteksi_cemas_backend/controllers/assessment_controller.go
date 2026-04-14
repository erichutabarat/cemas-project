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
	if err := ac.DB.Preload("Options").Find(&questions).Error; err != nil {
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

func (ac *AssessmentController) SubmitGuestAssessment(c *gin.Context) {
	var input struct {
		Email  string `json:"email" binding:"required,email"`
		Name   string `json:"name" binding:"required"`
		Gender string `json:"gender" binding:"required"`
		Age    int    `json:"age" binding:"required"`

		Score int    `json:"score" binding:"required"`
		Level string `json:"level" binding:"required"`
	}

	// Validate request
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error":   "Invalid input format or missing fields",
			"details": err.Error(),
		})
		return
	}

	// Create guest
	guest := models.Guest{
		Email:  input.Email,
		Name:   input.Name,
		Gender: input.Gender,
		Age:    input.Age,
	}

	if err := ac.DB.Create(&guest).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": "Failed to create guest",
		})
		return
	}

	// Create assessment result
	result := models.GuestHarsResults{
		GuestID: guest.ID,
		Score:   input.Score,
		Level:   input.Level,
	}

	if err := ac.DB.Create(&result).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": "Failed to submit assessment",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Guest assessment submitted successfully",
		"guest":   guest,
		"result":  result,
	})
}

func (ac *AssessmentController) DeleteResult(c *gin.Context) {
    id := c.Param("id")
	
    userID, exists := c.Get("userID")
    if !exists {
        c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
        return
    }

    var result models.HarsResults
    dbResult := ac.DB.Where("id = ? AND user_id = ?", id, userID).First(&result)
    
    if dbResult.Error != nil {
        if dbResult.Error == gorm.ErrRecordNotFound {
            c.JSON(http.StatusNotFound, gin.H{"error": "Result not found or you don't have permission"})
        } else {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
        }
        return
    }

    if err := ac.DB.Delete(&result).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete result"})
        return
    }

    c.JSON(http.StatusOK, gin.H{"message": "Assessment result deleted successfully"})
}

func (ac *AssessmentController) GetInformedConsent(c *gin.Context) {
    userID, exists := c.Get("userID")
    if !exists {
        c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
        return
    }

    var consent models.InformedConsent
    err := ac.DB.Where("user_id = ?", userID).First(&consent).Error

    if err != nil {
        // If the record simply doesn't exist
        if err == gorm.ErrRecordNotFound {
            c.JSON(http.StatusNotFound, gin.H{
                "message": "No informed consent found for this user",
                "exists":  false,
            })
            return
        }

        // If it's a real database crash/connection issue
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error occurred"})
        return
    }

    // Success
    c.JSON(http.StatusOK, gin.H{
        "exists":           true,
        "informed_consent": consent,
    })
}

func (ac *AssessmentController) SubmitInformedConsent(c *gin.Context) {
	userID, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}
	var input struct {
		PhoneNumber string `json:"phone_number" binding:"required"`
		Consent     bool   `json:"consent" binding:"required"`
	}
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input format or missing fields", "details": err.Error()})
		return
	}
	
	consent := models.InformedConsent{
		// First assert as int, then convert to uint
		UserID:      uint(userID.(int)), 
		PhoneNumber: input.PhoneNumber,
		Consent:     input.Consent,
	}
	if err := ac.DB.Create(&consent).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to submit informed consent"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Informed consent submitted successfully", "informed_consent": consent})
}

func (ac *AssessmentController) GetAllGuestResults(c *gin.Context) {
	var results []models.GuestHarsResults

	if err := ac.DB.
		Preload("Guest").
		Order("created_at DESC").
		Find(&results).Error; err != nil {

		c.JSON(http.StatusInternalServerError, gin.H{
			"error": "Failed to fetch guest assessment results",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Guest results retrieved successfully",
		"data": results,
	})
}