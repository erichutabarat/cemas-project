package controllers

import (
	"net/http"
	
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	
	"deteksi_cemas_backend/models" // Using the user-provided module path
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