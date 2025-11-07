package routers

import (
    "net/http"
    "cemas-backend/controllers"
)

func AuthRoutes(mux *http.ServeMux) {
    mux.HandleFunc("/api/auth/register", controllers.RegisterController)
    mux.HandleFunc("/api/auth/login", controllers.LoginController)
}