package models

import "time"

// RegisterRequest defines the expected structure for /register POST requests.
type RegisterRequest struct {
    Name      string    `json:"name"`
    Email     string    `json:"email"`
    Password  string    `json:"password"`
    Gender    string    `json:"gender"`
    Birthdate time.Time `json:"birthdate"`
}


// LoginRequest defines the expected structure for /login POST requests.
type LoginRequest struct {
    Email    string `json:"email"`
    Password string `json:"password"`
}

// AuthResponse defines the standard structure for a successful auth response.
type AuthResponse struct {
    Token string `json:"token"`
    Message string `json:"message"`
}