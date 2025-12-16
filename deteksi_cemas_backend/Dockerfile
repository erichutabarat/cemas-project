# Stage 1: Build the Go application
# Use the official Go image for building
FROM golang:1.25.2-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the go.mod and go.sum files and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the application source code
COPY . .

# Build the Go application
# -o deteksi_cemas_backend: names the output binary
# ./main.go: adjust this path to your main package (e.g., if your main is in 'cmd/server')
RUN CGO_ENABLED=0 go build -o /deteksi_cemas_backend ./main.go

# Stage 2: Create a minimal production image
# Use a minimal, highly secure base image for the final container
FROM alpine:latest

# Set the working directory in the final image
WORKDIR /root/

# Copy the built binary from the builder stage
COPY --from=builder /deteksi_cemas_backend .

# Expose the port your Go application listens on (e.g., 8080)
EXPOSE 8080

# Command to run the executable
CMD ["./deteksi_cemas_backend"]