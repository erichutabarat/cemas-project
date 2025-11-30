package main

import (
	"log"

	"github.com/gin-gonic/gin"
	"deteksi_cemas_backend/config"
	"deteksi_cemas_backend/migrations"
	"deteksi_cemas_backend/models"
	"deteksi_cemas_backend/routes"
)

func main() {
	// 1. Initialize the database connection and run migrations
	// We pass the models that need to be migrated (User)
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

	// 2. Initialize the Gin router
	r := gin.Default()

	// 2.5. Serve static files from the "uploads" directory
	r.Static("/uploads", "./uploads")
	
	// 3. Setup routes, passing the router and the DB instance
	routes.SetupAuthRoutes(r, db)
	routes.SetupAssessmentRoutes(r, db)
	routes.SetupUserRoutes(r, db)
	routes.SetupHeartbeatRoutes(r, db)
	routes.SetupRecommendationRoutes(r, db)

	// 4. Run the server on port 8080
	log.Println("Server listening on :8080")
	if err := r.Run("0.0.0.0:8080"); err != nil {
		log.Fatalf("Server failed to start: %v", err)
	}
}