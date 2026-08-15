# Etapa 1: Compilación de la aplicación Go
FROM golang:1.22-alpine AS builder

WORKDIR /app

# Copia todo el código fuente al contenedor
COPY . .

# Compila el binario estático para Linux de 64 bits
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o notely .

# Etapa 2: Imagen ligera final de producción
FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /app

# Copia los archivos estáticos y el binario recién compilado en la etapa 1
COPY --from=builder /app/static /app/static
COPY --from=builder /app/notely /app/notely

RUN chmod +x /app/notely

ENV PORT=8080
EXPOSE 8080

CMD ["/app/notely"]
