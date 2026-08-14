package models

import "time"

// Inspection is the primary model in the one-to-one relationship.
type Inspection struct {
    ID        int   `gorm:"primaryKey" json:"id"`
    UserID    int   `json:"user_id"`
    AudioUrl string `json:"audio_url"`
    Checked   bool  `json:"checked"`
    CreatedAt time.Time `json:"created_at"`
    
    // One-to-One connection: 
    // This establishes the relationship where one Inspection has exactly one Result.
    // The tag `gorm:"foreignKey:InspectionID"` ensures GORM uses the 'InspectionID' 
    // field in the 'Result' model as the foreign key.
    Result *Result `gorm:"foreignKey:InspectionID" json:"result,omitempty"` 
}

// Result is the secondary model in the one-to-one relationship.
// The foreign key (InspectionID) must be unique to enforce a one-to-one constraint.
type Result struct {
    ID           int       `gorm:"primaryKey" json:"id"`
    AnxietyScore float64   `json:"anxiety_score"`
    AnxietyLevel string    `json:"anxiety_level"`   // now populated with predicted_label
    Hrv          float64   `json:"hrv"`              // not provided by heartbeat-api yet, stays 0
    Bpm          float64   `json:"bpm"`               // not provided by heartbeat-api yet, stays 0
    Confidence   float64   `json:"confidence"`         // approximate, see note below

    // NEW - nullable, so existing rows just get NULL here, no data loss
    ClassScores *datatypes.JSON `json:"class_scores,omitempty"`

    InspectionID int       `gorm:"unique;not null" json:"inspection_id"`
    CreatedAt    time.Time `json:"created_at"`
}

type UpdateFileRequest struct {
    FileName string `json:"file_name" binding:"required"`
}