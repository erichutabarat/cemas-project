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
        &models.Guest{},
        &models.HarsResults{},
        &models.GuestHarsResults{},
        &models.HarsQuestions{},
        &models.HarsOptions{},
        &models.InformedConsent{},
        &models.Inspection{},
        &models.Result{},
        &models.RecommendationActivity{},
        &models.RecommendationFood{},
        &models.FeedbackQuestion{},
        &models.FeedbackResponse{},
        &models.JournalEntry{},
    )

    migrations.SeedHarsQuestions(db)

    // Seed Options second (Child)
    migrations.SeedHarsOptions(db)

    // Seed Feedback Questions
    migrations.SeedFeedbackQuestions(db)

    // -----------------------------------------------------------
    // OPTIMASI PERFORMA LOAD TEST
    // -----------------------------------------------------------
    var r *gin.Engine // <--- Declare 'r' here first!

    // Respect the GIN_MODE env var set in Docker
    if os.Getenv("GIN_MODE") == "release" {
        gin.SetMode(gin.ReleaseMode)
        r = gin.New() 
        log.Println("⚡ Running in High Performance Mode (Logger Disabled)")
    } else {
        // Standard development mode
        gin.SetMode(gin.DebugMode)
        r = gin.Default() 
        log.Println("🛠️ Running in Debug Mode (Logger Enabled)")
    }
    // -----------------------------------------------------------
    r.Use(gin.Recovery())
    r.Use(func(c *gin.Context) {
        c.Next()
        if len(c.Errors) > 0 {
            // Use log.Printf instead of fmt.Printf to ensure it hits Docker logs
            log.Printf("❌ HANDLER ERROR: %s", c.Errors.String())
        }
    })
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
    routes.SetupAdminRoutes(r, db)
    routes.SetupFeedbackRoutes(r, db)
    routes.SetupJournalRoutes(r, db)

    // 4. Run server
    log.Println("Server listening on :8080")
    if err := r.Run("0.0.0.0:8080"); err != nil {
        log.Fatalf("Server failed to start: %v", err)
    }

    // App run
}
