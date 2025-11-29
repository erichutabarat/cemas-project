package controllers

import (
	"net/http"
	
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	
	"deteksi_cemas_backend/models" // Using the user-provided module path
	"deteksi_cemas_backend/utils"
	"time"
)

// UserController struct holds dependencies like the database connection
type UserController struct {
	DB *gorm.DB
}

// NewUserController creates a new instance of UserController
func NewUserController(db *gorm.DB) *UserController {
	return &UserController{DB: db}
}

// GetProfile handles fetching the user's profile information.
// It uses the DB connection stored in the UserController struct.
func (uc *UserController) GetProfile(c *gin.Context) {
	// Assuming user ID is obtained from the context (e.g., from JWT claims)
	userID, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}
	
	var user models.User
	result := uc.DB.First(&user, userID)
	if result.Error != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}
	
	// Return user profile (excluding sensitive information like password)
	c.JSON(http.StatusOK, gin.H{
		"id":        user.ID,
		"email":     user.Email,
		"name":      user.Name,
		"birthdate": user.Birthdate,
		"gender":	user.Gender,
		"job":       user.Job,
		"address":   user.Address,
	})
}

// UpdateProfile handles updating the user's profile information.
func (uc *UserController) UpdateProfile(c *gin.Context) {
	// 1. Get user ID from JWT
	userID, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	// 2. Bind incoming JSON dynamically
	var input map[string]interface{}
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid JSON", "details": err.Error()})
		return
	}

	// 3. Fetch the user from DB
	var user models.User
	if err := uc.DB.First(&user, userID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	// 4. Update fields dynamically
	if pwd, ok := input["password"].(string); ok && pwd != "" {
		hashedPwd, err := utils.HashPassword(pwd)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to hash password"})
			return
		}
		user.Password = hashedPwd
	}

	if name, ok := input["name"].(string); ok && name != "" {
		user.Name = name
	}

	if birth, ok := input["birthdate"].(string); ok && birth != "" {
		parsedDate, err := time.Parse("2006-01-02", birth)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid birthdate format. Use YYYY-MM-DD"})
			return
		}
		user.Birthdate = parsedDate
	}

	if gender, ok := input["gender"].(string); ok && gender != "" {
		user.Gender = gender
	}

	if job, ok := input["job"].(string); ok {
		user.Job = &job
	}

	if address, ok := input["address"].(string); ok {
		user.Address = &address
	}

	// 5. Save the updated user
	if err := uc.DB.Save(&user).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update profile"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Profile updated successfully",
		"user": gin.H{
			"id":        user.ID,
			"email":     user.Email,
			"name":      user.Name,
			"birthdate": user.Birthdate,
			"gender":    user.Gender,
			"job":       user.Job,
			"address":   user.Address,
		},
	})
}

func (uc *UserController) GetHistory(c *gin.Context) {
	// 1. Get user ID from JWT
	userID, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	// 2. Fetch user's assessment history
	var inspections []models.Inspection
	if err := uc.DB.
		Preload("Result").          // <--- this loads result if exists
		Where("user_id = ?", userID).
		Find(&inspections).Error; err != nil {

		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch history"})
		return
	}

	var HarsResults []models.HarsResults
	columnsToSelect := []string{"ID", "CreatedAt", "user_id", "score", "level"}
	if err := uc.DB.Where("user_id = ?", userID).Select(columnsToSelect).Find(&HarsResults).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch HARS results"})
		return
	}
	
	// 3. Return the history
	c.JSON(http.StatusOK, gin.H{
		"inspections": inspections,
		"hars_results": HarsResults,
	})
}