package config

import (
	"fmt"
	"log"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

// InitDB initializes the MySQL connection and performs auto-migration.
// It returns the gorm.DB instance.
func InitDB(modelsToMigrate ...interface{}) *gorm.DB {
	// IMPORTANT: Replace these placeholders with your actual MySQL credentials.
	// Ensure your database 'gin_auth_db' exists or change the name here.
	const DSN = "cemas_admin:Cemas_admin3532@tcp(127.0.0.1:3306)/cemas_db?charset=utf8mb4&parseTime=True&loc=Local"

	db, err := gorm.Open(mysql.Open(DSN), &gorm.Config{})
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