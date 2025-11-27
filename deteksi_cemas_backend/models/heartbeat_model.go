package models

type UploadRequest struct{
	userID	int    `json:"user_id"`
	AudioUrl string `json:"audio_url"`
}