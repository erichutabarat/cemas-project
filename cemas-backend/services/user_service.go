package services

import (
	"cemas-backend/models"
	"time"
)

func GetUserByID(id int) (*models.UserProfile, error) {
	if id == 1 {
		birthdate, _ := time.Parse("2006-01-02", "2000-05-21")
		return &models.UserProfile{ // ✅ pointer
			ID:        1,
			Name:      "John Doe",
			Email:     "john@example.com",
			Gender:    "male",
			Birthdate: birthdate,
		}, nil
	}

	// ✅ return nil instead of an empty struct for "not found"
	return nil, nil
}
