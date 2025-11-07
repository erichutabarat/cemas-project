package services

import (
    "time"
	"errors"
    "cemas-backend/models"
	"cemas-backend/validators"
)

// Handle user registration
func Register(email string, password string, name string, gender string, birthdate time.Time) (models.AuthResponse, error) {
	if email == "" || password == "" || name == "" || gender == "" || birthdate.IsZero() {
		return models.AuthResponse{
			Token: "",
        	Message: "Registration Failed, all fields are required",
		}, errors.New("All fields are required")
	}
	if err := validators.ValidateEmail(email); err != nil{
		return models.AuthResponse{
			Token: "",
        	Message: "Registration Failed, invalid email",
		}, errors.New("Invalid Email")
	}
    return models.AuthResponse{
        Token: "TODO_JWT_TOKEN",
        Message: "Registration OK (TODO)",
    }, nil
}


// Handle user login
func Login(email string, password string) (models.AuthResponse, error) {
	if email == "" || password == "" {
		return models.AuthResponse{
			Token: "",
			Message: "Login Failed",
		}, errors.New("All fields are required")
	}
	if err := validators.ValidateEmail(email); err != nil{
		return models.AuthResponse{
			Token: "",
        	Message: "Login Failed, invalid email",
		}, errors.New("Invalid Email")
	}
    return models.AuthResponse{
        Token: "TODO_JWT_TOKEN",
        Message: "Login OK (TODO)",
    }, nil 
}