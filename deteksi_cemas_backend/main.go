package main

import (
	"log"
	"os"
    "time"
	"github.com/gin-gonic/gin"
    "github.com/gin-contrib/cors"
	"deteksi_cemas_backend/config"
	"deteksi_cemas_backend/migrations"
	"deteksi_cemas_backend/models"
	"deteksi_cemas_backend/routes"
)

func main() {
    // 1. Initialize DB
    db := config.InitDB(
        &models.User{},
        &models.HarsResults{},
        &models.HarsQuestions{},
        &models.Inspection{},
        &models.Result{},
        &models.RecommendationActivity{},
        &models.RecommendationFood{},
    )

    migrations.SeedHarsQuestions(db)

    // -----------------------------------------------------------
    // OPTIMASI PERFORMA LOAD TEST
    // -----------------------------------------------------------
    // Cek environment variable
    if os.Getenv("APP_ENV") == "local" {
        // 1. Set mode ke Release (mematikan log debug internal Gin)
        gin.SetMode(gin.ReleaseMode)
        log.Println("⚡ Running in High Performance Mode (Logs Disabled)")
    }
    
    var r *gin.Engine

    if os.Getenv("APP_ENV") == "local" {
        // 2. Gunakan gin.New() bukannya gin.Default()
        // gin.Default() = Logger + Recovery (Logger itu lambat!)
        // gin.New()     = Kosong (Sangat cepat)
        r = gin.New()
        r.Use(gin.Recovery()) // Tetap pakai Recovery agar tidak crash jika panic
        // Kita TIDAK pasang r.Use(gin.Logger()) agar terminal bersih
    } else {
        // Mode development biasa (pakai log)
        r = gin.Default()
    }
    // -----------------------------------------------------------

    r.Use(cors.New(cors.Config{
        AllowOrigins:     []string{"*"}, // Untuk development, buka semua
        AllowMethods:     []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
        AllowHeaders:     []string{"Origin", "Content-Type", "Authorization"},
        ExposeHeaders:    []string{"Content-Length"},
        AllowCredentials: true,
        MaxAge: 12 * time.Hour,
    }))
    // 2.5. Serve static files
    r.Static("/uploads", "./uploads")

    // 3. Setup routes
    routes.SetupAuthRoutes(r, db)
    routes.SetupAssessmentRoutes(r, db)
    routes.SetupUserRoutes(r, db)
    routes.SetupHeartbeatRoutes(r, db)
    routes.SetupRecommendationRoutes(r, db)

    // 4. Run server
    log.Println("Server listening on :8080")
    if err := r.Run("0.0.0.0:8080"); err != nil {
        log.Fatalf("Server failed to start: %v", err)
    }

    // App run
}