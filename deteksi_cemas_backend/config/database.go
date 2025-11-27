package config

import (
	"fmt"
	"log"
	"os"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"
	"github.com/joho/godotenv"
)

// InitDB initializes the MySQL connection and performs auto-migration.
// It returns the gorm.DB instance.
func InitDB(modelsToMigrate ...interface{}) *gorm.DB {
	err := godotenv.Load()
    if err != nil {
        log.Println("Warning: .env file not found, using system environment variables")
    }
	// IMPORTANT: Replace these placeholders with your actual MySQL credentials.
	// Ensure your database 'gin_auth_db' exists or change the name here.
	dsn := os.Getenv("DB_DSN") // ✅ use a variable


	db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}

	// Auto-Migrate the provided models to create/update tables
	if err := db.AutoMigrate(modelsToMigrate...); err != nil {
		log.Fatalf("Failed to migrate database: %v", err)
	}

	fmt.Println("Database connection and migration successful!")
	return db
}