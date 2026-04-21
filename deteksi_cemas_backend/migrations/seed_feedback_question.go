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
        // ===== UEQ =====
        {Text: "Menyusahkan — Menyenangkan", Type: "scale", Category: "ueq"},
        {Text: "Sulit dipahami — Mudah dipahami", Type: "scale", Category: "ueq"},
        {Text: "Membosankan — Menarik", Type: "scale", Category: "ueq"},
        {Text: "Tidak efisien — Efisien", Type: "scale", Category: "ueq"},
        {Text: "Membingungkan — Jelas", Type: "scale", Category: "ueq"},
        {Text: "Tidak menarik — Atraktif", Type: "scale", Category: "ueq"},
        {Text: "Lambat — Cepat", Type: "scale", Category: "ueq"},
        {Text: "Tidak dapat diandalkan — Dapat diandalkan", Type: "scale", Category: "ueq"},
        {Text: "Rumit — Sederhana", Type: "scale", Category: "ueq"},
        {Text: "Tidak nyaman — Nyaman", Type: "scale", Category: "ueq"},
        {Text: "Kuno — Modern", Type: "scale", Category: "ueq"},
        {Text: "Tidak kreatif — Kreatif", Type: "scale", Category: "ueq"},
        {Text: "Tidak inovatif — Inovatif", Type: "scale", Category: "ueq"},
        {Text: "Tidak mendukung — Mendukung", Type: "scale", Category: "ueq"},
        {Text: "Buruk — Baik", Type: "scale", Category: "ueq"},
        {Text: "Tidak menyenangkan — Menyenangkan", Type: "scale", Category: "ueq"},
        {Text: "Sulit digunakan — Mudah digunakan", Type: "scale", Category: "ueq"},
        {Text: "Tidak praktis — Praktis", Type: "scale", Category: "ueq"},
        {Text: "Tidak fleksibel — Fleksibel", Type: "scale", Category: "ueq"},
        {Text: "Tidak aman — Aman", Type: "scale", Category: "ueq"},
        {Text: "Tidak memotivasi — Memotivasi", Type: "scale", Category: "ueq"},
        {Text: "Tidak menarik perhatian — Menarik perhatian", Type: "scale", Category: "ueq"},
        {Text: "Tidak profesional — Profesional", Type: "scale", Category: "ueq"},
        {Text: "Tidak intuitif — Intuitif", Type: "scale", Category: "ueq"},

        // ===== SUS =====
        {Text: "Saya berpikir akan sering menggunakan sistem ini", Type: "scale", Category: "sus"},
        {Text: "Saya merasa sistem ini terlalu rumit untuk digunakan", Type: "scale", Category: "sus"},
        {Text: "Saya merasa sistem ini mudah digunakan", Type: "scale", Category: "sus"},
        {Text: "Saya membutuhkan bantuan orang lain untuk menggunakan sistem ini", Type: "scale", Category: "sus"},
        {Text: "Saya merasa fitur-fitur dalam sistem ini terintegrasi dengan baik", Type: "scale", Category: "sus"},
        {Text: "Saya merasa terdapat banyak inkonsistensi dalam sistem ini", Type: "scale", Category: "sus"},
        {Text: "Saya merasa kebanyakan orang akan dapat mempelajari sistem ini dengan cepat", Type: "scale", Category: "sus"},
        {Text: "Saya merasa sistem ini membingungkan untuk digunakan", Type: "scale", Category: "sus"},
        {Text: "Saya merasa percaya diri saat menggunakan sistem ini", Type: "scale", Category: "sus"},
        {Text: "Saya perlu belajar banyak hal sebelum dapat menggunakan sistem ini", Type: "scale", Category: "sus"},

        // optional
        {Text: "Masukan (Kritik & Saran)", Type: "text", Category: "general"},
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