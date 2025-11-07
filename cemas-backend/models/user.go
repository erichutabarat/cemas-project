package models

import "time"

// UserProfile defines the structure for user profile information.
type UserProfile struct {
	ID        uint      `json:"id"`
	Name      string    `json:"name"`
	Email     string    `json:"email"`
	Gender    string    `json:"gender"`
	Birthdate time.Time `json:"birthdate"`
	Job       *string    `json:"job,omitempty"`
	Address   *string    `json:"address,omitempty"`
}