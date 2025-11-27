package utils

import (
	"crypto/rand"
	"encoding/base64"
	"golang.org/x/crypto/bcrypt"
)

// HashPassword generates a bcrypt hash of the plaintext password.
func HashPassword(password string) (string, error) {
	bytes, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	return string(bytes), err
}

// CheckPasswordHash compares a plaintext password with a hashed password.
func CheckPasswordHash(password, hash string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
	return err == nil
}

// GenerateAuthToken generates a simple, random authentication token.
// In a production application, this should be replaced with JWT generation.
func GenerateAuthToken() (string, error) {
	b := make([]byte, 32) // 32 bytes = 256 bits of entropy
	_, err := rand.Read(b)
	if err != nil {
		return "", err
	}
	// Use base64 to make it URL-safe and compact
	return base64.URLEncoding.EncodeToString(b), nil
}