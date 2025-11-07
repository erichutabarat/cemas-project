package routers

import (
    "net/http"
)

func SetupRouter() *http.ServeMux {
    mux := http.NewServeMux()

    AuthRoutes(mux)
    UserRoutes(mux)

    mux.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
        w.WriteHeader(http.StatusOK)
        w.Write([]byte(`{"status": "ok", "message": "Server is running"}`))
    })

    return mux
}