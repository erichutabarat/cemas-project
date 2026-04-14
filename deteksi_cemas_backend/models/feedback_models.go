package models

import (
	"time"
	"gorm.io/gorm"
)

type FeedbackQuestion struct {
    ID        int       `gorm:"primaryKey" json:"id"`
    Text      string    `gorm:"not null" json:"text"`
    // Type can be "scale" (1-5) or "text"
    Type      string    `gorm:"not null;default:'scale'" json:"type"` 
    
    CreatedAt time.Time `json:"created_at"`
    UpdatedAt time.Time `json:"updated_at"`
}

type FeedbackResponse struct {
    gorm.Model

    GuestID            int       `gorm:"not null" json:"guest_id"`
    FeedbackQuestionID int       `gorm:"not null" json:"feedback_question_id"`
    Response           string    `gorm:"not null" json:"response"`

    Guest            Guest            `gorm:"foreignKey:GuestID" json:"guest,omitempty"`
    // Add constraint:OnDelete:CASCADE here
    FeedbackQuestion FeedbackQuestion `gorm:"foreignKey:FeedbackQuestionID;constraint:OnDelete:CASCADE;" json:"feedback_question,omitempty"`
}