package controllers

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"time"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type AudioController struct {
	DB *gorm.DB
}

func NewAudioController(db *gorm.DB) *AudioController {
	return &AudioController{DB: db}
}

func (ctrl *AudioController) UploadAudio(c *gin.Context) {
	// 1. Create unique filename
	timestamp := time.Now().Format("20060102-150405")
	filename := fmt.Sprintf("rec_%s.wav", timestamp)
	filePath := fmt.Sprintf("./uploads/%s", filename)

	// 2. Open destination file
	dst, err := os.Create(filePath)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create file on server"})
		return
	}
	defer dst.Close()

	// 3. Stream binary body from ESP32 to file
	// Since ESP32 sends raw bytes, we use c.Request.Body
	written, err := io.Copy(dst, c.Request.Body)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save audio data"})
		return
	}

	// (Optional) Save record to DB if you have an Audio model
	// ctrl.DB.Create(&models.Audio{Filename: filename, Size: written})

	c.JSON(http.StatusOK, gin.H{
		"message": "Upload successful",
		"file":    filename,
		"size":    written,
	})
}