package controllers

import (
	"net/http"
	
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	
	"deteksi_cemas_backend/models" // Using the user-provided module path
)

type AdminController struct {
    DB *gorm.DB
}

func NewAdminController(db *gorm.DB) *AdminController {
    return &AdminController{DB: db}
}

// CountTotalUsers returns the total number of registered users
func (ac *AdminController) CountTotalUsers(c *gin.Context) {
    var count int64

    // Using Model(&models.User{}) ensures GORM targets the correct table
    if err := ac.DB.Model(&models.User{}).Count(&count).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not count users"})
        return
    }

    c.JSON(http.StatusOK, gin.H{
        "status":      "success",
        "total_users": count,
    })
}