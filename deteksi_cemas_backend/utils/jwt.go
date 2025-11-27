package utils

import (
	"strings"
	"time"

	"github.com/golang-jwt/jwt/v4"
)

// JWT secret key (in production, use .env)
var jwtSecret = []byte("test_jwt_secret_key")

// GenerateJWT creates a signed JWT token with userID in claims
func GenerateJWT(userID int) (string, error) {
	claims := jwt.MapClaims{
		"userID": userID,
		"exp":    time.Now().Add(72 * time.Hour).Unix(), // expires in 72 hours
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString(jwtSecret)
}

// ValidateJWT parses the token and returns the userID
func ValidateJWT(tokenString string) (int, error) {
	tokenString = strings.TrimSpace(tokenString)
	if strings.HasPrefix(tokenString, "Bearer ") {
		tokenString = strings.TrimPrefix(tokenString, "Bearer ")
	}

	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		return jwtSecret, nil
	})
	if err != nil || !token.Valid {
		return 0, err
	}

	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok || claims["userID"] == nil {
		return 0, err
	}

	return int(claims["userID"].(float64)), nil
}
