package migrations

import (
    "log"
    "deteksi_cemas_backend/models" // Update with your actual module path
    "gorm.io/gorm"
)

func SeedFeedbackQuestions(db *gorm.DB) {
    var count int64
    
    // Check if the table already has data
    db.Model(&models.FeedbackQuestion{}).Count(&count)
    if count > 0 {
        log.Println("FeedbackQuestions already seeded, skipping...")
        return
    }

    // Define the data to insert
    questions := []models.FeedbackQuestion{
        {Text: "UI/UX", Type: "scale"},
        {Text: "Fungsionalitas", Type: "scale"},
        {Text: "Fitur", Type: "scale"},
        {Text: "Kepuasan", Type: "scale"},
        {Text: "Masukan (Kritik & Saran)", Type: "text"}, // This one allows free text
    }

    // Use a transaction for better performance and safety
    err := db.Transaction(func(tx *gorm.DB) error {
        if err := tx.Create(&questions).Error; err != nil {
            return err
        }
        return nil
    })

    if err != nil {
        log.Fatalf("Could not seed FeedbackQuestions: %v", err)
    }

    log.Println("FeedbackQuestions seeded successfully.")
}