package controllers

import (
	"fmt"
	"strconv"
	"github.com/gin-gonic/gin"
	"deteksi_cemas_backend/models"
	"gorm.io/gorm"
)

type FeedbackController struct {
	DB *gorm.DB
}

// NewFeedbackController creates a new instance of FeedbackController
func NewFeedbackController(db *gorm.DB) *FeedbackController {
	return &FeedbackController{DB: db}
}

func (fc *FeedbackController) GetFeedbackQuestions(c *gin.Context) {
	var questions []models.FeedbackQuestion
	if err := fc.DB.Find(&questions).Error; err != nil {
		c.JSON(500, gin.H{"error": "Failed to retrieve feedback questions"})
		return
	}
	c.JSON(200, questions)
}

func (fc *FeedbackController) SubmitFeedback(c *gin.Context) {
    var requestBody struct {
        Guest     models.Guest              `json:"guest" binding:"required"`
        Feedbacks []models.FeedbackResponse `json:"feedbacks" binding:"required"`
    }

    if err := c.ShouldBindJSON(&requestBody); err != nil {
        c.JSON(400, gin.H{"error": err.Error()})
        return
    }

    err := fc.DB.Transaction(func(tx *gorm.DB) error {
        // 1. Create the Guest
        if err := tx.Create(&requestBody.Guest).Error; err != nil {
            return err
        }

        // 2. Validate and Link Feedbacks
        for i := range requestBody.Feedbacks {
            // Find the question to check its type
            var question models.FeedbackQuestion
            if err := tx.First(&question, requestBody.Feedbacks[i].FeedbackQuestionID).Error; err != nil {
                return fmt.Errorf("question ID %d not found", requestBody.Feedbacks[i].FeedbackQuestionID)
            }

            // --- VALIDATION LOGIC ---
            if question.Type == "scale" {
                score, err := strconv.Atoi(requestBody.Feedbacks[i].Response)
                if err != nil || score < 1 || score > 5 {
                    return fmt.Errorf("question '%s' requires a score between 1-5, got: '%s'", question.Text, requestBody.Feedbacks[i].Response)
                }
            }
            // ------------------------

            requestBody.Feedbacks[i].GuestID = requestBody.Guest.ID
        }

        // 3. Batch insert
        return tx.Create(&requestBody.Feedbacks).Error
    })

    if err != nil {
        c.JSON(400, gin.H{"error": err.Error()})
        return
    }

    c.JSON(200, gin.H{"message": "Feedback submitted successfully"})
}