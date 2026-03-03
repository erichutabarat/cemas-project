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

// show statistics about users, hars results, inspections, and hars questions for admin dashboard
func (ac *AdminController) Statistics(c *gin.Context) {
    var countUsers int64
    var countHarsResults int64
    var countInspections int64
    var countHarsQuestions int64

    // Using Model(&models.User{}) ensures GORM targets the correct table
    if err := ac.DB.Model(&models.User{}).Count(&countUsers).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not count users"})
        return
    }

    if err := ac.DB.Model(&models.HarsResults{}).Count(&countHarsResults).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not count HARS results"})
        return
    }

    if err := ac.DB.Model(&models.Inspection{}).Count(&countInspections).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not count Inspections"})
        return
    }

    if err := ac.DB.Model(&models.HarsQuestions{}).Count(&countHarsQuestions).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not count HARS questions"})
        return
    }

    c.JSON(http.StatusOK, gin.H{
        "status":           "success",
        "total_users":      countUsers,
        "total_hars_results": countHarsResults,
        "total_inspections": countInspections,
        "total_hars_questions": countHarsQuestions,
    })
}