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
                if err != nil || score < 1 || score > 7 {
                    return fmt.Errorf("question '%s' requires a score between 1-7, got: '%s'", question.Text, requestBody.Feedbacks[i].Response)
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

func (fc *FeedbackController) GetFeedbackResponses(c *gin.Context) {
	category := c.Query("category")

	// DTO biar field clean
	type FeedbackResponseDTO struct {
		ID                 uint   `json:"id"`
		GuestID            int    `json:"guest_id"`
		FeedbackQuestionID int    `json:"feedback_question_id"`
		Response           string `json:"response"`
		QuestionText       string `json:"question_text"`
		Category           string `json:"category"`
	}

	var results []FeedbackResponseDTO

	query := fc.DB.
		Table("feedback_responses").
		Select(`
			feedback_responses.id,
			feedback_responses.guest_id,
			feedback_responses.feedback_question_id,
			feedback_responses.response,
			feedback_questions.text as question_text,
			feedback_questions.category
		`).
		Joins("JOIN feedback_questions ON feedback_questions.id = feedback_responses.feedback_question_id")

	// filter category
	if category != "" {
		query = query.Where("feedback_questions.category = ?", category)
	}

	if err := query.Scan(&results).Error; err != nil {
		c.JSON(500, gin.H{"error": "Failed to retrieve feedback responses"})
		return
	}

	c.JSON(200, results)
}