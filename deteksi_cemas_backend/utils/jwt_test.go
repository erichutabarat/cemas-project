package utils

import (
	"testing"
)

func TestJWTFlow(t *testing.T) {
	userID := 123

	// 1. Test Generate JWT
	token, err := GenerateJWT(userID)
	if err != nil {
		t.Fatalf("Gagal membuat token: %v", err)
	}
	if token == "" {
		t.Fatal("Token yang dihasilkan kosong")
	}

	// 2. Test Validate JWT (Kasus Normal)
	t.Run("Valid Token", func(t *testing.T) {
		gotUserID, err := ValidateJWT(token)
		if err != nil {
			t.Errorf("Harusnya valid, tapi dapet error: %v", err)
		}
		if gotUserID != userID {
			t.Errorf("UserID tidak sesuai. Mau: %d, Dapet: %d", userID, gotUserID)
		}
	})

	// 3. Test Validate JWT dengan prefix "Bearer "
	t.Run("Valid Token with Bearer Prefix", func(t *testing.T) {
		bearerToken := "Bearer " + token
		gotUserID, err := ValidateJWT(bearerToken)
		if err != nil {
			t.Errorf("Harusnya valid dengan prefix Bearer, tapi dapet error: %v", err)
		}
		if gotUserID != userID {
			t.Errorf("UserID tidak sesuai saat pakai Bearer. Mau: %d, Dapet: %d", userID, gotUserID)
		}
	})

	// 4. Test Token Invalid/Salah
	t.Run("Invalid Token", func(t *testing.T) {
		_, err := ValidateJWT("token-asal-asalan.palsu.aja")
		if err == nil {
			t.Error("Harusnya error untuk token yang tidak valid")
		}
	})

	// 5. Test Token Kosong
	t.Run("Empty Token", func(t *testing.T) {
		_, err := ValidateJWT("")
		if err == nil {
			t.Error("Harusnya error untuk token kosong")
		}
	})
}