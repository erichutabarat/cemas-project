package routers

import (
    "net/http"
    "cemas-backend/controllers"
)

func UserRoutes(mux *http.ServeMux) {
    mux.HandleFunc("/api/user/profile/", controllers.GetUserProfile)
}