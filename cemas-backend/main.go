package main

import (
    "log"
    "net/http"
    "cemas-backend/routers"
)

func main() {
    router := routers.SetupRouter()
    
    log.Println("Server starting on :8080")
    
    // 2. Start the server with the central router
    if err := http.ListenAndServe(":8080", router); err != nil {
        log.Fatalf("Server failed: %v", err)
    }
}