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
    ID       int     `gorm:"primaryKey" json:"id"`
    AnxietyScore float64 `json:"anxiety_score"`
    AnxietyLevel string  `json:"anxiety_level"`
    Hrv       float64 `json:"hrv"`
    Bpm    float64 `json:"bpm"`
    Confidence   float64 `json:"confidence"`
    
    // Foreign Key: Links this Result back to its Inspection.
    // The `unique` tag is CRUCIAL for making it a true one-to-one relationship, 
    // ensuring no two Result records can point to the same Inspection.
    InspectionID int     `gorm:"unique;not null" json:"inspection_id"` 
    CreatedAt   time.Time `json:"created_at"`
}