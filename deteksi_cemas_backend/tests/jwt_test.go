package test

import (
	"testing"
	"deteksi_cemas_backend/utils"
)

func TestJWTFlow(t *testing.T) {
	userID := 123

	// 1. Test Generate JWT
	token, err := utils.GenerateJWT(userID)
	if err != nil {
		t.Fatalf("Gagal membuat token: %v", err)
	}

	if token == "" {
		t.Error("Token yang dihasilkan kosong")
	}

	// 2. Test Validate JWT (Skenario Positif)
	extractedID, err := utils.ValidateJWT(token)
	if err != nil {
		t.Errorf("Harusnya token valid, tapi error: %v", err)
	}

	if extractedID != userID {
		t.Errorf("UserID tidak cocok. Got: %d, Want: %d", extractedID, userID)
	}

	// 3. Test Validate dengan prefix "Bearer "
	// Ini penting karena Flutter biasanya mengirim token dengan prefix ini
	tokenWithBearer := "Bearer " + token
	extractedIDWithBearer, err := utils.ValidateJWT(tokenWithBearer)
	if err != nil {
		t.Errorf("Gagal validasi token dengan prefix Bearer: %v", err)
	}

	if extractedIDWithBearer != userID {
		t.Errorf("UserID dari Bearer token tidak cocok")
	}
}

func TestJWTInvalid(t *testing.T) {
	tests := []struct {
		name        string
		tokenString string
	}{
		{"Token Ngasal", "ini-bukan-token-jwt-yang-benar"},
		{"Token Kosong", ""},
		{"Token Manipulasi", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.invalid.data"},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			_, err := utils.ValidateJWT(tt.tokenString)
			if err == nil {
				t.Errorf("Skenario [%s] harusnya error, tapi malah dianggap valid", tt.name)
			}
		})
	}
}