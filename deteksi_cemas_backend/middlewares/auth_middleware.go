package middlewares

import (
	"net/http"
	
	"github.com/gin-gonic/gin"
	"deteksi_cemas_backend/utils"
)

func AuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		userID, err := utils.ValidateJWT(authHeader)
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid or missing token"})
			c.Abort()
			return
		}

		c.Set("userID", userID)
		c.Next()
	}
}
