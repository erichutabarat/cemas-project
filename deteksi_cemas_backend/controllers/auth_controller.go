package controllers

import (
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"

	"deteksi_cemas_backend/models" // Using the user-provided module path
	"deteksi_cemas_backend/utils"  // Using the user-provided module path
)

// AuthController struct holds dependencies like the database connection
type AuthController struct {
	DB *gorm.DB
}

// NewAuthController creates a new instance of AuthController
func NewAuthController(db *gorm.DB) *AuthController {
	return &AuthController{DB: db}
}

// Register handles new user registration.
// It uses the DB connection stored in the AuthController struct.
func (ac *AuthController) Register(c *gin.Context) {
	var input models.User
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input format or missing fields", "details": err.Error()})
		return
	}

	// 1. Check if email already exists
	var existingUser models.User
	result := ac.DB.Where("email = ?", input.Email).First(&existingUser)

	if result.RowsAffected > 0 {
		c.JSON(http.StatusConflict, gin.H{"error": "Email already registered"})
		return
	}

	// 2. Hash the password using the utility function
	hashedPassword, err := utils.HashPassword(input.Password)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not process password"})
		return
	}

	// 3. Create the new User object with all new fields
	newUser := models.User{
		Email:     input.Email,
		Password:  hashedPassword,
		Name:      input.Name,
		Birthdate: input.Birthdate,
		Gender:    input.Gender,
		Job:       input.Job,
		Address:   input.Address,
	}

	// 4. Save the user to the database
	if result := ac.DB.Create(&newUser); result.Error != nil {
		log.Printf("Database save error: %v", result.Error)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create user"})
		return
	}

	// 5. Success response
	c.JSON(http.StatusCreated, gin.H{
		"message": "User registered successfully",
		"user_id": newUser.ID,
		"name":    newUser.Name,
	})
}

// Login handles user authentication, now solely by Email.
func (ac *AuthController) Login(c *gin.Context) {
	var input models.AuthLoginRequest

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input format"})
		return
	}

	// 1. Find user by Email only
	var user models.User
	result := ac.DB.Where("email = ?", input.Email).First(&user)

	if result.Error != nil {
		// If no user is found, result.Error will be gorm.ErrRecordNotFound
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid email or password"})
		return
	}

	// 2. Check the password using the utility function
	if !utils.CheckPasswordHash(input.Password, user.Password) {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid email or password"})
		return
	}

	// 3. Generate a token
	token, err := utils.GenerateAuthToken()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to generate authentication token"})
		return
	}

	// 4. Success response
	c.JSON(http.StatusOK, gin.H{
		"message": "Login successful",
		"token":   token,
		"user_id": user.ID,
		"name":    user.Name,
	})
}