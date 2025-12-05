package config

import (
	"fmt"
	"log"
	"os"
	"time"

	"gorm.io/gorm/logger"

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

    dsn := os.Getenv("DB_DSN")

    // 1. Buka koneksi GORM
    db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{
        // Opsional: Matikan log SQL saat load test agar tidak membebani I/O console
        Logger: logger.Default.LogMode(logger.Silent), 
    })
    if err != nil {
        log.Fatalf("Failed to connect to database: %v", err)
    }

    // ---------------------------------------------------------
    // 2. OPTIMASI CONNECTION POOL (BAGIAN PENTING)
    // ---------------------------------------------------------
    sqlDB, err := db.DB() // Ambil objek database generic (database/sql)
    if err != nil {
        log.Fatalf("Failed to get generic database object: %v", err)
    }

    // SetMaxIdleConns: Jumlah koneksi yang "standby" menunggu dipakai.
    // Jangan biarkan default (2). Set angka ini sama atau mendekati MaxOpen.
    sqlDB.SetMaxIdleConns(50)

    // SetMaxOpenConns: Jumlah maksimal koneksi yang boleh dibuka ke MySQL.
    // Mencegah aplikasi membuka ribuan koneksi yang bisa mematikan database.
    sqlDB.SetMaxOpenConns(100)

    // SetConnMaxLifetime: Seberapa lama koneksi boleh hidup sebelum didaur ulang.
    // Ini penting agar koneksi tidak "stale" (basi).
    sqlDB.SetConnMaxLifetime(1 * time.Hour)
    // ---------------------------------------------------------

    // 3. Auto-Migrate
    if err := db.AutoMigrate(modelsToMigrate...); err != nil {
        log.Fatalf("Failed to migrate database: %v", err)
    }

    fmt.Println("Database connection established with optimized pool settings!")
    return db
}