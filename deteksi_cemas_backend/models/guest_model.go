package models

import (
	"time"
	"gorm.io/gorm"
)

type Guest struct {
	ID        int       `gorm:"primaryKey" json:"id"`
	Email     string    `gorm:"not null" json:"email"`
	Name      string    `gorm:"not null" json:"name"`
	Gender    string    `json:"gender"`
	Age       int       `json:"age"`

	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`

	HarsResults []GuestHarsResults `gorm:"foreignKey:GuestID" json:"hars_results,omitempty"`
}

type GuestHarsResults struct {
	gorm.Model

	GuestID int    `gorm:"not null" json:"guest_id"`
	Score   int    `gorm:"not null" json:"score"`
	Level   string `gorm:"not null" json:"level"`

	Guest Guest `gorm:"foreignKey:GuestID" json:"guest,omitempty"`
}