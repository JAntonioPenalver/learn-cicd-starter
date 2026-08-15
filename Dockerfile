# Etapa 1: Compilación en Go
FROM golang:1.22-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

# Compilación estática
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o notely .

# Etapa 2: Imagen final de producción
FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /app

# Copia el binario y los archivos estáticos
COPY --from=builder /app/notely /app/notely
COPY --from=builder /app/static /app/static

RUN chmod +x /app/notely

ENV PORT=8080
EXPOSE 8080

CMD ["./notely"]
