package controllers

import (
	"net/http"
	"deteksi_cemas_backend/models"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type HeartbeatController struct{
	DB *gorm.DB
}

func NewHeartbeatController(db *gorm.DB) *HeartbeatController {
	return &HeartbeatController{DB: db}
}

func (hc *HeartbeatController) Upload(c *gin.Context) {
    userID, exists := c.Get("userID")
    if !exists {
        c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
        return
    }

    // ==== Step 1: Ambil file audio dari request ====
    file, err := c.FormFile("audio")
    if err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": "Audio file required"})
        return
    }

    // ==== Step 2: Simpan file lokal (boleh diganti cloud/minio later) ====
    filePath := "uploads/" + file.Filename
    if err := c.SaveUploadedFile(file, filePath); err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Upload failed"})
        return
    }

    // Audio URL (buat nanti ML server menggunakan di Analyze)
    audioUrl := "http://localhost:8080/" + filePath  

    // ==== Step 3: Simpan ke DB ====
    inspection := models.Inspection{
        UserID:   userID.(int),
        AudioUrl: audioUrl,
        Checked:  false,
    }

    if err := hc.DB.Create(&inspection).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save inspection"})
        return
    }

    c.JSON(http.StatusOK, gin.H{
        "message": "Audio uploaded successfully — pending analysis",
        "inspection_id": inspection.ID,
        "audio_url": audioUrl,
    })
}

func (hc *HeartbeatController) Analyze(c *gin.Context) {
    userID, exists := c.Get("userID")
    if !exists {
        c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
        return
    }

    // ==== Step 1: Ambil latest inspection ====
    var inspection models.Inspection
    if err := hc.DB.Where("user_id = ?", userID).
        Order("created_at DESC").
        First(&inspection).Error; err != nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "No inspection found"})
        return
    }

    // ==== Step 2: Kirim audio ke ML server ====
    // Dummy contoh, nanti tinggal call HTTP ke Python server
    // misal http.Post("http://ml-server/analyze", audioUrl)
    result := models.Result{
        InspectionID: inspection.ID,
        AnxietyScore: 40.5,
        AnxietyLevel: "Moderate",
        Hrv:          72,
        Bpm:          80,
        Confidence:   0.89,
    }

    // ==== Step 3: Simpan hasil ke DB ====
    if err := hc.DB.Create(&result).Error; err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save result"})
        return
    }

    // ==== Step 4: return ke user ====
    c.JSON(http.StatusOK, gin.H{
        "message": "Analysis completed",
        "result":  result,
    })
}
