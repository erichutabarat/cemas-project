package models

type UploadRequest struct{
	userID	int    `json:"user_id"`
	AudioUrl string `json:"audio_url"`
}

type HeartbeatPredictRequest struct {
	InspectionID string `json:"inspection_id"`
	AudioPath    string `json:"audio_path"`
}

type HeartbeatPredictResponse struct {
	InspectionID  string             `json:"inspection_id"`
	PredictedLabel string            `json:"predicted_label"`
	ClassScores    map[string]float64 `json:"class_scores"`
}
