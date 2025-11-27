package models

type HarsQuestions struct {
	ID int `gorm:"primaryKey" json:"id"`
	Category string `gorm:"not null" json:"category" binding:"required"`
	Question string `gorm:"not null" json:"question" binding:"required"`
	Description string `json:"description,omitempty"`
}

type HarsResults struct {
	ID uint `gorm:"primaryKey" json:"id"`
	UserID uint `gorm:"not null" json:"user_id" binding:"required"`
	Score int `gorm:"not null" json:"score" binding:"required"`
	Level string `gorm:"not null" json:"level" binding:"required"`

	User User `gorm:"foreignKey:UserID" json:"user,omitempty"` // belongs to User
}