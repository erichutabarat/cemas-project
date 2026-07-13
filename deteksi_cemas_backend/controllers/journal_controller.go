package controllers

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"

	"deteksi_cemas_backend/models" // Using the user-provided module path
)

// JournalController struct holds dependencies like the database connection
type JournalController struct {
	DB *gorm.DB
}

// NewJournalController creates a new instance of JournalController
func NewJournalController(db *gorm.DB) *JournalController {
	return &JournalController{DB: db}
}

// CreateJournal handles creating a new journal entry for the authenticated user.
func (jc *JournalController) CreateJournal(c *gin.Context) {
	// 1. Get user ID from JWT
	userID, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	// 2. Bind incoming JSON to a request struct
	var input struct {
		Mood    string `json:"mood" binding:"required"`
		Content string `json:"content" binding:"required"`
	}
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid JSON", "details": err.Error()})
		return
	}

	// 3. Build and save the entry
	entry := models.JournalEntry{
		UserID:  userID.(int),
		Mood:    input.Mood,
		Content: input.Content,
	}

	if err := jc.DB.Create(&entry).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save journal entry"})
		return
	}

	c.JSON(http.StatusCreated, entry)
}

// GetJournalHistory handles fetching the authenticated user's journal entries,
// most recent first.
func (jc *JournalController) GetJournalHistory(c *gin.Context) {
	// 1. Get user ID from JWT
	userID, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	// 2. Fetch this user's journal entries
	var entries []models.JournalEntry
	if err := jc.DB.
		Where("user_id = ?", userID).
		Order("created_at desc").
		Find(&entries).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch journal history"})
		return
	}

	// 3. Return a bare array, matching how the Flutter client decodes the
	// response (jsonDecode(response.body) as List).
	c.JSON(http.StatusOK, entries)
}

// DeleteJournal handles deleting a journal entry by ID, scoped to the
// authenticated user so one user can't delete another's entry.
func (jc *JournalController) DeleteJournal(c *gin.Context) {
	// 1. Get user ID from JWT
	userID, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	// 2. Parse the entry ID from the URL param
	idParam := c.Param("id")
	id, err := strconv.Atoi(idParam)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid journal ID"})
		return
	}

	// 3. Delete only if it belongs to this user
	result := jc.DB.
		Where("id = ? AND user_id = ?", id, userID).
		Delete(&models.JournalEntry{})

	if result.Error != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete journal entry"})
		return
	}

	if result.RowsAffected == 0 {
		c.JSON(http.StatusNotFound, gin.H{"error": "Journal entry not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Journal entry deleted successfully"})
}