package controllers

import (
	"bytes"
	"deteksi_cemas_backend/models"
	"deteksi_cemas_backend/utils"
	"encoding/json"
	"fmt"
	"math"
	"net/http"
	"os"
	"path"
	"strconv"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"gorm.io/datatypes"
	"gorm.io/gorm"
)

type HeartbeatController struct {
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

	// ==== PERMANENT PERMISSION FIXES ====
	os.Chmod(filePath, 0644)
	os.Chmod("uploads", 0755)

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
		"message":       "Audio uploaded successfully — pending analysis",
		"inspection_id": inspection.ID,
		"audio_url":     audioUrl,
	})
}

func (hc *HeartbeatController) Analyze(c *gin.Context) {
	userID, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	// ===== Step 1: Read request body =====
	var req struct {
		InspectionID uint `json:"inspection_id"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request body"})
		return
	}

	// ===== Step 2: Find inspection by ID + user =====
	var inspection models.Inspection
	if err := hc.DB.Where("id = ? AND user_id = ?", req.InspectionID, userID).
		First(&inspection).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Inspection not found for this user"})
		return
	}

	// ===== Step 3: Call heartbeat-api =====
	// Inspection only stores AudioUrl (a full URL), not a bare relative
	// path, so we derive the relative path heartbeat-api needs from it.
	audioPath := extractAudioPath(inspection.AudioUrl)

	prediction, err := callHeartbeatAPI(inspection.ID, audioPath)
	if err != nil {
		c.JSON(http.StatusBadGateway, gin.H{"error": "Analysis failed: " + err.Error()})
		return
	}

	// ===== Step 4: Save result =====
	classScoresJSON, err := json.Marshal(prediction.ClassScores)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to serialize class scores"})
		return
	}
	classScores := datatypes.JSON(classScoresJSON)

	// softmaxConfidence gives a rough 0-1 "confidence" for display purposes.
	// This is NOT a calibrated probability -- the SVM was trained with
	// probability=False, so class_scores are raw decision-function
	// distances, not probabilities. Treat this as an approximation only.
	confidence := softmaxConfidence(prediction.ClassScores, prediction.PredictedLabel)

	// Translate the model's Indonesian label to the English label the
	// mobile app expects, BEFORE saving -- so the DB and the API response
	// always agree. ClassScores keeps the model's original Indonesian keys
	// (Ringan/Sedang/Berat/Sangat Berat) since two of them currently map to
	// the same English "severe" bucket and merging their scores isn't
	// decided yet -- revisit this once the 4-vs-3 tier question is settled.
	translatedLevel := utils.TranslateAnxietyLevel(prediction.PredictedLabel)

	result := models.Result{
		InspectionID: inspection.ID,
		AnxietyLevel: translatedLevel,          // now stores English, e.g. "severe"
		AnxietyScore: confidence * 100,          // keeps old 0-100 scale convention
		Confidence:   confidence,                // 0-1 scale, approximate
		Hrv:          0,                         // not provided by heartbeat-api yet
		Bpm:          0,                         // not provided by heartbeat-api yet
		ClassScores:  &classScores,
	}

	if err := hc.DB.Create(&result).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save result"})
		return
	}

	// ===== Step 5: Update inspection.Checked → true =====
	inspection.Checked = true
	if err := hc.DB.Save(&inspection).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update inspection status"})
		return
	}

	// ===== Step 6: Final response =====
	c.JSON(http.StatusOK, gin.H{
		"message":    "Analysis completed",
		"result":     result,
		"inspection": inspection,
	})
}

// extractAudioPath pulls just the filename out of a stored audio URL,
// e.g. "http://103.63.25.67:8080/uploads/rec_2247644.wav" -> "rec_2247644.wav"
// Assumes files are stored flat in the uploads folder (no subfolders) --
// matches how Upload() currently saves them ("uploads/" + file.Filename).
func extractAudioPath(audioURL string) string {
	return path.Base(audioURL)
}

// callHeartbeatAPI sends the audio path to heartbeat-api and returns the parsed result.
// inspection.ID is `int` (per models.Inspection), so this takes an int, not uint.
func callHeartbeatAPI(inspectionID int, audioPath string) (*models.HeartbeatPredictResponse, error) {
	baseURL := "http://103.63.25.67:8000" // e.g. http://heartbeat-api:8000 (internal docker network)
	if baseURL == "" {
		return nil, fmt.Errorf("HEARTBEAT_API_URL is not set")
	}
	reqBody := models.HeartbeatPredictRequest{
		InspectionID: strconv.Itoa(inspectionID),
		AudioPath:    audioPath,
	}
	bodyBytes, err := json.Marshal(reqBody)
	if err != nil {
		return nil, fmt.Errorf("failed to marshal request: %w", err)
	}

	// Trim trailing slash on baseURL so we never end up with a double slash
	// before /predict-by-path.
	url := strings.TrimSuffix(baseURL, "/") + "/predict-by-path"

	httpReq, err := http.NewRequest(http.MethodPost, url, bytes.NewReader(bodyBytes))
	if err != nil {
		return nil, fmt.Errorf("failed to build request: %w", err)
	}

	client := &http.Client{Timeout: 30 * time.Second}
	resp, err := client.Do(httpReq)
	if err != nil {
		return nil, fmt.Errorf("heartbeat-api request failed: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		var errBody map[string]interface{}
		_ = json.NewDecoder(resp.Body).Decode(&errBody)
		return nil, fmt.Errorf("heartbeat-api returned %d: %v", resp.StatusCode, errBody["detail"])
	}

	var result models.HeartbeatPredictResponse
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return nil, fmt.Errorf("failed to decode heartbeat-api response: %w", err)
	}

	return &result, nil
}

func softmaxConfidence(scores map[string]float64, predictedLabel string) float64 {
	var sumExp float64
	for _, v := range scores {
		sumExp += math.Exp(v)
	}
	if sumExp == 0 {
		return 0
	}
	return math.Exp(scores[predictedLabel]) / sumExp
}