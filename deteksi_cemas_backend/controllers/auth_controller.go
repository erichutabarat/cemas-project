package controllers

import (
	"os"
    "context"
	"net/http"
	"log"
	"strings"
	"github.com/gin-gonic/gin"
    "github.com/joho/godotenv"
	"gorm.io/gorm"
	"google.golang.org/api/idtoken"

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
	var input models.AuthRegisterRequest
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error":   "Invalid input format or missing fields",
			"details": err.Error(),
		})
		return
	}

	// 1. Check if email already exists
	var existingUser models.User
	result := ac.DB.Where("email = ?", input.Email).First(&existingUser)
	if result.RowsAffected > 0 {
		// TODO: CHANGE RESPONSE CODE TO 409 CONFLICT, FOR PERFORMANCE TESTING
		c.JSON(http.StatusCreated, gin.H{"error": "Email already registered"})
		return
	}

	// 2. Hash the password
	hashedPassword, err := utils.HashPassword(input.Password)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not process password"})
		return
	}

	// 3. Create new User object
	newUser := models.User{
		Email:     input.Email,
		Password:  hashedPassword,
		Name:      input.Name,
		Birthdate: input.Birthdate,
		Gender:    input.Gender,
		Job:       input.Job,
		Address:   input.Address,
	}

	// 4. Save to DB
	if result := ac.DB.Create(&newUser); result.Error != nil {
   	 // Check if the error is a duplicate entry (MySQL Error 1062)
	    if isDuplicateEntryError(result.Error) {
       	       log.Printf("⚠️ Race condition handled: Duplicate entry for %s", newUser.Email)
       	       c.JSON(http.StatusCreated, gin.H{
       	         "message": "User already registered (Handled)",
       	         "user_id": 0,
       	 })
       	 return
    	}

   	 log.Printf("❌ ACTUAL DATABASE ERROR: %v", result.Error)
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
	token, err := utils.GenerateJWT(user.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to generate token"})
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

// GoogleLogin handles the verification of Google ID Tokens
func (ac *AuthController) GoogleLogin(c *gin.Context) {
	_ = godotenv.Load()
    var input struct {
        IDToken string `json:"id_token" binding:"required"`
    }

    if err := c.ShouldBindJSON(&input); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": "ID Token is required"})
        return
    }

    // Fetch Client ID from environment
    googleClientID := os.Getenv("GOOGLE_CLIENT_ID")
	if googleClientID == "" {
        log.Println("ERROR: GOOGLE_CLIENT_ID not set in .env")
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Server configuration error"})
        return
    }
    // 1. Verify the token with Google using the env variable
    payload, err := idtoken.Validate(context.Background(), input.IDToken, googleClientID)
    if err != nil {
        log.Printf("Google Token Validation Error: %v", err)
        c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid Google token"})
        return
    }

    // 2. Extract info from Google Payload
    email := payload.Claims["email"].(string)
    name := payload.Claims["name"].(string)

    // 3. Check if user exists in database
    var user models.User
    err = ac.DB.Where("email = ?", email).First(&user).Error

    if err != nil {
        if err == gorm.ErrRecordNotFound {
            // USER NOT FOUND: Return data so Flutter can show registration form
            c.JSON(http.StatusOK, gin.H{
                "registered": false,
                "email":      email,
                "name":       name,
                "message":    "User not found, please register",
            })
            return
        }
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
        return
    }

    // 4. USER EXISTS: Generate your system's JWT (Login)
    token, err := utils.GenerateJWT(user.ID)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to generate token"})
        return
    }

    c.JSON(http.StatusOK, gin.H{
        "registered": true,
        "token":      token,
        "user_id":    user.ID,
        "name":       user.Name,
        "message":    "Login successful",
    })
}

// Helper function to check for MySQL Duplicate Entry error
func isDuplicateEntryError(err error) bool {
    if err == nil {
        return false
    }
    // Error 1062 is the specific MySQL code for Unique Constraint violation
    return  appendErrorCheck(err, "1062")
}

// Low-level string check to avoid complex type assertions during load test
func appendErrorCheck(err error, code string) bool {
    // Alternatively, just add "strings" to your imports at the top
    return strings.Contains(err.Error(), code)
}
