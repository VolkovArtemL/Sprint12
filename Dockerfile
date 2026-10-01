FROM golang:1.27 AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o parcel-service .

FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/parcel-service .
COPY --from=builder /app/tracker.db .

CMD ["./parcel-service"]