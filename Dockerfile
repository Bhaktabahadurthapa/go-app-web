# Stage 1: Build Stage
FROM golang:1.22.5 AS builder

WORKDIR /app

COPY go.mod .

RUN go mod download

COPY . .

# Ensure binary is built for the correct architecture
RUN GOARCH=amd64 GOOS=linux go build -o main .

# Stage 2: Final Stage
FROM gcr.io/distroless/base

WORKDIR /app

COPY --from=builder /app/main .

COPY --from=builder /app/static ./static

EXPOSE 8080

CMD ["./main"]
