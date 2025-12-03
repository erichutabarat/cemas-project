package models

import "mime/multipart"

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

type UploadActivityRequest struct {	
	// Text Fields: Bind the form values
    Name         string `form:"name" binding:"required"`
    Description  string `form:"description" binding:"required"`
    AnxietyLevel string `form:"anxiety_level" binding:"required"`
    
	// File Field: Captures the uploaded image file
    ImageFile    *multipart.FileHeader `form:"image" binding:"required"`
}

type UploadFoodRequest struct {
	// Text Fields: Bind the form values
    Name         string `form:"name" binding:"required"`
    Description  string `form:"description" binding:"required"`
    AnxietyLevel string `form:"anxiety_level" binding:"required"`
    
	// File Field: Captures the uploaded image file
    ImageFile    *multipart.FileHeader `form:"image" binding:"required"`
}