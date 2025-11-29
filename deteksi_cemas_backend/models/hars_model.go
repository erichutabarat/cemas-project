package models

import "gorm.io/gorm"

type HarsQuestions struct {
    ID          int   `gorm:"primaryKey" json:"id"`
    Category    string `gorm:"not null" json:"category"`
    Question    string `gorm:"not null" json:"question"`
    SymptomType string `gorm:"not null" json:"symptom_type"`
}

type HarsResults struct {
	gorm.Model

	UserID int `gorm:"not null" json:"user_id" binding:"required"`
	Score int `gorm:"not null" json:"score" binding:"required"`
	Level string `gorm:"not null" json:"level" binding:"required"`

	User User `gorm:"foreignKey:UserID" json:"user,omitempty"` // belongs to User
}