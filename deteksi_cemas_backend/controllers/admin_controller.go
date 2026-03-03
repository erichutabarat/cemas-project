package controllers

import (
	"net/http"
	"strconv"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	
	"deteksi_cemas_backend/models" // Using the user-provided module path
)

type AdminController struct {
    DB *gorm.DB
    RC *RecommendationController
}

func NewAdminController(db *gorm.DB, rc *RecommendationController) *AdminController {
	return &AdminController{
		DB: db,
		RC: rc,
	}
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

func (ac *AdminController) GetAllArticles(c *gin.Context) {
    var activityArticles []models.RecommendationActivity
    var foodArticles []models.RecommendationFood
    if err := ac.DB.Find(&activityArticles).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch activity articles"})
        return
    }
    if err := ac.DB.Find(&foodArticles).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch food articles"})
        return
    }
    total := len(activityArticles) + len(foodArticles)

    c.JSON(http.StatusOK, gin.H{
        "status": "success",
        "total_articles": total,
        "activity_articles": activityArticles,
        "food_articles": foodArticles,
    })
}

func (ac *AdminController) GetArticleByTypeId(c *gin.Context) {
    articleType := c.Param("type") // "activity" or "food"
    articleIDStr := c.Param("id")

    // Convert ID to integer
    articleID, err := strconv.Atoi(articleIDStr)
    if err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid article ID"})
        return
    }

    switch articleType {
    case "activity":
        var article models.RecommendationActivity
        if err := ac.DB.First(&article, articleID).Error; err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
            return
        }
        c.JSON(http.StatusOK, gin.H{
            "status":  "success",
            "article": article,
        })
    case "food":
        var article models.RecommendationFood
        if err := ac.DB.First(&article, articleID).Error; err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
            return
        }
        c.JSON(http.StatusOK, gin.H{
            "status":  "success",
            "article": article,
        })
    default:
        c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid article type"})
        return
    }
}

func (ac *AdminController) CreateArticleByType(c *gin.Context) {
    articleType := c.Param("type")
    switch articleType {
    case "activity":
        var req models.UploadActivityRequest
        if err := c.ShouldBind(&req); err != nil {
            c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request data", "details": err.Error()})
            return
        }

        // Save image using RecommendationController
        imageUrl, err := ac.RC.SaveFiles(c, req.ImageFile, "activities")
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
            return
        }

        activity := models.RecommendationActivity{
            Name:         req.Name,
            Description:  req.Description,
            AnxietyLevel: req.AnxietyLevel,
            ImageUrl:     imageUrl,
        }

        if err := ac.DB.Create(&activity).Error; err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save activity recommendation"})
            return
        }

        c.JSON(http.StatusOK, gin.H{"message": "Activity recommendation uploaded successfully", "activity": activity})

    case "food":
        var req models.UploadFoodRequest
        if err := c.ShouldBind(&req); err != nil {
            c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request data", "details": err.Error()})
            return
        }

        // Save image using RecommendationController
        imageUrl, err := ac.RC.SaveFiles(c, req.ImageFile, "foods")
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
            return
        }

        food := models.RecommendationFood{
            Name:         req.Name,
            Description:  req.Description,
            AnxietyLevel: req.AnxietyLevel,
            ImageUrl:     imageUrl,
        }

        if err := ac.DB.Create(&food).Error; err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save food recommendation"})
            return
        }

        c.JSON(http.StatusOK, gin.H{"message": "Food recommendation uploaded successfully", "food": food})

    default:
        c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid article type"})
        return
    }
}

func (ac *AdminController) UpdateArticleByTypeId(c *gin.Context) {
	articleType := c.Param("type") // "activity" or "food"
	articleIDStr := c.Param("id")

	// convert to int
	articleID, err := strconv.Atoi(articleIDStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid article ID"})
		return
	}

	switch articleType {
	case "activity":
		var req models.UpdateActivityRequest
		if err := c.ShouldBind(&req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request", "details": err.Error()})
			return
		}

		var activity models.RecommendationActivity
		if err := ac.DB.First(&activity, articleID).Error; err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "Activity not found"})
			return
		}

		// Update fields if provided
        if req.Name != "" {
            activity.Name = req.Name
        }
		if req.Description != "" {
			activity.Description = req.Description
		}
		if req.AnxietyLevel != "" {
			activity.AnxietyLevel = req.AnxietyLevel
		}

		// Update image if provided
		if req.ImageFile != nil {
			imageUrl, err := ac.RC.SaveFiles(c, req.ImageFile, "activities") // reuse RecommendationController
			if err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
				return
			}
			activity.ImageUrl = imageUrl
		}

		if err := ac.DB.Save(&activity).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update activity"})
			return
		}

		c.JSON(http.StatusOK, gin.H{"message": "Activity updated successfully", "activity": activity})

	case "food":
		var req models.UpdateFoodRequest
		if err := c.ShouldBind(&req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request", "details": err.Error()})
			return
		}

		var food models.RecommendationFood
		if err := ac.DB.First(&food, articleID).Error; err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "Food not found"})
			return
		}

		// Update fields if provided
        if req.Name != "" {
            food.Name = req.Name
        }
		if req.Description != "" {
			food.Description = req.Description
		}
		if req.AnxietyLevel != "" {
			food.AnxietyLevel = req.AnxietyLevel
		}

		// Update image if provided
		if req.ImageFile != nil {
			imageUrl, err := ac.RC.SaveFiles(c, req.ImageFile, "foods") // reuse RecommendationController
			if err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
				return
			}
			food.ImageUrl = imageUrl
		}

		if err := ac.DB.Save(&food).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update food"})
			return
		}

		c.JSON(http.StatusOK, gin.H{"message": "Food updated successfully", "food": food})

	default:
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid article type"})
	}
}