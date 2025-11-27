package models

type RecommendationActivity struct {
	ID          int    `gorm:"primaryKey" json:"id"`
	Name string `json:"name"`
	ImageUrl   string `json:"image_url"`
	Description string `json:"description"`
	AnxietyLevel string `json:"anxiety_level"`
}

type RecommendationFood struct{
	ID          int    `gorm:"primaryKey" json:"id"`
	Name string `json:"name"`
	ImageUrl   string `json:"image_url"`
	Description string `json:"description"`
	AnxietyLevel string `json:"anxiety_level"`
}