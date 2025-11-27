package models

import (
	"time"
)

type AuthLoginRequest struct{
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required"`
}

type AuthRegisterRequest struct{
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required,min=6"`
	Name     string `json:"name" binding:"required"`
	Birthdate time.Time `json:"birthdate" binding:"required"` // Expecting date in string format, e.g., "2006-01-02"
	Gender   string `json:"gender" binding:"required"`
	Job      *string `json:"job,omitempty"`     // optional
	Address  *string `json:"address,omitempty"` // optional
}