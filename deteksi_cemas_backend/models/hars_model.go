package models

import "gorm.io/gorm"

type HarsQuestions struct {
    ID          int   `gorm:"primaryKey" json:"id"`
    Category    string `gorm:"not null" json:"category"`
    Question    string `gorm:"not null" json:"question"`
	QuestionId  *string `gorm:"column:question_id" json:"question_id"`
    SymptomType string `gorm:"not null" json:"symptom_type"`

    Options     []HarsOptions `gorm:"foreignKey:QuestionID" json:"options"`
}

type HarsOptions struct {
    ID         int    `gorm:"primaryKey" json:"id"`
    QuestionID int    `gorm:"not null" json:"question_id"` // Matches the foreign key
    Option     string `gorm:"not null" json:"option"`
    OptionId   string `gorm:"column:option_id" json:"option_id"`
    Score      int    `gorm:"not null" json:"score"` // Usually HARS options have scores (0-4)
}

type HarsResults struct {
	gorm.Model

	UserID int `gorm:"not null" json:"user_id" binding:"required"`
	Score int `gorm:"not null" json:"score" binding:"required"`
	Level string `gorm:"not null" json:"level" binding:"required"`

	User User `gorm:"foreignKey:UserID" json:"user,omitempty"`
}

type InformedConsent struct {
    gorm.Model
    // Explicitly match the EXACT type of users.id (bigint unsigned)
    UserID      uint   `gorm:"type:bigint unsigned;not null;index" json:"user_id" binding:"required"`
    PhoneNumber string `gorm:"not null" json:"phone_number" binding:"required"`
    Consent     bool   `gorm:"not null" json:"consent" binding:"required"`
    User        User   `gorm:"foreignKey:UserID" json:"user,omitempty"`
}