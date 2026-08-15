# Etapa 1: Compilación
FROM golang:1.22-alpine AS builder

WORKDIR /app

# Copia los archivos de definición de módulos Go
COPY go.mod go.sum ./
RUN go mod download

# Copia todo el código fuente y assets de Notely
COPY . .

# Compila el ejecutable estático para Linux
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o notely .

# Etapa 2: Imagen final de producción
FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /app

# Copia el binario y TODOS los archivos estáticos/recursos
COPY --from=builder /app/notely /app/notely
COPY --from=builder /app/static /app/static

# Asigna permisos de ejecución
RUN chmod +x /app/notely

ENV PORT=8080
EXPOSE 8080

CMD ["/app/notely"]
