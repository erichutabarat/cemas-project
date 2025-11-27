package main

import (
	"log"

	"github.com/gin-gonic/gin"
	"deteksi_cemas_backend/config"
	"deteksi_cemas_backend/models"
	"deteksi_cemas_backend/routes"
)

func main() {
	// 1. Initialize the database connection and run migrations
	// We pass the models that need to be migrated (User)
	db := config.InitDB(&models.User{})

	// 2. Initialize the Gin router
	r := gin.Default()

	// 3. Setup routes, passing the router and the DB instance
	routes.SetupAuthRoutes(r, db)

	// 4. Run the server on port 8080
	log.Println("Server listening on :8080")
	if err := r.Run(":8080"); err != nil {
		log.Fatalf("Server failed to start: %v", err)
	}
}