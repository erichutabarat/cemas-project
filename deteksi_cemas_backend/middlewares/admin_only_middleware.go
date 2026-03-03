package middlewares

import (

	"strconv"

	"github.com/gin-gonic/gin"

	"deteksi_cemas_backend/utils"
)

func AdminOnly() gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		userID, err := utils.ValidateJWT(authHeader)
		if err != nil {
			c.JSON(403, gin.H{"error": "Access denied: Admins only"})
			c.Abort()
			return
		}

		if userID != 6786 {
			c.JSON(403, gin.H{
				"error": "Access denied: Admins only, " + strconv.Itoa(userID) + " is not an admin",
			})
			c.Abort()
			return
		}

		c.Next()
	}
}