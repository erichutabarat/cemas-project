package controllers

import (
	"encoding/json"
	"net/http"
	"strconv"
	"strings"

	"cemas-backend/services"
)

// GetUserProfile handles the retrieval of a user's profile information.
func GetUserProfile(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	pathParts := strings.Split(r.URL.Path, "/")
	if len(pathParts) < 5 {
		http.Error(w, `{"error": "invalid request path"}`, http.StatusBadRequest)
		return
	}

	idStr := pathParts[4]
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, `{"error": "invalid user id"}`, http.StatusBadRequest)
		return
	}

	user, err := services.GetUserByID(id)
	if err != nil {
		http.Error(w, `{"error": "server error"}`, http.StatusInternalServerError)
		return
	}

	if user == nil {
		http.Error(w, `{"error": "user not found"}`, http.StatusNotFound)
		return
	}

	json.NewEncoder(w).Encode(user)
}
