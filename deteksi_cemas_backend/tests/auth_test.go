package test

import (
	"os"
	"testing"
	"deteksi_cemas_backend/utils"
)

func TestHashAndCheckPassword(t *testing.T) {
	// Setup env
	os.Setenv("APP_ENV", "testing")
	defer os.Unsetenv("APP_ENV")

	pword := "rahasia123"

	// 1. Test Hashing
	hash, err := utils.HashPassword(pword)
	if err != nil {
		t.Fatalf("Gagal hash: %v", err)
	}

	// 2. Test Verification
	isValid := utils.CheckPasswordHash(pword, hash)
	if !isValid {
		t.Errorf("Password harusnya valid")
	}

	// 3. Test Wrong Password
	if utils.CheckPasswordHash("salah", hash) {
		t.Errorf("Password harusnya tidak valid")
	}
}

func TestGenerateAuthToken(t *testing.T) {
	token, err := utils.GenerateAuthToken()
	if err != nil {
		t.Fatalf("Gagal generate token: %v", err)
	}

	// Token base64 dari 32 bytes biasanya punya panjang tertentu dan tidak kosong
	if len(token) == 0 {
		t.Error("Token kosong")
	}
}