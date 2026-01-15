package utils

import (
	"os"
	"testing"
)

func TestHashPassword(t *testing.T) {
	// Setup: Set env ke testing agar bcrypt menggunakan MinCost (biar test cepat)
	os.Setenv("APP_ENV", "testing")
	defer os.Unsetenv("APP_ENV")

	tests := []struct {
		name     string
		password string
		wantErr  bool
	}{
		{
			name:     "Password standar",
			password: "password123",
			wantErr:  false,
		},
		{
			name:     "Password panjang",
			password: "ini-adalah-password-yang-sangat-panjang-sekali",
			wantErr:  false,
		},
		{
			name:     "Password kosong",
			password: "",
			wantErr:  false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			hash, err := HashPassword(tt.password)
			
			// Cek apakah ada error yang tidak diharapkan
			if (err != nil) != tt.wantErr {
				t.Errorf("HashPassword() error = %v, wantErr %v", err, tt.wantErr)
				return
			}

			// Cek apakah hasil hash tidak kosong
			if hash == "" {
				t.Error("HashPassword() menghasilkan string kosong")
			}

			// Verifikasi hasil hash dengan fungsi CheckPasswordHash
			if !CheckPasswordHash(tt.password, hash) {
				t.Errorf("CheckPasswordHash() gagal memverifikasi hash untuk password: %s", tt.name)
			}
		})
	}
}

func TestCheckPasswordHash(t *testing.T) {
	password := "rahasia"
	hash, _ := HashPassword(password)

	t.Run("Password Benar", func(t *testing.T) {
		if !CheckPasswordHash(password, hash) {
			t.Error("Harusnya return true untuk password yang benar")
		}
	})

	t.Run("Password Salah", func(t *testing.T) {
		if CheckPasswordHash("salah-password", hash) {
			t.Error("Harusnya return false untuk password yang salah")
		}
	})
}

func TestGenerateAuthToken(t *testing.T) {
	t.Run("Keunikan Token", func(t *testing.T) {
		token1, _ := GenerateAuthToken()
		token2, _ := GenerateAuthToken()

		if token1 == token2 {
			t.Error("Token yang dihasilkan harus unik, tidak boleh sama")
		}
	})

	t.Run("Panjang Token", func(t *testing.T) {
		token, err := GenerateAuthToken()
		if err != nil {
			t.Errorf("Gagal generate token: %v", err)
		}
		
		// Base64 encoding dari 32 bytes biasanya sekitar 43-44 karakter
		if len(token) < 40 {
			t.Errorf("Panjang token terlalu pendek: %d", len(token))
		}
	})
}