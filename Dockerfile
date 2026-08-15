FROM golang:1.22-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

# Compilamos el binario
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o notely .

FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /app

# Copiamos el binario y la carpeta static completa
COPY --from=builder /app/notely .
COPY --from=builder /app/static ./static

RUN chmod +x ./notely

ENV PORT=8080
EXPOSE 8080

CMD ["./notely"]
