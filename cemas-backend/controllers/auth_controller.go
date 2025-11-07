package controllers

import (
    "encoding/json"
    "net/http"
    "io"
    "cemas-backend/models" 
    "cemas-backend/services"
)

// RegisterController handles the POST /api/auth/register endpoint.
func RegisterController(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("Content-Type", "application/json")
    
    var user models.RegisterRequest
    if err := json.NewDecoder(r.Body).Decode(&user); err != nil && err != io.EOF {
        http.Error(w, "Invalid JSON: "+err.Error(), http.StatusBadRequest)
        return
    }

    resp, err := services.Register(user.Email, user.Password, user.Name, user.Gender, user.Birthdate)

    if err != nil {
        http.Error(w, "Registration failed (Service error)", http.StatusInternalServerError)
        return
    }
    
    w.WriteHeader(http.StatusCreated)
    json.NewEncoder(w).Encode(resp)
}

// LoginController handles the POST /api/auth/login endpoint.
func LoginController(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("Content-Type", "application/json")

    var user models.LoginRequest
    if err := json.NewDecoder(r.Body).Decode(&user); err != nil && err != io.EOF {
        http.Error(w, "Invalid JSON: "+err.Error(), http.StatusBadRequest)
        return
    }

    resp, err := services.Login(user.Email, user.Password)

    if err != nil {
        http.Error(w, "Login failed: Invalid credentials", http.StatusUnauthorized)
        return
    }
    
    json.NewEncoder(w).Encode(resp)
}