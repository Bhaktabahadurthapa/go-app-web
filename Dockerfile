# Stage 1: Build the Go binary
FROM golang:1.22.5 AS base
WORKDIR /app
COPY go.mod .
RUN go mod download
COPY . .
# Ensure the binary is built for linux/amd64
RUN GOARCH=amd64 GOOS=linux go build -o main .

# Stage 2: Copy the binary into a smaller image
FROM gcr.io/distroless/base:latest
COPY --from=base /app/main .
COPY --from=base /app/static ./static
EXPOSE 8080
ENTRYPOINT ["./main"]
