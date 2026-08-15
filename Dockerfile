# Etapa 1: Compilación en Go
FROM golang:1.22-alpine AS builder

WORKDIR /app

# Copia los archivos de módulos y descarta dependencias
COPY go.mod go.sum ./
RUN go mod download

# Copia todo el código fuente del proyecto
COPY . .

# Compila el ejecutable sin dependencias C (CGO_ENABLED=0)
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o notely .

# Etapa 2: Imagen final de producción
FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /app

# Copia el binario y los recursos estáticos desde la etapa de compilación
COPY --from=builder /app/notely /app/notely
COPY --from=builder /app/static /app/static

# Asigna permisos de ejecución al binario
RUN chmod +x /app/notely

# Variable de entorno de respaldo por si Cloud Run la requiere
ENV PORT=8080
EXPOSE 8080

CMD ["/app/notely"]
