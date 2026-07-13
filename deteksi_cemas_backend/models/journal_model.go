package models

import (
	"time"
)

// JournalEntry represents a single journal entry written by a user.
type JournalEntry struct {
	ID        int       `gorm:"primaryKey" json:"ID"`
	UserID    int       `gorm:"not null;index" json:"user_id"`
	Mood      string    `gorm:"not null" json:"mood" binding:"required"`
	Content   string    `gorm:"not null;type:text" json:"content" binding:"required"`
	CreatedAt time.Time `json:"CreatedAt"`
	UpdatedAt time.Time `json:"UpdatedAt"`
}