package config

import (
    "database/sql"
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
    _ = godotenv.Load()

    dsn := fmt.Sprintf(
        "%s:%s@tcp(%s:%s)/%s?charset=utf8mb4&parseTime=True&loc=Local",
        os.Getenv("DB_USER"),
        os.Getenv("DB_PASSWORD"),
        os.Getenv("DB_HOST"),
        os.Getenv("DB_PORT"),
        os.Getenv("DB_NAME"),
    )

    var (
        db    *gorm.DB
        sqlDB *sql.DB
        err   error
    )

    maxRetries := 10
    retryDelay := 2 * time.Second

    for i := 1; i <= maxRetries; i++ {
        log.Printf("Connecting to database... (%d/%d)", i, maxRetries)

        db, err = gorm.Open(mysql.Open(dsn), &gorm.Config{
            Logger: logger.Default.LogMode(logger.Silent),
        })
        if err != nil {
            log.Printf("GORM open failed: %v", err)
            time.Sleep(retryDelay)
            continue
        }

        sqlDB, err = db.DB()
        if err != nil {
            log.Printf("sql.DB failed: %v", err)
            time.Sleep(retryDelay)
            continue
        }

        err = sqlDB.Ping() // ✅ NO pingErr
        if err == nil {
            log.Println("Database connected successfully")
            break
        }

        log.Printf("Database not ready: %v", err)
        time.Sleep(retryDelay)
    }

    if err != nil {
        log.Fatalf("Failed to connect to database after %d attempts: %v", maxRetries, err)
    }

    // Connection pool
    sqlDB.SetMaxIdleConns(50)
    sqlDB.SetMaxOpenConns(100)
    sqlDB.SetConnMaxLifetime(1 * time.Hour)

    if err := db.AutoMigrate(modelsToMigrate...); err != nil {
        log.Fatalf("Migration failed: %v", err)
    }

    return db
}
