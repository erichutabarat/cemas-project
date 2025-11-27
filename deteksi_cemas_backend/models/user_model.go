package models

import (
	"time"
)

type User struct {
	ID        uint      `gorm:"primaryKey" json:"id"`
	Email	  string   `gorm:"unique;not null" json:"email" binding:"required"`
	Password  string   `gorm:"not null" json:"-" binding:"required"`
	Name	  string   `gorm:"not null" json:"name" binding:"required"`
	Birthdate time.Time   `json:"birthdate" binding:"required"`
	Gender	string  `json:"gender" binding:"required"`
	Job       *string    `json:"job,omitempty"`    // optional
	Address   *string    `json:"address,omitempty"`// optional
	CreatedAt time.Time `json:"created_at"` // Added back for GORM
	UpdatedAt time.Time `json:"updated_at"`
}