FROM golang:1.21 as base

WORKDIR /app

COPY go.mod .

RUN go mod download 

COPY . .

RUN go build -o main .

# Used of Distroless Image : Reducing the Image size and secure 

FROM gcr.io/Distroless/base

COPY --from=base /app/main .

COPY  --from=base /app/static ./static

EXPOSE 8080 

CMD [ "./main" ]
