FROM golang:1.22-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

# Compilamos el binario de Go para Linux de 64 bits
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o notely .

FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /app

# Copiamos todo lo necesario desde el builder
COPY --from=builder /app/notely /app/notely
COPY --from=builder /app/static /app/static

# Copiamos archivos de configuración si existen
COPY --from=builder /app/.env* /app/

RUN chmod +x /app/notely

# Variable de puerto estándar requerida por Cloud Run
ENV PORT=8080
EXPOSE 8080

CMD ["/app/notely"]
